import 'package:flutter/material.dart';
import 'package:journal_custom_client/journal_custom_client.dart';
import 'package:journal_custom_flutter/src/serverpod_client.dart';

class SubgroupDetailPage extends StatefulWidget {
  final Subgroups initialSubgroup;

  const SubgroupDetailPage({super.key, required this.initialSubgroup});

  @override
  _SubgroupDetailPageState createState() => _SubgroupDetailPageState();
}

class _SubgroupDetailPageState extends State<SubgroupDetailPage> {
  bool _isLoading = true;
  String? _errorMessage;
  List<Students> _subgroupStudents = [];
  List<Students> _availableStudents = []; // Студенты основной группы, не в этой подгруппе
  late Subgroups _currentSubgroup;

  @override
  void initState() {
    super.initState();
    _currentSubgroup = widget.initialSubgroup;
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final studentsIn = await client.subgroups.getSubgroupStudents(_currentSubgroup.id!);
      final studentsOut = await client.subgroups.getStudentsNotInSubgroup(_currentSubgroup.id!);
      if (mounted) {
        setState(() {
          _subgroupStudents = studentsIn;
          _availableStudents = studentsOut;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _showEditSubgroupDialog() async {
    final nameController = TextEditingController(text: _currentSubgroup.name);
    final descriptionController = TextEditingController(text: _currentSubgroup.description ?? '');
    final formKey = GlobalKey<FormState>();

    final updated = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Редактировать подгруппу'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Название подгруппы'),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Введите название';
                    return null;
                  },
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Описание (необязательно)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Отмена')),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    final updatedSubgroup = await client.subgroups.updateSubgroup(
                      _currentSubgroup.id!,
                      nameController.text,
                      descriptionController.text.isEmpty ? null : descriptionController.text,
                    );
                    if (mounted) {
                       setState(() {
                         _currentSubgroup = updatedSubgroup;
                       });
                    }
                    Navigator.of(context).pop(true); // Успешно
                  } catch (e) {
                    Navigator.of(context).pop(false);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ошибка обновления: ${e.toString()}')),
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
     if (updated == true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Подгруппа обновлена!')),
        );
        // Возвращаем true, чтобы предыдущая страница знала об обновлении
        // Navigator.of(context).pop(true); // Это не нужно здесь, т.к. диалог уже закрыт
    }
  }

  Future<void> _confirmDeleteSubgroup() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Удалить подгруппу?'),
          content: Text('Вы уверены, что хотите удалить подгруппу "${_currentSubgroup.name}"?'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Отмена')),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await client.subgroups.deleteSubgroup(_currentSubgroup.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Подгруппа удалена!')),
          );
          Navigator.of(context).pop(true); // Возвращаемся на предыдущую страницу, сигнализируя об изменениях
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка удаления: ${e.toString()}')),
          );
        }
      }
    }
  }

  Future<void> _showAddStudentDialog() async {
    if (_availableStudents.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Все студенты группы уже в этой подгруппе или нет доступных студентов.')),
      );
      return;
    }
    Students? selectedStudent;

    final studentToAdd = await showDialog<Students>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Добавить студента в подгруппу'),
              content: DropdownButtonFormField<Students>(
                hint: const Text('Выберите студента'),
                value: selectedStudent,
                isExpanded: true,
                items: _availableStudents.map((student) {
                  return DropdownMenuItem<Students>(
                    value: student,
                    child: Text('${student.person?.firstName ?? ""} ${student.person?.lastName ?? ""}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setDialogState(() {
                    selectedStudent = value;
                  });
                },
                validator: (value) => value == null ? 'Выберите студента' : null,
              ),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Отмена')),
                ElevatedButton(
                  onPressed: selectedStudent == null ? null : () => Navigator.of(context).pop(selectedStudent),
                  child: const Text('Добавить'),
                ),
              ],
            );
          },
        );
      },
    );

    if (studentToAdd != null) {
      try {
        await client.subgroups.addStudentToSubgroup(_currentSubgroup.id!, studentToAdd.id!);
        _loadData(); // Обновляем списки
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Студент добавлен!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка добавления: ${e.toString()}')),
          );
        }
      }
    }
  }

  Future<void> _removeStudent(Students student) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Удалить студента из подгруппы?'),
          content: Text('Удалить ${student.person?.firstName} ${student.person?.lastName}?'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Отмена')),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );
    if (confirm == true) {
      try {
        await client.subgroups.removeStudentFromSubgroup(_currentSubgroup.id!, student.id!);
        _loadData(); // Обновляем списки
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Студент удален из подгруппы!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка удаления: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Подгруппа: ${_currentSubgroup.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Редактировать детали подгруппы',
            onPressed: _showEditSubgroupDialog,
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Удалить подгруппу',
            onPressed: _confirmDeleteSubgroup,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_errorMessage!, textAlign: TextAlign.center),
                        const SizedBox(height: 20),
                        ElevatedButton(onPressed: _loadData, child: const Text('Повторить')),
                      ],
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_currentSubgroup.description != null && _currentSubgroup.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(_currentSubgroup.description!, style: Theme.of(context).textTheme.titleMedium),
                      ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          // Пороговое значение ширины, при котором макет меняется.
                          // Подберите это значение в зависимости от ваших предпочтений и контента.
                          const double breakpoint = 380.0; 

                          if (constraints.maxWidth < breakpoint) {
                            // Вертикальный макет для узких экранов
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Студенты в подгруппе', style: Theme.of(context).textTheme.titleLarge),
                                // const SizedBox(height: 8), // Убираем этот отступ, чтобы кнопка не "съезжала"
                                Align( 
                                  alignment: Alignment.centerRight,
                                  child: Tooltip( // Добавляем Tooltip для отображения текста при наведении/долгом нажатии
                                    message: 'Добавить студента',
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.person_add),
                                      label: const SizedBox.shrink(), // Скрываем текстовую метку
                                      onPressed: _showAddStudentDialog,
                                      style: ElevatedButton.styleFrom(
                                        // Можно немного уменьшить отступы, если кнопка кажется слишком широкой только с иконкой
                                        // padding: const EdgeInsets.symmetric(horizontal: 12.0), 
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            // Горизонтальный макет для широких экранов
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Студенты в подгруппе', style: Theme.of(context).textTheme.titleLarge),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.person_add),
                                  label: const Text('Добавить'),
                                  onPressed: _showAddStudentDialog,
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: _subgroupStudents.isEmpty
                          ? const Center(child: Text('В этой подгруппе пока нет студентов.'))
                          : ListView.builder(
                              itemCount: _subgroupStudents.length,
                              itemBuilder: (context, index) {
                                final student = _subgroupStudents[index];
                                return ListTile(
                                  leading: CircleAvatar(child: Text(student.person?.firstName?.substring(0, 1) ?? '')),
                                  title: Text('${student.person?.firstName ?? ""} ${student.person?.lastName ?? ""}'),
                                  subtitle: Text(student.person?.email ?? 'Email не указан'),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                    onPressed: () => _removeStudent(student),
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