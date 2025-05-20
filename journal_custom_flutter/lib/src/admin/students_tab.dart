import 'package:flutter/material.dart';
import 'package:journal_custom_client/journal_custom_client.dart';
import 'package:journal_custom_flutter/src/serverpod_client.dart';

class StudentsTab extends StatefulWidget {
  @override
  _StudentsTabState createState() => _StudentsTabState();
}

class _StudentsTabState extends State<StudentsTab> {
  bool isLoading = true;
  List<Students> students = [];
  String? errorMessage;

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

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Добавить студента'),
          content: Form(
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

  Future<void> _showEditStudentDialog(Students student) async {
    final formKey = GlobalKey<FormState>();
    String firstName = student.person?.firstName ?? '';
    String lastName = student.person?.lastName ?? '';
    String? patronymic = student.person?.patronymic;
    String email = student.person?.email ?? '';
    String? phoneNumber = student.person?.phoneNumber;
    String groupName = student.groups?.name ?? '';
    Groups? selectedGroup;

    // Загрузка всех групп для выбора
    List<Groups> availableGroups = [];
    try {
      availableGroups = await client.admin.getAllGroups();
    } catch (e) {
      print('Ошибка при загрузке списка групп: $e');
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                      // Выпадающий список для выбора группы
                      DropdownButtonFormField<Groups>(
                        value: availableGroups.isNotEmpty 
                            ? availableGroups.firstWhere(
                                (g) => g.id == student.groupsId,
                                orElse: () => availableGroups[0],
                              )
                            : null, // null только если список пуст
                        decoration: const InputDecoration(labelText: 'Группа'),
                        items: availableGroups.map((group) {
                          return DropdownMenuItem<Groups>(
                            value: group,
                            child: Text(group.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedGroup = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) return 'Выберите группу';
                          return null;
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
                        // Обновляем данные person
                        var updatedPerson = student.person!.copyWith(
                          firstName: firstName,
                          lastName: lastName,
                          patronymic: patronymic,
                          email: email,
                          phoneNumber: phoneNumber,
                        );
                        
                        // Сначала обновляем запись Person
                        await client.admin.updatePerson(updatedPerson);
                        
                        // Затем обновляем запись Student с новой группой, если она изменилась
                        if (selectedGroup != null && selectedGroup!.id != student.groupsId) {
                          var updatedStudent = student.copyWith(
                            groupsId: selectedGroup!.id!,
                          );
                          await client.admin.updateStudent(updatedStudent);
                        }
                        
                        Navigator.of(context).pop();
                        _loadAllStudents(); // Обновляем список студентов
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Данные студента успешно обновлены')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Ошибка: $e')),
                        );
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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage!),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadAllStudents,
              child: const Text('Попробовать снова'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Поиск по имени, фамилии, email или группе',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: (value) {
                    _searchStudents(value);
                  },
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Добавить'),
                onPressed: _showCreateStudentDialog, // Открываем диалог добавления студента
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              final person = student.person;

              if (person == null) {
                return ListTile(
                  title: Text('ID: ${student.id}'),
                  subtitle: const Text('Данные о человеке отсутствуют'),
                );
              }

              return ListTile(
                title: Text('${person.firstName} ${person.lastName}'),
                subtitle: Text('Email: ${person.email ?? 'Не указан'}'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showEditStudentDialog(student);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}