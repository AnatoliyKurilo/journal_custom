import 'package:flutter/material.dart';
import 'package:journal_custom_client/journal_custom_client.dart';
import 'package:journal_custom_flutter/src/serverpod_client.dart';

class TeachersTab extends StatefulWidget {
  @override
  _TeachersTabState createState() => _TeachersTabState();
}

class _TeachersTabState extends State<TeachersTab> {
  bool isLoading = true;
  List<Teachers> teachers = [];
  List<Teachers> filteredTeachers = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTeachers(); // Загружаем всех преподавателей при инициализации
  }

  Future<void> _loadTeachers() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      var result = await client.teachers.getAllTeachers();
      setState(() {
        teachers = result;
        filteredTeachers = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Ошибка загрузки преподавателей: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _searchTeachers(String query) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Используем новый унифицированный поиск
      var result = await client.search.searchTeachers(query: query); // Изменено с teacherSearch на search
      setState(() {
        teachers = result;
        filteredTeachers = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Ошибка поиска преподавателей: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _showCreateTeacherDialog() async {
    final formKey = GlobalKey<FormState>();
    String firstName = '';
    String lastName = '';
    String? patronymic;
    String email = '';
    String? phoneNumber;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Добавить преподавателя'),
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
                    // Создаем преподавателя через сервер
                    await client.teachers.createTeacher(
                      firstName: firstName,
                      lastName: lastName,
                      patronymic: patronymic,
                      email: email,
                      phoneNumber: phoneNumber,
                    );
                    Navigator.of(context).pop();
                    _loadTeachers(); // Обновляем список преподавателей
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Преподаватель успешно добавлен')),
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

  Future<void> _showEditTeacherDialog(Teachers teacher) async {
    final formKey = GlobalKey<FormState>();
    Person personToEdit = teacher.person ?? Person(firstName: '', lastName: '', email: ''); // Removed non-existent fields

    String firstName = personToEdit.firstName;
    String lastName = personToEdit.lastName;
    String? patronymic = personToEdit.patronymic;
    String email = personToEdit.email; // Removed ?? '' as email is not nullable
    String? phoneNumber = personToEdit.phoneNumber;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Редактировать преподавателя'),
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

                  final updatedPerson = Person(
                    id: personToEdit.id, 
                    firstName: firstName,
                    lastName: lastName,
                    patronymic: patronymic,
                    email: email,
                    phoneNumber: phoneNumber,
                    userInfoId: personToEdit.userInfoId, // Keep original userInfoId
                    userInfo: personToEdit.userInfo, // Keep original userInfo
                  );

                  try {
                    await client.person.updatePerson(updatedPerson); // Pass as positional argument
                    Navigator.of(context).pop();
                    _loadTeachers(); 
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Данные преподавателя успешно обновлены')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ошибка обновления: $e')),
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
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;

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
              onPressed: _loadTeachers,
              child: const Text('Попробовать снова'),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(isMobile ? 8.0 : 16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Поиск преподавателей',
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: isMobile ? const EdgeInsets.symmetric(horizontal: 10, vertical: 8) : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onChanged: (value) {
                    // Вызываем _searchTeachers при изменении текста
                    _searchTeachers(value);
                  },
                ),
              ),
              if (isMobile)
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _showCreateTeacherDialog,
                  tooltip: 'Добавить преподавателя',
                )
            ],
          ),
          const SizedBox(height: 10),
          if (!isMobile)
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Добавить преподавателя'),
                onPressed: _showCreateTeacherDialog,
                style: ElevatedButton.styleFrom(
                  padding: isMobile ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8) : null,
                ),
              ),
            ),
          const SizedBox(height: 10),
          Expanded(
            child: filteredTeachers.isEmpty
                ? const Center(child: Text('Преподаватели не найдены'))
                : ListView.builder(
                    itemCount: filteredTeachers.length,
                    itemBuilder: (context, index) {
                      final teacher = filteredTeachers[index];
                      final person = teacher.person;
                      // Construct full name including patronymic if available
                      String fullName = person?.firstName ?? '';
                      if (person?.lastName != null && person!.lastName.isNotEmpty) {
                        fullName += ' ${person.lastName}';
                      }
                      if (person?.patronymic != null && person!.patronymic!.isNotEmpty) {
                        fullName += ' ${person.patronymic}';
                      }
                      
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ListTile(
                          contentPadding: isMobile ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8) : null,
                          title: Text(fullName.isNotEmpty ? fullName : 'Имя не указано'),
                          subtitle: Text('Email: ${person?.email ?? 'Не указан'}'),
                          trailing: IconButton( // Added IconButton for editing
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              if (person != null) {
                                _showEditTeacherDialog(teacher);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Невозможно редактировать: данные преподавателя отсутствуют.')),
                                );
                              }
                            },
                            tooltip: 'Редактировать',
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}