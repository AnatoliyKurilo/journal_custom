import 'package:flutter/material.dart';
import 'package:journal_custom_client/journal_custom_client.dart';
import 'package:journal_custom_flutter/src/serverpod_client.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Управление посещаемостью'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Text(_errorMessage!),
                )
              : const Center(
                  child: Text('Здесь будет список занятий'),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddClassDialog,
        icon: const Icon(Icons.add),
        label: const Text('Добавить занятие'),
      ),
    );
  }

  Future<void> _showAddClassDialog() async {
    String? selectedSubject;
    String? selectedTeacher;
    DateTime? selectedDate;

    final formKey = GlobalKey<FormState>();
    final subjectController = TextEditingController();
    final teacherController = TextEditingController();
    final dateController = TextEditingController();

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Добавить занятие',
      pageBuilder: (context, animation, secondaryAnimation) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Добавить занятие'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Поле для выбора дисциплины
                    TextFormField(
                      controller: subjectController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Дисциплина',
                        suffixIcon: Icon(Icons.search),
                      ),
                      onTap: () async {
                        final subject = await _showSearchDialog(
                          context,
                          'Выберите дисциплину',
                          (query) => client.admin.searchSubjects(query: query),
                        );
                        if (subject != null) {
                          setDialogState(() {
                            selectedSubject = subject.name;
                            subjectController.text = subject.name;
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Выберите дисциплину';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Поле для выбора преподавателя
                    TextFormField(
                      controller: teacherController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Преподаватель',
                        suffixIcon: Icon(Icons.search),
                      ),
                      onTap: () async {
                        final teacher = await _showSearchDialog(
                          context,
                          'Выберите преподавателя',
                          (query) => client.admin.searchTeachers(query: query),
                        );
                        if (teacher != null) {
                          setDialogState(() {
                            selectedTeacher = teacher.person?.firstName ?? '';
                            teacherController.text =
                                '${teacher.person?.firstName} ${teacher.person?.lastName}';
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Выберите преподавателя';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Поле для выбора даты
                    TextFormField(
                      controller: dateController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Дата занятия',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          setDialogState(() {
                            selectedDate = date;
                            dateController.text =
                                '${date.day}.${date.month}.${date.year}';
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Выберите дату';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Отмена'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        // Отправляем данные на сервер
                        await client.admin.createClass(
                          subject: selectedSubject!,
                          teacher: selectedTeacher!,
                          date: selectedDate!,
                        );
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Занятие успешно добавлено'),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Ошибка: $e'),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Добавить'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<dynamic> _showSearchDialog(
    BuildContext context,
    String title,
    Future<List<dynamic>> Function(String query) searchFunction,
  ) async {
    String searchQuery = '';
    List<dynamic> results = [];

    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: title,
      pageBuilder: (context, animation, secondaryAnimation) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Поиск',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) async {
                      searchQuery = value;
                      final searchResults = await searchFunction(searchQuery);
                      setDialogState(() {
                        results = searchResults;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  if (results.isEmpty)
                    const Text('Ничего не найдено')
                  else
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final item = results[index];
                          return ListTile(
                            title: Text(item.name),
                            onTap: () => Navigator.of(context).pop(item),
                          );
                        },
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Отмена'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}