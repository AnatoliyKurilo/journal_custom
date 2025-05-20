import 'dart:io';
import 'package:journal_custom_client/journal_custom_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';

Future<void> exportGroupsToCsv(List<Groups> groups) async {
  try {
    // Создаем заголовки для CSV
    List<List<dynamic>> rows = [
      ['ID', 'Название группы', 'Куратор', 'Староста']
    ];

    // // Добавляем данные групп
    // for (var group in groups) {
    //   rows.add([
    //     group.id,
    //     group.name,
    //     '${group.curator?.person?.firstName ?? ''} ${group.curator?.person?.lastName ?? ''}',
    //     '${group.groupHead?.person?.firstName ?? ''} ${group.groupHead?.person?.lastName ?? ''}',
    //   ]);
    // }

    // Генерируем CSV-строку
    String csvData = const ListToCsvConverter().convert(rows);

    // Получаем путь для сохранения файла
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/groups_export.csv';

    // Сохраняем файл
    final file = File(path);
    await file.writeAsString(csvData);

    print('Файл успешно сохранен: $path');
  } catch (e) {
    print('Ошибка при экспорте данных: $e');
  }
}

Future<void> exportGroupToCsv(Groups group, List<Students> students) async {
  try {
    // Фильтруем студентов, которые принадлежат к этой группе
    List<Students> groupStudents = students.where((student) => student.groupsId == group.id).toList();

    // Создаем заголовки для CSV
    List<List<dynamic>> rows = [
      ['Имя', 'Фамилия', 'Отчество', 'Email', 'Телефон']
    ];

    // Добавляем данные студентов
    for (var student in groupStudents) {
      rows.add([
        student.person?.firstName ?? '',
        student.person?.lastName ?? '',
        student.person?.patronymic ?? '', // Добавляем отчество
        student.person?.email ?? 'Не указан',
        student.person?.phoneNumber ?? 'Не указан', // Добавляем телефон
      ]);
    }

    // Генерируем CSV-строку
    String csvData = const ListToCsvConverter().convert(rows);

    // Вызываем FilePicker для выбора пути сохранения
    String? outputFilePath = await FilePicker.platform.saveFile(
      dialogTitle: 'Выберите место для сохранения файла',
      fileName: '${group.name.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')}.csv', // Убираем недопустимые символы
    );

    if (outputFilePath == null) {
      // Пользователь отменил выбор
      return;
    }

    // Сохраняем файл
    final file = File(outputFilePath);
    await file.writeAsString(csvData);

    print('Файл успешно сохранен: $outputFilePath');
  } catch (e) {
    print('Ошибка при экспорте группы: $e');
  }
}