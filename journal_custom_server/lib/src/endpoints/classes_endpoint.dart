import 'dart:convert';

import 'package:journal_custom_server/src/custom_scope.dart';
import 'package:journal_custom_server/src/services/permission_service.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import '../generated/protocol.dart';
import '../services/user_subgroup_service.dart';
import '../services/permission_service.dart';
import 'rasp_endpoint.dart';

class ClassesEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  // Обновленный метод для получения предметов с занятиями
  Future<List<Subjects>> getSubjectsWithClasses(Session session) async {
    try {
      return await UserSubgroupService.getUserAccessibleSubjectsWithClasses(session);
    } catch (e, stackTrace) {
      session.log(
        'Ошибка в getSubjectsWithClasses: $e',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  // Обновленный метод для получения занятий по предмету
  Future<List<Classes>> getClassesBySubject(Session session, {required int subjectId}) async {
    try {
      final accessibleSubgroupIds = await UserSubgroupService.getUserAccessibleSubgroupIds(session);
      
      if (accessibleSubgroupIds.isEmpty) {
        return [];
      }

      return await Classes.db.find(
        session,
        where: (c) => c.subjectsId.equals(subjectId) & c.subgroupsId.inSet(accessibleSubgroupIds.toSet()),
        include: Classes.include(
          subjects: Subjects.include(),
          class_types: ClassTypes.include(),
          teachers: Teachers.include(person: Person.include()),
          semesters: Semesters.include(),
          subgroups: Subgroups.include(),
        ),
        orderBy: (c) => c.date,
        orderDescending: true,
      );
    } catch (e, stackTrace) {
      session.log(
        'Ошибка в getClassesBySubject: $e',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  // Обновленный метод создания занятий с проверкой доступа
  Future<Classes> createClass(
    Session session, {
    required int subjectsId,
    required int classTypesId,
    required int teachersId,
    required int semestersId,
    required int subgroupsId,
    required DateTime date,
    String? topic,
    String? notes,
    }) async {

    // Проверяем существование связанных объектов
    final existingSubject = await Subjects.db.findById(session, subjectsId);
    if (existingSubject == null) {
      throw Exception('Предмет с ID "$subjectsId" не найден.');
    }

    final existingClassType = await ClassTypes.db.findById(session, classTypesId);
    if (existingClassType == null) {
      throw Exception('Тип занятия с ID "$classTypesId" не найден.');
    }

    final existingTeacher = await Teachers.db.findById(session, teachersId);
    if (existingTeacher == null) {
      throw Exception('Преподаватель с ID "$teachersId" не найден.');
    }

    final existingSemester = await Semesters.db.findById(session, semestersId);
    if (existingSemester == null) {
      throw Exception('Семестр с ID "$semestersId" не найден.');
    }

    final existingSubgroup = await Subgroups.db.findById(session, subgroupsId);
    if (existingSubgroup == null) {
      throw Exception('Подгруппа с ID "$subgroupsId" не найдена.');
    }

    // Проверяем доступ к подгруппе
    if (!await UserSubgroupService.hasAccessToSubgroup(session, subgroupsId)) {
      throw Exception('Доступ запрещен: нет прав на создание занятий для этой подгруппы.');
    }
    var userId = (await session.authenticated)!.userId;
    var authUser = await Users.findUserByUserId(session, userId);
    // if (authUser == null) return false;

    if (authUser!.scopes.contains(CustomScope.student)) {
      throw Exception('Доступ запрещен: студенты не могут создавать занятия.');
    }

    final newClass = Classes(
      subjectsId: subjectsId,
      class_typesId: classTypesId,
      teachersId: teachersId,
      semestersId: semestersId,
      subgroupsId: subgroupsId,
      date: date,
      topic: topic,
      notes: notes,
    );

    return await Classes.db.insertRow(session, newClass);
  }

  Future<List<Subjects>> getSubjectsForGroup(Session session, int groupId) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Пользователь не авторизован.');
    }

    session.log('getSubjectsForGroup: groupId=$groupId, userId=${authInfo.userId}, scopes=${authInfo.scopes.map((s) => s.name).join(',')}');

    // Проверяем, имеет ли пользователь доступ к группе
    final hasAccess = await PermissionService.canViewGroupSubjects(session, groupId);
    session.log('getSubjectsForGroup: hasAccess=$hasAccess для группы $groupId');
    
    if (!hasAccess) {
      // Добавляем дополнительную диагностику
      final person = await Person.db.findFirstRow(
        session,
        where: (p) => p.userInfoId.equals(authInfo.userId),
      );
      
      if (person != null && authInfo.scopes.any((scope) => scope.name == 'curator')) {
        final teacher = await Teachers.db.findFirstRow(
          session,
          where: (t) => t.personId.equals(person.id),
        );
        
        if (teacher != null) {
          final group = await Groups.db.findById(session, groupId);
          session.log('getSubjectsForGroup: teacher.id=${teacher.id}, group.curatorId=${group?.curatorId}, person.id=${person.id}');
          
          final allCuratedGroups = await Groups.db.find(
            session,
            where: (g) => g.curatorId.equals(teacher.id),
          );
          session.log('getSubjectsForGroup: куратор ${teacher.id} курирует группы: ${allCuratedGroups.map((g) => '${g.id}:${g.name}').join(', ')}');
        }
      }
      
      throw Exception('Доступ запрещен: нет прав на просмотр предметов этой группы.');
    }

    // Получаем подгруппы, связанные с группой
    final subgroups = await Subgroups.db.find(
      session,
      where: (s) => s.groupsId.equals(groupId),
    );

    if (subgroups.isEmpty) {
      return [];
    }

    // Получаем ID подгрупп
    final subgroupIds = subgroups.map((s) => s.id!).toSet();

    // Получаем занятия, связанные с этими подгруппами
    final classes = await Classes.db.find(
      session,
      where: (c) => c.subgroupsId.inSet(subgroupIds),
    );

    if (classes.isEmpty) {
      return [];
    }

    // Если пользователь — преподаватель, фильтруем занятия по его ID
    if (authInfo.scopes.contains(CustomScope.teacher)) {
      final person = await Person.db.findFirstRow(
        session,
        where: (p) => p.userInfoId.equals(authInfo.userId),
      );

      if (person != null) {
        final teacher = await Teachers.db.findFirstRow(
          session,
          where: (t) => t.personId.equals(person.id),
        );

        if (teacher != null) {
          classes.removeWhere((c) => c.teachersId != teacher.id);
        }
      }
    }

    // Получаем ID предметов, связанных с этими занятиями
    final subjectIds = classes.map((c) => c.subjectsId).toSet();

    // Получаем предметы по их ID
    final subjects = await Subjects.db.find(
      session,
      where: (s) => s.id.inSet(subjectIds),
    );

    return subjects;
  }

  
  
  /// Импортирует занятия из API расписания для указанной группы
  Future<String> importClassesFromScheduleForGroup(
    Session session, 
    int groupId, 
    String year,
    {String? startDate, String? endDate}
  ) async {
    try {
      session.log('Начало импорта занятий из расписания для группы $groupId, год: $year');
      
      // Проверяем права доступа
      if (!await PermissionService.canManageGroupSubgroups(session, groupId)) {
        throw Exception('Нет прав на импорт занятий для этой группы');
      }

      // Проверяем, существует ли группа в нашей БД
      final group = await Groups.db.findById(session, groupId);
      if (group == null) {
        throw Exception('Группа с ID $groupId не найдена в базе данных');
      }

      final raspEndpoint = RaspEndpoint();
      
      // 1. Проверяем доступность API
      session.log('Проверка доступности API расписания...');
      if (!await raspEndpoint.checkApiAvailability(session)) {
        throw Exception('API расписания недоступен в данный момент. Попробуйте позже.');
      }

      // 2. Проверяем существование группы в API
      session.log('Проверка существования группы $groupId в API...');
      if (!await raspEndpoint.checkGroupExists(session, groupId, year)) {
        throw Exception('Группа с ID $groupId не найдена в API расписания для года $year');
      }

      // 3. Получаем расписание группы из API
      String scheduleJsonString;
      try {
        session.log('Получение расписания для группы $groupId...');
        scheduleJsonString = await raspEndpoint.getScheduleForGroup(session, groupId);
        session.log('Получено расписание из API для группы $groupId');
      } catch (e) {
        session.log('Ошибка при получении расписания из API: $e', level: LogLevel.error);
        throw Exception('Не удалось получить расписание из API: $e');
      }

      // Парсим JSON расписания
      Map<String, dynamic> scheduleData;
      try {
        scheduleData = json.decode(scheduleJsonString);
        session.log('JSON расписания успешно декодирован');
      } catch (e) {
        session.log('Ошибка парсинга JSON расписания: $e', level: LogLevel.error);
        throw Exception('Ошибка парсинга данных расписания: $e');
      }

      // ИСПРАВЛЕНИЕ: Добавляем подробную проверку структуры данных
      session.log('Структура полученных данных: ${scheduleData.keys.toList()}');
      
      if (scheduleData['rasp'] == null) {
        session.log('Поле "rasp" отсутствует или равно null в ответе API');
        return 'Расписание для группы "${group.name}" (ID: $groupId) пустое для года $year. Поле "rasp" отсутствует в ответе API.';
      }

      // ИСПРАВЛЕНИЕ: Безопасная проверка типа данных
      final raspData = scheduleData['rasp'];
      if (raspData is! List) {
        session.log('Поле "rasp" не является списком: ${raspData.runtimeType}');
        if (raspData is Map && (raspData as Map).isEmpty) {
          return 'Расписание для группы "${group.name}" (ID: $groupId) пустое для года $year. Данные расписания представлены как пустой объект.';
        }
        throw Exception('Неожиданный формат данных расписания: ожидался список, получен ${raspData.runtimeType}');
      }

      final classList = List<Map<String, dynamic>>.from(raspData);
      session.log('Найдено ${classList.length} записей в расписании');
      
      if (classList.isEmpty) {
        return 'В расписании группы "${group.name}" (ID: $groupId) не найдено занятий для года $year.';
      }

      int importedCount = 0;
      int skippedCount = 0;
      int errorCount = 0;
      List<String> errors = [];

      // Получаем или создаем основную подгруппу для группы
      Subgroups mainSubgroup = await _getOrCreateMainSubgroup(session, group);

      // Получаем семестр по умолчанию
      Semesters defaultSemester = await _getOrCreateDefaultSemester(session, year);

      for (var classInfo in classList) {
        try {
          // Проверяем, что classInfo является Map
          if (classInfo is! Map<String, dynamic>) {
            session.log('Пропуск записи: не является объектом Map - ${classInfo.runtimeType}');
            skippedCount++;
            continue;
          }

          // Парсим данные занятия с улучшенным извлечением типа
          String rawSubject = classInfo['дисциплина']?.toString() ?? '';
          final teacherName = classInfo['фиоПреподавателя']?.toString() ?? '';
          String classType = classInfo['видЗанятия']?.toString() ?? '';
          final dateTimeStr = classInfo['дата']?.toString() ?? '';
          final timeStr = classInfo['время']?.toString() ?? '';

          session.log('Обработка занятия: предмет="$rawSubject", дата="$dateTimeStr", время="$timeStr"');

          // Извлекаем тип занятия из названия дисциплины, если он не указан отдельно
          String cleanSubject = rawSubject;
          if (classType.isEmpty && rawSubject.isNotEmpty) {
            final extractedType = _extractClassTypeFromSubject(rawSubject);
            classType = extractedType['type'] ?? 'Занятие';
            cleanSubject = extractedType['subject'] ?? rawSubject;
            session.log('Извлечен тип занятия: "$classType", чистое название: "$cleanSubject"');
          }

          if (cleanSubject.isEmpty || dateTimeStr.isEmpty) {
            session.log('Пропуск занятия: пустое название предмета или дата');
            skippedCount++;
            continue;
          }

          // Парсим дату и время
          DateTime classDateTime;
          try {
            classDateTime = _parseDateTime(dateTimeStr, timeStr);
            session.log('Дата и время занятия: $classDateTime');
          } catch (e) {
            errors.add('Ошибка парсинга даты для "$cleanSubject": $e');
            errorCount++;
            session.log('Ошибка парсинга даты: $e');
            continue;
          }

          // Фильтрация по датам, если указана
          if (startDate != null && endDate != null) {
            try {
              final start = DateTime.parse(startDate);
              final end = DateTime.parse(endDate).add(const Duration(days: 1)); // Включаем конечный день
              if (classDateTime.isBefore(start) || classDateTime.isAfter(end)) {
                session.log('Занятие исключено фильтром дат: $classDateTime не в диапазоне $start - $end');
                skippedCount++;
                continue;
              }
            } catch (e) {
              session.log('Ошибка парсинга фильтра дат: $e');
            }
          }

          // Получаем или создаем предмет
          final subjectEntity = await _getOrCreateSubject(session, cleanSubject);

          // Получаем или создаем тип занятия
          final classTypeEntity = await _getOrCreateClassType(session, classType);

          // Получаем или создаем преподавателя
          final teacher = await _getOrCreateTeacher(session, teacherName);

          // Проверяем, не существует ли уже такое занятие
          final existingClass = await Classes.db.findFirstRow(
            session,
            where: (c) => 
              c.subjectsId.equals(subjectEntity.id!) &
              c.subgroupsId.equals(mainSubgroup.id!) &
              c.date.equals(classDateTime) &
              c.class_typesId.equals(classTypeEntity.id!),
          );

          if (existingClass != null) {
            session.log('Занятие уже существует, пропуск');
            skippedCount++;
            continue;
          }

          // Создаем занятие
          final newClass = Classes(
            subjectsId: subjectEntity.id!,
            class_typesId: classTypeEntity.id!,
            teachersId: teacher.id!,
            semestersId: defaultSemester.id!,
            subgroupsId: mainSubgroup.id!,
            date: classDateTime,
            topic: null,
            notes: 'Импортировано из расписания',
          );

          await Classes.db.insertRow(session, newClass);
          importedCount++;
          session.log('Занятие успешно создано: ID=${newClass.id}');

        } catch (e, stackTrace) {
          errorCount++;
          final errorMsg = 'Ошибка импорта занятия: $e';
          errors.add(errorMsg);
          session.log(errorMsg, level: LogLevel.error, stackTrace: stackTrace);
        }
      }

      // Формируем итоговое сообщение
      String summary = 'Импорт занятий для группы "${group.name}" (ID: $groupId) завершен.\n';
      summary += 'Учебный год: $year\n';
      if (startDate != null && endDate != null) {
        summary += 'Период: $startDate - $endDate\n';
      }
      summary += 'Всего в расписании: ${classList.length}\n';
      summary += 'Импортировано новых занятий: $importedCount\n';
      summary += 'Пропущено (дубликаты/фильтры): $skippedCount\n';
      if (errorCount > 0) {
        summary += 'Ошибок: $errorCount\n';
        if (errors.isNotEmpty) {
          summary += 'Детали ошибок:\n${errors.take(5).join('\n')}';
          if (errors.length > 5) {
            summary += '\n... и еще ${errors.length - 5} ошибок';
          }
        }
      }

      session.log(summary);
      return summary;

    } catch (e, stackTrace) {
      session.log(
        'Критическая ошибка при импорте занятий: $e',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      throw Exception('Не удалось импортировать занятия: $e');
    }
  }

  /// Извлекает тип занятия из названия дисциплины
  Map<String, String> _extractClassTypeFromSubject(String rawSubject) {
    final subject = rawSubject.trim();
    
    final patterns = {
      // Основные типы занятий
      r'^лек\s+(.+)': 'Лекция',
      r'^лаб\s+(.+)': 'Лабораторная работа',
      r'^пр\s+(.+)': 'Практическое занятие',
      r'^прак\s+(.+)': 'Практическое занятие',
      r'^сем\s+(.+)': 'Семинар',
      r'^зач\s+(.+)': 'Зачет',
      r'^экз\s+(.+)': 'Экзамен',
      r'^кр\s+(.+)': 'Контрольная работа',
      r'^курс\s+(.+)': 'Курсовая работа',
      r'^диплом\s+(.+)': 'Дипломная работа',
      
      // Полные формы
      r'^лекция\s+(.+)': 'Лекция',
      r'^лабораторная\s+(.+)': 'Лабораторная работа',
      r'^практическое\s+(.+)': 'Практическое занятие',
      r'^семинар\s+(.+)': 'Семинар',
      
      // Формы в скобках
      r'^\(лек\)\s*(.+)': 'Лекция',
      r'^\(лаб\)\s*(.+)': 'Лабораторная работа',
      r'^\(пр\)\s*(.+)': 'Практическое занятие',
      r'^\(прак\)\s*(.+)': 'Практическое занятие',
      
      // Комбинированные формы с подгруппами
      r'^лек\s+п/г\s+(.+)': 'Лекция',
      r'^лаб\s+п/г\s+(.+)': 'Лабораторная работа', 
      r'^пр\s+п/г\s+(.+)': 'Практическое занятие',
      r'^прак\s+п/г\s+(.+)': 'Практическое занятие',
      
      // Обратный порядок (п/г в начале)
      r'^п/г\s+лек\s+(.+)': 'Лекция',
      r'^п/г\s+лаб\s+(.+)': 'Лабораторная работа',
      r'^п/г\s+пр\s+(.+)': 'Практическое занятие',
      r'^п/г\s+прак\s+(.+)': 'Практическое занятие',
      
      // Только п/г в начале
      r'^п/г\s+(.+)': 'Практическое занятие', // По умолчанию считаем практическим
    };

    // Пробуем каждый паттерн
    for (var entry in patterns.entries) {
      final regex = RegExp(entry.key, caseSensitive: false);
      final match = regex.firstMatch(subject);
      
      if (match != null) {
        String cleanSubject = match.group(1)?.trim() ?? subject;
        
        // Дополнительная очистка от оставшихся сокращений
        cleanSubject = _cleanSubjectName(cleanSubject);
        
        return {
          'type': entry.value,
          'subject': cleanSubject,
        };
      }
    }

    // Если паттерн не найден, проверяем на наличие п/г в любом месте и убираем
    String cleanSubject = _cleanSubjectName(subject);
    
    return {
      'type': 'Занятие',
      'subject': cleanSubject,
    };
  }

  /// Дополнительная очистка названия предмета от сокращений
  String _cleanSubjectName(String subject) {
    String cleaned = subject.trim();
    
    // 1. Убираем информацию о подгруппах в конце строки (после запятой)
    final endPatterns = [
      r',\s*п/г\s*\d*$',           // ", п/г 1", ", п/г"
      r',\s*п\.г\s*\d*$',          // ", п.г 1", ", п.г"
      r',\s*подгр\s*\d*$',         // ", подгр 1", ", подгр"
      r',\s*подгруппа\s*\d*$',     // ", подгруппа 1", ", подгруппа"
      r',\s*гр\s*\d*$',            // ", гр 1", ", гр"
      r',\s*группа\s*\d*$',        // ", группа 1", ", группа"
    ];
    
    for (var pattern in endPatterns) {
      cleaned = cleaned.replaceAll(RegExp(pattern, caseSensitive: false), '');
    }
    
    // 2. Убираем различные варианты сокращений подгрупп в любом месте
    final anywherePatterns = [
      r'\bп/г\s*\d*\b',            // п/г 1, п/г как отдельное слово
      r'\bп\.г\s*\d*\b',           // п.г 1, п.г как отдельное слово  
      r'\bподгр\s*\d*\b',          // подгр 1, подгр как отдельное слово
      r'\bподгруппа\s*\d*\b',      // подгруппа 1, подгруппа как отдельное слово
      r'\(\s*п/г\s*\d*\s*\)',      // (п/г 1) в скобках
      r'\(\s*подгр\s*\d*\s*\)',    // (подгр 1) в скобках
      r'\[\s*п/г\s*\d*\s*\]',      // [п/г 1] в квадратных скобках
      r'\[\s*подгр\s*\d*\s*\]',    // [подгр 1] в квадратных скобках
    ];
    
    for (var pattern in anywherePatterns) {
      cleaned = cleaned.replaceAll(RegExp(pattern, caseSensitive: false), '');
    }
    
    // 3. Убираем лишние пробелы и приводим в порядок
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();
    
    // 4. Убираем висящие знаки препинания в начале и конце
    cleaned = cleaned.replaceAll(RegExp(r'^[,.\-\s]+|[,.\-\s]+$'), '');
    
    // 5. Убираем повторяющиеся запятые и пробелы
    cleaned = cleaned.replaceAll(RegExp(r',\s*,+'), ',');
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();
    
    return cleaned.isEmpty ? subject : cleaned; // Возвращаем оригинал если после очистки ничего не осталось
  }

  Future<Subgroups> _getOrCreateMainSubgroup(Session session, Groups group) async {
    var subgroup = await Subgroups.db.findFirstRow(
      session,
      where: (s) => s.groupsId.equals(group.id!) & s.name.equals('Основная подгруппа'),
    );

    if (subgroup == null) {
      subgroup = Subgroups(
        name: 'Основная подгруппа',
        description: 'Автоматически созданная подгруппа для импорта расписания',
        groupsId: group.id!,
      );
      subgroup = await Subgroups.db.insertRow(session, subgroup);

      // Добавляем всех студентов группы в подгруппу
      final students = await Students.db.find(
        session,
        where: (s) => s.groupsId.equals(group.id!),
      );

      for (var student in students) {
        final link = StudentSubgroup(
          subgroupsId: subgroup.id!,
          studentsId: student.id!,
        );
        await StudentSubgroup.db.insertRow(session, link);
      }
    }

    return subgroup;
  }

  Future<Semesters> _getOrCreateDefaultSemester(Session session, String year) async {
    var semester = await Semesters.db.findFirstRow(
      session,
      where: (s) => s.name.equals('Учебный год $year'),
    );

    if (semester == null) {
      final yearParts = year.split('-');
      final startYear = int.tryParse(yearParts[0]) ?? DateTime.now().year;
      
      semester = Semesters(
        name: 'Учебный год $year',
        startDate: DateTime(startYear, 9, 1),
        endDate: DateTime(startYear + 1, 6, 30),
        year: startYear,
      );
      semester = await Semesters.db.insertRow(session, semester);
    }

    return semester;
  }

  Future<Subjects> _getOrCreateSubject(Session session, String subjectName) async {
    var subject = await Subjects.db.findFirstRow(
      session,
      where: (s) => s.name.equals(subjectName),
    );

    if (subject == null) {
      subject = Subjects(name: subjectName);
      subject = await Subjects.db.insertRow(session, subject);
    }

    return subject;
  }

  Future<ClassTypes> _getOrCreateClassType(Session session, String typeName) async {
    var classType = await ClassTypes.db.findFirstRow(
      session,
      where: (ct) => ct.name.equals(typeName),
    );

    if (classType == null) {
      classType = ClassTypes(name: typeName);
      classType = await ClassTypes.db.insertRow(session, classType);
    }

    return classType;
  }

  Future<Teachers> _getOrCreateTeacher(Session session, String teacherFullName) async {
    if (teacherFullName.isEmpty) {
      teacherFullName = 'Неизвестный преподаватель';
    }

    // Парсим ФИО
    final nameParts = teacherFullName.trim().split(' ');
    String lastName = nameParts.isNotEmpty ? nameParts[0] : 'Неизвестен';
    String firstName = nameParts.length > 1 ? nameParts[1] : '';
    String? patronymic = nameParts.length > 2 ? nameParts[2] : null;

    // Ищем преподавателя по ФИО
    var person = await Person.db.findFirstRow(
      session,
      where: (p) => p.lastName.equals(lastName) & p.firstName.equals(firstName),
    );

    if (person == null) {
      // Создаем новую персону
      person = Person(
        firstName: firstName,
        lastName: lastName,
        patronymic: patronymic,
        email: '${firstName.toLowerCase()}.${lastName.toLowerCase()}@university.auto',
      );
      person = await Person.db.insertRow(session, person);
    }

    // Ищем преподавателя
    var teacher = await Teachers.db.findFirstRow(
      session,
      where: (t) => t.personId.equals(person?.id!),
    );

    if (teacher == null) {
      teacher = Teachers(personId: person.id!);
      teacher = await Teachers.db.insertRow(session, teacher);
    }

    return teacher;
  }

  DateTime _parseDateTime(String dateStr, String timeStr) {
    try {
      // Попытка парсинга различных форматов даты
      DateTime date;
      
      if (dateStr.contains('.')) {
        // Формат DD.MM.YYYY
        final parts = dateStr.split('.');
        date = DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      } else if (dateStr.contains('-')) {
        // Формат YYYY-MM-DD
        date = DateTime.parse(dateStr);
      } else {
        throw Exception('Неподдерживаемый формат даты: $dateStr');
      }

      // Парсинг времени
      if (timeStr.isNotEmpty) {
        final timeParts = timeStr.split(':');
        if (timeParts.length >= 2) {
          date = date.add(Duration(
            hours: int.parse(timeParts[0]),
            minutes: int.parse(timeParts[1]),
          ));
        }
      }

      return date;
    } catch (e) {
      throw Exception('Ошибка парсинга даты/времени "$dateStr $timeStr": $e');
    }
  }

  // Добавляем метод для обновления занятия
  Future<Classes> updateClass(
    Session session, {
    required int classId,
    int? subjectsId,
    int? classTypesId,
    int? teachersId,
    int? semestersId,
    int? subgroupsId,
    DateTime? date,
    String? topic,
    String? notes,
  }) async {
  
    // Проверяем существование занятия
    final existingClass = await Classes.db.findById(session, classId);
    if (existingClass == null) {
      throw Exception('Занятие с ID "$classId" не найдено.');
    }

    // Проверяем доступ к текущей подгруппе занятия
    if (!await UserSubgroupService.hasAccessToSubgroup(session, existingClass.subgroupsId!)) {
      throw Exception('Доступ запрещен: нет прав на редактирование этого занятия.');
    }

    var userId = (await session.authenticated)!.userId;
    var authUser = await Users.findUserByUserId(session, userId);

    if (authUser!.scopes.contains(CustomScope.student)) {
      throw Exception('Доступ запрещен: студенты не могут редактировать занятия.');
    }

    // Проверяем существование связанных объектов, если они изменяются
    if (subjectsId != null && subjectsId != existingClass.subjectsId) {
      final existingSubject = await Subjects.db.findById(session, subjectsId);
      if (existingSubject == null) {
        throw Exception('Предмет с ID "$subjectsId" не найден.');
      }
    }

    if (classTypesId != null && classTypesId != existingClass.class_typesId) {
      final existingClassType = await ClassTypes.db.findById(session, classTypesId);
      if (existingClassType == null) {
        throw Exception('Тип занятия с ID "$classTypesId" не найден.');
      }
    }

    if (teachersId != null && teachersId != existingClass.teachersId) {
      final existingTeacher = await Teachers.db.findById(session, teachersId);
      if (existingTeacher == null) {
        throw Exception('Преподаватель с ID "$teachersId" не найден.');
      }
    }

    if (semestersId != null && semestersId != existingClass.semestersId) {
      final existingSemester = await Semesters.db.findById(session, semestersId);
      if (existingSemester == null) {
        throw Exception('Семестр с ID "$semestersId" не найден.');
      }
    }

    if (subgroupsId != null && subgroupsId != existingClass.subgroupsId) {
      final existingSubgroup = await Subgroups.db.findById(session, subgroupsId);
      if (existingSubgroup == null) {
        throw Exception('Подгруппа с ID "$subgroupsId" не найдена.');
      }

      // Проверяем доступ к новой подгруппе
      if (!await UserSubgroupService.hasAccessToSubgroup(session, subgroupsId)) {
        throw Exception('Доступ запрещен: нет прав на создание занятий для этой подгруппы.');
      }
    }

    // Создаем обновленное занятие
    final updatedClass = existingClass.copyWith(
      subjectsId: subjectsId ?? existingClass.subjectsId,
      class_typesId: classTypesId ?? existingClass.class_typesId,
      teachersId: teachersId ?? existingClass.teachersId,
      semestersId: semestersId ?? existingClass.semestersId,
      subgroupsId: subgroupsId ?? existingClass.subgroupsId,
      date: date ?? existingClass.date,
      topic: topic ?? existingClass.topic,
      notes: notes ?? existingClass.notes,
    );

    return await Classes.db.updateRow(session, updatedClass);
  }

  // Добавляем метод для удаления занятия
  Future<bool> deleteClass(Session session, int classId) async {
  // Проверяем существование занятия
  final existingClass = await Classes.db.findById(session, classId);
  if (existingClass == null) {
    throw Exception('Занятие с ID "$classId" не найдено.');
  }

  // Проверяем доступ к подгруппе занятия
  if (!await UserSubgroupService.hasAccessToSubgroup(session, existingClass.subgroupsId!)) {
    throw Exception('Доступ запрещен: нет прав на удаление этого занятия.');
  }

  var userId = (await session.authenticated)!.userId;
  var authUser = await Users.findUserByUserId(session, userId);

  if (authUser!.scopes.contains(CustomScope.student)) {
    throw Exception('Доступ запрещен: студенты не могут удалять занятия.');
  }

  // Удаляем связанные записи о посещаемости
  await Attendance.db.deleteWhere(
    session,
    where: (a) => a.classesId.equals(classId),
  );

  // Удаляем само занятие
  await Classes.db.deleteRow(session, existingClass);
  return true;
}

  /// Закрыть занятие (подпись преподавателя)
Future<Classes> closeClassByTeacher(Session session, int classId) async {
  final authInfo = await session.authenticated;
  if (authInfo == null) {
    throw Exception('Пользователь не авторизован.');
  }

  final classInfo = await Classes.db.findById(session, classId);
  if (classInfo == null) {
    throw Exception('Занятие с ID $classId не найдено.');
  }

  // Проверяем, является ли пользователь преподавателем этого занятия
  final person = await Person.db.findFirstRow(
    session,
    where: (p) => p.userInfoId.equals(authInfo.userId),
  );
  
  if (person == null) {
    throw Exception('Пользователь не найден.');
  }

  final teacher = await Teachers.db.findFirstRow(
    session,
    where: (t) => t.personId.equals(person.id),
  );
  
  if (teacher == null || teacher.id != classInfo.teachersId) {
    throw Exception('Только преподаватель данного занятия может его закрыть.');
  }

  if (classInfo.isClosedByTeacher == true) {
    throw Exception('Занятие уже закрыто.');
  }

  // Закрываем занятие
  final updatedClass = classInfo.copyWith(
    isClosedByTeacher: true,
    closedAt: DateTime.now(),
    closedByTeacherId: teacher.id,
  );

  return await Classes.db.updateRow(session, updatedClass);
}

/// Открыть занятие (только для администраторов)
Future<Classes> reopenClass(Session session, int classId) async {
  final authInfo = await session.authenticated;
  if (authInfo == null) {
    throw Exception('Пользователь не авторизован.');
  }

  // Проверяем права администратора
  final userInfo = await Users.findUserByUserId(session, authInfo.userId);
  if (userInfo == null || !userInfo.scopes.contains(Scope.admin)) {
    throw Exception('Только администраторы могут открывать закрытые занятия.');
  }

  final classInfo = await Classes.db.findById(session, classId);
  if (classInfo == null) {
    throw Exception('Занятие с ID $classId не найдено.');
  }

  if (classInfo.isClosedByTeacher != true) {
    throw Exception('Занятие не закрыто.');
  }

  // Открываем занятие
  final updatedClass = classInfo.copyWith(
    isClosedByTeacher: false,
    closedAt: null,
    closedByTeacherId: null,
  );

  return await Classes.db.updateRow(session, updatedClass);
}

/// Получить статус занятия
Future<Map<String, dynamic>> getClassStatus(Session session, int classId) async {
  final classInfo = await Classes.db.findById(
    session, 
    classId,
    include: Classes.include(
      teachers: Teachers.include(person: Person.include()),
    ),
  );
  
  if (classInfo == null) {
    throw Exception('Занятие с ID $classId не найдено.');
  }

  return {
    'isClosed': classInfo.isClosedByTeacher ?? false,
    'closedAt': classInfo.closedAt?.toIso8601String(),
    'closedByTeacher': classInfo.teachers?.person != null 
        ? '${classInfo.teachers!.person!.firstName} ${classInfo.teachers!.person!.lastName}'
        : null,
  };
}
}