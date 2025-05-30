import 'package:flutter/material.dart';
import 'package:journal_custom_client/journal_custom_client.dart';
import 'package:journal_custom_flutter/src/admin/filework/export_groups_csv.dart';
import 'package:journal_custom_flutter/src/admin/filework/import_groups_csv.dart';
import 'package:journal_custom_flutter/src/serverpod_client.dart';
import 'package:collection/collection.dart'; // Убедитесь, что этот импорт есть, если используется firstWhereOrNull

// Функция для фильтрации студентов по ФИО
List<Students> filterStudents(List<Students> allStudents, String query) {
  if (query.isEmpty) {
    return allStudents;
  }
  final lowerCaseQuery = query.toLowerCase();
  return allStudents.where((student) {
    final person = student.person;
    if (person == null) return false;

    // Собираем ФИО, обрабатывая возможные null значения
    final surname = person.lastName?.toLowerCase() ?? '';
    final name = person.firstName?.toLowerCase() ?? '';
    final patronymic = person.patronymic?.toLowerCase() ?? '';

    // Проверяем вхождение по каждому полю отдельно или по полному ФИО
    // Это более гибко, если пользователь ищет только по фамилии или имени
    return surname.contains(lowerCaseQuery) ||
           name.contains(lowerCaseQuery) ||
           patronymic.contains(lowerCaseQuery) ||
           '$surname $name $patronymic'.trim().contains(lowerCaseQuery);
  }).toList();
}

class GroupsTab extends StatefulWidget {
  const GroupsTab({super.key}); // Используем super.key

  @override
  _GroupsTabState createState() => _GroupsTabState();
}

class _GroupsTabState extends State<GroupsTab> {
  bool isLoading = true;
  List<Groups> groups = [];
  List<Teachers> teachers = [];
  List<Students> students = [];
  String? errorMessage;
  String? _currentGroupsSearchQuery;
  final TextEditingController _groupSearchController = TextEditingController(); // Контроллер для поиска

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _searchTeachersInDialog(String query, Function(List<Teachers>) setStateCallback) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      var result = await client.teacherSearch.searchTeachers(query: query);
      setState(() {
        teachers = result;
        setStateCallback(result);
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
      _currentGroupsSearchQuery = query;
    });

    try {
      // Используем новый поиск
      var loadedGroups = (query == null || query.isEmpty)
          ? await client.groups.getAllGroups()
          : await client.search.searchGroups(query: query); // Изменено с admin.searchGroups на search.searchGroups

      var loadedTeachers = await client.teachers.getAllTeachers();
      var loadedStudents = await client.students.getAllStudents();

      if (mounted) {
        setState(() {
          this.groups = loadedGroups;
          this.teachers = loadedTeachers;
          this.students = loadedStudents;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Ошибка загрузки данных: $e';
          isLoading = false;
        });
      }
    }
  }

  Future<void> _updateGroup(Groups group, {int? curatorId, int? groupHeadId}) async {
    try {
      await client.groups.updateGroup(group, newCuratorId: curatorId, newGroupHeadId: groupHeadId);
      await _loadGroups(query: _currentGroupsSearchQuery);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Группа успешно обновлена')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при обновлении группы: $e')),
        );
      }
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
                    await client.groups.createGroup(groupName, null); // curatorId пока null
                    Navigator.of(context).pop();
                    _loadGroups(); // Обновляем список групп
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Группа успешно добавлена')),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ошибка: $e')),
                      );
                    }
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
                          filteredTeachers = await client.teacherSearch.searchTeachers(query: searchQuery);
                          setState(() {});
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
    List<Students> groupStudents = students.where((student) => student.groupsId == group.id).toList();
    List<Students> dialogFilteredStudents = List.from(groupStudents);

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Выбор старосты',
      pageBuilder: (context, animation, secondaryAnimation) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Выберите старосту'),
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
                        labelText: 'Поиск студентов',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        searchQuery = value.toLowerCase();
                        setDialogState(() {
                          dialogFilteredStudents = filterStudents(groupStudents, searchQuery);
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: dialogFilteredStudents.length,
                        itemBuilder: (context, index) {
                          final student = dialogFilteredStudents[index];
                          final person = student.person;
                          return ListTile(
                            title: Text('${person?.firstName ?? ''} ${person?.lastName ?? ''}'.trim()),
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
        );
      },
    ).then((selectedGroupHeadId) {
      if (selectedGroupHeadId != null) {
        _updateGroup(group, groupHeadId: selectedGroupHeadId as int?);
      }
    });
  }

  Future<void> _showDeleteGroupConfirmation(Groups group) async {
    return showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Удаление группы'),
          content: Text(
            'Вы действительно хотите удалить группу "${group.name}"?\n\n'
            'Все студенты этой группы также будут удалены. Это действие нельзя отменить.'
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                
                try {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Удаление группы...'))
                    );
                  }
                  
                  bool success = await client.groups.deleteGroup(group.id!);
                  
                  if (success && mounted) {
                    await _loadGroups(query: _currentGroupsSearchQuery);
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Группа "${group.name}" успешно удалена'))
                    );
                  } else if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Не удалось удалить группу'))
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ошибка при удалении группы: $e'))
                    );
                  }
                }
              },
              child: const Text('Удалить'),
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
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _groupSearchController,
                  decoration: InputDecoration(
                    labelText: 'Поиск групп',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _groupSearchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _groupSearchController.clear();
                              _loadGroups(query: '');
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    _loadGroups(query: value);
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'Добавить группу',
                onPressed: _showCreateGroupDialog,
              ),
              IconButton(
                icon: const Icon(Icons.file_upload),
                onPressed: () async {
                  await importGroupFromCsv(context);
                  _loadGroups(); 
                },
                tooltip: 'Импорт группы из CSV',
              ),
              IconButton(
                icon: const Icon(Icons.download),
                onPressed: () async {
                  await exportGroupsToCsv(groups, students);
                  if (mounted) {
                     ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Экспорт всех групп запущен')),
                    );
                  }
                },
                tooltip: 'Экспорт всех групп в CSV',
              ),
            ],
          ),
        ),
        Expanded(
          child: groups.isEmpty
              ? const Center(child: Text('Группы не найдены'))
              : ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              final curator = teachers.firstWhereOrNull((t) => t.id == group.curatorId);
              final groupHeadStudent = students.firstWhereOrNull(
                (s) => s.groupsId == group.id && s.isGroupHead == true,
              );

              return ExpansionTile(
                title: Text(group.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                  'Куратор: ${curator?.person != null ? '${curator!.person!.firstName} ${curator.person!.lastName}' : 'Не назначен'}\n'
                  'Староста: ${groupHeadStudent?.person != null ? '${groupHeadStudent!.person!.firstName} ${groupHeadStudent.person!.lastName}' : 'Не назначен'}'
                ),
                children: [
                  ListTile(
                    title: const Text('Куратор'),
                    subtitle: Text(
                       curator?.person != null ? '${curator!.person!.firstName} ${curator.person!.lastName}' : 'Не назначен',
                    ),
                    trailing: const Icon(Icons.edit_outlined),
                    onTap: () {
                      _showSelectCuratorDialog(group);
                    },
                  ),
                  ListTile(
                    title: const Text('Староста'),
                    subtitle: Text(
                      groupHeadStudent?.person != null
                          ? '${groupHeadStudent!.person!.firstName} ${groupHeadStudent.person!.lastName}'
                          : 'Не назначен',
                    ),
                    trailing: const Icon(Icons.edit_outlined),
                    onTap: () {
                      _showSelectGroupHeadDialog(group);
                    },
                  ),
                  ListTile(
                    title: const Text('Экспорт группы'),
                    trailing: IconButton(
                      icon: const Icon(Icons.download_outlined),
                      onPressed: () async {
                        await exportGroupToCsv(group, students);
                        if (mounted) {
                           ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Группа "${group.name}" экспортирована')),
                          );
                        }
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Удалить группу', style: TextStyle(color: Colors.red)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_forever_outlined, color: Colors.red),
                      onPressed: () {
                        _showDeleteGroupConfirmation(group);
                      },
                    ),
                    tileColor: Colors.red.withOpacity(0.05),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
