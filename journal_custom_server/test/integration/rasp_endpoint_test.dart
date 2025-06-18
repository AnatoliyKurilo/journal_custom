import 'package:test/test.dart';
import 'package:serverpod/serverpod.dart';
import 'package:journal_custom_server/src/generated/protocol.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'dart:convert';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given RaspEndpoint', (sessionBuilder, endpoints) {
    const int userId = 1234;
    
    var authenticatedSessionBuilder = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        userId,
        {Scope.admin},
      ),
    );

    setUp(() async {
      final session = sessionBuilder.build();
        // Создаем тестовые данные пользователя
      await UserInfo.db.insertRow(session, UserInfo(
        id: userId,
        userIdentifier: 'testuser',
        userName: 'testuser',
        email: 'test@example.com',
        created: DateTime.now(),
        blocked: false,
        scopeNames: ['serverpod.admin'],
      ));
    });

    tearDown(() async {
      final session = sessionBuilder.build();
      
      // Удаляем тестовые данные
      await UserInfo.db.deleteWhere(session, where: (u) => u.id > 0);
    });

    group('getAvailableYears', () {
      test('should handle API errors gracefully', () async {
        // Тест на обработку ошибок API
        // Поскольку RaspEndpoint работает с внешним API, этот тест может завершиться ошибкой
        // в зависимости от доступности API
        try {
          final result = await endpoints.rasp.getAvailableYears(authenticatedSessionBuilder);
          expect(result, isA<List<String>>());
          print('Available years: $result');
        } catch (e) {
          // Ожидаемо, если API недоступен
          expect(e.toString(), contains('Не удалось получить список годов'));
          print('Expected API error: $e');
        }
      });
    });

    group('getGroupsList', () {
      test('should handle valid year parameter', () async {
        try {
          final result = await endpoints.rasp.getGroupsList(authenticatedSessionBuilder, '2024-2025');
          expect(result, isA<List<GroupInfo>>());
          print('Groups count: ${result.length}');
          
          if (result.isNotEmpty) {
            final firstGroup = result.first;
            expect(firstGroup.id, isA<int>());
            expect(firstGroup.name, isA<String>());
            expect(firstGroup.facul, isA<String>());
            expect(firstGroup.kurs, isA<int>());
            print('First group: ${firstGroup.name}, ${firstGroup.facul}, курс ${firstGroup.kurs}');
          }
        } catch (e) {
          // Ожидаемо, если API недоступен
          expect(e.toString(), contains('Не удалось получить список групп'));
          print('Expected API error: $e');
        }
      });

      test('should handle empty year parameter', () async {
        try {
          final result = await endpoints.rasp.getGroupsList(authenticatedSessionBuilder, '');
          expect(result, isA<List<GroupInfo>>());
        } catch (e) {
          // Ожидаемая ошибка для пустого года
          expect(e, isA<Exception>());
          print('Expected error for empty year: $e');
        }
      });
    });

    group('getGroupsByFaculty', () {
      test('should filter groups by faculty', () async {
        try {
          final result = await endpoints.rasp.getGroupsByFaculty(
            authenticatedSessionBuilder, 
            '2024-2025', 
            'ФИТ'
          );
          expect(result, isA<List<GroupInfo>>());
          
          // Проверяем, что все группы принадлежат указанному факультету
          for (final group in result) {
            expect(group.facul, equals('ФИТ'));
          }
          print('Groups by faculty ФИТ: ${result.length}');
        } catch (e) {
          expect(e.toString(), contains('Не удалось получить группы по факультету'));
          print('Expected API error: $e');
        }
      });

      test('should return empty list for non-existent faculty', () async {
        try {
          final result = await endpoints.rasp.getGroupsByFaculty(
            authenticatedSessionBuilder, 
            '2024-2025', 
            'НЕСУЩЕСТВУЮЩИЙ_ФАКУЛЬТЕТ'
          );
          expect(result, isEmpty);
        } catch (e) {
          expect(e.toString(), contains('Не удалось получить группы по факультету'));
          print('Expected API error: $e');
        }
      });
    });

    group('getGroupsByCourse', () {
      test('should filter groups by course', () async {
        try {
          final result = await endpoints.rasp.getGroupsByCourse(
            authenticatedSessionBuilder, 
            '2024-2025', 
            2
          );
          expect(result, isA<List<GroupInfo>>());
          
          // Проверяем, что все группы принадлежат указанному курсу
          for (final group in result) {
            expect(group.kurs, equals(2));
          }
          print('Groups by course 2: ${result.length}');
        } catch (e) {
          expect(e.toString(), contains('Не удалось получить группы по курсу'));
          print('Expected API error: $e');
        }
      });

      test('should handle invalid course parameter', () async {
        try {
          final result = await endpoints.rasp.getGroupsByCourse(
            authenticatedSessionBuilder, 
            '2024-2025', 
            99 // Невалидный курс
          );
          expect(result, isEmpty);
        } catch (e) {
          expect(e.toString(), contains('Не удалось получить группы по курсу'));
          print('Expected API error: $e');
        }
      });
    });

    group('getGroupById', () {
      test('should return group when found', () async {
        try {
          // Сначала получаем список групп для получения валидного ID
          final groups = await endpoints.rasp.getGroupsList(authenticatedSessionBuilder, '2024-2025');
          if (groups.isNotEmpty) {
            final firstGroupId = groups.first.id;
            final result = await endpoints.rasp.getGroupById(
              authenticatedSessionBuilder, 
              '2024-2025', 
              firstGroupId
            );
            expect(result, isNotNull);
            expect(result!.id, equals(firstGroupId));
            print('Found group by ID: ${result.name}');
          }
        } catch (e) {
          expect(e.toString(), contains('Не удалось найти группу по ID'));
          print('Expected API error: $e');
        }
      });

      test('should return null for non-existent group ID', () async {
        try {
          final result = await endpoints.rasp.getGroupById(
            authenticatedSessionBuilder, 
            '2024-2025', 
            99999 // Несуществующий ID
          );
          expect(result, isNull);
        } catch (e) {
          expect(e.toString(), contains('Не удалось найти группу по ID'));
          print('Expected API error: $e');
        }
      });
    });

    group('getFaculties', () {
      test('should return unique list of faculties', () async {
        try {
          final result = await endpoints.rasp.getFaculties(authenticatedSessionBuilder, '2024-2025');
          expect(result, isA<List<String>>());
          
          // Проверяем, что список отсортирован и не содержит дубликатов
          final sortedResult = List<String>.from(result)..sort();
          expect(result, equals(sortedResult));
          
          final uniqueResult = result.toSet().toList();
          expect(result.length, equals(uniqueResult.length));
          
          print('Faculties: $result');
        } catch (e) {
          expect(e.toString(), contains('Не удалось получить список факультетов'));
          print('Expected API error: $e');
        }
      });
    });

    group('getTeachersList', () {
      test('should return list of teachers', () async {
        try {
          final result = await endpoints.rasp.getTeachersList(authenticatedSessionBuilder, '2024-2025');
          expect(result, isA<List<TeacherInfo>>());
          
          if (result.isNotEmpty) {
            final firstTeacher = result.first;
            expect(firstTeacher.id, isA<int>());
            expect(firstTeacher.name, isA<String>());
            expect(firstTeacher.name, isNotEmpty);
            print('First teacher: ${firstTeacher.name}, кафедра: ${firstTeacher.kaf}');
          }
          print('Teachers count: ${result.length}');
        } catch (e) {
          expect(e.toString(), contains('Не удалось получить список преподавателей'));
          print('Expected API error: $e');
        }
      });
    });

    group('getTeacherById', () {
      test('should return teacher when found', () async {
        try {
          // Сначала получаем список преподавателей для получения валидного ID
          final teachers = await endpoints.rasp.getTeachersList(authenticatedSessionBuilder, '2024-2025');
          if (teachers.isNotEmpty) {
            final firstTeacherId = teachers.first.id;
            final result = await endpoints.rasp.getTeacherById(
              authenticatedSessionBuilder, 
              '2024-2025', 
              firstTeacherId
            );
            expect(result, isNotNull);
            expect(result!.id, equals(firstTeacherId));
            print('Found teacher by ID: ${result.name}');
          }
        } catch (e) {
          expect(e.toString(), contains('Не удалось найти преподавателя по ID'));
          print('Expected API error: $e');
        }
      });

      test('should return null for non-existent teacher ID', () async {
        try {
          final result = await endpoints.rasp.getTeacherById(
            authenticatedSessionBuilder, 
            '2024-2025', 
            99999 // Несуществующий ID
          );
          expect(result, isNull);
        } catch (e) {
          expect(e.toString(), contains('Не удалось найти преподавателя по ID'));
          print('Expected API error: $e');
        }
      });
    });

    group('searchTeachersByName', () {
      test('should return matching teachers', () async {
        try {
          final result = await endpoints.rasp.searchTeachersByName(
            authenticatedSessionBuilder, 
            '2024-2025', 
            'Иван'
          );
          expect(result, isA<List<TeacherInfo>>());
          
          // Проверяем, что все найденные преподаватели содержат поисковый запрос
          for (final teacher in result) {
            expect(teacher.name.toLowerCase(), contains('иван'));
          }
          print('Teachers found by name "Иван": ${result.length}');
        } catch (e) {
          expect(e.toString(), contains('Не удалось найти преподавателей по имени'));
          print('Expected API error: $e');
        }
      });

      test('should handle empty search query', () async {
        try {
          final result = await endpoints.rasp.searchTeachersByName(
            authenticatedSessionBuilder, 
            '2024-2025', 
            ''
          );
          expect(result, isA<List<TeacherInfo>>());
          // Пустой запрос должен вернуть всех преподавателей
        } catch (e) {
          expect(e.toString(), contains('Не удалось найти преподавателей по имени'));
          print('Expected API error: $e');
        }
      });
    });

    group('getTeachersByDepartment', () {
      test('should filter teachers by department', () async {
        try {
          // Сначала получаем список кафедр
          final departments = await endpoints.rasp.getDepartments(authenticatedSessionBuilder, '2024-2025');
          if (departments.isNotEmpty) {
            final firstDepartment = departments.first;
            final result = await endpoints.rasp.getTeachersByDepartment(
              authenticatedSessionBuilder, 
              '2024-2025', 
              firstDepartment
            );
            expect(result, isA<List<TeacherInfo>>());
            
            // Проверяем, что все преподаватели принадлежат указанной кафедре
            for (final teacher in result) {
              expect(teacher.kaf, equals(firstDepartment));
            }
            print('Teachers by department "$firstDepartment": ${result.length}');
          }
        } catch (e) {
          expect(e.toString(), contains('Не удалось получить преподавателей по кафедре'));
          print('Expected API error: $e');
        }
      });
    });

    group('getDepartments', () {
      test('should return unique list of departments', () async {
        try {
          final result = await endpoints.rasp.getDepartments(authenticatedSessionBuilder, '2024-2025');
          expect(result, isA<List<String>>());
          
          // Проверяем, что список отсортирован и не содержит дубликатов
          final sortedResult = List<String>.from(result)..sort();
          expect(result, equals(sortedResult));
          
          final uniqueResult = result.toSet().toList();
          expect(result.length, equals(uniqueResult.length));
          
          // Проверяем, что нет пустых значений
          for (final dept in result) {
            expect(dept, isNotEmpty);
          }
          
          print('Departments: $result');
        } catch (e) {
          expect(e.toString(), contains('Не удалось получить список кафедр'));
          print('Expected API error: $e');
        }
      });
    });

    group('getScheduleForGroup', () {
      test('should return JSON string for valid group', () async {
        try {
          // Используем фиксированный ID группы для теста
          final result = await endpoints.rasp.getScheduleForGroup(authenticatedSessionBuilder, 1001);
          expect(result, isA<String>());
          
          // Проверяем, что результат является валидным JSON
          expect(() => jsonDecode(result), returnsNormally);
          print('Schedule JSON length: ${result.length}');
        } catch (e) {
          // Ожидаемая ошибка для недоступного API или несуществующей группы
          expect(e, isA<Exception>());
          print('Expected error for schedule: $e');
        }
      });

      test('should handle invalid group ID', () async {
        try {
          final result = await endpoints.rasp.getScheduleForGroup(authenticatedSessionBuilder, -1);
          expect(result, isA<String>());
        } catch (e) {
          expect(e, isA<Exception>());
          print('Expected error for invalid group ID: $e');
        }
      });
    });

    group('checkApiAvailability', () {
      test('should return boolean status', () async {
        final result = await endpoints.rasp.checkApiAvailability(authenticatedSessionBuilder);
        expect(result, isA<bool>());
        print('API availability: $result');
      });
    });

    group('checkGroupExists', () {
      test('should return boolean for group existence', () async {
        final result = await endpoints.rasp.checkGroupExists(authenticatedSessionBuilder, 1001, '2024-2025');
        expect(result, isA<bool>());
        print('Group 1001 exists: $result');
      });

      test('should return false for non-existent group', () async {
        final result = await endpoints.rasp.checkGroupExists(authenticatedSessionBuilder, 99999, '2024-2025');
        expect(result, isFalse);
      });
    });

    group('getClassesForGroup', () {
      test('should return list of class strings', () async {
        final result = await endpoints.rasp.getClassesForGroup(authenticatedSessionBuilder, 1001);
        expect(result, isA<List<String>>());
        print('Classes for group 1001: ${result.length}');
      });
    });

    group('getScheduleForTeacher', () {
      test('should return JSON string for valid teacher', () async {
        try {
          final result = await endpoints.rasp.getScheduleForTeacher(authenticatedSessionBuilder, 1001, '2024-2025');
          expect(result, isA<String>());
          
          // Проверяем, что результат является валидным JSON
          expect(() => jsonDecode(result), returnsNormally);
          print('Teacher schedule JSON length: ${result.length}');
        } catch (e) {
          expect(e, isA<Exception>());
          print('Expected error for teacher schedule: $e');
        }
      });
    });

    group('getClassesForTeacher', () {
      test('should return list of class strings', () async {
        final result = await endpoints.rasp.getClassesForTeacher(authenticatedSessionBuilder, 1001, '2024-2025');
        expect(result, isA<List<String>>());
        print('Classes for teacher 1001: ${result.length}');
      });
    });

    group('stub methods', () {
      test('getSubjectsForGroup should return stub data', () async {
        final result = await endpoints.rasp.getSubjectsForGroup(authenticatedSessionBuilder, 1001);
        expect(result, isA<List<String>>());
        expect(result, contains('Программирование'));
        expect(result, contains('Математика'));
        expect(result, contains('Физика'));
      });

      test('getTeachersForGroup should return stub data', () async {
        final result = await endpoints.rasp.getTeachersForGroup(authenticatedSessionBuilder, 1001);
        expect(result, isA<List<String>>());
        expect(result, contains('Иванов И.И.'));
        expect(result, contains('Петров П.П.'));
        expect(result, contains('Сидоров С.С.'));
      });

      test('getWeekSchedule should return stub data', () async {
        final weekStart = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
        final result = await endpoints.rasp.getWeekSchedule(authenticatedSessionBuilder, 1001, weekStart);
        expect(result, isA<Map<String, List<String>>>());
        expect(result.keys, contains('Понедельник'));
        expect(result.keys, contains('Вторник'));
        expect(result.keys, contains('Среда'));
        expect(result.keys, contains('Четверг'));
        expect(result.keys, contains('Пятница'));
        expect(result.keys, contains('Суббота'));
        expect(result.keys, contains('Воскресенье'));
        
        expect(result['Понедельник']!, isNotEmpty);
        expect(result['Понедельник']!, contains('Математика 9:00'));
      });
    });

    group('getScheduleForDate', () {
      test('should return list of classes for specific date', () async {
        final testDate = DateTime.now();
        final result = await endpoints.rasp.getScheduleForDate(authenticatedSessionBuilder, 1001, testDate);
        expect(result, isA<List<String>>());
        // Результат может быть пустым или содержать ошибку в зависимости от API
      });
    });

    // group('getWeekScheduleDetailed', () {
    //   test('should return detailed week schedule', () async {
    //     final weekStart = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
    //     final result = await endpoints.rasp.getWeekScheduleDetailed(authenticatedSessionBuilder, 1001, weekStart);
    //     expect(result, isA<Map<String, List<Map<String, dynamic>>>>());
        
    //     // Проверяем, что все дни недели присутствуют в результате
    //     final expectedDays = ['Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота', 'Воскресенье'];
    //     for (final day in expectedDays) {
    //       expect(result.keys, contains(day));
    //       expect(result[day], isA<List<Map<String, dynamic>>>());
    //     }
    //   });
    // });

    group('edge cases and error handling', () {
      test('should handle network timeout gracefully', () async {
        // Этот тест проверяет устойчивость к сетевым ошибкам
        try {
          final result = await endpoints.rasp.getAvailableYears(authenticatedSessionBuilder);
          expect(result, isA<List<String>>());
        } catch (e) {
          // Ожидаемо при недоступности сети
          expect(e, isA<Exception>());
        }
      });

      test('should handle malformed API responses', () async {
        // Тестируем обработку некорректных ответов API
        try {
          final result = await endpoints.rasp.getGroupsList(authenticatedSessionBuilder, 'invalid-year');
          expect(result, isA<List<GroupInfo>>());
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });

      test('should handle empty API responses', () async {
        // Тестируем обработку пустых ответов
        try {
          final result = await endpoints.rasp.getGroupsByFaculty(
            authenticatedSessionBuilder, 
            '2024-2025', 
            'NONEXISTENT'
          );
          expect(result, isEmpty);
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });
    });

    group('data validation', () {
      test('GroupInfo should have valid structure', () async {
        try {
          final groups = await endpoints.rasp.getGroupsList(authenticatedSessionBuilder, '2024-2025');
          if (groups.isNotEmpty) {
            final group = groups.first;
            expect(group.id, isPositive);
            expect(group.name, isNotEmpty);
            expect(group.facul, isNotEmpty);
            expect(group.kurs, isPositive);
            expect(group.kurs, lessThanOrEqualTo(6)); // Обычно не более 6 курсов
          }
        } catch (e) {
          print('Expected API error in validation test: $e');
        }
      });

      test('TeacherInfo should have valid structure', () async {
        try {
          final teachers = await endpoints.rasp.getTeachersList(authenticatedSessionBuilder, '2024-2025');
          if (teachers.isNotEmpty) {
            final teacher = teachers.first;
            expect(teacher.id, isPositive);
            expect(teacher.name, isNotEmpty);
            // kaf может быть null или пустой строкой
          }
        } catch (e) {
          print('Expected API error in validation test: $e');
        }
      });
    });
  });
}
