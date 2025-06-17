// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// import 'package:journal_custom_client/journal_custom_client.dart';
import 'package:journal_custom_flutter/core/serverpod_client.dart';
// import 'package:journal_custom_flutter/main.dart' hide client; // Для client

/// Функция для импорта преподавателей из CSV-файла
Future<void> importTeachersFromCsv(BuildContext context) async {
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
    final fileBytes = await file.readAsBytes();
    final csvData = utf8.decode(fileBytes);
    
    // ПРАВИЛЬНАЯ проверка авторизации
    // print("isSignedIn: ${client.}");
    // print("User ID: ${client.sessionManager.signedInUser?.userId}");
    // print("User scopes: ${client.sessionManager.signedInUser?.scopes}");
    
    // // Проверяем авторизацию
    // if (!client.sessionManager.isSignedIn) {
    //   throw Exception('Пользователь не авторизован. Необходимо войти в систему.');
    // }
    print("isSignedIn: ${sessionManager.isSignedIn}");
    
    
    print('--- Начало CSV данных (первые 500 символов) ---');
    print(csvData.substring(0, csvData.length > 500 ? 500 : csvData.length));
    print('--- Конец CSV данных ---');

    // 3. Преобразуем CSV в список строк
    List<List<dynamic>> rows = [];
    bool parsedSuccessfully = false;

    // Попытка 1: Разделитель ','
    try {
      print('Попытка разбора CSV с разделителем ","');
      rows = const CsvToListConverter(fieldDelimiter: ',', eol: '\n').convert(csvData);
      print('Разбор с "," завершен. Всего строк: ${rows.length}.');
      if (rows.isNotEmpty && rows[0].length > 1) {
        bool allRowsSingleColumn = rows.every((row) => row.length <= 1);
        if (!allRowsSingleColumn) {
          parsedSuccessfully = true;
          print('Разбор с "," выглядит успешным.');
        }
      }
    } catch (e) {
      print('Ошибка при разборе CSV с разделителем ",": $e.');
    }

    // Попытка 2: Разделитель ';'
    if (!parsedSuccessfully && csvData.contains(';')) {
      print('Попытка разбора CSV с разделителем ";"');
      try {
        rows = const CsvToListConverter(fieldDelimiter: ';', eol: '\n').convert(csvData);
        print('Разбор с ";" завершен. Всего строк: ${rows.length}.');
        if (rows.isNotEmpty && rows[0].length > 1) {
          bool allRowsSingleColumn = rows.every((row) => row.length <= 1);
          if (!allRowsSingleColumn) {
            parsedSuccessfully = true;
            print('Разбор с ";" выглядит успешным.');
          }
        }
      } catch (e) {
        print('Ошибка при разборе CSV с разделителем ";": $e.');
      }
    }

    if (!parsedSuccessfully || rows.isEmpty) {
      throw Exception('Не удалось разобрать CSV файл. Убедитесь, что он корректен и использует разделители "," или ";".');
    }

    // 4. Собираем данные о преподавателях из файла
    List<Map<String, String>> teachersPreview = [];
    
    bool hasHeaders = rows.isNotEmpty && _isLikelyTeacherHeader(rows[0]);
    int startRow = hasHeaders ? 1 : 0;
    
    print('--- Обработка строк CSV для преподавателей ---');
    print('Всего строк для обработки: ${rows.length}');
    print('Определено наличие заголовка: $hasHeaders. Начальная строка: $startRow');

    for (int i = startRow; i < rows.length; i++) {
      final row = rows[i];
      print('Обработка строки ${i + 1}: $row. Количество элементов: ${row.length}');
      
      if (row.isEmpty) {
        print('Строка ${i + 1} пуста. Пропуск.');
        continue;
      }
      
      // Ожидаем как минимум Имя и Фамилию
      if (row.length < 2) {
        print('Строка ${i + 1} содержит менее 2 элементов (${row.length}). Пропуск.');
        continue;
      }

      String firstName = (row[0]?.toString() ?? '').trim();
      String lastName = (row[1]?.toString() ?? '').trim();
      
      print('Извлечено из строки ${i + 1}: Имя="$firstName", Фамилия="$lastName"');

      Map<String, String> teacherData = {
        'Имя': firstName,
        'Фамилия': lastName,
      };
      
      if (row.length > 2) teacherData['Отчество'] = (row[2]?.toString() ?? '').trim();
      if (row.length > 3) teacherData['Email'] = (row[3]?.toString() ?? '').trim();
      if (row.length > 4) teacherData['Телефон'] = (row[4]?.toString() ?? '').trim();

      if (teacherData['Имя']!.isNotEmpty && teacherData['Фамилия']!.isNotEmpty) {
        bool isDuplicate = false;
        if (teacherData['Email'] != null && teacherData['Email']!.isNotEmpty) {
          isDuplicate = teachersPreview.any((t) => t['Email'] == teacherData['Email']);
        }
        
        if (!isDuplicate) {
          teachersPreview.add(teacherData);
          print('Добавлен преподаватель: ${teacherData['Фамилия']} ${teacherData['Имя']}');
        } else {
          print('Дубликат преподавателя (по Email: ${teacherData['Email']}), не добавлен: ${teacherData['Фамилия']} ${teacherData['Имя']}');
        }
      } else {
        print('Пропуск преподавателя из строки ${i + 1} из-за пустого Имени или Фамилии');
      }
    }

    print('--- Завершение обработки строк CSV ---');
    print('Итоговое количество преподавателей в preview: ${teachersPreview.length}');

    if (teachersPreview.isEmpty) {
      throw Exception('В файле не найдено данных о преподавателях');
    }

    // 5. Проверяем на существующих преподавателей
    final duplicates = await _checkExistingTeachers(teachersPreview);
    if (duplicates.isNotEmpty) {
      bool? continueWithDuplicates = await _showDuplicatesDialog(context, duplicates);
      if (continueWithDuplicates != true) {
        return;
      }
    }

    // 6. Показываем предварительный просмотр для подтверждения
    bool? confirm = await _showTeachersPreviewDialog(context, teachersPreview);
    if (confirm != true) {
      return;
    }

    // 7. Показываем индикатор прогресса
    int imported = 0;
    int total = teachersPreview.length;
    List<String> errors = [];
    
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Импорт преподавателей'),
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

    // 8. Импортируем преподавателей
    for (var teacher in teachersPreview) {
      try {
        // Генерируем уникальный email, если он не указан
        String email = teacher['Email'] ?? '';
        if (email.isEmpty) {
          String baseName = '${teacher['Имя']!.toLowerCase()}.${teacher['Фамилия']!.toLowerCase()}';
          email = '$baseName.${DateTime.now().millisecondsSinceEpoch}@university.edu';
        }
        
        await client.teachers.createTeacher(
          firstName: teacher['Имя']!,
          lastName: teacher['Фамилия']!,
          patronymic: teacher['Отчество'] ?? '',
          email: email,
          phoneNumber: teacher['Телефон'],
        );
        imported++;
      } catch (e) {
        errors.add('${teacher['Имя']} ${teacher['Фамилия']}: $e');
      }
      
      // Обновляем диалог прогресса каждые 5 преподавателей
      if (imported % 5 == 0 && context.mounted) {
        Navigator.pop(context);
        if (context.mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: const Text('Импорт преподавателей'),
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

    // 9. Закрываем индикатор прогресса и показываем итоговое сообщение
    if (context.mounted) {
      Navigator.pop(context);
      
      if (errors.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Импорт завершен: добавлено $imported преподавателей'))
        );
      } else {
        _showTeachersErrorsDialog(context, errors, imported, total);
      }
    }
  } catch (e) {
    print('Критическая ошибка при импорте преподавателей: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при импорте преподавателей: $e'))
      );
    }
  }
}

/// Проверка существующих преподавателей без вызова getAllTeachers
Future<List<String>> _checkExistingTeachers(
  List<Map<String, String>> teachersToImport
) async {
  List<String> duplicates = [];
  
  // Проверяем каждого преподавателя отдельно через поиск
  for (var teacherData in teachersToImport) {
    final email = teacherData['Email'] ?? '';
    final firstName = teacherData['Имя'] ?? '';
    final lastName = teacherData['Фамилия'] ?? '';
    
    if (email.isNotEmpty) {
      try {
        // Используем поиск вместо getAllTeachers
        final existingByEmail = await client.search.searchTeachers(query: email);
        if (existingByEmail.isNotEmpty) {
          duplicates.add('$firstName $lastName (по email)');
          continue;
        }
      } catch (e) {
        print('Ошибка поиска по email: $e');
      }
    }
    
    // Поиск по имени
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      try {
        final existingByName = await client.search.searchTeachers(query: '$firstName $lastName');
        final exactMatch = existingByName.any((existing) => 
          existing.person?.firstName == firstName && 
          existing.person?.lastName == lastName
        );
        if (exactMatch) {
          duplicates.add('$firstName $lastName (по имени)');
        }
      } catch (e) {
        print('Ошибка поиска по имени: $e');
      }
    }
  }
  
  return duplicates;
}

/// Определяет, является ли строка заголовком таблицы преподавателей
bool _isLikelyTeacherHeader(List<dynamic> row) {
  if (row.isEmpty) return false;
  
  List<String> possibleHeaders = [
    'имя', 'фамилия', 'отчество', 'email', 'телефон',
    'name', 'first name', 'firstname', 'last name', 'lastname', 'email', 'phone'
  ];
  
  for (var cell in row) {
    String cellText = cell.toString().toLowerCase().trim();
    if (possibleHeaders.contains(cellText)) {
      return true;
    }
  }
  return false;
}

/// Диалог для отображения дубликатов
Future<bool?> _showDuplicatesDialog(BuildContext context, List<String> duplicates) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Обнаружены дубликаты'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: Column(
            children: [
              Text('Найдено ${duplicates.length} преподавателей, которые уже существуют:'),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: duplicates.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(duplicates[index]),
                      leading: const Icon(Icons.warning, color: Colors.orange),
                    );
                  },
                ),
              ),
              const Text('Продолжить импорт? (дубликаты будут пропущены)'),
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
            child: const Text('Продолжить'),
          ),
        ],
      );
    },
  );
}

/// Диалог для предварительного просмотра преподавателей
Future<bool?> _showTeachersPreviewDialog(
  BuildContext context, 
  List<Map<String, String>> teachers
) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Импорт преподавателей'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: Column(
            children: [
              Text('Найдено ${teachers.length} преподавателей'),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: teachers.length,
                  itemBuilder: (context, index) {
                    final teacher = teachers[index];
                    return Card(
                      child: ListTile(
                        title: Text('${teacher['Имя']} ${teacher['Фамилия']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (teacher['Отчество']?.isNotEmpty ?? false)
                              Text('Отчество: ${teacher['Отчество']}'),
                            if (teacher['Email']?.isNotEmpty ?? false)
                              Text('Email: ${teacher['Email']}'),
                            if (teacher['Телефон']?.isNotEmpty ?? false)
                              Text('Телефон: ${teacher['Телефон']}'),
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

/// Диалог для отображения ошибок импорта преподавателей
void _showTeachersErrorsDialog(BuildContext context, List<String> errors, int imported, int total) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Результат импорта преподавателей'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: Column(
            children: [
              Text('Импортировано $imported из $total преподавателей'),
              Text('Не удалось импортировать ${total - imported} преподавателей:', 
                   style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: errors.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(errors[index]),
                      leading: const Icon(Icons.error, color: Colors.red),
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