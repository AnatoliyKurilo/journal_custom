import 'package:flutter/material.dart';
import 'package:journal_custom_client/journal_custom_client.dart';
import 'package:journal_custom_flutter/src/serverpod_client.dart';
import 'package:intl/intl.dart';

class ClassAttendancePage extends StatefulWidget {
  final Classes classItem;

  const ClassAttendancePage({Key? key, required this.classItem}) : super(key: key);

  @override
  _ClassAttendancePageState createState() => _ClassAttendancePageState();
}

class _ClassAttendancePageState extends State<ClassAttendancePage> {
  bool _isLoading = true;
  String? _errorMessage;
  List<StudentAttendanceInfo> _studentAttendanceList = [];
  Map<int, bool> _attendanceStatus = {}; // studentId -> isPresent
  Map<int, TextEditingController> _commentControllers = {};

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
        setState(() {
          _studentAttendanceList = studentInfoList;
          _attendanceStatus = {
            for (var info in studentInfoList) info.student.id!: info.isPresent
          };
          _commentControllers = {
            for (var info in studentInfoList)
              info.student.id!: TextEditingController(text: info.comment ?? '')
          };
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

  Future<void> _updateAttendance(int studentId, bool isPresent, String? comment) async {
    try {
      await client.classes.updateStudentAttendance(
        classId: widget.classItem.id!,
        studentId: studentId,
        isPresent: isPresent,
        comment: comment,
      );
      // Можно показать SnackBar об успехе, но для быстрого UI можно и не показывать
      // Обновляем локальное состояние, чтобы не перезагружать все данные
      final index = _studentAttendanceList.indexWhere((info) => info.student.id == studentId);
      if (index != -1) {
        final updatedInfo = _studentAttendanceList[index].copyWith(
          isPresent: isPresent,
          comment: comment,
          // attendanceId можно обновить, если сервер его возвращает после создания/обновления
        );
         if (mounted) {
            setState(() {
              _studentAttendanceList[index] = updatedInfo;
              _attendanceStatus[studentId] = isPresent;
            });
         }
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка обновления посещаемости: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _commentControllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String classTitle = 'Посещаемость';
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
                      child: Text('Нет студентов для отметки посещаемости.'),
                    )
                  : ListView.builder(
                      itemCount: _studentAttendanceList.length,
                      itemBuilder: (context, index) {
                        final studentInfo = _studentAttendanceList[index];
                        final student = studentInfo.student;
                        final studentId = student.id!;
                        final commentController = _commentControllers[studentId]!;

                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${student.person?.lastName ?? ''} ${student.person?.firstName ?? ''} ${student.person?.patronymic ?? ''}'.trim(),
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                    ),
                                    Switch(
                                      value: _attendanceStatus[studentId] ?? false,
                                      onChanged: (bool value) {
                                        setState(() {
                                          _attendanceStatus[studentId] = value;
                                        });
                                        _updateAttendance(studentId, value, commentController.text);
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                TextField(
                                  controller: commentController,
                                  decoration: const InputDecoration(
                                    labelText: 'Комментарий (причина отсутствия)',
                                    isDense: true,
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (value) {
                                    // Можно добавить debounce, чтобы не вызывать _updateAttendance на каждое изменение
                                  },
                                  onSubmitted: (value) { // Обновляем при завершении ввода
                                     _updateAttendance(studentId, _attendanceStatus[studentId] ?? false, value);
                                  },
                                  onEditingComplete: () { // Также обновляем, когда фокус уходит
                                    _updateAttendance(studentId, _attendanceStatus[studentId] ?? false, commentController.text);
                                    FocusScope.of(context).unfocus(); // Скрыть клавиатуру
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}