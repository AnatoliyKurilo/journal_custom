import 'package:flutter/material.dart';
import 'package:journal_custom_client/journal_custom_client.dart';
import 'package:journal_custom_flutter/src/serverpod_client.dart';
import 'package:journal_custom_flutter/src/group_head/subgroup_detail_page.dart';

class GroupHeadPage extends StatefulWidget {
  const GroupHeadPage({super.key});

  @override
  _GroupHeadPageState createState() => _GroupHeadPageState();
}

class _GroupHeadPageState extends State<GroupHeadPage> {
  bool _isLoading = true;
  String? _errorMessage;
  Groups? _currentGroup;
  List<Subgroups> _subgroups = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final group = await client.subgroups.getCurrentUserGroup();
      if (group == null) {
        throw Exception(
            'Не удалось определить вашу группу. Убедитесь, что вы студент и назначены старостой с соответствующими правами.');
      }

      final subgroups = await client.subgroups.getGroupSubgroups(group.id!);

      if (mounted) {
        setState(() {
          _currentGroup = group;
          _subgroups = subgroups;
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

  Future<void> _showCreateOrEditSubgroupDialog({Subgroups? existingSubgroup}) async {
    if (_currentGroup == null) return;

    final isEditing = existingSubgroup != null;
    final nameController = TextEditingController(text: existingSubgroup?.name ?? '');
    final descriptionController = TextEditingController(text: existingSubgroup?.description ?? '');
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isEditing ? 'Редактировать подгруппу' : 'Создать подгруппу'),
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
                  maxLines: 2,
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
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    if (isEditing) {
                      await client.subgroups.updateSubgroup(
                        existingSubgroup!.id!,
                        nameController.text,
                        descriptionController.text.isEmpty ? null : descriptionController.text,
                      );
                    } else {
                      await client.subgroups.createSubgroup(
                        _currentGroup!.id!,
                        nameController.text,
                        descriptionController.text.isEmpty ? null : descriptionController.text,
                      );
                    }
                    Navigator.of(context).pop(true); // Успешно
                  } catch (e) {
                    Navigator.of(context).pop(false); // Закрыть диалог
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ошибка: ${e.toString()}')),
                      );
                    }
                  }
                }
              },
              child: Text(isEditing ? 'Сохранить' : 'Создать'),
            ),
          ],
        );
      },
    );

    if (result == true && mounted) {
      _loadData(); // Перезагружаем данные для обновления списка
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isEditing ? 'Подгруппа обновлена!' : 'Подгруппа создана!')),
      );
    }
  }

  Future<void> _showCreateFullGroupSubgroupDialog() async {
    if (_currentGroup == null) return;

    final nameController = TextEditingController(text: 'Все студенты');
    final descriptionController = TextEditingController(text: 'Подгруппа со всеми студентами группы ${_currentGroup!.name}');
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Создать подгруппу со всеми студентами'),
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
                  maxLines: 2,
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
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    await client.subgroups.createFullGroupSubgroup(
                      _currentGroup!.id!,
                      nameController.text,
                      descriptionController.text.isEmpty ? null : descriptionController.text,
                    );
                    Navigator.of(context).pop(true); // Успешно
                  } catch (e) {
                    Navigator.of(context).pop(false); // Закрыть диалог
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ошибка: ${e.toString()}')),
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

    if (result == true && mounted) {
      _loadData(); // Перезагружаем данные для обновления списка
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Подгруппа со всеми студентами создана!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Всегда оборачиваем содержимое в Scaffold для корректного отображения Material Design
    return Scaffold(
      appBar: AppBar(
        title: Text('Подгруппы: ${_currentGroup?.name ?? "Моя группа"}'),
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Управление подгруппами для группы "${_currentGroup?.name}"',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Expanded(
                      child: _subgroups.isEmpty
                          ? const Center(child: Text('Подгруппы еще не созданы.'))
                          : ListView.builder(
                              itemCount: _subgroups.length,
                              itemBuilder: (context, index) {
                                final subgroup = _subgroups[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: ListTile(
                                    title: Text(subgroup.name),
                                    subtitle: subgroup.description != null && subgroup.description!.isNotEmpty
                                        ? Text(subgroup.description!)
                                        : null,
                                    trailing: const Icon(Icons.arrow_forward_ios),
                                    onTap: () async {
                                      final refresh = await Navigator.push<bool>(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SubgroupDetailPage(initialSubgroup: subgroup),
                                        ),
                                      );
                                      if (refresh == true) {
                                        _loadData(); // Обновляем список, если подгруппа была изменена/удалена
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
      floatingActionButton: !_isLoading && _errorMessage == null 
      ? Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              heroTag: 'createFullGroupSubgroup',
              onPressed: _showCreateFullGroupSubgroupDialog,
              icon: const Icon(Icons.group),
              label: const Text('Подгруппа со всеми'),
              backgroundColor: Colors.green,
            ),
            const SizedBox(width: 16),
            FloatingActionButton.extended(
              heroTag: 'createSubgroup',
              onPressed: () => _showCreateOrEditSubgroupDialog(),
              icon: const Icon(Icons.add),
              label: const Text('Создать подгруппу'),
            ),
          ],
        ) 
      : null,
    );
  }
}