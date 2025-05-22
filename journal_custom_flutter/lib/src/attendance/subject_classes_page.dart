import 'package:flutter/material.dart';
import 'package:journal_custom_client/journal_custom_client.dart';
import 'package:journal_custom_flutter/src/serverpod_client.dart';
import 'package:intl/intl.dart'; // Для форматирования даты
import 'package:journal_custom_flutter/src/attendance/class_attendance_page.dart'; // Добавьте этот импорт

class SubjectClassesPage extends StatefulWidget {
  final Subjects subject;

  const SubjectClassesPage({Key? key, required this.subject}) : super(key: key);

  @override
  _SubjectClassesPageState createState() => _SubjectClassesPageState();
}

class _SubjectClassesPageState extends State<SubjectClassesPage> {
  bool _isLoading = true;
  String? _errorMessage;
  List<Classes> _classes = [];

  @override
  void initState() {
    super.initState();
    _fetchClassesForSubject();
  }

  Future<void> _fetchClassesForSubject() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      if (widget.subject.id == null) {
        throw Exception('ID предмета не может быть null');
      }
      final classes = await client.classes.getClassesBySubject(subjectId: widget.subject.id!);
      if (mounted) {
        setState(() {
          _classes = classes;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Ошибка загрузки занятий: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject.name ?? 'Занятия по предмету'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_errorMessage!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchClassesForSubject,
                        child: const Text('Попробовать снова'),
                      )
                    ],
                  ),
                )
              : _classes.isEmpty
                  ? const Center(
                      child: Text('По этому предмету еще нет занятий.'),
                    )
                  : ListView.builder(
                      itemCount: _classes.length,
                      itemBuilder: (context, index) {
                        final classItem = _classes[index];
                        String subtitleText =
                            'Дата: ${classItem.date != null ? DateFormat('dd.MM.yyyy HH:mm').format(classItem.date!) : 'Не указана'}';
                        if (classItem.topic != null && classItem.topic!.isNotEmpty) {
                          subtitleText += '\nТема: ${classItem.topic}';
                        }
                        if (classItem.notes != null && classItem.notes!.isNotEmpty) {
                          subtitleText += '\nПримечание: ${classItem.notes}';
                        }

                        return ListTile(
                          title: Text(
                              // Отображаем тип занятия, если он загружен
                              '${classItem.class_types?.name ?? 'Занятие'} ID: ${classItem.id}'),
                          subtitle: Text(subtitleText),
                          isThreeLine: (classItem.topic != null && classItem.topic!.isNotEmpty) ||
                              (classItem.notes != null && classItem.notes!.isNotEmpty),
                          onTap: () {
                            // Убедимся, что classItem.id не null перед навигацией
                            if (classItem.id != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ClassAttendancePage(classItem: classItem),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Ошибка: ID занятия не определен.')),
                              );
                            }
                          },
                        );
                      },
                    ),
    );
  }
}