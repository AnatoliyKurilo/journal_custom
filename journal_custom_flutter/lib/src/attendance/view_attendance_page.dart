import 'package:flutter/material.dart';
import 'package:journal_custom_client/journal_custom_client.dart';
import 'package:journal_custom_flutter/src/serverpod_client.dart';
import 'package:journal_custom_flutter/src/attendance/view_subject_classes_page.dart'; // Для навигации

class ViewAttendancePage extends StatefulWidget {
  const ViewAttendancePage({Key? key}) : super(key: key);

  @override
  _ViewAttendancePageState createState() => _ViewAttendancePageState();
}

class _ViewAttendancePageState extends State<ViewAttendancePage> {
  bool _isLoading = true;
  String? _errorMessage;
  List<Subjects> _subjectsWithClasses = [];

  @override
  void initState() {
    super.initState();
    _fetchSubjectsData();
  }

  Future<void> _fetchSubjectsData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      // Используем тот же эндпоинт, что и для управления
      final subjects = await client.classes.getSubjectsWithClasses();
      if (mounted) {
        setState(() {
          _subjectsWithClasses = subjects;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Ошибка загрузки предметов: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Просмотр посещаемости'),
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
                        onPressed: _fetchSubjectsData,
                        child: const Text('Попробовать снова'),
                      )
                    ],
                  ),
                )
              : _subjectsWithClasses.isEmpty
                  ? const Center(
                      child: Text('Нет предметов с назначенными занятиями.'),
                    )
                  : ListView.builder(
                      itemCount: _subjectsWithClasses.length,
                      itemBuilder: (context, index) {
                        final subject = _subjectsWithClasses[index];
                        return ListTile(
                          title: Text(subject.name ?? 'Предмет без названия'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewSubjectClassesPage(subject: subject),
                              ),
                            );
                          },
                        );
                      },
                    ),
    );
  }
}