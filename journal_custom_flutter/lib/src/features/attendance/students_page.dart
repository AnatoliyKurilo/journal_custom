import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:journal_custom_client/journal_custom_client.dart';
import 'package:journal_custom_flutter/core/serverpod_client.dart';
// import 'package:journal_custom_flutter/src/utils/name_formatters.dart';
import 'package:journal_custom_flutter/src/features/attendance/presentation/pages/student_overall_attendance_page.dart';
import 'package:journal_custom_flutter/src/utils/name_formatters.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class StudentsPage extends StatefulWidget {
  const StudentsPage({Key? key}) : super(key: key);

  @override
  _StudentsPageState createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  bool _isLoading = true;
  String? _errorMessage;
  List<Students> _students = [];
  List<Students> _filteredStudents = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadStudents();
    _searchController.addListener(_filterStudents);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterStudents);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadStudents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final roles = sessionManager.signedInUser?.scopeNames;
      List<Students> studentsData = [];

      if (roles!.contains('serverpod.admin')) {
        studentsData = await client.search.getAllStudentsForAdmin();
      } else if (roles.contains('documentSpecialist')) {
        studentsData = await client.search.searchStudents(query: ''); // Загружаем всех для документоведа
      } else if (roles.contains('curator')) {
        studentsData = await client.search.getStudentsForCurator();
      } else {
        _errorMessage = 'Нет прав для просмотра списка студентов.';
      }
      
      setState(() {
        _students = studentsData;
        _filteredStudents = studentsData;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Ошибка загрузки студентов: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterStudents() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredStudents = _students.where((student) {
        final person = student.person;
        final group = student.groups;
        final fullName = NameFormatters.formatFullName(
          lastName: person?.lastName,
          firstName: person?.firstName,
          patronymic: person?.patronymic,
        ).toLowerCase();
        final email = person?.email?.toLowerCase() ?? '';
        final groupName = group?.name?.toLowerCase() ?? '';
        
        return fullName.contains(query) ||
               email.contains(query) ||
               groupName.contains(query);
      }).toList();
    });
  }

  Future<void> _generateStudentAttendanceReport(Students student) async {
    final pdf = pw.Document();

    // Загружаем шрифт
    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    try {
      // Получаем данные о посещаемости студента
      final attendanceRecords = await client.students.getStudentOverallAttendanceRecords(student.id!);

      pdf.addPage(
        pw.Page(
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Отчет о посещаемости',
                  style: pw.TextStyle(font: ttf, fontSize: 18, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 16),
                pw.Text(
                  'Студент: ${student.person?.lastName ?? ''} ${student.person?.firstName ?? ''} ${student.person?.patronymic ?? ''}',
                  style: pw.TextStyle(font: ttf),
                ),
                pw.SizedBox(height: 8),
                pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    // Заголовок таблицы
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4.0),
                          child: pw.Text('Предмет', style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4.0),
                          child: pw.Text('Дата', style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4.0),
                          child: pw.Text('Статус', style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold)),
                        ),
                      ],
                    ),
                    // Данные посещаемости
                    ...attendanceRecords.map((record) {
                      return pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4.0),
                            child: pw.Text(record.subjectName, style: pw.TextStyle(font: ttf)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4.0),
                            child: pw.Text(
                              DateFormat('dd.MM.yyyy HH:mm').format(record.classDate),
                              style: pw.TextStyle(font: ttf),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4.0),
                            child: pw.Text(
                              record.isPresent ? 'Присутствовал' : 'Отсутствовал',
                              style: pw.TextStyle(font: ttf),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ],
            );
          },
        ),
      );

      // Печать или сохранение PDF
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка генерации отчета: $e')),
      );
    }
  }

  // TODO: Реализовать диалоги _showCreateStudentDialog и _showEditStudentDialog
  // Future<void> _showCreateStudentDialog() async { ... }
  // Future<void> _showEditStudentDialog(Students student) async { ... }


  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold( // Обернули в Scaffold
      appBar: AppBar(
        title: const Text('Студенты'),
      ),
      body: Padding(
        padding: EdgeInsets.all(isMobile ? 8.0 : 16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Поиск студентов',
                      hintText: 'Введите имя, фамилию или группу...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding: isMobile ? const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0) : null,
                    ),
                  ),
                ),
                // if (isMobile) // Кнопка добавления, если нужна
                //   IconButton(
                //     icon: const Icon(Icons.add),
                //     onPressed: _showCreateStudentDialog,
                //     tooltip: 'Добавить студента',
                //   )
              ],
            ),
            // const SizedBox(height: 10),
            // if (!isMobile) // Кнопка добавления, если нужна
            //   Align(
            //     alignment: Alignment.centerRight,
            //     child: ElevatedButton.icon(
            //       icon: const Icon(Icons.add),
            //       label: const Text('Добавить студента'),
            //       onPressed: _showCreateStudentDialog,
            //       style: ElevatedButton.styleFrom(
            //         padding: isMobile ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8) : null,
            //       ),
            //     ),
            //   ),
            const SizedBox(height: 10),
            if (_isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (_errorMessage != null)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_errorMessage!, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadStudents,
                        child: const Text('Попробовать снова'),
                      ),
                    ],
                  ),
                ),
              )
            else if (_filteredStudents.isEmpty)
              const Expanded(child: Center(child: Text('Студенты не найдены')))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredStudents.length,
                  itemBuilder: (context, index) {
                    final student = _filteredStudents[index];
                    final person = student.person;
                    final group = student.groups;
                    final fullName = NameFormatters.formatFullName(
                      lastName: person?.lastName,
                      firstName: person?.firstName,
                      patronymic: person?.patronymic,
                    );

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: isMobile ? 0 : 8.0, vertical: 4.0),
                      child: ListTile(
                        contentPadding: isMobile ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8) : null,
                        title: Text(fullName.isNotEmpty ? fullName : 'Имя не указано'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email: ${person?.email ?? 'Не указан'}'),
                            Text('Группа: ${group?.name ?? 'Не указана'}'),
                            if (student.isGroupHead ?? false)
                              const Text('Староста группы', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.visibility),
                              tooltip: 'Посмотреть посещаемость',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StudentOverallAttendancePage(student: student),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.picture_as_pdf),
                              tooltip: 'Скачать отчет (PDF)',
                              onPressed: () => _generateStudentAttendanceReport(student),
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
      ),
    );
  }
}