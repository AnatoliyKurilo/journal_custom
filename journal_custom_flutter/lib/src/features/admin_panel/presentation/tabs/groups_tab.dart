import 'package:flutter/material.dart';
import 'package:journal_custom_client/journal_custom_client.dart';
import 'package:journal_custom_flutter/src/features/admin_panel/data/utils/export_groups_csv.dart';
import 'package:journal_custom_flutter/src/features/admin_panel/data/utils/import_groups_csv.dart';
import 'package:journal_custom_flutter/core/serverpod_client.dart';
import 'package:collection/collection.dart';
import 'dart:async'; // Добавляем для Timer
import 'package:journal_custom_flutter/src/widgets/csv_format_dialog.dart';


// Функция для фильтрации студентов по ФИО
List<Students> filterStudents(List<Students> allStudents, String query) {
  if (query.isEmpty) {
    return allStudents;
  }
  final lowerCaseQuery = query.toLowerCase();
  return allStudents.where((student) {
    final person = student.person;
    if (person == null) return false;

    final surname = person.lastName?.toLowerCase() ?? '';
    final name = person.firstName?.toLowerCase() ?? '';
    final patronymic = person.patronymic?.toLowerCase() ?? '';

    return surname.contains(lowerCaseQuery) ||
           name.contains(lowerCaseQuery) ||
           patronymic.contains(lowerCaseQuery) ||
           '$surname $name $patronymic'.trim().contains(lowerCaseQuery);
  }).toList();
}

class GroupsTab extends StatefulWidget {
  const GroupsTab({super.key});

  @override
  _GroupsTabState createState() => _GroupsTabState();
}

class _GroupsTabState extends State<GroupsTab> {
  bool isLoading = true;
  List<Groups> groups = [];
  List<Groups> filteredGroups = []; // Добавляем локальную фильтрацию
  List<Teachers> teachers = [];
  List<Students> students = [];
  String? errorMessage;
  String? _currentGroupsSearchQuery;
  final TextEditingController _groupSearchController = TextEditingController();
  Timer? _searchTimer; // Таймер для дебаунсинга

  @override
  void initState() {
    super.initState();
    _loadAllGroups(); // Загружаем все группы при инициализации
    _groupSearchController.addListener(_onSearchChanged); // Добавляем слушатель
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    _groupSearchController.removeListener(_onSearchChanged);
    _groupSearchController.dispose();
    super.dispose();
  }

  // Локальная фильтрация групп
  void _filterGroups(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredGroups = List.from(groups);
      } else {
        final lowerCaseQuery = query.toLowerCase();
        filteredGroups = groups.where((group) {
          final groupName = group.name?.toLowerCase() ?? '';
          final curatorName = group.curator?.person != null 
              ? '${group.curator!.person!.firstName} ${group.curator!.person!.lastName}'.toLowerCase()
              : '';
          
          return groupName.contains(lowerCaseQuery) ||
                 curatorName.contains(lowerCaseQuery);
        }).toList();
      }
    });
  }

  // Дебаунсинг для серверного поиска
  void _onSearchChanged() {
    final query = _groupSearchController.text;
    _searchTimer?.cancel();
    
    // Мгновенная локальная фильтрация
    _filterGroups(query);
    
    // Если запрос пустой, просто делаем локальную фильтрацию
    if (query.isEmpty) {
      return;
    }
    
    // Серверный поиск с задержкой
    _searchTimer = Timer(const Duration(milliseconds: 800), () {
      if (mounted) {
        _searchGroupsFromServer(query);
      }
    });
  }

  Future<void> _loadAllGroups() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      var loadedGroups = await client.groups.getAllGroups();
      var loadedTeachers = await client.teachers.getAllTeachers();
      var loadedStudents = await client.students.getAllStudents();

      if (mounted) {
        setState(() {
          this.groups = loadedGroups;
          this.filteredGroups = List.from(loadedGroups); // Синхронизируем фильтрованный список
          this.teachers = loadedTeachers;
          this.students = loadedStudents;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Ошибка загрузки групп: $e';
          isLoading = false;
        });
      }
    }
  }

  Future<void> _searchGroupsFromServer(String query) async {
    // НЕ показываем индикатор загрузки при поиске
    try {
      var loadedGroups = await client.search.searchGroups(query: query);
      
      if (mounted) {
        setState(() {
          this.groups = loadedGroups;
          this.filteredGroups = List.from(loadedGroups); // Обновляем и основной, и фильтрованный список
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Ошибка поиска групп: $e';
        });
      }
    }
  }

  // Устаревшие методы для совместимости
  Future<void> _loadGroups({String? query}) async {
    _currentGroupsSearchQuery = query;
    if (query == null || query.isEmpty) {
      await _loadAllGroups();
    } else {
      await _searchGroupsFromServer(query);
    }
  }

  Future<void> _searchTeachersInDialog(String query, Function(List<Teachers>) setStateCallback) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      var result = await client.search.searchTeachers(query: query);
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

  Future<void> _updateGroup(Groups group, {int? curatorId, int? groupHeadId}) async {
    try {
      await client.groups.updateGroup(group, newCuratorId: curatorId, newGroupHeadId: groupHeadId);
      await _loadAllGroups(); // Обновляем все данные

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
                    await client.groups.createGroup(groupName, null);
                    Navigator.of(context).pop();
                    _loadAllGroups();
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
                          filteredTeachers = await client.search.searchTeachers(query: searchQuery);
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
                    await _loadAllGroups();
                    
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

  Future<void> _importGroupsFromSchedule() async {
    final String? year = await _showYearInputDialog();
    if (year == null || year.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Год не указан. Импорт отменен.')),
        );
      }
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final resultMessage = await client.groups.importGroupsFromSchedule(year);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resultMessage),
            duration: const Duration(seconds: 7),
            action: SnackBarAction(label: 'OK', onPressed: () {}),
          ),
        );
        await _loadAllGroups();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка импорта групп из расписания: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<String?> _showYearInputDialog({
    String title = 'Импорт групп из расписания',
    String subtitle = 'Введите учебный год для импорта групп:',
  }) async {
    final TextEditingController yearController = TextEditingController(text: '2024-2025');
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(subtitle),
              const SizedBox(height: 16),
              TextField(
                controller: yearController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Учебный год',
                  hintText: '2024-2025',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Продолжить'),
              onPressed: () => Navigator.of(context).pop(yearController.text.trim()),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showImportClassesDialog(Groups group) async {
    final TextEditingController yearController = TextEditingController(text: '2024-2025');
    final TextEditingController startDateController = TextEditingController();
    final TextEditingController endDateController = TextEditingController();
    bool useDataFilter = false;

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Импорт занятий для "${group.name}"'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: yearController,
                      decoration: const InputDecoration(
                        labelText: 'Учебный год',
                        hintText: '2024-2025',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CheckboxListTile(
                      title: const Text('Фильтр по датам'),
                      subtitle: const Text('Импортировать только занятия в указанном периоде'),
                      value: useDataFilter,
                      onChanged: (value) {
                        setDialogState(() {
                          useDataFilter = value ?? false;
                        });
                      },
                    ),
                    if (useDataFilter) ...[
                      const SizedBox(height: 8),
                      TextField(
                        controller: startDateController,
                        decoration: const InputDecoration(
                          labelText: 'Дата начала',
                          hintText: 'YYYY-MM-DD',
                          border: OutlineInputBorder(),
                        ),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (date != null) {
                            startDateController.text = date.toIso8601String().split('T')[0];
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: endDateController,
                        decoration: const InputDecoration(
                          labelText: 'Дата окончания',
                          hintText: 'YYYY-MM-DD',
                          border: OutlineInputBorder(),
                        ),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now().add(const Duration(days: 30)),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (date != null) {
                            endDateController.text = date.toIso8601String().split('T')[0];
                          }
                        },
                      ),
                    ],
                    const SizedBox(height: 16),
                    const Text(
                      'Занятия будут импортированы из внешнего API расписания в систему журнала.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Отмена'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    
                    final year = yearController.text.trim();
                    final startDate = useDataFilter && startDateController.text.isNotEmpty 
                        ? startDateController.text 
                        : null;
                    final endDate = useDataFilter && endDateController.text.isNotEmpty 
                        ? endDateController.text 
                        : null;
                    
                    if (year.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Укажите учебный год')),
                      );
                      return;
                    }

                    // Показываем индикатор загрузки
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Импорт занятий из расписания...'),
                          ],
                        ),
                      ),
                    );

                    try {
                      final result = await client.classes.importClassesFromScheduleForGroup(
                        group.id!,
                        year,
                        startDate: startDate,
                        endDate: endDate,
                      );
                      
                      Navigator.pop(context); // Закрываем индикатор загрузки
                      
                      // Показываем результат
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Результат импорта'),
                          content: SingleChildScrollView(
                            child: Text(result),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    } catch (e) {
                      Navigator.pop(context); // Закрываем индикатор загрузки
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ошибка импорта: $e')),
                      );
                    }
                  },
                  child: const Text('Импортировать'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _synchronizeGroupIds() async {
    final String? year = await _showYearInputDialog(
      title: 'Синхронизация ID групп',
      subtitle: 'Введите учебный год для синхронизации ID групп с API расписания:',
    );
    
    if (year == null || year.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Год не указан. Синхронизация отменена.')),
        );
      }
      return;
    }

    // Показываем предупреждение
    final bool? confirmed = await _showSynchronizationWarningDialog();
    if (confirmed != true) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final resultMessage = await client.groups.synchronizeGroupIdsWithSchedule(year);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resultMessage),
            duration: const Duration(seconds: 10),
            action: SnackBarAction(label: 'OK', onPressed: () {}),
          ),
        );
        await _loadAllGroups();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка синхронизации ID групп: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<bool?> _showSynchronizationWarningDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 8),
              Text('Внимание!'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Синхронизация ID групп - это потенциально опасная операция.'),
              SizedBox(height: 8),
              Text('Что произойдет:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• ID групп в базе данных будут изменены на ID из API'),
              Text('• Все связанные записи (студенты, подгруппы, занятия) будут обновлены'),
              Text('• В случае конфликтов операция может быть отменена'),
              SizedBox(height: 8),
              Text('Рекомендуется создать резервную копию базы данных перед выполнением.',
                   style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Продолжить'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showCsvFormatWarningDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue),
              SizedBox(width: 8),
              Text('Формат CSV файла'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Для корректного импорта студентов CSV файл должен иметь следующий формат:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Заголовок (первая строка):',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                      Text(
                        'Имя,Фамилия,Отчество,Email,Телефон',
                        style: TextStyle(fontFamily: 'monospace'),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Пример данных:',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                      Text(
                        'Иван,Иванов,Иванович,ivan@example.com,79001234567\nПетр,Петров,Петрович,petr@example.com,79007654321',
                        style: TextStyle(fontFamily: 'monospace'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text('📋 Требования к файлу:'),
                const SizedBox(height: 8),
                _buildRequirementItem('• Кодировка: UTF-8'),
                _buildRequirementItem('• Разделитель: запятая (,) или точка с запятой (;)'),
                _buildRequirementItem('• Обязательные поля: Имя, Фамилия, Email'),
                _buildRequirementItem('• Необязательные поля: Отчество, Телефон'),
                _buildRequirementItem('• Email должен быть уникальным'),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.warning_amber, color: Colors.amber, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Название группы будет взято из имени файла или запрошено отдельно',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Продолжить импорт'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRequirementItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13),
      ),
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
              onPressed: _loadAllGroups,
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
                    hintText: 'Введите название группы или имя куратора...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  // НЕ используем onChanged здесь, так как у нас есть слушатель
                ),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                tooltip: 'Дополнительные действия',
                icon: const Icon(Icons.more_vert),
                onSelected: (String value) async {
                  switch (value) {
                    case 'import_schedule':
                      _importGroupsFromSchedule();
                      break;
                    case 'sync_ids':
                      _synchronizeGroupIds();
                      break;
                    case 'import_csv':
                      final shouldProceed = await CsvFormatDialog.showStudentCsvDialog(context);
                      if (shouldProceed == true) {
                        importGroupFromCsv(context).then((_) => _loadAllGroups());
                      }
                      break;
                    case 'export_csv':
                      exportGroupsToCsv(filteredGroups, students);
                      break;
                    case 'create_group':
                      _showCreateGroupDialog();
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'create_group',
                    child: ListTile(
                      leading: Icon(Icons.add),
                      title: Text('Создать группу'),
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem<String>(
                    value: 'import_schedule',
                    child: ListTile(
                      leading: Icon(Icons.cloud_download),
                      title: Text('Импорт из расписания'),
                    ),
                  ),
                  // const PopupMenuItem<String>(
                  //   value: 'sync_ids',
                  //   child: ListTile(
                  //     leading: Icon(Icons.sync, color: Colors.orange),
                  //     title: Text('Синхронизация ID'),
                  //     subtitle: Text('Обновить ID групп из API'),
                  //   ),
                  // ),
                  const PopupMenuDivider(),
                  const PopupMenuItem<String>(
                    value: 'import_csv',
                    child: ListTile(
                      leading: Icon(Icons.file_upload),
                      title: Text('Импорт из CSV'),
                    ),
                  ),
                  // const PopupMenuItem<String>(
                  //   value: 'export_csv',
                  //   child: ListTile(
                  //     leading: Icon(Icons.file_download),
                  //     title: Text('Экспорт в CSV'),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: filteredGroups.isEmpty && _groupSearchController.text.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Группы не найдены.'),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _showCreateGroupDialog,
                        icon: const Icon(Icons.add),
                        label: const Text('Создать первую группу'),
                      ),
                    ],
                  ),
                )
              : filteredGroups.isEmpty && _groupSearchController.text.isNotEmpty
                  ? const Center(child: Text('Группы по вашему запросу не найдены'))
                  : ListView.builder(
                      itemCount: filteredGroups.length,
                      itemBuilder: (context, index) {
                        final group = filteredGroups[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: ListTile(
                            title: Text(group.name ?? 'Группа без названия'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ID: ${group.id}'), // Показываем ID группы
                                if (group.curator?.person != null)
                                  Text('Куратор: ${group.curator!.person!.firstName} ${group.curator!.person!.lastName}')
                                else
                                  const Text('Куратор не назначен'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.schedule_outlined),
                                  tooltip: 'Импорт занятий из расписания',
                                  onPressed: () => _showImportClassesDialog(group),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.assignment_ind_outlined),
                                  tooltip: 'Назначить куратора',
                                  onPressed: () => _showSelectCuratorDialog(group),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.person_search_outlined),
                                  tooltip: 'Назначить старосту',
                                  onPressed: () => _showSelectGroupHeadDialog(group),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  tooltip: 'Удалить группу',
                                  onPressed: () => _showDeleteGroupConfirmation(group),
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
