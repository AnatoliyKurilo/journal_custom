import 'package:flutter/material.dart';
import 'package:journal_custom_client/journal_custom_client.dart';
import 'package:journal_custom_flutter/src/serverpod_client.dart';
import 'package:intl/intl.dart';

class ViewClassAttendancePage extends StatefulWidget {
  final Classes classItem;

  const ViewClassAttendancePage({Key? key, required this.classItem}) : super(key: key);

  @override
  _ViewClassAttendancePageState createState() => _ViewClassAttendancePageState();
}

class _ViewClassAttendancePageState extends State<ViewClassAttendancePage> {
  bool _isLoading = true;
  String? _errorMessage;
  List<StudentAttendanceInfo> _studentAttendanceList = [];

  @override
  void initState() {
    super.initState();
    _fetchStudentAttendance();
  }

  Future<void> _fetchStudentAttendance() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      if (widget.classItem.id == null) {
        throw Exception('ID занятия не может быть null');
      }
      final studentInfoList = await client.classes.getStudentsForClassWithAttendance(classId: widget.classItem.id!);
      if (mounted) {
        // Сортируем студентов по фамилии и имени для удобства
        studentInfoList.sort((a, b) {
          final lastNameA = a.student.person?.lastName?.toLowerCase() ?? '';
          final lastNameB = b.student.person?.lastName?.toLowerCase() ?? '';
          int lastNameComparison = lastNameA.compareTo(lastNameB);
          if (lastNameComparison != 0) {
            return lastNameComparison;
          }
          final firstNameA = a.student.person?.firstName?.toLowerCase() ?? '';
          final firstNameB = b.student.person?.firstName?.toLowerCase() ?? '';
          return firstNameA.compareTo(firstNameB);
        });
        setState(() {
          _studentAttendanceList = studentInfoList;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Ошибка загрузки данных о посещаемости: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String classTitle = 'Просмотр посещаемости';
    if (widget.classItem.subjects?.name != null) {
      classTitle += ': ${widget.classItem.subjects!.name}';
    }
    if (widget.classItem.date != null) {
      classTitle += ' (${DateFormat('dd.MM.yyyy HH:mm').format(widget.classItem.date!)})';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(classTitle, overflow: TextOverflow.ellipsis),
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
                        onPressed: _fetchStudentAttendance,
                        child: const Text('Попробовать снова'),
                      )
                    ],
                  ),
                )
              : _studentAttendanceList.isEmpty
                  ? const Center(
                      child: Text('Нет студентов для отображения посещаемости.'),
                    )
                  : SingleChildScrollView( // Оборачиваем DataTable в SingleChildScrollView для горизонтальной прокрутки, если таблица широкая
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView( // И для вертикальной, если список длинный
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          columnSpacing: 20, // Расстояние между колонками
                          headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blueGrey.shade100),
                          columns: const [
                            DataColumn(label: Text('Студент', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Статус', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Комментарий', style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                          rows: _studentAttendanceList.map((studentInfo) {
                            final student = studentInfo.student;
                            return DataRow(cells: [
                              DataCell(Text(
                                  '${student.person?.lastName ?? ''} ${student.person?.firstName ?? ''} ${student.person?.patronymic ?? ''}'.trim())),
                              DataCell(Text(
                                studentInfo.isPresent ? 'Присутствовал' : 'Отсутствовал',
                                style: TextStyle(
                                  color: studentInfo.isPresent ? Colors.green.shade700 : Colors.red.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                              DataCell(Text(studentInfo.comment ?? '')),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
    );
  }
}