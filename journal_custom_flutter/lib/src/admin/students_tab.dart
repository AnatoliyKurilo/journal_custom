import 'package:flutter/material.dart';
import 'package:journal_custom_client/journal_custom_client.dart';
import 'package:journal_custom_flutter/src/serverpod_client.dart';
import 'package:journal_custom_flutter/src/utils/search_utils.dart';
import 'package:journal_custom_flutter/src/admin/student_overall_attendance_page.dart'; // <-- Новый импорт

class StudentsTab extends StatefulWidget {
  @override
  _StudentsTabState createState() => _StudentsTabState();
}

class _StudentsTabState extends State<StudentsTab> {
  bool isLoading = true;
  List<Students> students = [];
  String? errorMessage;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAllStudents(); // Загружаем всех студентов при инициализации
  }

  Future<void> _loadAllStudents() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Получаем список всех студентов
      var result = await client.admin.getAllStudents();
      setState(() {
        students = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Ошибка загрузки студентов: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _searchStudents(String query) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Выполняем поиск студентов
      var result = await client.admin.searchStudents(query: query);
      setState(() {
        students = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Ошибка поиска студентов: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _showCreateStudentDialog() async {
    final formKey = GlobalKey<FormState>();
    String firstName = '';
    String lastName = '';
    String? patronymic;
    String email = '';
    String? phoneNumber;
    String groupName = ''; // Название группы
    final isMobile = MediaQuery.of(context).size.width < 600;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Добавить студента'),
          content: SingleChildScrollView( // Обертка для прокрутки
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Имя'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите имя';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      firstName = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Фамилия'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите фамилию';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      lastName = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Отчество (необязательно)'),
                    onSaved: (value) {
                      patronymic = value;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите email';
                      }
                      if (!value.contains('@')) {
                        return 'Введите корректный email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      email = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Телефон (необязательно)'),
                    onSaved: (value) {
                      phoneNumber = value;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Название группы'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите название группы';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      groupName = value!;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();

                  try {
                    // Создаем студента через сервер
                    await client.admin.createStudent(
                      firstName: firstName,
                      lastName: lastName,
                      patronymic: patronymic,
                      email: email,
                      phoneNumber: phoneNumber,
                      groupName: groupName, // Передаем название группы
                    );
                    Navigator.of(context).pop();
                    _loadAllStudents(); // Обновляем список студентов
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Студент успешно добавлен')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ошибка: $e')),
                    );
                  }
                }
              },
              child: const Text('Создать'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditStudentDialog(Students? student) async {
    final formKey = GlobalKey<FormState>();
    String firstName = student?.person?.firstName ?? '';
    String lastName = student?.person?.lastName ?? '';
    String? patronymic = student?.person?.patronymic;
    String email = student?.person?.email ?? '';
    String? phoneNumber = student?.person?.phoneNumber;
    Groups? selectedGroup; // Инициализируем здесь

    // Загрузка всех групп для выбора
    List<Groups> availableGroups = [];
    bool groupsLoadingError = false;
    try {
      availableGroups = await client.admin.getAllGroups();
      if (student?.groupsId != null && availableGroups.isNotEmpty) {
        // Пытаемся найти текущую группу студента в списке доступных групп
        selectedGroup = availableGroups.firstWhere(
          (g) => g.id == student!.groupsId,
          orElse: () => Groups(id: -1, name: 'Неизвестная группа'), // Возвращаем группу по умолчанию
        );
      } else if (student?.groups != null) {
        // Если группы загрузить не удалось, но у студента есть объект группы (маловероятно, если groupsId есть)
        // Это запасной вариант, но лучше полагаться на availableGroups
        selectedGroup = student!.groups;
      }
    } catch (e) {
      groupsLoadingError = true;
      if (mounted) { // Проверяем, смонтирован ли виджет
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при загрузке списка групп: $e')),
        );
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder( // Используем StatefulBuilder для обновления состояния внутри диалога
          builder: (context, setDialogState) { // Переименовываем setState в setDialogState
            return AlertDialog(
              title: const Text('Редактировать студента'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        initialValue: firstName,
                        decoration: const InputDecoration(labelText: 'Имя'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Введите имя';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          firstName = value!;
                        },
                      ),
                      TextFormField(
                        initialValue: lastName,
                        decoration: const InputDecoration(labelText: 'Фамилия'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Введите фамилию';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          lastName = value!;
                        },
                      ),
                      TextFormField(
                        initialValue: patronymic,
                        decoration: const InputDecoration(labelText: 'Отчество (необязательно)'),
                        onSaved: (value) {
                          patronymic = value;
                        },
                      ),
                      TextFormField(
                        initialValue: email,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Введите email';
                          }
                          if (!value.contains('@')) {
                            return 'Введите корректный email';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          email = value!;
                        },
                      ),
                      TextFormField(
                        initialValue: phoneNumber,
                        decoration: const InputDecoration(labelText: 'Телефон (необязательно)'),
                        onSaved: (value) {
                          phoneNumber = value;
                        },
                      ),
                      const SizedBox(height: 16),
                      if (groupsLoadingError)
                        const Text('Не удалось загрузить список групп.', style: TextStyle(color: Colors.red))
                      else if (availableGroups.isNotEmpty)
                        DropdownButtonFormField<Groups>(
                          value: selectedGroup,
                          decoration: const InputDecoration(labelText: 'Группа'),
                          items: availableGroups.map((group) {
                            return DropdownMenuItem<Groups>(
                              value: group,
                              child: Text(group.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setDialogState(() { // Используем setDialogState
                              selectedGroup = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) return 'Выберите группу';
                            return null;
                          },
                        )
                      else
                        Text(student?.groups?.name ?? 'Группа не назначена (список групп пуст)'),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Отмена'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();

                      if (student == null || student.person == null) {
                        if (mounted) {
                           ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Ошибка: Данные студента или персональные данные отсутствуют.')),
                          );
                        }
                        return;
                      }

                      try {
                        var updatedPerson = student.person!.copyWith(
                          firstName: firstName,
                          lastName: lastName,
                          patronymic: patronymic,
                          email: email,
                          phoneNumber: phoneNumber,
                        );
                        
                        await client.admin.updatePerson(updatedPerson);
                        
                        if (selectedGroup != null && selectedGroup?.id != student.groupsId) {
                          var updatedStudent = student.copyWith(
                            groupsId: selectedGroup?.id!,
                            // groups: selectedGroup, // Serverpod автоматически обновит связь по groupsId
                          );
                          await client.admin.updateStudent(updatedStudent);
                        } else if (selectedGroup == null && student.groupsId != null) {
                          // Если группа была удалена (стала null), а раньше была
                           var updatedStudent = student.copyWith(
                            groupsId: null, // Устанавливаем null
                            // groups: null, 
                          );
                          await client.admin.updateStudent(updatedStudent);
                        }
                        
                        if (mounted) {
                          Navigator.of(context).pop();
                          _loadAllStudents(); 
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Данные студента успешно обновлены')),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Ошибка обновления: $e')),
                          );
                        }
                      }
                    }
                  },
                  child: const Text('Сохранить'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    List<Students> displayStudents = students;

    if (_searchController.text.isNotEmpty) {
      displayStudents = filterStudents(students, _searchController.text);
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(isMobile ? 8.0 : 16.0),
          child: Flex( // Используем Flex для адаптивного расположения
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded( // Expanded для поля поиска
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Поиск студентов',
                    hintText: 'Введите имя, фамилию или группу...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    contentPadding: isMobile ? const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0) : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      // Фильтрация будет происходить при построении списка
                    });
                  },
                ),
              ),
              SizedBox(width: isMobile ? 0 : 16.0, height: isMobile ? 8.0 : 0), // Отступ
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: Text(isMobile ? 'Добавить' : 'Добавить студента'),
                onPressed: _showCreateStudentDialog,
                style: ElevatedButton.styleFrom(
                  padding: isMobile ? const EdgeInsets.symmetric(horizontal: 12, vertical: 12) : null,
                  textStyle: isMobile ? const TextStyle(fontSize: 14) : null,
                ),
              ),
            ],
          ),
        ),
        if (isLoading)
          const Expanded(child: Center(child: CircularProgressIndicator()))
        else if (errorMessage != null)
          Expanded(child: Center(child: Text(errorMessage!)))
        else if (displayStudents.isEmpty)
          const Expanded(child: Center(child: Text('Студенты не найдены')))
        else
          Expanded(
            child: ListView.builder(
              itemCount: displayStudents.length,
              itemBuilder: (context, index) {
                final student = displayStudents[index];
                final person = student.person;
                final group = student.groups;
                String fullName = person?.firstName ?? '';
                if (person?.lastName != null && person!.lastName.isNotEmpty) {
                  fullName += ' ${person.lastName}';
                }
                if (person?.patronymic != null && person!.patronymic!.isNotEmpty) {
                  fullName += ' ${person.patronymic}';
                }

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: isMobile ? 8.0 : 16.0, vertical: 4.0),
                  child: ListTile(
                    contentPadding: isMobile ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8) : null,
                    title: Text(fullName.isNotEmpty ? fullName : 'Имя не указано'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${person?.email ?? 'Не указан'}'),
                        Text('Группа: ${group?.name ?? 'Не указана'}'),
                        if (student.isGroupHead ?? false)
                          const Text('Староста группы', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.visibility),
                          tooltip: 'Посмотреть посещаемость',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StudentOverallAttendancePage(student: student),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: 'Редактировать',
                          onPressed: () => _showEditStudentDialog(student),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

// Функция filterStudents должна быть определена где-то, например, в search_utils.dart
// или прямо в этом файле, если она специфична только для этого виджета.
// Для примера, если она еще не определена:
List<Students> filterStudents(List<Students> allStudents, String query) {
  if (query.isEmpty) {
    return allStudents;
  }
  final lowerCaseQuery = query.toLowerCase();
  return allStudents.where((student) {
    final person = student.person;
    final group = student.groups;
    final fullName = '${person?.firstName ?? ''} ${person?.lastName ?? ''} ${person?.patronymic ?? ''}'.toLowerCase();
    final groupName = group?.name.toLowerCase() ?? '';
    return fullName.contains(lowerCaseQuery) || groupName.contains(lowerCaseQuery);
  }).toList();
}