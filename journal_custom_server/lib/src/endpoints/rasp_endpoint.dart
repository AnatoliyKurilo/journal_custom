import 'package:serverpod/serverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RaspEndpoint extends Endpoint {
  // @override
  static const String baseUrl = 'https://umu.sibadi.org/api';

  /// Получить список доступных годов
  Future<List<String>> getAvailableYears(Session session) async {
    try {
      final url = '$baseUrl/Rasp/ListYears';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData['state'] == 1 && jsonData['data'] != null) {
          final years = List<String>.from(jsonData['data']['years']);
          return years;
        } else {
          throw Exception('Ошибка API: ${jsonData['msg']}');
        }
      } else {
        throw Exception('HTTP ошибка: ${response.statusCode}');
      }
    } catch (e) {
      session.log('Ошибка получения списка годов: $e');
      throw Exception('Не удалось получить список годов: $e');
    }
  }

  /// Получить список групп для указанного года
  Future<List<Map<String, dynamic>>> getGroupsList(Session session, String year) async {
    try {
      final url = '$baseUrl/raspGrouplist?year=$year';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData['state'] == 1 && jsonData['data'] != null) {
          final groups = List<Map<String, dynamic>>.from(jsonData['data']);
          return groups;
        } else {
          throw Exception('Ошибка API: ${jsonData['msg']}');
        }
      } else {
        throw Exception('HTTP ошибка: ${response.statusCode}');
      }
    } catch (e) {
      session.log('Ошибка получения списка групп: $e');
      throw Exception('Не удалось получить список групп: $e');
    }
  }

  /// Получить список групп с фильтрацией по факультету
  Future<List<Map<String, dynamic>>> getGroupsByFaculty(Session session, String year, String faculty) async {
    try {
      final allGroups = await getGroupsList(session, year);
      
      // Фильтруем группы по факультету
      final filteredGroups = allGroups.where((group) => group['facul'] == faculty).toList();
      
      return filteredGroups;
    } catch (e) {
      session.log('Ошибка фильтрации групп по факультету: $e');
      throw Exception('Не удалось получить группы по факультету: $e');
    }
  }

  /// Получить список групп по курсу
  Future<List<Map<String, dynamic>>> getGroupsByCourse(Session session, String year, int course) async {
    try {
      final allGroups = await getGroupsList(session, year);
      
      // Фильтруем группы по курсу
      final filteredGroups = allGroups.where((group) => group['kurs'] == course).toList();
      
      return filteredGroups;
    } catch (e) {
      session.log('Ошибка фильтрации групп по курсу: $e');
      throw Exception('Не удалось получить группы по курсу: $e');
    }
  }

  /// Найти группу по ID
  Future<Map<String, dynamic>?> getGroupById(Session session, String year, int groupId) async {
    try {
      final allGroups = await getGroupsList(session, year);
      
      // Ищем группу по ID
      final group = allGroups.firstWhere(
        (group) => group['id'] == groupId,
        orElse: () => {},
      );
      
      return group.isNotEmpty ? group : null;
    } catch (e) {
      session.log('Ошибка поиска группы по ID: $e');
      throw Exception('Не удалось найти группу по ID: $e');
    }
  }

  /// Получить список уникальных факультетов
  Future<List<String>> getFaculties(Session session, String year) async {
    try {
      final allGroups = await getGroupsList(session, year);
      
      // Получаем уникальные факультеты
      final faculties = allGroups
          .map((group) => group['facul'] as String)
          .toSet()
          .toList();
      
      faculties.sort(); // Сортируем по алфавиту
      
      return faculties;
    } catch (e) {
      session.log('Ошибка получения списка факультетов: $e');
      throw Exception('Не удалось получить список факультетов: $e');
    }
  }

  /// Получить расписание для группы
  Future<Map<String, dynamic>> getScheduleForGroup(
    Session session,
    int groupId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      var url = '$baseUrl/Rasp?idGroup=$groupId';
      
      if (startDate != null) {
        final dateString = startDate.toIso8601String().split('T')[0];
        url += '&sdate=$dateString';
      }
      
      if (endDate != null) {
        final dateString = endDate.toIso8601String().split('T')[0];
        url += '&edate=$dateString';
      }
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData['state'] == 1 && jsonData['data'] != null) {
          return jsonData['data'];
        } else {
          throw Exception('Ошибка API: ${jsonData['msg']}');
        }
      } else {
        throw Exception('HTTP ошибка: ${response.statusCode}');
      }
    } catch (e) {
      session.log('Ошибка получения расписания: $e');
      throw Exception('Не удалось получить расписание: $e');
    }
  }

  /// Получить список занятий для группы (структурированный)
  Future<List<Map<String, dynamic>>> getClassesForGroup(
    Session session,
    int groupId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final scheduleData = await getScheduleForGroup(
        session,
        groupId,
        startDate: startDate,
        endDate: endDate,
      );
      
      if (scheduleData['rasp'] != null) {
        final classes = List<Map<String, dynamic>>.from(scheduleData['rasp']);
        
        // Сортируем по дате и времени
        classes.sort((a, b) {
          final dateA = DateTime.parse(a['датаНачала']);
          final dateB = DateTime.parse(b['датаНачала']);
          return dateA.compareTo(dateB);
        });
        
        return classes;
      }
      
      return [];
    } catch (e) {
      session.log('Ошибка получения списка занятий: $e');
      throw Exception('Не удалось получить список занятий: $e');
    }
  }

  /// Получить расписание для группы на конкретную дату
  Future<List<Map<String, dynamic>>> getScheduleForDate(
    Session session,
    int groupId,
    DateTime date,
  ) async {
    try {
      final classes = await getClassesForGroup(
        session,
        groupId,
        startDate: date,
        endDate: date,
      );
      
      // Фильтруем занятия по дате
      final targetDate = date.toIso8601String().split('T')[0];
      final classesForDate = classes.where((classItem) {
        final classDate = DateTime.parse(classItem['дата']).toIso8601String().split('T')[0];
        return classDate == targetDate;
      }).toList();
      
      return classesForDate;
    } catch (e) {
      session.log('Ошибка получения расписания на дату: $e');
      throw Exception('Не удалось получить расписание на дату: $e');
    }
  }

  /// Получить расписание для группы на неделю
  Future<Map<String, List<Map<String, dynamic>>>> getWeekSchedule(
    Session session,
    int groupId,
    DateTime weekStart,
  ) async {
    try {
      final weekEnd = weekStart.add(Duration(days: 6));
      final classes = await getClassesForGroup(
        session,
        groupId,
        startDate: weekStart,
        endDate: weekEnd,
      );
      
      // Группируем занятия по дням недели
      Map<String, List<Map<String, dynamic>>> weekSchedule = {
        'Понедельник': [],
        'Вторник': [],
        'Среда': [],
        'Четверг': [],
        'Пятница': [],
        'Суббота': [],
        'Воскресенье': [],
      };
      
      for (var classItem in classes) {
        final dayOfWeek = classItem['день_недели'] as String;
        if (weekSchedule.containsKey(dayOfWeek)) {
          weekSchedule[dayOfWeek]!.add(classItem);
        }
      }
      
      return weekSchedule;
    } catch (e) {
      session.log('Ошибка получения недельного расписания: $e');
      throw Exception('Не удалось получить недельное расписание: $e');
    }
  }

  /// Получить список предметов для группы
  Future<List<String>> getSubjectsForGroup(
    Session session,
    int groupId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final classes = await getClassesForGroup(
        session,
        groupId,
        startDate: startDate,
        endDate: endDate,
      );
      
      // Извлекаем уникальные дисциплины
      final subjects = classes
          .map((classItem) => classItem['дисциплина'] as String)
          .toSet()
          .toList();
      
      subjects.sort(); // Сортируем по алфавиту
      
      return subjects;
    } catch (e) {
      session.log('Ошибка получения списка предметов: $e');
      throw Exception('Не удалось получить список предметов: $e');
    }
  }

  /// Получить список преподавателей для группы
  Future<List<Map<String, dynamic>>> getTeachersForGroup(
    Session session,
    int groupId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final classes = await getClassesForGroup(
        session,
        groupId,
        startDate: startDate,
        endDate: endDate,
      );
      
      // Извлекаем уникальных преподавателей
      Map<int, Map<String, dynamic>> teachersMap = {};
      
      for (var classItem in classes) {
        final teacherId = classItem['кодПреподавателя'] as int;
        final teacherName = classItem['фиоПреподавателя'] as String;
        
        if (!teachersMap.containsKey(teacherId)) {
          teachersMap[teacherId] = {
            'id': teacherId,
            'name': teacherName,
            'subjects': <String>{},
          };
        }
        
        // Добавляем предмет к преподавателю
        (teachersMap[teacherId]!['subjects'] as Set<String>)
            .add(classItem['дисциплина'] as String);
      }
      
      // Преобразуем Set в List для subjects
      final teachers = teachersMap.values.map((teacher) {
        teacher['subjects'] = (teacher['subjects'] as Set<String>).toList();
        return teacher;
      }).toList();
      
      // Сортируем по имени
      teachers.sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));
      
      return teachers;
    } catch (e) {
      session.log('Ошибка получения списка преподавателей: $e');
      throw Exception('Не удалось получить список преподавателей: $e');
    }
  }

  /// Поиск занятий по преподавателю
  Future<List<Map<String, dynamic>>> getClassesByTeacher(
    Session session,
    int groupId,
    String teacherName, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final classes = await getClassesForGroup(
        session,
        groupId,
        startDate: startDate,
        endDate: endDate,
      );
      
      // Фильтруем по преподавателю
      final teacherClasses = classes.where((classItem) {
        final teacher = classItem['фиоПреподавателя'] as String;
        return teacher.toLowerCase().contains(teacherName.toLowerCase());
      }).toList();
      
      return teacherClasses;
    } catch (e) {
      session.log('Ошибка поиска занятий по преподавателю: $e');
      throw Exception('Не удалось найти занятия по преподавателю: $e');
    }
  }

  /// Поиск занятий по предмету
  Future<List<Map<String, dynamic>>> getClassesBySubject(
    Session session,
    int groupId,
    String subjectName, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final classes = await getClassesForGroup(
        session,
        groupId,
        startDate: startDate,
        endDate: endDate,
      );
      
      // Фильтруем по предмету
      final subjectClasses = classes.where((classItem) {
        final subject = classItem['дисциплина'] as String;
        return subject.toLowerCase().contains(subjectName.toLowerCase());
      }).toList();
      
      return subjectClasses;
    } catch (e) {
      session.log('Ошибка поиска занятий по предмету: $e');
      throw Exception('Не удалось найти занятия по предмету: $e');
    }
  }

  /// Получить список преподавателей для указанного года
  Future<List<Map<String, dynamic>>> getTeachersList(Session session, String year) async {
    try {
      final url = '$baseUrl/raspTeacherlist?year=$year';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData['state'] == 1 && jsonData['data'] != null) {
          final teachers = List<Map<String, dynamic>>.from(jsonData['data']);
          return teachers;
        } else {
          throw Exception('Ошибка API: ${jsonData['msg']}');
        }
      } else {
        throw Exception('HTTP ошибка: ${response.statusCode}');
      }
    } catch (e) {
      session.log('Ошибка получения списка преподавателей: $e');
      throw Exception('Не удалось получить список преподавателей: $e');
    }
  }

  /// Найти преподавателя по ID
  Future<Map<String, dynamic>?> getTeacherById(Session session, String year, int teacherId) async {
    try {
      final allTeachers = await getTeachersList(session, year);
      
      // Ищем преподавателя по ID
      final teacher = allTeachers.firstWhere(
        (teacher) => teacher['id'] == teacherId,
        orElse: () => {},
      );
      
      return teacher.isNotEmpty ? teacher : null;
    } catch (e) {
      session.log('Ошибка поиска преподавателя по ID: $e');
      throw Exception('Не удалось найти преподавателя по ID: $e');
    }
  }

  /// Поиск преподавателей по имени (частичное совпадение)
  Future<List<Map<String, dynamic>>> searchTeachersByName(Session session, String year, String searchQuery) async {
    try {
      final allTeachers = await getTeachersList(session, year);
      
      // Поиск преподавателей по имени (регистронезависимый)
      final foundTeachers = allTeachers.where((teacher) {
        final teacherName = (teacher['name'] as String).toLowerCase();
        return teacherName.contains(searchQuery.toLowerCase());
      }).toList();
      
      return foundTeachers;
    } catch (e) {
      session.log('Ошибка поиска преподавателей по имени: $e');
      throw Exception('Не удалось найти преподавателей по имени: $e');
    }
  }

  /// Получить список преподавателей по кафедре
  Future<List<Map<String, dynamic>>> getTeachersByDepartment(Session session, String year, String department) async {
    try {
      final allTeachers = await getTeachersList(session, year);
      
      // Фильтруем преподавателей по кафедре
      final departmentTeachers = allTeachers.where((teacher) {
        final teacherDept = teacher['kaf'] as String? ?? '';
        return teacherDept == department;
      }).toList();
      
      return departmentTeachers;
    } catch (e) {
      session.log('Ошибка фильтрации преподавателей по кафедре: $e');
      throw Exception('Не удалось получить преподавателей по кафедре: $e');
    }
  }

  /// Получить список уникальных кафедр
  Future<List<String>> getDepartments(Session session, String year) async {
    try {
      final allTeachers = await getTeachersList(session, year);
      
      // Получаем уникальные кафедры (исключая пустые значения)
      final departments = allTeachers
          .map((teacher) => teacher['kaf'] as String? ?? '')
          .where((dept) => dept.isNotEmpty)
          .toSet()
          .toList();
      
      departments.sort(); // Сортируем по алфавиту
      
      return departments;
    } catch (e) {
      session.log('Ошибка получения списка кафедр: $e');
      throw Exception('Не удалось получить список кафедр: $e');
    }
  }

  /// Получить расписание для преподавателя
  Future<Map<String, dynamic>> getScheduleForTeacher(
    Session session,
    int teacherId,
    String year, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      var url = '$baseUrl/Rasp?idTeacher=$teacherId&year=$year';
      
      if (startDate != null) {
        final dateString = startDate.toIso8601String().split('T')[0];
        url += '&sdate=$dateString';
      }
      
      if (endDate != null) {
        final dateString = endDate.toIso8601String().split('T')[0];
        url += '&edate=$dateString';
      }
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData['state'] == 1 && jsonData['data'] != null) {
          return jsonData['data'];
        } else {
          throw Exception('Ошибка API: ${jsonData['msg']}');
        }
      } else {
        throw Exception('HTTP ошибка: ${response.statusCode}');
      }
    } catch (e) {
      session.log('Ошибка получения расписания преподавателя: $e');
      throw Exception('Не удалось получить расписание преподавателя: $e');
    }
  }

  /// Получить список занятий для преподавателя (структурированный)
  Future<List<Map<String, dynamic>>> getClassesForTeacher(
    Session session,
    int teacherId,
    String year, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final scheduleData = await getScheduleForTeacher(
        session,
        teacherId,
        year,
        startDate: startDate,
        endDate: endDate,
      );
      
      if (scheduleData['rasp'] != null) {
        final classes = List<Map<String, dynamic>>.from(scheduleData['rasp']);
        
        // Сортируем по дате и времени
        classes.sort((a, b) {
          final dateA = DateTime.parse(a['датаНачала']);
          final dateB = DateTime.parse(b['датаНачала']);
          return dateA.compareTo(dateB);
        });
        
        return classes;
      }
      
      return [];
    } catch (e) {
      session.log('Ошибка получения списка занятий преподавателя: $e');
      throw Exception('Не удалось получить список занятий преподавателя: $e');
    }
  }
}