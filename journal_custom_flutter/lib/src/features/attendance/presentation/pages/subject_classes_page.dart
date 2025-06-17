import 'package:flutter/material.dart';
import 'package:journal_custom_client/journal_custom_client.dart';
import 'package:journal_custom_flutter/core/serverpod_client.dart';
import 'package:intl/intl.dart';
import 'package:journal_custom_flutter/src/features/attendance/presentation/pages/class_attendance_page.dart';

class SubjectClassesPage extends StatefulWidget {
  final Subjects subject;

  const SubjectClassesPage({Key? key, required this.subject}) : super(key: key);

  @override
  _SubjectClassesPageState createState() => _SubjectClassesPageState();
}

class _SubjectClassesPageState extends State<SubjectClassesPage> {
  bool _isLoading = true;
  String? _errorMessage;
  List<Classes> _classes = [];

  @override
  void initState() {
    super.initState();
    _fetchClassesForSubject();
  }

  Future<void> _fetchClassesForSubject() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      if (widget.subject.id == null) {
        throw Exception('ID предмета не может быть null');
      }
      final classes = await client.classes.getClassesBySubject(subjectId: widget.subject.id!);
      if (mounted) {
        setState(() {
          _classes = classes;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Ошибка загрузки занятий: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _showEditClassDialog(Classes classItem) async {
    if (classItem.id == null) return;

    int? localSelectedSubjectId = classItem.subjectsId;
    int? localSelectedClassTypeId = classItem.class_typesId;
    int? localSelectedTeacherId = classItem.teachersId;
    int? localSelectedSemesterId = classItem.semestersId;
    int? localSelectedSubgroupId = classItem.subgroupsId;
    DateTime? localSelectedDateTimeForClass = classItem.date;

    final topicController = TextEditingController(text: classItem.topic ?? '');
    final notesController = TextEditingController(text: classItem.notes ?? '');

    final formKey = GlobalKey<FormState>();
    final subjectController = TextEditingController(text: widget.subject.name);
    final teacherController = TextEditingController();
    final semesterController = TextEditingController();
    final subgroupController = TextEditingController();
    final dateTimeControllerForDisplay = TextEditingController(
      text: classItem.date != null 
        ? '${DateFormat('dd.MM.yyyy').format(classItem.date!)} ${TimeOfDay.fromDateTime(classItem.date!).format(context)}'
        : ''
    );

    // Предзагружаем данные
    List<ClassTypes> classTypes = [];
    try {
      classTypes = await client.classTypes.searchClassTypes(query: '');
      
      // Предзагружаем данные о преподавателе
      if (classItem.teachersId != null) {
        final teachers = await client.teacherSearch.searchTeachers(query: '');
        final teacher = teachers.where((t) => t.id == classItem.teachersId).firstOrNull;
        if (teacher != null) {
          teacherController.text = '${teacher.person?.firstName ?? ''} ${teacher.person?.lastName ?? ''}'.trim();
        }
      }

      // Предзагружаем данные о семестре
      if (classItem.semestersId != null) {
        final semesters = await client.semesters.searchSemesters(query: '');
        final semester = semesters.where((s) => s.id == classItem.semestersId).firstOrNull;
        if (semester != null) {
          semesterController.text = semester.name;
        }
      }

      // Предзагружаем данные о подгруппе
      if (classItem.subgroupsId != null) {
        final subgroups = await client.search.searchSubgroups(query: '');
        final subgroup = subgroups.where((s) => s.id == classItem.subgroupsId).firstOrNull;
        if (subgroup != null) {
          subgroupController.text = subgroup.name ?? 'Без названия';
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка загрузки данных: $e')),
        );
      }
      return;
    }

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Редактировать занятие',
      pageBuilder: (context, animation, secondaryAnimation) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Редактировать занятие'),
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _showDeleteConfirmation(classItem),
                    tooltip: 'Удалить занятие',
                  ),
                ],
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Поле для предмета (только для чтения)
                      TextFormField(
                        controller: subjectController,
                        decoration: const InputDecoration(
                          labelText: 'Дисциплина',
                          border: OutlineInputBorder(),
                        ),
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      // Выпадающий список для выбора типа занятия
                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: 'Тип занятия',
                          border: OutlineInputBorder(),
                        ),
                        value: localSelectedClassTypeId,
                        validator: (value) {
                          if (value == null) {
                            return 'Выберите тип занятия';
                          }
                          return null;
                        },
                        items: classTypes.map((classType) {
                          return DropdownMenuItem<int>(
                            value: classType.id,
                            child: Text(classType.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setDialogState(() {
                            localSelectedClassTypeId = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      // Поле для выбора преподавателя
                      TextFormField(
                        controller: teacherController,
                        decoration: const InputDecoration(
                          labelText: 'Преподаватель',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.search),
                        ),
                        readOnly: true,
                        validator: (value) {
                          if (localSelectedTeacherId == null) {
                            return 'Выберите преподавателя';
                          }
                          return null;
                        },
                        onTap: () async {
                          final selectedTeacher = await _showSearchDialog(
                            context,
                            'Выберите преподавателя',
                            (query) => client.teacherSearch.searchTeachers(query: query),
                          );
                          if (selectedTeacher != null) {
                            setDialogState(() {
                              localSelectedTeacherId = selectedTeacher.id;
                              teacherController.text = '${selectedTeacher.person?.firstName ?? ''} ${selectedTeacher.person?.lastName ?? ''}';
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      // Поле для выбора семестра
                      TextFormField(
                        controller: semesterController,
                        decoration: const InputDecoration(
                          labelText: 'Семестр',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.search),
                        ),
                        readOnly: true,
                        validator: (value) {
                          if (localSelectedSemesterId == null) {
                            return 'Выберите семестр';
                          }
                          return null;
                        },
                        onTap: () async {
                          final selectedSemester = await _showSearchDialog(
                            context,
                            'Выберите семестр',
                            (query) => client.semesters.searchSemesters(query: query),
                          );
                          if (selectedSemester != null) {
                            setDialogState(() {
                              localSelectedSemesterId = selectedSemester.id;
                              semesterController.text = selectedSemester.name;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      // Поле для выбора подгруппы
                      TextFormField(
                        controller: subgroupController,
                        decoration: const InputDecoration(
                          labelText: 'Подгруппа',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.search),
                        ),
                        readOnly: true,
                        validator: (value) {
                          if (localSelectedSubgroupId == null) {
                            return 'Выберите подгруппу';
                          }
                          return null;
                        },
                        onTap: () async {
                          final selectedSubgroup = await _showSearchDialog(
                            context,
                            'Выберите подгруппу',
                            (query) => client.search.searchSubgroups(query: query),
                          );
                          if (selectedSubgroup != null) {
                            setDialogState(() {
                              localSelectedSubgroupId = selectedSubgroup.id;
                              subgroupController.text = selectedSubgroup.name ?? 'Без названия';
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      // Поле для выбора даты и времени
                      TextFormField(
                        controller: dateTimeControllerForDisplay,
                        decoration: const InputDecoration(
                          labelText: 'Дата и время',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        validator: (value) {
                          if (localSelectedDateTimeForClass == null) {
                            return 'Выберите дату и время';
                          }
                          return null;
                        },
                        onTap: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: localSelectedDateTimeForClass ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (selectedDate != null) {
                            final selectedTime = await showTimePicker(
                              context: context,
                              initialTime: localSelectedDateTimeForClass != null 
                                ? TimeOfDay.fromDateTime(localSelectedDateTimeForClass!)
                                : TimeOfDay.now(),
                            );
                            if (selectedTime != null) {
                              setDialogState(() {
                                localSelectedDateTimeForClass = DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                  selectedTime.hour,
                                  selectedTime.minute,
                                );
                                dateTimeControllerForDisplay.text = 
                                    '${selectedDate.day}.${selectedDate.month}.${selectedDate.year} ${selectedTime.format(context)}';
                              });
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      // Поле для темы занятия
                      TextFormField(
                        controller: topicController,
                        decoration: const InputDecoration(
                          labelText: 'Тема занятия (необязательно)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Поле для примечаний
                      TextFormField(
                        controller: notesController,
                        decoration: const InputDecoration(
                          labelText: 'Примечания (необязательно)',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    try {
                      await client.classes.updateClass(
                        classId: classItem.id!,
                        subjectsId: localSelectedSubjectId,
                        classTypesId: localSelectedClassTypeId,
                        teachersId: localSelectedTeacherId,
                        semestersId: localSelectedSemesterId,
                        subgroupsId: localSelectedSubgroupId,
                        date: localSelectedDateTimeForClass,
                        topic: topicController.text.isEmpty ? null : topicController.text,
                        notes: notesController.text.isEmpty ? null : notesController.text,
                      );
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Занятие успешно обновлено')),
                      );
                      // Обновляем список занятий
                      _fetchClassesForSubject();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ошибка обновления занятия: $e')),
                      );
                    }
                  }
                },
                label: const Text('Сохранить'),
                icon: const Icon(Icons.save),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showDeleteConfirmation(Classes classItem) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить занятие'),
        content: const Text('Вы уверены, что хотите удалить это занятие? Это действие нельзя отменить.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );

    if (confirmed == true && classItem.id != null) {
      try {
        await client.classes.deleteClass(classItem.id!);
        Navigator.of(context).pop(); // Закрываем диалог редактирования
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Занятие успешно удалено')),
        );
        _fetchClassesForSubject(); // Обновляем список
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка удаления занятия: $e')),
        );
      }
    }
  }

  Future<dynamic> _showSearchDialog(
    BuildContext context,
    String title,
    Future<List<dynamic>> Function(String query) searchFunction,
  ) async {
    String searchQuery = '';
    List<dynamic> results = [];
    bool isLoading = false;
    String itemType = 'unknown';
    bool isInitialFetchDone = false;

    // Определение типа элемента
    final lowerCaseTitle = title.toLowerCase();
    if (lowerCaseTitle.contains('преподавател')) itemType = 'teacher';
    else if (lowerCaseTitle.contains('семестр')) itemType = 'semester';
    else if (lowerCaseTitle.contains('подгрупп')) itemType = 'subgroup';

    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: title,
      pageBuilder: (context, animation, secondaryAnimation) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // Начальная загрузка данных
            if (!isInitialFetchDone && searchQuery.isEmpty) {
              isInitialFetchDone = true;
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                if (!context.mounted) return;
                setDialogState(() {
                  isLoading = true;
                });
                try {
                  results = await searchFunction('');
                } catch (e) {
                  results = [];
                } finally {
                  if (context.mounted) {
                    setDialogState(() {
                      isLoading = false;
                    });
                  }
                }
              });
            }

            return AlertDialog(
              title: Text(title),
              content: SizedBox(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Поиск',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) async {
                        searchQuery = value;
                        setDialogState(() {
                          isLoading = true;
                        });
                        try {
                          results = await searchFunction(searchQuery);
                        } catch (e) {
                          results = [];
                        } finally {
                          if (context.mounted) {
                            setDialogState(() {
                              isLoading = false;
                            });
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : results.isEmpty
                              ? const Center(child: Text('Ничего не найдено'))
                              : ListView.builder(
                                  itemCount: results.length,
                                  itemBuilder: (context, index) {
                                    return _buildListTile(context, results[index], itemType);
                                  },
                                ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  child: const Text('Отмена'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildListTile(BuildContext context, dynamic item, String type) {
    switch (type) {
      case 'teacher':
        return ListTile(
          title: Text('${item.person?.firstName ?? ''} ${item.person?.lastName ?? ''}'),
          subtitle: Text(item.person?.email ?? 'Email не указан'),
          onTap: () => Navigator.of(context).pop(item),
        );
      case 'subgroup':
        return ListTile(
          title: Text(item.name ?? 'Без названия'),
          subtitle: Text('ID: ${item.id}'),
          onTap: () => Navigator.of(context).pop(item),
        );
      case 'semester':
        if (item is Semesters) {
          return ListTile(
            title: Text(item.name),
            onTap: () => Navigator.of(context).pop(item),
          );
        }
        return ListTile(
          title: Text('Ошибка данных: неверный тип для семестра'),
          onTap: () => Navigator.of(context).pop(null),
        );
      default:
        return ListTile(
          title: Text('Неизвестный тип ($type)'),
          subtitle: Text('Элемент: $item'),
          onTap: () => Navigator.of(context).pop(null),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject.name ?? 'Занятия по предмету'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_errorMessage!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchClassesForSubject,
                        child: const Text('Попробовать снова'),
                      )
                    ],
                  ),
                )
              : _classes.isEmpty
                  ? const Center(
                      child: Text('По этому предмету еще нет занятий.'),
                    )
                  : ListView.builder(
                      itemCount: _classes.length,
                      itemBuilder: (context, index) {
                        final classItem = _classes[index];
                        String subtitleText =
                            'Дата: ${classItem.date != null ? DateFormat('dd.MM.yyyy HH:mm').format(classItem.date!) : 'Не указана'}';
                        if (classItem.topic != null && classItem.topic!.isNotEmpty) {
                          subtitleText += '\nТема: ${classItem.topic}';
                        }
                        if (classItem.notes != null && classItem.notes!.isNotEmpty) {
                          subtitleText += '\nПримечание: ${classItem.notes}';
                        }

                        return ListTile(
                          title: Text(
                              '${classItem.class_types?.name ?? 'Занятие'} '),
                          subtitle: Text(subtitleText),
                          isThreeLine: (classItem.topic != null && classItem.topic!.isNotEmpty) ||
                              (classItem.notes != null && classItem.notes!.isNotEmpty),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _showEditClassDialog(classItem),
                                tooltip: 'Редактировать занятие',
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.arrow_forward_ios, size: 16),
                            ],
                          ),
                          onTap: () {
                            if (classItem.id != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ClassAttendancePage(classItem: classItem),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Ошибка: ID занятия не определен.')),
                              );
                            }
                          },
                        );
                      },
                    ),
    );
  }
}