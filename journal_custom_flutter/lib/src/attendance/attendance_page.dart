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

  // Добавлены переменные состояния
  int? selectedSubjectId;
  int? selectedClassTypeId;
  int? selectedTeacherId;
  int? selectedSubgroupId;
  DateTime? selectedDateTimeForClass;
  int? selectedSemesterId; // <--- ОБЪЯВЛЕНА ПЕРЕМЕННАЯ

  final TextEditingController topicController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
    int? localSelectedSubjectId; // Используем локальные переменные для диалога
    int? localSelectedClassTypeId;
    int? localSelectedTeacherId;
    int? localSelectedSemesterId; // Раскомментировали и будем использовать
    int? localSelectedSubgroupId;
    DateTime? localSelectedDateTimeForClass;

    final topicController = TextEditingController();
    final notesController = TextEditingController();

    final formKey = GlobalKey<FormState>();
    final subjectController = TextEditingController();
    final teacherController = TextEditingController();
    final semesterController = TextEditingController(); // Контроллер для отображения выбранного семестра
    final subgroupController = TextEditingController();
    final dateTimeControllerForDisplay = TextEditingController();

    final isSmallScreenDialog = MediaQuery.of(context).size.width < 600;

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
                        validator: (value) => value == null || value.isEmpty ? 'Выберите дисциплину' : null,
                        onTap: () async {
                          final selected = await _showSearchDialog(
                            context,
                            'Выберите дисциплину', // Title for subjects
                            (query) => client.search.searchSubjects(query: query),
                          );
                          if (selected != null && selected is Subjects) {
                            setDialogState(() {
                              localSelectedSubjectId = selected.id;
                              subjectController.text = selected.name;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      // Выпадающий список для выбора типа занятия
                      DropdownButtonFormField<int>(
                        value: localSelectedClassTypeId,
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
                            localSelectedClassTypeId = value;
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
                              localSelectedTeacherId = teacher.id;
                              teacherController.text =
                                  '${teacher.person?.lastName ?? ''} ${teacher.person?.firstName ?? ''} ${teacher.person?.patronymic ?? ''}'.trim();
                            });
                          }
                        },
                        validator: (value) {
                          if (localSelectedTeacherId == null) { // Проверяем ID
                            return 'Выберите преподавателя';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Поле для выбора семестра
                      TextFormField(
                        controller: semesterController,
                        readOnly: true, // Делаем поле только для чтения
                        decoration: const InputDecoration(
                          labelText: 'Семестр *',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.search),
                        ),
                        validator: (value) => value == null || value.isEmpty ? 'Выберите семестр' : null,
                        onTap: () async {
                          // TODO: Замените client.search.searchSemesters на ваш реальный эндпоинт поиска семестров
                          // Предполагается, что он возвращает List<Semesters>
                          final selected = await _showSearchDialog(
                            context,
                            'Выберите семестр',
                            (query) => client.semesters.searchSemesters(query: query)
                          );
                          if (selected != null && selected is Semesters) { // Убедитесь, что Semesters - это ваша модель
                            setDialogState(() {
                              localSelectedSemesterId = selected.id;
                              semesterController.text = selected.name; // Предполагаем, что у Semesters есть поле name
                            });
                          }
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
                              localSelectedSubgroupId = subgroup.id;
                              subgroupController.text = subgroup.name ?? 'Не выбрано';
                            });
                          }
                        },
                        validator: (value) {
                          if (localSelectedSubgroupId == null) { // Проверяем ID
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
                                localSelectedDateTimeForClass = DateTime(
                                  date.year, date.month, date.day,
                                  time.hour, time.minute,
                                );
                                dateTimeControllerForDisplay.text =
                                    '${localSelectedDateTimeForClass!.day.toString().padLeft(2, '0')}.${localSelectedDateTimeForClass!.month.toString().padLeft(2, '0')}.${localSelectedDateTimeForClass!.year} ${time.format(context)}';
                              });
                            }
                          }
                        },
                        validator: (value) {
                          if (localSelectedDateTimeForClass == null) { // Проверяем выбранную дату
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
                    if (localSelectedSubjectId == null ||
                        localSelectedClassTypeId == null ||
                        localSelectedTeacherId == null ||
                        localSelectedSemesterId == null || // Проверяем localSelectedSemesterId
                        localSelectedSubgroupId == null ||
                        localSelectedDateTimeForClass == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Пожалуйста, заполните все обязательные поля.')),
                      );
                      return;
                    }
                    try {
                      await client.classes.createClass(
                        subjectsId: localSelectedSubjectId!,
                        classTypesId: localSelectedClassTypeId!,
                        teachersId: localSelectedTeacherId!,
                        semestersId: localSelectedSemesterId!, // Используем localSelectedSemesterId
                        subgroupsId: localSelectedSubgroupId!,
                        date: localSelectedDateTimeForClass!,
                        topic: topicController.text.isNotEmpty ? topicController.text : null,
                        notes: notesController.text.isNotEmpty ? notesController.text : null,
                      );
                      Navigator.of(context).pop(); // Закрываем диалог
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
    String itemType = 'unknown';
    bool isInitialFetchDone = false; // Флаг для отслеживания начальной загрузки

    // Определение itemType (ваш существующий код)
    final lowerCaseTitle = title.toLowerCase();
    if (lowerCaseTitle.contains('дисциплин')) itemType = 'subject';
    else if (lowerCaseTitle.contains('преподавател')) itemType = 'teacher';
    else if (lowerCaseTitle.contains('семестр')) itemType = 'semester';
    else if (lowerCaseTitle.contains('подгрупп')) itemType = 'subgroup';

    print('--- Search Dialog Opened ---');
    print('Dialog title (original): "$title"');
    print('Dialog title (lowercase): "$lowerCaseTitle"');
    print('Determined itemType: "$itemType"');
    print('--------------------------');

    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: title,
      pageBuilder: (context, animation, secondaryAnimation) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // Начальная загрузка данных, если запрос пуст и загрузка еще не выполнялась
            if (!isInitialFetchDone && searchQuery.isEmpty) {
              isInitialFetchDone = true;
              // Выполняем асинхронно после построения первого кадра
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                if (!context.mounted) return; // Проверка, что виджет все еще в дереве
                setDialogState(() {
                  isLoading = true;
                });
                try {
                  results = await searchFunction(''); // Загружаем все элементы
                } catch (e) {
                  print('Initial search error in dialog: $e');
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
                height: MediaQuery.of(context).size.height * 0.6, // Можно настроить высоту
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Поиск...',
                        suffixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) async {
                        searchQuery = value;
                        isInitialFetchDone = true; // Любой ввод отменяет "начальную" загрузку

                        // Запускаем поиск, если запрос пуст (для отображения всех) или длиннее 1 символа
                        if (searchQuery.isEmpty || searchQuery.length > 1) {
                          setDialogState(() {
                            isLoading = true;
                          });
                          try {
                            results = await searchFunction(searchQuery);
                          } catch (e) {
                            print('Search error in dialog: $e');
                            results = [];
                          } finally {
                            if (context.mounted) {
                              setDialogState(() {
                                isLoading = false;
                              });
                            }
                          }
                        } else if (searchQuery.length == 1) {
                          // Если введен только один символ, можно очистить результаты или ничего не делать
                          if (context.mounted) {
                            setDialogState(() {
                              results = [];
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
                              ? Center(child: Text(searchQuery.isEmpty && !isLoading ? 'Начните ввод для поиска' : 'Нет результатов'))
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: results.length,
                                  itemBuilder: (context, index) {
                                    // Отладочный вывод перед вызовом buildListTile
                                    // print('ListView.builder - itemType: $itemType, item: ${results[index]}');
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
    // Отладочный вывод в начале buildListTile
    print('--- buildListTile ---');
    print('Type: "$type"');
    print('Item: $item');
    if (item != null) {
      print('Item runtimeType: ${item.runtimeType}');
      try {
        // Попытка вывести имя, если оно есть, для отладки
        if (item.name != null) {
          print('Item name: ${item.name}');
        }
      } catch (_) {
        // Игнорируем ошибку, если поля name нет
      }
    }
    print('---------------------');

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
            title: Text(item.name), // Убрал ?? 'Без названия', т.к. name не nullable в Subjects
            onTap: () => Navigator.of(context).pop(item),
          );
        }
        // Если item не Subjects, но type 'subject', это ошибка данных
        print('Error: itemType is "subject", but item is not Subjects: $item');
        return ListTile(
          title: Text('Ошибка данных: неверный тип для предмета ($item)'),
          onTap: () => Navigator.of(context).pop(null),
        );
      case 'subgroup':
        return ListTile(
          title: Text(item.name ?? 'Без названия'),
          subtitle: Text('ID: ${item.id}'),
          onTap: () => Navigator.of(context).pop(item),
        );
      case 'semester': // Добавлен case для семестра
        if (item is Semesters) { // Убедитесь, что Semesters - это ваша модель
          return ListTile(
            title: Text(item.name), // Предполагаем, что у Semesters есть поле name
            // subtitle: Text('ID: ${item.id}'), // Можно добавить доп. информацию
            onTap: () => Navigator.of(context).pop(item),
          );
        }
        print('Error: itemType is "semester", but item is not Semesters: $item');
        return ListTile(
          title: Text('Ошибка данных: неверный тип для семестра ($item)'),
          onTap: () => Navigator.of(context).pop(null),
        );
      default:
        print('Warning: Unknown itemType "$type" in buildListTile for item: $item');
        return ListTile(
          title: Text('Неизвестный тип ($type)'),
          subtitle: Text('Элемент: $item'),
          onTap: () => Navigator.of(context).pop(null),
        );
    }
  }
}