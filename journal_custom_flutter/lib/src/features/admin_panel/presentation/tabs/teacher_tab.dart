import 'package:flutter/material.dart';
import 'package:journal_custom_client/journal_custom_client.dart';
import 'package:journal_custom_flutter/core/serverpod_client.dart';
import 'package:journal_custom_flutter/src/features/admin_panel/data/utils/import_teachers_csv.dart';
import 'dart:async'; // Добавляем для Timer

class TeachersTab extends StatefulWidget {
  @override
  _TeachersTabState createState() => _TeachersTabState();
}

class _TeachersTabState extends State<TeachersTab> {
  bool isLoading = true;
  List<Teachers> teachers = [];
  List<Teachers> filteredTeachers = [];
  String? errorMessage;
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchTimer; // Таймер для дебаунсинга

  @override
  void initState() {
    super.initState();
    _loadAllTeachers(); // Загружаем всех преподавателей при инициализации
    _searchController.addListener(_onSearchChanged); // Добавляем слушатель
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // Локальная фильтрация преподавателей
  void _filterTeachers(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredTeachers = List.from(teachers);
      } else {
        final lowerCaseQuery = query.toLowerCase();
        filteredTeachers = teachers.where((teacher) {
          final person = teacher.person;
          if (person == null) return false;

          final firstName = person.firstName?.toLowerCase() ?? '';
          final lastName = person.lastName?.toLowerCase() ?? '';
          final patronymic = person.patronymic?.toLowerCase() ?? '';
          final email = person.email?.toLowerCase() ?? '';
          final fullName = '$firstName $lastName $patronymic'.trim();

          return firstName.contains(lowerCaseQuery) ||
                 lastName.contains(lowerCaseQuery) ||
                 patronymic.contains(lowerCaseQuery) ||
                 fullName.contains(lowerCaseQuery) ||
                 email.contains(lowerCaseQuery);
        }).toList();
      }
    });
  }

  // Дебаунсинг для серверного поиска
  void _onSearchChanged() {
    final query = _searchController.text;
    _searchTimer?.cancel();
    
    // Мгновенная локальная фильтрация
    _filterTeachers(query);
    
    // Если запрос пустой, просто делаем локальную фильтрацию
    if (query.isEmpty) {
      return;
    }
    
    // Серверный поиск с задержкой
    _searchTimer = Timer(const Duration(milliseconds: 800), () {
      if (mounted) {
        _searchTeachersFromServer(query);
      }
    });
  }

  Future<void> _loadAllTeachers() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      var result = await client.teachers.getAllTeachers();
      if (mounted) {
        setState(() {
          teachers = result;
          filteredTeachers = List.from(result); // Синхронизируем фильтрованный список
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Ошибка загрузки преподавателей: $e';
          isLoading = false;
        });
      }
    }
  }

  Future<void> _searchTeachersFromServer(String query) async {
    // НЕ показываем индикатор загрузки при поиске
    try {
      var result = await client.search.searchTeachers(query: query);
      if (mounted) {
        setState(() {
          teachers = result;
          filteredTeachers = List.from(result); // Обновляем и основной, и фильтрованный список
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Ошибка поиска преподавателей: $e';
        });
      }
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
                    await client.teachers.createTeacher(
                      firstName: firstName,
                      lastName: lastName,
                      patronymic: patronymic,
                      email: email,
                      phoneNumber: phoneNumber,
                    );
                    Navigator.of(context).pop();
                    _loadAllTeachers();
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
    Person personToEdit = teacher.person ?? Person(firstName: '', lastName: '', email: '');

    String firstName = personToEdit.firstName;
    String lastName = personToEdit.lastName;
    String? patronymic = personToEdit.patronymic;
    String email = personToEdit.email;
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
                    userInfoId: personToEdit.userInfoId,
                  );

                  try {
                    await client.person.updatePerson(updatedPerson);
                    Navigator.of(context).pop();
                    _loadAllTeachers(); 
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

  Future<void> _importTeachers() async {
    try {
      await importTeachersFromCsv(context);
      _loadAllTeachers();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при импорте: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(isMobile ? 8.0 : 16.0),
          child: Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: isMobile ? CrossAxisAlignment.stretch : CrossAxisAlignment.center,
            children: [
              isMobile 
                ? TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Поиск преподавателей',
                      hintText: 'Введите имя, фамилию или email...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    ),
                  )
                : Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Поиск преподавателей',
                        hintText: 'Введите имя, фамилию или email...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
              SizedBox(width: isMobile ? 0 : 16.0, height: isMobile ? 8.0 : 0),
              if (isMobile) ...[
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.upload_file),
                        label: const Text('Импорт CSV'),
                        onPressed: _importTeachers,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Добавить'),
                        onPressed: _showCreateTeacherDialog,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Row(
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Импорт CSV'),
                      onPressed: _importTeachers,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Добавить преподавателя'),
                      onPressed: _showCreateTeacherDialog,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        if (isLoading)
          const Expanded(child: Center(child: CircularProgressIndicator()))
        else if (errorMessage != null)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(errorMessage!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadAllTeachers,
                    child: const Text('Попробовать снова'),
                  ),
                ],
              ),
            ),
          )
        else if (filteredTeachers.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_searchController.text.isEmpty 
                    ? 'Преподаватели не найдены.' 
                    : 'Преподаватели по вашему запросу не найдены.'),
                  if (_searchController.text.isEmpty) ...[
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Добавить преподавателя'),
                      onPressed: _showCreateTeacherDialog,
                    ),
                  ],
                ],
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: filteredTeachers.length,
              itemBuilder: (context, index) {
                final teacher = filteredTeachers[index];
                final person = teacher.person;
                
                String fullName = person?.firstName ?? '';
                if (person?.lastName != null && person!.lastName.isNotEmpty) {
                  fullName += ' ${person.lastName}';
                }
                if (person?.patronymic != null && person!.patronymic!.isNotEmpty) {
                  fullName += ' ${person.patronymic}';
                }
                
                return Card(
                  margin: EdgeInsets.symmetric(
                    horizontal: isMobile ? 8.0 : 16.0, 
                    vertical: 4.0
                  ),
                  child: ListTile(
                    contentPadding: isMobile 
                      ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8) 
                      : null,
                    title: Text(fullName.isNotEmpty ? fullName : 'Имя не указано'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${person?.email ?? 'Не указан'}'),
                        if (person?.phoneNumber != null && person!.phoneNumber!.isNotEmpty)
                          Text('Телефон: ${person.phoneNumber}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: 'Редактировать',
                          onPressed: () => _showEditTeacherDialog(teacher),
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