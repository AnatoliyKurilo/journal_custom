import 'package:serverpod/serverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../generated/protocol.dart'; // Важно: импортируем сгенерированные модели

class RaspEndpoint extends Endpoint {
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

  /// Получить список групп для указанного года (ИСПРАВЛЕНО)
  Future<List<GroupInfo>> getGroupsList(Session session, String year) async {
    try {
      final url = '$baseUrl/raspGrouplist?year=$year';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData['state'] == 1 && jsonData['data'] != null) {
          final groups = List<Map<String, dynamic>>.from(jsonData['data']);
          
          // Преобразуем в GroupInfo объекты
          final groupInfoList = groups.map((group) {
            return GroupInfo(
              id: group['id'] as int,
              name: group['name'] as String,
              facul: group['facul'] as String,
              kurs: group['kurs'] as int,
              spec: group['spec'] as String?,
            );
          }).toList();
          
          session.log('Получено ${groupInfoList.length} групп для года $year');
          return groupInfoList;
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

  /// Получить список групп с фильтрацией по факультету (ИСПРАВЛЕНО)
  Future<List<GroupInfo>> getGroupsByFaculty(Session session, String year, String faculty) async {
    try {
      final allGroups = await getGroupsList(session, year);
      
      // Фильтруем группы по факультету
      final filteredGroups = allGroups.where((group) => group.facul == faculty).toList();
      
      return filteredGroups;
    } catch (e) {
      session.log('Ошибка фильтрации групп по факультету: $e');
      throw Exception('Не удалось получить группы по факультету: $e');
    }
  }

  /// Получить список групп по курсу (ИСПРАВЛЕНО)
  Future<List<GroupInfo>> getGroupsByCourse(Session session, String year, int course) async {
    try {
      final allGroups = await getGroupsList(session, year);
      
      // Фильтруем группы по курсу
      final filteredGroups = allGroups.where((group) => group.kurs == course).toList();
      
      return filteredGroups;
    } catch (e) {
      session.log('Ошибка фильтрации групп по курсу: $e');
      throw Exception('Не удалось получить группы по курсу: $e');
    }
  }

  /// Найти группу по ID (ИСПРАВЛЕНО)
  Future<GroupInfo?> getGroupById(Session session, String year, int groupId) async {
    try {
      final allGroups = await getGroupsList(session, year);
      
      // Ищем группу по ID
      final group = allGroups.where((group) => group.id == groupId).firstOrNull;
      
      return group;
    } catch (e) {
      session.log('Ошибка поиска группы по ID: $e');
      throw Exception('Не удалось найти группу по ID: $e');
    }
  }

  /// Получить список уникальных факультетов (ИСПРАВЛЕНО)
  Future<List<String>> getFaculties(Session session, String year) async {
    try {
      final allGroups = await getGroupsList(session, year);
      
      // Получаем уникальные факультеты
      final faculties = allGroups
          .map((group) => group.facul)
          .toSet()
          .toList();
      
      faculties.sort(); // Сортируем по алфавиту
      
      return faculties;
    } catch (e) {
      session.log('Ошибка получения списка факультетов: $e');
      throw Exception('Не удалось получить список факультетов: $e');
    }
  }

  /// Получить список преподавателей для указанного года (ИСПРАВЛЕНО)
  Future<List<TeacherInfo>> getTeachersList(Session session, String year) async {
    try {
      final url = '$baseUrl/raspTeacherlist?year=$year';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData['state'] == 1 && jsonData['data'] != null) {
          final teachers = List<Map<String, dynamic>>.from(jsonData['data']);
          
          // Преобразуем в TeacherInfo объекты
          final teacherInfoList = teachers.map((teacher) {
            return TeacherInfo(
              id: teacher['id'] as int,
              name: teacher['name'] as String,
              kaf: teacher['kaf'] as String?,
            );
          }).toList();
          
          session.log('Получено ${teacherInfoList.length} преподавателей для года $year');
          return teacherInfoList;
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

  /// Найти преподавателя по ID (ИСПРАВЛЕНО)
  Future<TeacherInfo?> getTeacherById(Session session, String year, int teacherId) async {
    try {
      final allTeachers = await getTeachersList(session, year);
      
      // Ищем преподавателя по ID
      final teacher = allTeachers.where((teacher) => teacher.id == teacherId).firstOrNull;
      
      return teacher;
    } catch (e) {
      session.log('Ошибка поиска преподавателя по ID: $e');
      throw Exception('Не удалось найти преподавателя по ID: $e');
    }
  }

  /// Поиск преподавателей по имени (ИСПРАВЛЕНО)
  Future<List<TeacherInfo>> searchTeachersByName(Session session, String year, String searchQuery) async {
    try {
      final allTeachers = await getTeachersList(session, year);
      
      // Поиск преподавателей по имени (регистронезависимый)
      final foundTeachers = allTeachers.where((teacher) {
        return teacher.name.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
      
      return foundTeachers;
    } catch (e) {
      session.log('Ошибка поиска преподавателей по имени: $e');
      throw Exception('Не удалось найти преподавателей по имени: $e');
    }
  }

  /// Получить список преподавателей по кафедре (ИСПРАВЛЕНО)
  Future<List<TeacherInfo>> getTeachersByDepartment(Session session, String year, String department) async {
    try {
      final allTeachers = await getTeachersList(session, year);
      
      // Фильтруем преподавателей по кафедре
      final departmentTeachers = allTeachers.where((teacher) {
        return teacher.kaf == department;
      }).toList();
      
      return departmentTeachers;
    } catch (e) {
      session.log('Ошибка фильтрации преподавателей по кафедре: $e');
      throw Exception('Не удалось получить преподавателей по кафедре: $e');
    }
  }

  /// Получить список уникальных кафедр (ИСПРАВЛЕНО)
  Future<List<String>> getDepartments(Session session, String year) async {
    try {
      final allTeachers = await getTeachersList(session, year);
      
      // Получаем уникальные кафедры (исключая пустые значения)
      final departments = allTeachers
          .map((teacher) => teacher.kaf ?? '')
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

  // Остальные методы возвращают JSON как строку для простоты
  /// Получить расписание для группы (JSON как строка) с улучшенной диагностикой
  Future<String> getScheduleForGroup(Session session, int groupId) async {
    try {
      final url = '$baseUrl/Rasp?idGroup=$groupId';
      session.log('Запрос к API расписания: $url');
      
      final response = await http.get(Uri.parse(url));
      
      session.log('Ответ API: статус=${response.statusCode}');
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        session.log('Структура ответа API: ${jsonData.keys.toList()}');
        session.log('Статус API: state=${jsonData['state']}, msg=${jsonData['msg']}');
        
        if (jsonData['state'] == 1 && jsonData['data'] != null) {
          final data = jsonData['data'];
          session.log('Тип данных: ${data.runtimeType}');
          
          if (data is Map) {
            session.log('Ключи в data: ${(data as Map).keys.toList()}');
            final rasp = data['rasp'];
            if (rasp != null) {
              session.log('Тип rasp: ${rasp.runtimeType}');
              if (rasp is List) {
                session.log('Количество элементов в rasp: ${rasp.length}');
              }
            } else {
              session.log('Поле "rasp" отсутствует или равно null');
            }
          }
          
          return json.encode(jsonData['data']);
        } else {
          final errorMsg = jsonData['msg'] ?? 'Неизвестная ошибка API';
          session.log('API вернул ошибку: state=${jsonData['state']}, msg=$errorMsg');
          throw Exception('Ошибка API расписания: $errorMsg');
        }
      } else {
        session.log('HTTP ошибка: ${response.statusCode}, тело: ${response.body}');
        throw Exception('HTTP ошибка: ${response.statusCode}');
      }
    } catch (e) {
      session.log('Исключение при получении расписания: $e');
      rethrow;
    }
  }

  /// Проверить доступность API
  Future<bool> checkApiAvailability(Session session) async {
    try {
      final url = '$baseUrl/Rasp/ListYears';
      session.log('Проверка доступности API: $url');
      
      final response = await http.get(Uri.parse(url));
      session.log('Проверка API: статус=${response.statusCode}');
      
      return response.statusCode == 200;
    } catch (e) {
      session.log('API недоступен: $e');
      return false;
    }
  }

  /// Проверить существование группы в API
  Future<bool> checkGroupExists(Session session, int groupId, String year) async {
    try {
      final groups = await getGroupsList(session, year);
      final groupExists = groups.any((group) => group.id == groupId);
      session.log('Группа $groupId ${groupExists ? 'найдена' : 'не найдена'} в API для года $year');
      return groupExists;
    } catch (e) {
      session.log('Ошибка проверки существования группы: $e');
      return false;
    }
  }

  /// Получить список занятий для группы (упрощенно как строки)
  Future<List<String>> getClassesForGroup(Session session, int groupId) async {
    try {
      final scheduleJson = await getScheduleForGroup(session, groupId);
      final scheduleData = json.decode(scheduleJson);
      
      if (scheduleData['rasp'] != null) {
        final classes = List<Map<String, dynamic>>.from(scheduleData['rasp']);
        return classes.map((c) => '${c['дисциплина']} - ${c['фиоПреподавателя']}').toList();
      }
      
      return [];
    } catch (e) {
      session.log('Ошибка получения списка занятий: $e');
      return [];
    }
  }

  /// Получить расписание для преподавателя (JSON как строка)
  Future<String> getScheduleForTeacher(Session session, int teacherId, String year) async {
    try {
      final url = '$baseUrl/Rasp?idTeacher=$teacherId&year=$year';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData['state'] == 1 && jsonData['data'] != null) {
          return json.encode(jsonData['data']);
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

  /// Получить список занятий для преподавателя (упрощенно как строки)
  Future<List<String>> getClassesForTeacher(Session session, int teacherId, String year) async {
    try {
      final scheduleJson = await getScheduleForTeacher(session, teacherId, year);
      final scheduleData = json.decode(scheduleJson);
      
      if (scheduleData['rasp'] != null) {
        final classes = List<Map<String, dynamic>>.from(scheduleData['rasp']);
        return classes.map((c) => '${c['дисциплина']} - группа ${c['группа'] ?? 'не указана'}').toList();
      }
      
      return [];
    } catch (e) {
      session.log('Ошибка получения списка занятий преподавателя: $e');
      return [];
    }
  }

  // Заглушки для остальных методов
  Future<List<String>> getSubjectsForGroup(Session session, int groupId) async {
    return ['Программирование', 'Математика', 'Физика'];
  }

  Future<List<String>> getTeachersForGroup(Session session, int groupId) async {
    return ['Иванов И.И.', 'Петров П.П.', 'Сидоров С.С.'];
  }

  Future<Map<String, List<String>>> getWeekSchedule(Session session, int groupId, DateTime weekStart) async {
    return {
      'Понедельник': ['Математика 9:00', 'Физика 10:40'],
      'Вторник': ['Программирование 9:00'],
      'Среда': ['История 9:00', 'Английский 10:40'],
      'Четверг': ['Программирование 9:00', 'Математика 10:40'],
      'Пятница': ['Физика 9:00'],
      'Суббота': [],
      'Воскресенье': [],
    };
  }

  /// Получить расписание на конкретную дату (улучшенная версия)
  Future<List<String>> getScheduleForDate(Session session, int groupId, DateTime date) async {
    try {
      // Получаем полное расписание группы
      final scheduleJson = await getScheduleForGroup(session, groupId);
      final scheduleData = json.decode(scheduleJson);
      
      if (scheduleData['rasp'] == null) {
        return [];
      }
      
      final allClasses = List<Map<String, dynamic>>.from(scheduleData['rasp']);
      final targetDateStr = DateFormat('dd.MM.yyyy').format(date);
      
      // Фильтруем занятия по дате
      final classesForDate = allClasses.where((classInfo) {
        final classDateStr = classInfo['дата']?.toString() ?? '';
        return classDateStr == targetDateStr;
      }).toList();
      
      // Форматируем для отображения
      return classesForDate.map((classInfo) {
        final subject = classInfo['дисциплина']?.toString() ?? 'Неизвестный предмет';
        final teacher = classInfo['фиоПреподавателя']?.toString() ?? 'Преподаватель не указан';
        final time = classInfo['время']?.toString() ?? '';
        final type = classInfo['видЗанятия']?.toString() ?? 'Занятие';
        
        return '$time - $subject ($type) - $teacher';
      }).toList();
      
    } catch (e) {
      session.log('Ошибка получения расписания на дату: $e');
      return ['Ошибка: $e'];
    }
  }

  /// Получить занятия на неделю с конкретными датами
  Future<Map<String, List<Map<String, dynamic>>>> getWeekScheduleDetailed(
    Session session, 
    int groupId, 
    DateTime weekStart
  ) async {
    try {
      final scheduleJson = await getScheduleForGroup(session, groupId);
      final scheduleData = json.decode(scheduleJson);
      
      if (scheduleData['rasp'] == null) {
        return {};
      }
      
      final allClasses = List<Map<String, dynamic>>.from(scheduleData['rasp']);
      Map<String, List<Map<String, dynamic>>> weekSchedule = {};
      
      // Инициализируем дни недели
      final weekDays = ['Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота', 'Воскресенье'];
      for (var day in weekDays) {
        weekSchedule[day] = [];
      }
      
      // Группируем занятия по дням недели
      for (var classInfo in allClasses) {
        final classDateStr = classInfo['дата']?.toString() ?? '';
        if (classDateStr.isNotEmpty) {
          try {
            final classDate = DateFormat('dd.MM.yyyy').parse(classDateStr);
            if (classDate.isAfter(weekStart.subtract(const Duration(days: 1))) &&
                classDate.isBefore(weekStart.add(const Duration(days: 7)))) {
              
              final dayName = DateFormat('EEEE', 'ru').format(classDate);
              final dayKey = weekDays.firstWhere(
                (day) => day.toLowerCase().startsWith(dayName.toLowerCase()),
                orElse: () => 'Понедельник',
              );
              
              weekSchedule[dayKey]?.add(classInfo);
            }
          } catch (e) {
            session.log('Ошибка парсинга даты: $classDateStr');
          }
        }
      }
      
      return weekSchedule;
      
    } catch (e) {
      session.log('Ошибка получения недельного расписания: $e');
      return {};
    }
  }
}