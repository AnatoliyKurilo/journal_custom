import 'package:excel/excel.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:journal_custom_client/journal_custom_client.dart';
import 'package:journal_custom_flutter/core/serverpod_client.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class SubjectOverallAttendancePage extends StatefulWidget {
  final Subjects subject;

  const SubjectOverallAttendancePage({Key? key, required this.subject}) : super(key: key);

  @override
  _SubjectOverallAttendancePageState createState() => _SubjectOverallAttendancePageState();
}

class _SubjectOverallAttendancePageState extends State<SubjectOverallAttendancePage> {
  bool _isLoading = true;
  String? _errorMessage;
  SubjectAttendanceMatrix? _matrixData;

  @override
  void initState() {
    super.initState();
    _fetchAttendanceMatrix();
  }

  Future<void> _fetchAttendanceMatrix() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _matrixData = null;
    });
    try {
      if (widget.subject.id == null) {
        throw Exception('ID предмета не может быть null');
      }
      final matrix = await client.attendance 
      .getSubjectAttendanceMatrix(subjectId: widget.subject.id!);
      if (mounted) {
        setState(() {
          _matrixData = matrix;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Ошибка загрузки матрицы посещаемости: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _generateAttendanceReport() async {
    final pdf = pw.Document();

    // Загружаем шрифт
    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

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
              pw.Text('Предмет: ${widget.subject.name ?? 'Не указан'}', style: pw.TextStyle(font: ttf)),
              pw.SizedBox(height: 8),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  // Заголовок таблицы
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4.0),
                        child: pw.Text('Студент', style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold)),
                      ),
                      ..._matrixData!.classes.map((classItem) {
                        return pw.Padding(
                          padding: const pw.EdgeInsets.all(4.0),
                          child: pw.Text(
                            classItem.date != null
                                ? DateFormat('dd.MM').format(classItem.date!)
                                : 'N/A',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(font: ttf),
                          ),
                        );
                      }).toList(),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4.0),
                        child: pw.Text('Посещ. %', style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  // Данные студентов
                  ..._matrixData!.students.map((student) {
                    final studentId = student.id!;
                    int attendedClasses = 0;
                    int totalApplicableClasses = 0;

                    // Считаем посещения для текущего студента
                    for (var classItem in _matrixData!.classes) {
                      final classId = classItem.id!;
                      final isPresent = _matrixData!.attendanceData[studentId]?[classId];
                      if (isPresent != null) {
                        totalApplicableClasses++;
                        if (isPresent) {
                          attendedClasses++;
                        }
                      }
                    }

                    double attendancePercentage = totalApplicableClasses > 0
                        ? (attendedClasses / totalApplicableClasses) * 100
                        : 0.0;

                    return pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4.0),
                          child: pw.Text(
                            '${student.person?.lastName ?? ''} ${student.person?.firstName?.substring(0, 1) ?? ''}.${student.person?.patronymic?.substring(0, 1) ?? ''}',
                            style: pw.TextStyle(font: ttf),
                          ),
                        ),
                        ..._matrixData!.classes.map((classItem) {
                          final classId = classItem.id!;
                          final isPresent = _matrixData!.attendanceData[studentId]?[classId];
                          String displayChar = isPresent == true ? 'П' : isPresent == false ? 'Н' : '-';
                          return pw.Padding(
                            padding: const pw.EdgeInsets.all(4.0),
                            child: pw.Text(displayChar, textAlign: pw.TextAlign.center, style: pw.TextStyle(font: ttf)),
                          );
                        }).toList(),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4.0),
                          child: pw.Text(
                            '${attendancePercentage.toStringAsFixed(1)}%',
                            textAlign: pw.TextAlign.center,
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
  }

  Future<void> _exportToExcel() async {
    try {
      // Создаем новый Excel-документ
      var excel = Excel.createExcel();

      // Добавляем лист
      Sheet sheetObject = excel['Отчет о посещаемости'];

      // Заголовок таблицы
      List<String> header = ['Студент'];
      header.addAll(_matrixData!.classes.map((classItem) {
        return classItem.date != null
            ? DateFormat('dd.MM.yyyy').format(classItem.date!)
            : 'N/A';
      }));
      header.add('Посещ. %');
      sheetObject.appendRow(header);

      // Данные студентов
      for (var student in _matrixData!.students) {
        final studentId = student.id!;
        int attendedClasses = 0;
        int totalApplicableClasses = 0;

        List<String> row = [
          '${student.person?.lastName ?? ''} ${student.person?.firstName?.substring(0, 1) ?? ''}.${student.person?.patronymic?.substring(0, 1) ?? ''}'
        ];

        for (var classItem in _matrixData!.classes) {
          final classId = classItem.id!;
          final isPresent = _matrixData!.attendanceData[studentId]?[classId];
          if (isPresent != null) {
            totalApplicableClasses++;
            if (isPresent) {
              attendedClasses++;
            }
          }
          row.add(isPresent == true ? 'П' : isPresent == false ? 'Н' : '-');
        }

        double attendancePercentage = totalApplicableClasses > 0
            ? (attendedClasses / totalApplicableClasses) * 100
            : 0.0;
        row.add('${attendancePercentage.toStringAsFixed(1)}%');

        sheetObject.appendRow(row);
      }

      // Сохраняем файл
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/attendance_report.xlsx';
      final fileBytes = excel.encode();
      final file = File(path)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes!);

      // Показываем сообщение об успешном экспорте
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Отчет сохранен: $path')),
      );
    } catch (e) {
      // Показываем сообщение об ошибке
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка экспорта: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' ${widget.subject.name ?? ''}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Скачать отчет',
            onPressed: _generateAttendanceReport,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Скачать отчет в Excel',
            onPressed: _exportToExcel,
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
                        onPressed: _fetchAttendanceMatrix,
                        child: const Text('Попробовать снова'),
                      )
                    ],
                  ),
                )
              : _matrixData == null || _matrixData!.students.isEmpty || _matrixData!.classes.isEmpty
                  ? const Center(
                      child: Text('Нет данных для отображения матрицы.'),
                    )
                  : SingleChildScrollView( // Для вертикальной прокрутки всей таблицы
                      child: SingleChildScrollView( // Для горизонтальной прокрутки
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 12, // Уменьшим для компактности дат
                          headingRowHeight: 80, // Увеличим высоту для дат (если нужно вертикально)
                          dataRowMinHeight: 30,
                          dataRowMaxHeight: 40,
                          border: TableBorder.all(color: Colors.grey.shade400, width: 1),
                          columns: [
                            const DataColumn(
                              label: Text('Студент', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            // Динамически создаем колонки для каждой даты занятия
                            ..._matrixData!.classes.map((classItem) {
                              return DataColumn(
                                label: RotatedBox( // Поворачиваем текст даты для экономии места
                                  quarterTurns: 3, // Поворот на -90 градусов
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: Text(
                                      classItem.date != null
                                          ? DateFormat('dd.MM\nHH:mm').format(classItem.date!) // Формат даты
                                          : 'N/A',
                                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.normal),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            // Новая колонка для процента посещений
                            const DataColumn(
                              label: Text('Посещ. %', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                          rows: _matrixData!.students.map((student) {
                            final studentId = student.id!;
                            int attendedClasses = 0;
                            int totalApplicableClasses = 0;

                            // Считаем посещения для текущего студента
                            for (var classItem in _matrixData!.classes) {
                              final classId = classItem.id!;
                              final isPresent = _matrixData!.attendanceData[studentId]?[classId];
                              if (isPresent != null) { // Если для этого занятия есть отметка (студент должен был быть)
                                totalApplicableClasses++;
                                if (isPresent) {
                                  attendedClasses++;
                                }
                              }
                            }

                            double attendancePercentage = totalApplicableClasses > 0
                                ? (attendedClasses / totalApplicableClasses) * 100
                                : 0.0;

                            return DataRow(
                              cells: [
                                DataCell(
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: Text(
                                        '${student.person?.lastName ?? ''} ${student.person?.firstName?.substring(0,1) ?? ''}.${student.person?.patronymic?.substring(0,1) ?? ''}'.trim(),
                                         style: const TextStyle(fontSize: 11),
                                         overflow: TextOverflow.ellipsis,
                                        ),
                                  )
                                ),
                                // Для каждой даты занятия получаем статус посещаемости
                                ..._matrixData!.classes.map((classItem) {
                                  final classId = classItem.id!;
                                  final isPresent = _matrixData!.attendanceData[studentId]?[classId];
                                  String displayChar = '';
                                  Color cellColor = Colors.transparent;

                                  if (isPresent != null) {
                                    displayChar = isPresent ? 'П' : 'Н'; // П - присутствовал, Н - не был
                                    cellColor = isPresent ? Colors.green.shade50 : Colors.red.shade50;
                                  } else {
                                    // Студент не из подгруппы этого занятия или нет данных
                                    displayChar = '-'; // или оставить пустым
                                    cellColor = Colors.grey.shade100;
                                  }

                                  return DataCell(
                                    Container(
                                      color: cellColor,
                                      alignment: Alignment.center,
                                      child: Text(displayChar, style: const TextStyle(fontSize: 11)),
                                    ),
                                  );
                                }).toList(),
                                // Новая ячейка для процента посещений
                                DataCell(
                                  Container(
                                    alignment: Alignment.centerRight, // Выравнивание по правому краю
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    child: Text(
                                      '${attendancePercentage.toStringAsFixed(1)}%', // Округляем до 1 знака после запятой
                                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
    );
  }
}