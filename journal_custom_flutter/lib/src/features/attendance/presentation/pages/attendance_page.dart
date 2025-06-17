import 'package:flutter/material.dart';
import 'package:journal_custom_client/journal_custom_client.dart';
import 'package:journal_custom_flutter/core/serverpod_client.dart';
import 'package:journal_custom_flutter/src/features/attendance/presentation/pages/subject_classes_page.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  bool _isLoading = true;
  String? _errorMessage;
  List<Groups> _groups = [];
  List<Subjects> _subjects = [];
  Groups? _selectedGroup;

  @override
  void initState() {
    super.initState();
    _fetchGroups();
  }

  Future<void> _fetchGroups() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final groups = await client.groups.getAllGroups(); // Получаем группы пользователя
      if (mounted) {
        setState(() {
          _groups = groups;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Ошибка загрузки групп: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchSubjectsForGroup(Groups group) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _selectedGroup = group;
    });
    try {
      final subjects = await client.classes.getSubjectsForGroup(group.id!);
      if (mounted) {
        setState(() {
          _subjects = subjects;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Ошибка загрузки предметов: $e';
          _isLoading = false;
        });
      }
    }
  }

  void _goBackToGroups() {
    setState(() {
      _selectedGroup = null;
      _subjects = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedGroup == null
            ? 'Выберите группу'
            : 'Предметы: ${_selectedGroup!.name}'),
        leading: _selectedGroup != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _goBackToGroups,
              )
            : null,
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
                        onPressed: _selectedGroup == null
                            ? _fetchGroups
                            : () => _fetchSubjectsForGroup(_selectedGroup!),
                        child: const Text('Попробовать снова'),
                      ),
                    ],
                  ),
                )
              : _selectedGroup == null
                  ? _buildGroupsList()
                  : _buildSubjectsList(),
      floatingActionButton: _selectedGroup != null
          ? FloatingActionButton.extended(
              onPressed: () => _showAddClassDialog(_selectedGroup!),
              icon: const Icon(Icons.add),
              label: const Text('Добавить занятие'),
            )
          : null,
    );
  }

  Widget _buildGroupsList() {
    if (_groups.isEmpty) {
      return const Center(
        child: Text('Нет доступных групп.'),
      );
    }
    return ListView.builder(
      itemCount: _groups.length,
      itemBuilder: (context, index) {
        final group = _groups[index];
        return ListTile(
          title: Text(group.name ?? 'Группа без названия'),
          subtitle: group.curator?.person != null
              ? Text('Куратор: ${group.curator!.person!.firstName} ${group.curator!.person!.lastName}')
              : null,
          onTap: () => _fetchSubjectsForGroup(group),
        );
      },
    );
  }

  Widget _buildSubjectsList() {
    if (_subjects.isEmpty) {
      return const Center(
        child: Text('Нет предметов в этой группе.'),
      );
    }
    return ListView.builder(
      itemCount: _subjects.length,
      itemBuilder: (context, index) {
        final subject = _subjects[index];
        return ListTile(
          title: Text(subject.name ?? 'Предмет без названия'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubjectClassesPage(subject: subject),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showAddClassDialog(Groups selectedGroup) async {
    int? localSelectedSubjectId;
    int? localSelectedClassTypeId;
    int? localSelectedTeacherId;
    int? localSelectedSemesterId;
    int? localSelectedSubgroupId;
    DateTime? localSelectedDateTimeForClass;

    final topicController = TextEditingController();
    final notesController = TextEditingController();

    final formKey = GlobalKey<FormState>();
    final subjectController = TextEditingController();
    final teacherController = TextEditingController();
    final semesterController = TextEditingController();
    final subgroupController = TextEditingController();
    final dateTimeControllerForDisplay = TextEditingController();

    List<ClassTypes> classTypes = [];
    try {
      classTypes = await client.classTypes.searchClassTypes(query: '');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка загрузки типов занятий: $e')),
        );
      }
      return;
    }

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Добавить занятие',
      pageBuilder: (context, animation, secondaryAnimation) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Добавить занятие для ${selectedGroup.name}'),
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Поле для выбора дисциплины
                      TextFormField(
                        controller: subjectController,
                        decoration: const InputDecoration(
                          labelText: 'Дисциплина',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.search),
                        ),
                        readOnly: true,
                        validator: (value) {
                          if (localSelectedSubjectId == null) {
                            return 'Выберите дисциплину';
                          }
                          return null;
                        },
                        onTap: () async {
                          final selectedSubject = await _showSearchDialog(
                            context,
                            'Выберите дисциплину',
                            (query) => client.search.searchSubjects(query: query),
                          );
                          if (selectedSubject != null) {
                            setDialogState(() {
                              localSelectedSubjectId = selectedSubject.id;
                              subjectController.text = selectedSubject.name;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      // Выпадающий список для выбора типа занятия
                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: 'Тип занятия',
                          border: OutlineInputBorder(),
                        ),
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
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (selectedDate != null) {
                            final selectedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
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
                      await client.classes.createClass(
                        subjectsId: localSelectedSubjectId!,
                        classTypesId: localSelectedClassTypeId!,
                        teachersId: localSelectedTeacherId!,
                        semestersId: localSelectedSemesterId!,
                        subgroupsId: localSelectedSubgroupId!,
                        date: localSelectedDateTimeForClass!,
                        topic: topicController.text.isEmpty ? null : topicController.text,
                        notes: notesController.text.isEmpty ? null : notesController.text,
                      );
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Занятие успешно создано')),
                      );
                      // Обновляем список предметов для выбранной группы
                      _fetchSubjectsForGroup(selectedGroup);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ошибка создания занятия: $e')),
                      );
                    }
                  }
                },
                label: const Text('Добавить'),
                icon: const Icon(Icons.check),
              ),
            );
          },
        );
      },
    );
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
    if (lowerCaseTitle.contains('дисциплин')) itemType = 'subject';
    else if (lowerCaseTitle.contains('преподавател')) itemType = 'teacher';
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
                                    return buildListTile(context, results[index], itemType);
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

  Widget buildListTile(BuildContext context, dynamic item, String type) {
    switch (type) {
      case 'teacher':
        return ListTile(
          title: Text('${item.person?.firstName ?? ''} ${item.person?.lastName ?? ''}'),
          subtitle: Text(item.person?.email ?? 'Email не указан'),
          onTap: () => Navigator.of(context).pop(item),
        );
      case 'subject':
        if (item is Subjects) {
          return ListTile(
            title: Text(item.name),
            onTap: () => Navigator.of(context).pop(item),
          );
        }
        return ListTile(
          title: Text('Ошибка данных: неверный тип для предмета'),
          onTap: () => Navigator.of(context).pop(null),
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
}