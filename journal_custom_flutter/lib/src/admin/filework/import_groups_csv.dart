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
      // Пользователь отменил выбор файла
      return;
    }

    // 2. Получаем путь к выбранному файлу и читаем его содержимое
    final filePath = result.files.single.path!;
    final file = File(filePath);
    final csvData = await file.readAsString();

    // 3. Преобразуем CSV в список строк - пробуем несколько разделителей
    // Используем CsvToListConverter без явного eol для авто-определения конца строки.
    List<List<dynamic>> rows;
    try {
      // Попытка 1: разделитель - запятая
      rows = const CsvToListConverter(fieldDelimiter: ',').convert(csvData);
      
      // Если после первого преобразования в первой строке (если она есть) только одно поле,
      // это может означать, что фактический разделитель - точка с запятой.
      // Эта проверка является эвристикой.
      if (rows.isNotEmpty && rows[0].length == 1) {
        // Попытка 2: разделитель - точка с запятой
        rows = const CsvToListConverter(fieldDelimiter: ';').convert(csvData);
      }
    } catch (e) {
      // Если при разборе с запятой произошла ошибка, пробуем с точкой с запятой.
      try {
        rows = const CsvToListConverter(fieldDelimiter: ';').convert(csvData);
      } catch (fallbackError) {
        // Если и вторая попытка не удалась, значит, файл либо не CSV,
        // либо использует другой разделитель, либо серьезно поврежден.
        // Выбрасываем ошибку, чтобы она была обработана выше в вызывающем коде.
        print('Ошибка при разборе CSV с разделителем ",": $e');
        print('Ошибка при разборе CSV с разделителем ";": $fallbackError');
        throw Exception('Не удалось разобрать CSV файл. Убедитесь, что используются разделители "," или ";".');
      }
    }

    if (rows.isEmpty) {
      throw Exception('Файл пуст');
    }

    // 4. Извлекаем название группы из имени файла
    String groupName = file.uri.pathSegments.last.split('.').first;

    // 5. Запрашиваем у пользователя название группы для подтверждения/изменения
    groupName = await _showGroupNameDialog(context, groupName) ?? groupName;
    if (groupName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Импорт отменен: не указано название группы'))
      );
      return;
    }

    // 6. Собираем данные о студентах из файла
    List<Map<String, String>> studentsPreview = [];
    
    // Проверяем наличие заголовков
    bool hasHeaders = rows.isNotEmpty && _isLikelyHeader(rows[0]);
    int startRow = hasHeaders ? 1 : 0;
    
    for (int i = startRow; i < rows.length; i++) {
      final row = rows[i];
      
      // Пропускаем пустые строки
      if (row.isEmpty) continue;
      
      // Проверка, что в строке достаточно данных для имени и фамилии
      if (row.length < 2) {
        // В строке должно быть минимум 2 значения (имя и фамилия)
        continue;
      }

      // Добавляем студента с доступными данными
      Map<String, String> studentData = {
        'Имя': row[0]?.toString().trim() ?? '',
        'Фамилия': row[1]?.toString().trim() ?? '',
      };
      
      // Добавляем опциональные поля в зависимости от количества колонок
      if (row.length > 2) studentData['Отчество'] = row[2]?.toString().trim() ?? '';
      if (row.length > 3) studentData['Email'] = row[3]?.toString().trim() ?? '';
      if (row.length > 4) studentData['Телефон'] = row[4]?.toString().trim() ?? '';

      // Добавляем только если есть как минимум имя и фамилия
      if (studentData['Имя']!.isNotEmpty && studentData['Фамилия']!.isNotEmpty) {
        // Проверяем, нет ли дубликатов в списке по email (если email указан)
        bool isDuplicate = false;
        if (studentData['Email'] != null && studentData['Email']!.isNotEmpty) {
          isDuplicate = studentsPreview.any((s) => 
            s['Email'] == studentData['Email'] && studentData['Email']!.isNotEmpty);
        }
        
        if (!isDuplicate) {
          studentsPreview.add(studentData);
        }
      }
    }

    if (studentsPreview.isEmpty) {
      throw Exception('В файле не найдено данных о студентах');
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
    print('Ошибка при импорте данных: $e');
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
  
  for (var cell in row) {
    String cellText = cell.toString().toLowerCase().trim();
    if (possibleHeaders.contains(cellText)) {
      return true;
    }
  }
  
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