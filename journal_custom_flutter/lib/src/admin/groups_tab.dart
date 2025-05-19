import 'package:flutter/material.dart';
import 'package:journal_custom_client/journal_custom_client.dart';
import 'package:journal_custom_flutter/src/serverpod_client.dart';
import 'package:journal_custom_flutter/src/utils/search_utils.dart';

class GroupsTab extends StatefulWidget {
  @override
  _GroupsTabState createState() => _GroupsTabState();
}

class _GroupsTabState extends State<GroupsTab> {
  bool isLoading = true;
  List<Groups> groups = [];
  List<Teachers> teachers = [];
  List<Teachers> filteredTeachers = [];
  List<Students> students = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadGroups();
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


  Future<void> _loadGroups({String? query}) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Если строка запроса пуста, загружаем все группы
      var loadedGroups = query == null || query.isEmpty
          ? await client.admin.getAllGroups()
          : await client.admin.searchGroups(query: query);

      var loadedTeachers = await client.admin.getAllTeachers();
      var loadedStudents = await client.admin.getAllStudents();

      setState(() {
        groups = loadedGroups;
        teachers = loadedTeachers;
        students = loadedStudents;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Ошибка загрузки данных: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _updateGroup(Groups group, {int? curatorId, int? groupHeadId}) async {
    try {
      print('Обновляем группу: ${group.id}, curatorId: $curatorId');
      var updatedGroup = group.copyWith(
        curatorId: curatorId,
        groupHeadId: groupHeadId,
      );
      await client.admin.updateGroup(updatedGroup);
      print('Группа успешно обновлена');
      await _loadGroups();
    } catch (e) {
      print('Ошибка обновления группы: $e');
    }
  }

  Future<void> _showCreateGroupDialog() async {
    final formKey = GlobalKey<FormState>();
    String groupName = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Добавить группу'),
          content: Form(
            key: formKey,
            child: TextFormField(
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
                    await client.admin.createGroup(groupName, null, null); // Replace 'null' with appropriate values if needed
                    Navigator.of(context).pop();
                    _loadGroups(); // Обновляем список групп
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Группа успешно добавлена')),
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

  Future<void> _showSelectCuratorDialog(Groups group) async {
    String searchQuery = '';
    List<Teachers> filteredTeachers = teachers;

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Выбор куратора',
      pageBuilder: (context, animation, secondaryAnimation) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Выберите куратора'),
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Поиск преподавателей',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onSubmitted: (value) async {
                        searchQuery = value.toLowerCase();
                        try {
                          // Выполняем поиск преподавателей через сервер
                          filteredTeachers = await client.admin.searchTeachers(query: searchQuery);
                          setState(() {}); // Обновляем состояние для отображения результатов
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Ошибка поиска: $e')),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredTeachers.length,
                        itemBuilder: (context, index) {
                          final teacher = filteredTeachers[index];
                          final person = teacher.person;
                          return ListTile(
                            title: Text('${person?.firstName ?? ''} ${person?.lastName ?? ''}'),
                            subtitle: Text('Email: ${person?.email ?? 'Не указан'}'),
                            onTap: () {
                              Navigator.of(context).pop(teacher.id);
                            },
                          );
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
    ).then((selectedCuratorId) {
      if (selectedCuratorId != null) {
        _updateGroup(group, curatorId: selectedCuratorId as int?);
      }
    });
  }

  Future<void> _showSelectGroupHeadDialog(Groups group) async {
    String searchQuery = '';
    List<Students> filteredStudents = students.where((student) => student.groupsId == group.id).toList();

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Выбор старосты',
      pageBuilder: (context, animation, secondaryAnimation) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Выберите старосту'),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Поиск студентов',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: (value) {
                    _searchTeachers(value); // Выполняем поиск через сервер
                  },
                  // onChanged: (value) {
                  //   searchQuery = value.toLowerCase();
                  //   setState(() {
                  //     filteredStudents = students
                  //         .where((student) =>
                  //             student.groupsId == group.id &&
                  //             ('${student.person?.firstName ?? ''} ${student.person?.lastName ?? ''}'
                  //                     .toLowerCase()
                  //                     .contains(searchQuery)))
                  //         .toList();
                  //   });
                  // },
                  
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredStudents.length,
                    itemBuilder: (context, index) {
                      final student = filteredStudents[index];
                      final person = student.person;
                      return ListTile(
                        title: Text('${person?.firstName ?? ''} ${person?.lastName ?? ''}'),
                        subtitle: Text('Email: ${person?.email ?? 'Не указан'}'),
                        onTap: () {
                          Navigator.of(context).pop(student.id);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((selectedGroupHeadId) {
      if (selectedGroupHeadId != null) {
        _updateGroup(group, groupHeadId: selectedGroupHeadId as int?);
      }
    });
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
              onPressed: _loadGroups,
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
                    labelText: 'Поиск групп',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: (value) {
                    _loadGroups(query: value); // Выполняем поиск
                  },
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Добавить группу'),
                onPressed: _showCreateGroupDialog, // Открываем диалог добавления группы
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Группа: ${group.name}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        title: const Text('Куратор'),
                        subtitle: Text(
                          teachers.firstWhere(
                            (teacher) => teacher.id == group.curatorId,
                            orElse: () => Teachers(personId: 0, person: Person(firstName: 'Не назначен', lastName: '', email: '')),
                          ).person != null ? '${teachers.firstWhere((teacher) => teacher.id == group.curatorId, orElse: () => Teachers(personId: 0, person: Person(firstName: 'Не назначен', lastName: '', email: ''))).person!.firstName} ${teachers.firstWhere((teacher) => teacher.id == group.curatorId, orElse: () => Teachers(personId: 0, person: Person(firstName: 'Не назначен', lastName: '', email: ''))).person!.lastName}' : 'Не назначен',
                        ),
                        onTap: () {
                          _showSelectCuratorDialog(group); // Открываем диалог выбора куратора
                        },
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        title: const Text('Староста'),
                        subtitle: Text(
                          students.firstWhere(
                            (student) => student.id == group.groupHeadId,
                            orElse: () => Students(personId: 0, groupsId: 0, person: Person(firstName: 'Не назначен', lastName: '', email: '')),
                          ).person != null ? '${students.firstWhere((student) => student.id == group.groupHeadId, orElse: () => Students(personId: 0, groupsId: 0, person: Person(firstName: 'Не назначен', lastName: '', email: ''))).person!.firstName} ${students.firstWhere((student) => student.id == group.groupHeadId, orElse: () => Students(personId: 0, groupsId: 0, person: Person(firstName: 'Не назначен', lastName: '', email: ''))).person!.lastName}' : 'Не назначен',
                        ),
                        onTap: () {
                          _showSelectGroupHeadDialog(group); // Открываем диалог выбора старосты
                        },
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
