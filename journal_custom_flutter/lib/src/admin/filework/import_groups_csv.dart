import 'dart:convert'; // Для utf8
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:journal_custom_client/journal_custom_client.dart';
import 'package:journal_custom_flutter/main.dart';

/// Функция для импорта группы и студентов из CSV-файла
Future<void> importGroupFromCsv(BuildContext context) async {
  try {
    // 1. Открываем диалог выбора файла
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выбор файла отменен'))
      );
      return;
    }

    // 2. Получаем путь к выбранному файлу и читаем его содержимое
    final filePath = result.files.single.path!;
    final file = File(filePath);
    // Читаем как байты и декодируем в UTF-8 для явности
    final fileBytes = await file.readAsBytes();
    final csvData = utf8.decode(fileBytes);


    // ОТЛАДКА: Выводим начало CSV данных
    print('--- Начало CSV данных (первые 500 символов) ---');
    print(csvData.substring(0, csvData.length > 500 ? 500 : csvData.length));
    print('--- Конец CSV данных ---');

    // 3. Преобразуем CSV в список строк
    List<List<dynamic>> rows = [];
    bool parsedSuccessfully = false;

    // Попытка 1: Разделитель ','
    try {
      print('Попытка разбора CSV с разделителем ","');
      // Используем eol: '\n' для большей определенности, хотя автоопределение обычно работает
      rows = const CsvToListConverter(fieldDelimiter: ',', eol: '\n').convert(csvData);
      print('Разбор с "," завершен. Всего строк: ${rows.length}.');
      if (rows.isNotEmpty) {
        print('Первая строка (если есть): ${rows[0]}, количество полей в первой строке: ${rows[0].length}');
        // Проверяем, не состоят ли все строки из одного поля (признак неправильного разделителя)
        bool allRowsSingleColumn = rows.every((row) => row.length <= 1);
        if (rows.length > 1 && rows[0].length > 1 && !allRowsSingleColumn) {
            parsedSuccessfully = true;
            print('Разбор с "," выглядит успешным (много полей в строках).');
        } else {
            print('ПРЕДУПРЕЖДЕНИЕ: Разбор с "," дал строки с 1 полем или мало полей. Возможно, разделитель неверный.');
            if (allRowsSingleColumn && rows.length > 1) print('Все непустые строки состоят из одного поля при разделителе ",".');
        }
      } else {
        print('Разбор с "," дал пустой список строк.');
      }
    } catch (e) {
      print('Ошибка при разборе CSV с разделителем ",": $e.');
    }

    // Попытка 2: Разделитель ';', если первая попытка не удалась или дала плохой результат
    if (!parsedSuccessfully && csvData.contains(';')) {
      print('Попытка разбора CSV с разделителем ";"');
      try {
        rows = const CsvToListConverter(fieldDelimiter: ';', eol: '\n').convert(csvData);
        print('Разбор с ";" завершен. Всего строк: ${rows.length}.');
        if (rows.isNotEmpty) {
          print('Первая строка (если есть): ${rows[0]}, количество полей в первой строке: ${rows[0].length}');
          bool allRowsSingleColumn = rows.every((row) => row.length <= 1);
          if (rows.length > 1 && rows[0].length > 1 && !allRowsSingleColumn) {
            parsedSuccessfully = true;
            print('Разбор с ";" выглядит успешным.');
          } else {
             print('ПРЕДУПРЕЖДЕНИЕ: Разбор с ";" также дал строки с 1 полем или мало полей.');
          }
        } else {
          print('Разбор с ";" дал пустой список строк.');
        }
      } catch (e) {
        print('Ошибка при разборе CSV с разделителем ";": $e.');
      }
    }

    if (!parsedSuccessfully || rows.isEmpty) {
      print('Не удалось корректно разобрать CSV файл ни с одним из разделителей или файл пуст.');
      throw Exception('Не удалось разобрать CSV файл. Убедитесь, что он корректен и использует разделители "," или ";".');
    }
    
    print('Итоговое количество строк после разбора: ${rows.length}');
    if (rows.isNotEmpty) {
        print('Пример первой строки данных для обработки (индекс 0 из rows): ${rows[0]} с ${rows[0].length} полями.');
    }


    // 4. Извлекаем название группы из имени файла
    String groupName = file.uri.pathSegments.last.split('.').first;

    // 5. Запрашиваем у пользователя название группы
    groupName = await _showGroupNameDialog(context, groupName) ?? groupName;
    if (groupName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Импорт отменен: не указано название группы'))
      );
      return;
    }

    // 6. Собираем данные о студентах из файла
    List<Map<String, String>> studentsPreview = [];
    
    bool hasHeaders = rows.isNotEmpty && _isLikelyHeader(rows[0]);
    int startRow = hasHeaders ? 1 : 0;
    
    print('--- Обработка строк CSV ---');
    print('Всего строк для обработки (после разбора): ${rows.length}');
    print('Определено наличие заголовка: $hasHeaders. Начальная строка для данных: $startRow');

    for (int i = startRow; i < rows.length; i++) {
      final row = rows[i];
      print('Обработка строки ${i + 1} (индекс $i из rows): $row. Количество элементов: ${row.length}');
      
      if (row.isEmpty) {
        print('Строка ${i + 1} пуста. Пропуск.');
        continue;
      }
      
      // Ожидаем как минимум Имя и Фамилию
      if (row.length < 2) {
        print('Строка ${i + 1} содержит менее 2 элементов (${row.length}). Пропуск. Это основная причина, если студенты не добавляются.');
        continue;
      }

      String firstName = (row[0]?.toString() ?? '').trim();
      String lastName = (row[1]?.toString() ?? '').trim();
      
      print('Извлечено из строки ${i + 1}: Имя="$firstName", Фамилия="$lastName"');

      Map<String, String> studentData = {
        'Имя': firstName,
        'Фамилия': lastName,
      };
      
      if (row.length > 2) studentData['Отчество'] = (row[2]?.toString() ?? '').trim();
      if (row.length > 3) studentData['Email'] = (row[3]?.toString() ?? '').trim();
      if (row.length > 4) studentData['Телефон'] = (row[4]?.toString() ?? '').trim();

      if (studentData['Имя']!.isNotEmpty && studentData['Фамилия']!.isNotEmpty) {
        bool isDuplicate = false;
        if (studentData['Email'] != null && studentData['Email']!.isNotEmpty) {
          isDuplicate = studentsPreview.any((s) => s['Email'] == studentData['Email']);
        }
        
        if (!isDuplicate) {
          studentsPreview.add(studentData);
          print('Добавлен студент: ${studentData['Фамилия']} ${studentData['Имя']}');
        } else {
          print('Дубликат студента (по Email: ${studentData['Email']}), не добавлен: ${studentData['Фамилия']} ${studentData['Имя']}');
        }
      } else {
        print('Пропуск студента из строки ${i + 1} из-за пустого Имени или Фамилии: Имя="${studentData['Имя']}", Фамилия="${studentData['Фамилия']}"');
      }
    }
    print('--- Завершение обработки строк CSV ---');
    print('Итоговое количество студентов в preview: ${studentsPreview.length}');

    if (studentsPreview.isEmpty) {
      throw Exception('В файле не найдено данных о студентах (studentsPreview пуст после обработки)');
    }

    // 7. Показываем предварительный просмотр для подтверждения
    bool? confirm = await _showPreviewDialog(context, groupName, studentsPreview);
    if (confirm != true) {
      return; // Пользователь отменил импорт
    }

    // 8. Проверяем, существует ли группа
    Groups? existingGroup = await client.admin.getGroupByName(groupName);

    // 9. Если группа не существует, создаем ее
    if (existingGroup == null) {
      existingGroup = await client.admin.createGroup(groupName, null);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Создана новая группа: $groupName'))
        );
      }
    }

    // 10. Показываем индикатор прогресса
    int imported = 0;
    int total = studentsPreview.length;
    List<String> errors = [];
    
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Импорт студентов'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text('Импортировано: $imported из $total'),
              ],
            ),
          );
        }
      );
    }

    // 11. Импортируем студентов
    for (var student in studentsPreview) {
      try {
        // Генерируем уникальный email, если он не указан
        String email = student['Email'] ?? '';
        if (email.isEmpty) {
          // Создаем уникальный email на основе имени, фамилии и случайного числа
          String baseName = '${student['Имя']!.toLowerCase()}.${student['Фамилия']!.toLowerCase()}';
          email = '$baseName.${DateTime.now().millisecondsSinceEpoch}@example.com';
        }
        
        await client.admin.createStudent(
          firstName: student['Имя']!,
          lastName: student['Фамилия']!,
          patronymic: student['Отчество'] ?? '',
          email: email,
          phoneNumber: student['Телефон'],
          groupName: groupName,
        );
        imported++;
      } catch (e) {
        errors.add('${student['Имя']} ${student['Фамилия']}: $e');
      }
      
      // Обновляем диалог прогресса каждые 5 студентов
      if (imported % 5 == 0 && context.mounted) {
        Navigator.pop(context);
        if (context.mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: const Text('Импорт студентов'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text('Импортировано: $imported из $total'),
                  ],
                ),
              );
            }
          );
        }
      }
    }

    // 12. Закрываем индикатор прогресса и показываем итоговое сообщение
    if (context.mounted) {
      Navigator.pop(context);
      
      if (errors.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Импорт завершен: добавлено $imported из $total студентов'))
        );
      } else {
        _showErrorsDialog(context, errors, imported, total);
      }
    }
  } catch (e) {
    print('Критическая ошибка при импорте данных: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при импорте данных: $e'))
      );
    }
  }
}

/// Определяет, является ли строка заголовком таблицы
bool _isLikelyHeader(List<dynamic> row) {
  if (row.isEmpty) return false;
  
  // Проверяем типичные заголовки для CSV со студентами
  List<String> possibleHeaders = [
    'имя', 'фамилия', 'отчество', 'email', 'телефон', 'name', 'first name', 'firstname', 
    'last name', 'lastname', 'email', 'phone', 'group'
  ];
  
  // Добавим вывод для отладки _isLikelyHeader
  // print('Проверка на заголовок строки: $row');
  for (var cell in row) {
    String cellText = cell.toString().toLowerCase().trim();
    if (possibleHeaders.contains(cellText)) {
      // print('Найдено совпадение заголовка: "$cellText" в строке $row');
      return true;
    }
  }
  // print('Строка $row не определена как заголовок');
  return false;
}

/// Диалог для ввода или подтверждения названия группы
Future<String?> _showGroupNameDialog(BuildContext context, String initialName) {
  final textController = TextEditingController(text: initialName);
  
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Название группы'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            labelText: 'Введите название группы',
            hintText: 'Например: ИТ-101',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, textController.text),
            child: const Text('Продолжить'),
          ),
        ],
      );
    },
  );
}

/// Диалог для предварительного просмотра данных
Future<bool?> _showPreviewDialog(
  BuildContext context, 
  String groupName, 
  List<Map<String, String>> students
) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Импорт в группу "$groupName"'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: Column(
            children: [
              Text('Найдено ${students.length} студентов'),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return ListTile(
                      title: Text('${student['Имя']} ${student['Фамилия']}'),
                      subtitle: Text(
                        [
                          if (student.containsKey('Отчество') && student['Отчество']!.isNotEmpty) 
                            'Отчество: ${student['Отчество']}',
                          if (student.containsKey('Email') && student['Email']!.isNotEmpty) 
                            'Email: ${student['Email']}',
                          if (student.containsKey('Телефон') && student['Телефон']!.isNotEmpty) 
                            'Телефон: ${student['Телефон']}',
                        ].join(', '),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Импортировать'),
          ),
        ],
      );
    },
  );
}

/// Диалог для отображения ошибок импорта
void _showErrorsDialog(BuildContext context, List<String> errors, int imported, int total) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Результат импорта'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: Column(
            children: [
              Text('Импортировано $imported из $total студентов'),
              Text('Не удалось импортировать ${total - imported} студентов:', 
                   style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: errors.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(errors[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      );
    },
  );
}