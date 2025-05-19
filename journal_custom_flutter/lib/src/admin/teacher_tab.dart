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
      var result = await client.admin.getAllTeachers();
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
      // Выполняем поиск преподавателей через сервер
      var result = await client.admin.searchTeachers(query: query);
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
                    await client.admin.createTeacher(
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
              onPressed: _loadTeachers,
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
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Поиск преподавателей',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: (value) {
                    _searchTeachers(value); // Выполняем поиск через сервер
                  },
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Добавить'),
                onPressed: _showCreateTeacherDialog, // Открываем диалог добавления преподавателя
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredTeachers.length,
            itemBuilder: (context, index) {
              final teacher = filteredTeachers[index];
              final person = teacher.person;

              if (person == null) {
                return ListTile(
                  title: Text('ID: ${teacher.id}'),
                  subtitle: const Text('Данные о человеке отсутствуют'),
                );
              }

              return ListTile(
                title: Text('${person.firstName} ${person.lastName}'),
                subtitle: Text('Email: ${person.email ?? 'Не указан'}'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Открыть диалог редактирования преподавателя
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