import 'package:flutter/material.dart';
import 'package:journal_custom_client/journal_custom_client.dart';
import 'package:journal_custom_flutter/src/serverpod_client.dart';
import 'package:journal_custom_flutter/src/attendance/subject_classes_page.dart'; // Добавьте этот импорт

class AttendancePage extends StatefulWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  bool _isLoading = true; // Устанавливаем в true, так как загрузка начнется сразу
  String? _errorMessage;
  DateTime? selectedDateTime;
  final dateTimeController = TextEditingController();
  List<Subjects> _subjectsWithClasses = []; // Состояние для хранения предметов

  @override
  void initState() {
    super.initState();
    _fetchSubjectsData(); // Загружаем данные при инициализации
  }

  Future<void> _fetchSubjectsData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final subjects = await client.classes.getSubjectsWithClasses();
      if (mounted) {
        setState(() {
          _subjectsWithClasses = subjects;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Управление посещаемостью'),
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
                        onPressed: _fetchSubjectsData, // Кнопка для повторной попытки
                        child: const Text('Попробовать снова'),
                      )
                    ],
                  ),
                )
              : _subjectsWithClasses.isEmpty
                  ? const Center(
                      child: Text('Нет предметов с назначенными занятиями.'),
                    )
                  : ListView.builder(
                      itemCount: _subjectsWithClasses.length,
                      itemBuilder: (context, index) {
                        final subject = _subjectsWithClasses[index];
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
                    ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddClassDialog,
        icon: const Icon(Icons.add),
        label: const Text('Добавить занятие'),
      ),
    );
  }

  Future<void> _showAddClassDialog() async {
    int? selectedSubjectId;
    // String? selectedSubjectName; // selectedSubjectName не используется напрямую в createClass
    int? selectedClassTypeId;
    int? selectedTeacherId;
    int? selectedSemesterId;
    int? selectedSubgroupId;
    DateTime? selectedDateTimeForClass; // Переименовано для ясности и используется для createClass

    final topicController = TextEditingController();
    final notesController = TextEditingController();

    final formKey = GlobalKey<FormState>();
    final subjectController = TextEditingController();
    final teacherController = TextEditingController();
    final semesterController = TextEditingController();
    final subgroupController = TextEditingController();
    final dateTimeControllerForDisplay = TextEditingController(); // Для отображения даты/времени

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
          builder: (context, setDialogState) { // Используем setDialogState
            return Scaffold(
              appBar: AppBar(
                title: const Text('Добавить занятие'),
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
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Дисциплина *', // Добавил * для обязательных полей
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.search),
                        ),
                        onTap: () async {
                          final subject = await _showSearchDialog(
                            context,
                            'Выберите предмет',
                            (query) => client.search.searchSubjects(query: query), // Изменено с subjects.searchSubjects на search.searchSubjects
                          );
                          if (subject != null && subject is Subjects) {
                            setDialogState(() {
                              selectedSubjectId = subject.id;
                              subjectController.text = subject.name ?? 'Не выбрано';
                            });
                          }
                        },
                        validator: (value) {
                          if (selectedSubjectId == null) { // Проверяем ID
                            return 'Выберите дисциплину';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Выпадающий список для выбора типа занятия
                      DropdownButtonFormField<int>(
                        value: selectedClassTypeId,
                        decoration: const InputDecoration(
                          labelText: 'Тип занятия *',
                          border: OutlineInputBorder(),
                        ),
                        items: classTypes.map((type) {
                          return DropdownMenuItem<int>(
                            value: type.id,
                            child: Text(type.name ?? 'Тип без названия'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setDialogState(() {
                            selectedClassTypeId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Выберите тип занятия';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Поле для выбора преподавателя
                      TextFormField(
                        controller: teacherController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Преподаватель *',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.search),
                        ),
                        onTap: () async {
                          final teacher = await _showSearchDialog(
                            context,
                            'Выберите преподавателя',
                            (query) => client.teacherSearch.searchTeachers(query: query),
                          );
                          if (teacher != null && teacher is Teachers) {
                            setDialogState(() {
                              selectedTeacherId = teacher.id;
                              teacherController.text =
                                  '${teacher.person?.lastName ?? ''} ${teacher.person?.firstName ?? ''} ${teacher.person?.patronymic ?? ''}'.trim();
                            });
                          }
                        },
                        validator: (value) {
                          if (selectedTeacherId == null) { // Проверяем ID
                            return 'Выберите преподавателя';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Поле для выбора семестра
                      TextFormField(
                        controller: semesterController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Семестр *',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.search),
                        ),
                        onTap: () async {
                          final semester = await _showSearchDialog(
                            context,
                            'Выберите семестр',
                            (query) => client.semesters.searchSemesters(query: query),
                          );
                          if (semester != null && semester is Semesters) {
                            setDialogState(() { // Используем setDialogState
                              selectedSemesterId = semester.id;
                              semesterController.text = semester.name ?? 'Не выбрано';
                            });
                          }
                        },
                        validator: (value) {
                          if (selectedSemesterId == null) { // Проверяем ID
                            return 'Выберите семестр';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Поле для выбора подгруппы
                      TextFormField(
                        controller: subgroupController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Подгруппа *',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.search),
                        ),
                        onTap: () async {
                          final subgroup = await _showSearchDialog(
                            context,
                            'Выберите подгруппу',
                            (query) => client.search.searchSubgroups(query: query), // Изменено
                          );
                          if (subgroup != null && subgroup is Subgroups) {
                            setDialogState(() { // Используем setDialogState
                              selectedSubgroupId = subgroup.id;
                              subgroupController.text = subgroup.name ?? 'Не выбрано';
                            });
                          }
                        },
                        validator: (value) {
                          if (selectedSubgroupId == null) { // Проверяем ID
                            return 'Выберите подгруппу';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Поле для выбора даты и времени
                      TextFormField(
                        controller: dateTimeControllerForDisplay,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Дата и время занятия *',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (date != null) {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (time != null) {
                              setDialogState(() { // Используем setDialogState
                                selectedDateTimeForClass = DateTime(
                                  date.year, date.month, date.day,
                                  time.hour, time.minute,
                                );
                                dateTimeControllerForDisplay.text =
                                    '${selectedDateTimeForClass!.day.toString().padLeft(2, '0')}.${selectedDateTimeForClass!.month.toString().padLeft(2, '0')}.${selectedDateTimeForClass!.year} ${time.format(context)}';
                              });
                            }
                          }
                        },
                        validator: (value) {
                          if (selectedDateTimeForClass == null) { // Проверяем выбранную дату
                            return 'Выберите дату и время';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: topicController,
                        decoration: const InputDecoration(
                          labelText: 'Тема занятия (необязательно)',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: notesController,
                        decoration: const InputDecoration(
                          labelText: 'Комментарии/Примечание (необязательно)',
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
                        subjectsId: selectedSubjectId!,
                        classTypesId: selectedClassTypeId!,
                        teachersId: selectedTeacherId!,
                        semestersId: selectedSemesterId!,
                        subgroupsId: selectedSubgroupId!,
                        date: selectedDateTimeForClass!, // Используем корректную переменную
                        topic: topicController.text.isNotEmpty ? topicController.text : null,
                        notes: notesController.text.isNotEmpty ? notesController.text : null,
                      );
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Занятие успешно добавлено!')),
                      );
                      _fetchSubjectsData(); // Обновляем список предметов с занятиями
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ошибка добавления занятия: $e')),
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
    String itemType = 'unknown'; // Определяем тип для buildListTile

    if (title.contains('дисциплину')) itemType = 'subject';
    if (title.contains('преподавателя')) itemType = 'teacher';
    if (title.contains('семестр')) itemType = 'semester';
    if (title.contains('подгруппу')) itemType = 'subgroup';


    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: title,
      pageBuilder: (context, animation, secondaryAnimation) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> performSearch(String query) async {
              setDialogState(() {
                isLoading = true;
              });
              try {
                final searchResults = await searchFunction(query);
                setDialogState(() {
                  results = searchResults;
                  isLoading = false;
                });
              } catch (e) {
                setDialogState(() {
                  isLoading = false;
                });
                if(mounted){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ошибка поиска: $e')),
                  );
                }
              }
            }
            // Первоначальный поиск при открытии диалога, если нужно
            // if (results.isEmpty && searchQuery.isEmpty && !isLoading) {
            //   performSearch('');
            // }

            return Scaffold(
              appBar: AppBar(
                title: Text(title),
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Поиск',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        searchQuery = value;
                        // Можно добавить debounce для оптимизации
                        performSearch(searchQuery);
                      },
                      onSubmitted: (value) { // Поиск по нажатию Enter
                        performSearch(value);
                      },
                    ),
                    const SizedBox(height: 16),
                    if (isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (results.isEmpty)
                      const Expanded(
                        child: Center(child: Text('Ничего не найдено. Попробуйте изменить запрос.')),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final item = results[index];
                            return buildListTile(context, item, itemType); // Передаем itemType
                          },
                        ),
                      ),
                  ],
                ),
              ),
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
        return ListTile(
          title: Text(item.name ?? 'Без названия'),
          onTap: () => Navigator.of(context).pop(item),
        );
      case 'subgroup':
        return ListTile(
          title: Text(item.name ?? 'Без названия'),
          subtitle: Text('ID: ${item.id}'),
          onTap: () => Navigator.of(context).pop(item),
        );
      case 'semester':
        return ListTile(
          title: Text(item.name ?? 'Без названия'),
          subtitle: Text('Год: ${item.year}'),
          onTap: () => Navigator.of(context).pop(item),
        );
      default:
        return ListTile(
          title: const Text('Неизвестный тип'),
        );
    }
  }
}