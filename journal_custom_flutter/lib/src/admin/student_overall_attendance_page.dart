import 'package:flutter/material.dart';
import 'package:journal_custom_client/journal_custom_client.dart';
import 'package:journal_custom_flutter/src/serverpod_client.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart'; // Для groupBy

class StudentOverallAttendancePage extends StatefulWidget {
  final Students student;

  const StudentOverallAttendancePage({Key? key, required this.student}) : super(key: key);

  @override
  _StudentOverallAttendancePageState createState() => _StudentOverallAttendancePageState();
}

class _StudentOverallAttendancePageState extends State<StudentOverallAttendancePage> {
  bool _isLoading = true;
  String? _errorMessage;
  List<StudentOverallAttendanceRecord> _attendanceRecords = [];
  Map<String, List<StudentOverallAttendanceRecord>> _groupedRecords = {};

  @override
  void initState() {
    super.initState();
    _fetchAttendanceRecords();
  }

  Future<void> _fetchAttendanceRecords() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _attendanceRecords = [];
      _groupedRecords = {};
    });
    try {
      if (widget.student.id == null) {
        throw Exception('ID студента не может быть null');
      }
      final records = await client.admin.getStudentOverallAttendanceRecords(widget.student.id!);

      // Группировка по предмету
      final Map<String, List<StudentOverallAttendanceRecord>> grouped =
          groupBy(records, (StudentOverallAttendanceRecord record) => record.subjectName);

      if (mounted) {
        setState(() {
          _attendanceRecords = records;
          _groupedRecords = grouped;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Ошибка загрузки посещаемости: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String studentFullName =
        '${widget.student.person?.lastName ?? ''} ${widget.student.person?.firstName ?? ''} ${widget.student.person?.patronymic ?? ''}'
            .trim();
    if (studentFullName.isEmpty) studentFullName = 'Студент ID: ${widget.student.id}';

    return Scaffold(
      appBar: AppBar(
        title: Text('Посещаемость: $studentFullName', overflow: TextOverflow.ellipsis),
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
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _fetchAttendanceRecords,
                          child: const Text('Попробовать снова'),
                        )
                      ],
                    ),
                  ),
                )
              : _attendanceRecords.isEmpty
                  ? const Center(
                      child: Text('Нет данных о посещаемости для этого студента.'),
                    )
                  : ListView.builder(
                      itemCount: _groupedRecords.keys.length,
                      itemBuilder: (context, subjectIndex) {
                        final subjectName = _groupedRecords.keys.elementAt(subjectIndex);
                        final recordsForSubject = _groupedRecords[subjectName]!;
                        int attendedCount = recordsForSubject.where((r) => r.isPresent).length;
                        int totalCount = recordsForSubject.length;
                        double percentage = totalCount > 0 ? (attendedCount / totalCount) * 100 : 0.0;

                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: ExpansionTile(
                            title: Text(
                              '$subjectName (${percentage.toStringAsFixed(0)}% - $attendedCount/$totalCount)',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            children: recordsForSubject.map((record) {
                              return ListTile(
                                title: Text(
                                    '${record.classTypeName ?? "Занятие"} (${DateFormat('dd.MM.yyyy HH:mm').format(record.classDate)})' +
                                    (record.classTopic != null && record.classTopic!.isNotEmpty ? '\nТема: ${record.classTopic}' : '') +
                                    (record.subgroupName != null ? '\nПодгруппа: ${record.subgroupName}' : '')
                                ),
                                subtitle: Text(
                                  record.comment ?? (record.isPresent ? 'Присутствовал' : 'Отсутствовал'),
                                  style: TextStyle(color: record.isPresent ? Colors.green.shade700 : Colors.red.shade700),
                                ),
                                trailing: Icon(
                                  record.isPresent ? Icons.check_circle_outline : Icons.highlight_off,
                                  color: record.isPresent ? Colors.green : Colors.red,
                                ),
                                isThreeLine: (record.classTopic != null && record.classTopic!.isNotEmpty) || (record.subgroupName != null),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
    );
  }
}