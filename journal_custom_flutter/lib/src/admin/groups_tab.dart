import 'package:flutter/material.dart';
import 'package:journal_custom_client/journal_custom_client.dart';
import 'package:journal_custom_flutter/src/admin/filework/export_groups_csv.dart';
import 'package:journal_custom_flutter/src/admin/filework/import_groups_csv.dart';
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
  List<Teachers> filteredTeachers = []; // Эта переменная используется в _showSelectCuratorDialog
  List<Students> students = [];
  String? errorMessage;
  String? _currentGroupsSearchQuery; // Новая переменная для хранения текущего поискового запроса групп

  @override
  void initState() {
    super.initState();
    _loadGroups(); // Начальная загрузка без поискового запроса
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
    // Если новый поисковый запрос предоставлен (из поля поиска), обновляем _currentGroupsSearchQuery.
    // Если query равен null (например, при вызове из _updateGroup или initState),
    // _currentGroupsSearchQuery сохраняет свое предыдущее значение.
    if (query != null) {
      _currentGroupsSearchQuery = query;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Используем _currentGroupsSearchQuery для загрузки или поиска групп
      var loadedGroups = (_currentGroupsSearchQuery == null || _currentGroupsSearchQuery!.isEmpty)
          ? await client.admin.getAllGroups()
          : await client.admin.searchGroups(query: _currentGroupsSearchQuery!);

      // Загружаем полный список преподавателей и студентов, так как они нужны для выбора и отображения
      var loadedTeachers = await client.admin.getAllTeachers();
      var loadedStudents = await client.admin.getAllStudents();

      if (mounted) { // Проверка, что виджет все еще в дереве
        setState(() {
          groups = loadedGroups;
          teachers = loadedTeachers;
          students = loadedStudents;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) { // Проверка, что виджет все еще в дереве
        setState(() {
          errorMessage = 'Ошибка загрузки данных: $e';
          isLoading = false;
        });
      }
    }
  }

  Future<void> _updateGroup(Groups group, {int? curatorId, int? groupHeadId}) async {
    try {
      // Измените вызов метода updateGroup, чтобы он соответствовал сигнатуре на сервере
      await client.admin.updateGroup(group, newCuratorId: curatorId, newGroupHeadId: groupHeadId);
      
      // Перезагружаем данные, используя текущий сохраненный поисковый запрос для групп
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
                    await client.admin.createGroup(groupName, null); // Replace 'null' with appropriate values if needed
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
        return StatefulBuilder(
          builder: (context, setState) {
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
                      onChanged: (value) {
                        // Реализуем локальный поиск по студентам группы
                        setState(() {
                          searchQuery = value.toLowerCase();
                          filteredStudents = students.where((student) => 
                            student.groupsId == group.id && 
                            (student.person?.firstName?.toLowerCase().contains(searchQuery) == true || 
                             student.person?.lastName?.toLowerCase().contains(searchQuery) == true ||
                             student.person?.email?.toLowerCase().contains(searchQuery) == true)
                          ).toList();
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: filteredStudents.isEmpty
                          ? const Center(child: Text('Студенты не найдены'))
                          : ListView.builder(
                              itemCount: filteredStudents.length,
                              itemBuilder: (context, index) {
                                final student = filteredStudents[index];
                                final person = student.person;
                                final bool isCurrentHead = student.isGroupHead == true;
                                
                                return ListTile(
                                  title: Text('${person?.firstName ?? ''} ${person?.lastName ?? ''}'),
                                  subtitle: Text('Email: ${person?.email ?? 'Не указан'}'),
                                  // Добавляем индикатор текущего старосты
                                  trailing: isCurrentHead 
                                    ? const Icon(Icons.star, color: Colors.amber) 
                                    : null,
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

  // Метод для показа диалога подтверждения удаления группы
  Future<void> _showDeleteGroupConfirmation(Groups group) async {
    return showDialog(
      context: context,
      builder: (dialogContext) { // Используем отдельный dialogContext
        return AlertDialog(
          title: const Text('Удаление группы'),
          content: Text(
            'Вы действительно хотите удалить группу "${group.name}"?\n\n'
            'Все студенты этой группы также будут удалены. Это действие нельзя отменить.'
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Используем dialogContext
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              onPressed: () async {
                // Закрываем диалог до начала асинхронных операций
                Navigator.of(dialogContext).pop();
                
                try {
                  // Показываем индикатор загрузки, если виджет всё еще в дереве
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Удаление группы...'))
                    );
                  }
                  
                  // Вызываем метод удаления группы
                  bool success = await client.admin.deleteGroup(group.id!);
                  
                  // Проверяем, что виджет всё еще в дереве, прежде чем обновить UI
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
                    // При поиске передаем новое значение query,
                    // _loadGroups обновит _currentGroupsSearchQuery
                    _loadGroups(query: value); 
                  },
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Добавить группу'),
                onPressed: _showCreateGroupDialog, // Открываем диалог добавления группы
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.upload_file),
                label: const Text('Импорт из CSV'),
                onPressed: () async {
                  await importGroupFromCsv(context); // Передаем BuildContext
                  await _loadGroups(); // Обновляем список групп после импорта
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Импорт данных завершен')),
                  );
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              // Ищем старосту в общем списке студентов для данной группы
              Students? groupHeadStudent;
              try {
                groupHeadStudent = students.firstWhere(
                  (student) => student.groupsId == group.id && student.isGroupHead == true,
                );
              } catch (e) {
                // Если староста не найден (firstWhere выбросит исключение), оставляем groupHeadStudent null
                groupHeadStudent = null;
              }

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
                          groupHeadStudent?.person != null
                              ? '${groupHeadStudent!.person!.firstName} ${groupHeadStudent.person!.lastName}'
                              : 'Не назначен',
                        ),
                        onTap: () {
                          _showSelectGroupHeadDialog(group); // Открываем диалог выбора старосты
                        },
                      ),
                      ListTile(
                        title: const Text('Экспорт группы'),
                        trailing: IconButton(
                          icon: const Icon(Icons.download),
                          onPressed: () async {
                            await exportGroupToCsv(group, students); // Экспортируем данные группы
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Группа "${group.name}" успешно экспортирована')),
                            );
                          },
                        ),
                      ),
                      // Новая кнопка для удаления группы
                      ListTile(
                        title: const Text('Удалить группу'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _showDeleteGroupConfirmation(group),
                        ),
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
