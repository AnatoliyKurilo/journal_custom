import 'dart:io';
import 'package:collection/collection.dart';
import 'package:journal_custom_client/journal_custom_client.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';

// Обновленная функция, принимающая список всех студентов
Future<void> exportGroupsToCsv(List<Groups> groups, List<Students> allStudents) async {
  try {
    // Создаем заголовки для CSV
    List<List<dynamic>> rows = [
      ['ID', 'Название группы', 'Куратор ФИО', 'Староста ФИО']
    ];

    for (var group in groups) {
      String curatorFullName = [
        group.curator?.person?.lastName ?? '',
        group.curator?.person?.firstName ?? '',
        group.curator?.person?.patronymic ?? ''
      ].where((namePart) => namePart.isNotEmpty).join(' ').trim();
      if (curatorFullName.isEmpty) curatorFullName = 'Не назначен';

      // Поиск старосты для текущей группы
      Students? groupHeadStudent;
      if (group.id != null) {
        groupHeadStudent = allStudents.firstWhereOrNull( // Используем firstWhereOrNull
          (student) => student.groupsId == group.id && student.isGroupHead == true,
        );
      }
      
      String groupHeadFullName = 'Не назначен';
      if (groupHeadStudent != null && groupHeadStudent.person != null) {
        groupHeadFullName = [
          groupHeadStudent.person!.lastName ?? '',
          groupHeadStudent.person!.firstName ?? '',
          groupHeadStudent.person!.patronymic ?? ''
        ].where((namePart) => namePart.isNotEmpty).join(' ').trim();
        if (groupHeadFullName.isEmpty) groupHeadFullName = 'Не назначен'; // На случай, если у Person нет имени
      }
      
      rows.add([
        group.id ?? 'N/A',
        group.name ?? 'Без названия',
        curatorFullName,
        groupHeadFullName,
      ]);
    }

    String csvData = const ListToCsvConverter().convert(rows);

    String? outputFilePath = await FilePicker.platform.saveFile(
      dialogTitle: 'Выберите место для сохранения файла экспорта групп',
      fileName: 'all_groups_export.csv',
    );

    if (outputFilePath == null) {
      print('Экспорт отменен пользователем.');
      return;
    }

    final file = File(outputFilePath);
    await file.writeAsString(csvData);

    print('Файл успешно сохранен: $outputFilePath');
  } catch (e) {
    print('Ошибка при экспорте данных всех групп: $e');
  }
}

Future<void> exportGroupToCsv(Groups group, List<Students> students) async {
  try {
    // Фильтруем студентов, которые принадлежат к этой группе
    List<Students> groupStudents = students.where((student) => student.groupsId == group.id).toList();

    // Создаем заголовки для CSV, соответствующие ожиданиям импорта
    List<List<dynamic>> rows = [
      ['Имя', 'Фамилия', 'Отчество', 'Email', 'Телефон']
    ];

    // Добавляем данные студентов
    for (var student in groupStudents) {
      rows.add([
        student.person?.firstName ?? '',
        student.person?.lastName ?? '',
        student.person?.patronymic ?? '', 
        student.person?.email ?? '', // Если email null, экспортируем пустую строку
        student.person?.phoneNumber ?? '', // Если телефон null, экспортируем пустую строку
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
    // Здесь можно добавить SnackBar для уведомления пользователя в UI
  } catch (e) {
    print('Ошибка при экспорте группы: $e');
    // Здесь можно добавить SnackBar для уведомления пользователя в UI
  }
}