import 'package:flutter/material.dart';
import 'package:journal_custom_client/journal_custom_client.dart';
import 'package:journal_custom_flutter/core/serverpod_client.dart';
import 'package:intl/intl.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart'; // Добавляем импорт

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
  Map<int, bool> _attendanceStatus = {};
  Map<int, TextEditingController> _commentControllers = {};
  bool _isClassClosed = false;
  DateTime? _closedAt;
  String? _closedByTeacher;

  // Добавляем метод для проверки прав пользователя
  bool _canManageClassStatus() {
    final userScopes = sessionManager.signedInUser?.scopeNames ?? [];
    
    // Только администраторы и преподаватели могут закрывать/открывать занятия
    return userScopes.contains('serverpod.admin') || 
           userScopes.contains('teacher');
  }

  @override
  void initState() {
    super.initState();
    _fetchStudentAttendance();
    _fetchClassStatus(); // Новый метод
  }

  Future<void> _fetchClassStatus() async {
    try {
      if (widget.classItem.id == null) return;
      
      final status = await client.classes.getClassStatus(widget.classItem.id!);
      if (mounted) {
        setState(() {
          _isClassClosed = status['isClosed'] ?? false;
          _closedAt = status['closedAt'] != null 
              ? DateTime.parse(status['closedAt']) 
              : null;
          _closedByTeacher = status['closedByTeacher'];
        });
      }
    } catch (e) {
      // Логируем ошибку, но не прерываем работу
      print('Ошибка получения статуса занятия: $e');
      // Если не удалось получить статус, используем данные из объекта занятия
      if (mounted) {
        setState(() {
          _isClassClosed = widget.classItem.isClosedByTeacher ?? false;
          _closedAt = widget.classItem.closedAt;
        });
      }
    }
  }

  Future<void> _closeClass() async {
    try {
      await client.classes.closeClassByTeacher(widget.classItem.id!);
      await _fetchClassStatus(); // Обновляем статус
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Занятие закрыто. Изменения посещаемости запрещены.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка закрытия занятия: $e')),
        );
      }
    }
  }

  Future<void> _reopenClass() async {
    try {
      await client.classes.reopenClass(widget.classItem.id!);
      await _fetchClassStatus(); // Обновляем статус
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Занятие открыто для редактирования.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка открытия занятия: $e')),
        );
      }
    }
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
      final studentInfoList = await client.attendance.getStudentsForClassWithAttendance(classId: widget.classItem.id!);
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
      await client.attendance.updateStudentAttendance(
        classId: widget.classItem.id!,
        studentId: studentId,
        isPresent: isPresent,
        comment: comment,
      );
      final index = _studentAttendanceList.indexWhere((info) => info.student.id == studentId);
      if (index != -1) {
        final updatedInfo = _studentAttendanceList[index].copyWith(
          isPresent: isPresent,
          comment: comment,
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
    String classTitle = '';
    if (widget.classItem.subjects?.name != null) {
      classTitle += '${widget.classItem.subjects!.name}';
    }
    // ignore: unnecessary_null_comparison
    if (widget.classItem.date != null) {
      classTitle += ' (${DateFormat('dd.MM.yyyy HH:mm').format(widget.classItem.date!)})';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(classTitle, overflow: TextOverflow.ellipsis),
        actions: [
          // Показываем статус занятия
          if (_isClassClosed)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Chip(
                label: const Text('ЗАКРЫТО'),
                backgroundColor: Colors.red.shade100,
                labelStyle: TextStyle(
                  color: Colors.red.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          
          // Кнопки для управления статусом занятия (только для преподавателей и администраторов)
          if (_canManageClassStatus())
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'close':
                    _closeClass();
                    break;
                  case 'reopen':
                    _reopenClass();
                    break;
                }
              },
              itemBuilder: (context) {
                List<PopupMenuEntry<String>> items = [];
                
                if (_isClassClosed) {
                  // Если занятие закрыто, показываем кнопку "Открыть"
                  items.add(
                    const PopupMenuItem(
                      value: 'reopen',
                      child: Row(
                        children: [
                          Icon(Icons.lock_open),
                          SizedBox(width: 8),
                          Text('Открыть занятие'),
                        ],
                      ),
                    ),
                  );
                } else {
                  // Если занятие открыто, показываем кнопку "Закрыть"
                  items.add(
                    const PopupMenuItem(
                      value: 'close',
                      child: Row(
                        children: [
                          Icon(Icons.lock),
                          SizedBox(width: 8),
                          Text('Закрыть занятие'),
                        ],
                      ),
                    ),
                  );
                }
                
                return items;
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Информация о статусе занятия
          if (_isClassClosed)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.red.shade50,
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.lock, color: Colors.red.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'Занятие закрыто преподавателем',
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (_closedAt != null && _closedByTeacher != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Закрыто: ${DateFormat('dd.MM.yyyy HH:mm').format(_closedAt!)} - $_closedByTeacher',
                        style: TextStyle(
                          color: Colors.red.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          
          // Остальной контент (список студентов)
          Expanded(
            child: _isLoading
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
                                            onChanged: _isClassClosed ? null : (bool value) {
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
                                        enabled: !_isClassClosed,
                                        decoration: InputDecoration(
                                          labelText: 'Комментарий (причина отсутствия)',
                                          isDense: true,
                                          border: const OutlineInputBorder(),
                                          fillColor: _isClassClosed ? Colors.grey.shade100 : null,
                                          filled: _isClassClosed,
                                        ),
                                        onSubmitted: _isClassClosed ? null : (value) {
                                          _updateAttendance(studentId, _attendanceStatus[studentId] ?? false, value);
                                        },
                                        onEditingComplete: _isClassClosed ? null : () {
                                          _updateAttendance(studentId, _attendanceStatus[studentId] ?? false, commentController.text);
                                          FocusScope.of(context).unfocus();
                                        },
                                      ),
                                    ],
                                  ),
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