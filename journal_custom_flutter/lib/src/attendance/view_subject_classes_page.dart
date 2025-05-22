import 'package:flutter/material.dart';
import 'package:journal_custom_client/journal_custom_client.dart';
import 'package:journal_custom_flutter/src/serverpod_client.dart';
import 'package:intl/intl.dart';
import 'package:journal_custom_flutter/src/attendance/view_class_attendance_page.dart'; // Для навигации
import 'package:journal_custom_flutter/src/attendance/subject_overall_attendance_page.dart'; // Новый импорт

class ViewSubjectClassesPage extends StatefulWidget {
  final Subjects subject;

  const ViewSubjectClassesPage({Key? key, required this.subject}) : super(key: key);

  @override
  _ViewSubjectClassesPageState createState() => _ViewSubjectClassesPageState();
}

class _ViewSubjectClassesPageState extends State<ViewSubjectClassesPage> {
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
        title: Text('Занятия: ${widget.subject.name ?? 'Предмет'}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.table_chart_outlined),
            tooltip: 'Сводный отчет по предмету',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubjectOverallAttendancePage(subject: widget.subject),
                ),
              );
            },
          ),
        ],
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
                              '${classItem.class_types?.name ?? 'Занятие'} ID: ${classItem.id}'),
                          subtitle: Text(subtitleText),
                          isThreeLine: (classItem.topic != null && classItem.topic!.isNotEmpty) ||
                              (classItem.notes != null && classItem.notes!.isNotEmpty),
                          onTap: () {
                            if (classItem.id != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewClassAttendancePage(classItem: classItem),
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