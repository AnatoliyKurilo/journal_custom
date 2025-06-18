// import 'package:flutter_test/flutter_test.dart';
import 'package:journal_custom_server/src/custom_scope.dart';
import 'package:serverpod/serverpod.dart';
import 'package:journal_custom_server/src/endpoints/class_types_endpoint.dart';
import 'package:journal_custom_server/src/generated/protocol.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {

  withServerpod('Given ClassesEndpoint', (sessionBuilder, endpoints) {
    // Пример теста для метода searchStudents (если такой существует в вашем SearchEndpoint)
    // Замените 'searchStudents' и параметры на реальные методы вашего эндпоинта
    var session = sessionBuilder.build();
    const int userId = 1234;
    const int GHid = 12;
    const int studentId = 5678; // Добавляем отдельный ID для студента

    var authenticatedSessionBuilder = sessionBuilder.copyWith(
      authentication:
          AuthenticationOverride.authenticationInfo(userId, 
          { 
            Scope.admin,
            CustomScope.teacher,
            CustomScope.documentSpecialist
          }
          ),
    );

    setUp(() async {
      final session = sessionBuilder.build();

      // Создаем пользователя с правами администратора
      List<String> adminScopeNames = [
        Scope.admin.name!,
        CustomScope.teacher.name!,
        CustomScope.documentSpecialist.name!
      ];
      await UserInfo.db.insertRow(session, UserInfo(
          id: userId,
          userIdentifier: 'user_$userId', 
          created: DateTime.now(), 
          scopeNames: adminScopeNames, 
          blocked: false));

      // Создаем пользователя с правами старосты группы
      List<String> groupHeadScopeNames = [
        CustomScope.groupHead.name!,
        CustomScope.teacher.name! // Добавляем права преподавателя для создания занятий
      ];
      await UserInfo.db.insertRow(session, UserInfo(
          id: GHid,
          userIdentifier: 'user_$GHid', 
          created: DateTime.now(), 
          scopeNames: groupHeadScopeNames, 
          blocked: false));

      // Создаем пользователя-студента (только права студента)
      List<String> studentScopeNames = [
        CustomScope.student.name!
      ];
      await UserInfo.db.insertRow(session, UserInfo(
          id: studentId,
          userIdentifier: 'student_$studentId', 
          created: DateTime.now(), 
          scopeNames: studentScopeNames, 
          blocked: false));
      
      // Создаем тестовые данные
      var group = Groups(id: 1, name: 'Группа 1');
      await Groups.db.insertRow(session, group);

      var subgroup = Subgroups(id: 1, name: 'Подгруппа 1', groupsId: group.id!);
      await Subgroups.db.insertRow(session, subgroup);

      var subject = Subjects(id: 1, name: 'Математика');
      await Subjects.db.insertRow(session, subject);

      var studentPerson = Person(
        userInfoId: GHid, 
        id: 9, 
        firstName: 'Петр', 
        lastName: 'Петров', 
        email: 'jyxfjk');
      await Person.db.insertRow(session, studentPerson);

      var student = Students(
        id: 1, 
        personId: studentPerson.id!, 
        groupsId: group.id!,
        isGroupHead: true);
      await Students.db.insertRow(session, student);

      // Создаем студента (не староста)
      var regularStudentPerson = Person(
        userInfoId: studentId, 
        id: 10, 
        firstName: 'Анна', 
        lastName: 'Студентова', 
        email: 'anna.student@example.com');
      await Person.db.insertRow(session, regularStudentPerson);

      var regularStudent = Students(
        id: 2, 
        personId: regularStudentPerson.id!, 
        groupsId: group.id!,
        isGroupHead: false);
      await Students.db.insertRow(session, regularStudent);

      var teacherPerson = Person(userInfoId: userId, id: 2, firstName: 'Иван', lastName: 'Иванов', email: 'ivan.ivanov@example.com');
      await Person.db.insertRow(session, teacherPerson);

      var teacher = Teachers(id: 1, personId: teacherPerson.id!);
      await Teachers.db.insertRow(session, teacher);

      var semester = Semesters(id: 1, name: 'Осенний семестр', startDate: DateTime(2023, 9, 1), endDate: DateTime(2024, 1, 31), year: 2023);
      await Semesters.db.insertRow(session, semester);

      var classType = ClassTypes(id: 1, name: 'Лекция');
      await ClassTypes.db.insertRow(session, classType);

      var classSession = Classes(
        id: 1,
        subjectsId: subject.id!,
        class_typesId: classType.id!,
        teachersId: teacher.id!,
        semestersId: semester.id!,
        subgroupsId: subgroup.id!,
        date: DateTime(2023, 9, 15),
      );
      await Classes.db.insertRow(session, classSession);
    });

    tearDown(() async {
      final session = sessionBuilder.build();

      await Students.db.deleteWhere(session, where: (s) => s.id > 0);
      await Classes.db.deleteWhere(session, where: (c) => c.id > 0);
      await Subgroups.db.deleteWhere(session, where: (s) => s.id > 0);
      await Groups.db.deleteWhere(session, where: (g) => g.id > 0);
      await Subjects.db.deleteWhere(session, where: (s) => s.id > 0);
      await Teachers.db.deleteWhere(session, where: (t) => t.id > 0);
      await Person.db.deleteWhere(session, where: (p) => p.id > 0);
      await Semesters.db.deleteWhere(session, where: (s) => s.id > 0);
      await ClassTypes.db.deleteWhere(session, where: (ct) => ct.id > 0);
      await UserInfo.db.deleteWhere(session, where: (u) => u.id > 0);
    });

    group('getSubjectsWithClasses', () {
      test('returns subjects with classes', () async {
        final result = await endpoints.classes
        .getSubjectsWithClasses(authenticatedSessionBuilder);

        expect(result, isNotEmpty);
        expect(result.any((subject) => subject.name == 'Математика'), isTrue);
      });
    });

    group('getClassesBySubject', () {
      test('returns classes for existing subject', () async {
        final result = await endpoints.classes
        .getClassesBySubject(authenticatedSessionBuilder, subjectId: 1);

        expect(result, isNotEmpty);
        expect(result.any((classSession) => classSession.subjectsId == 1), isTrue);
      });

      test('returns empty for non-existing subject', () async {
        final result = await endpoints.classes
        .getClassesBySubject(authenticatedSessionBuilder, subjectId: -1);

        expect(result, isEmpty);
      });
    });

    group('createClass', () {
      test('creates a new class', () async {
        final newClass = await endpoints.classes.createClass(
          authenticatedSessionBuilder,
          subjectsId: 1,
          classTypesId: 1,
          teachersId: 1,
          semestersId: 1,
          subgroupsId: 1,
          date: DateTime(2023, 9, 15),
          topic: 'Тема занятия',
          notes: 'Примечания',
        );

        expect(newClass, isNotNull);
        expect(newClass.subjectsId, equals(1));
        expect(newClass.topic, equals('Тема занятия'));
      });

      test('group head can create class', () async {
        // Исправленная сессия для старосты группы с правами преподавателя
        var groupHeadSession = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            GHid, 
            { 
              CustomScope.groupHead, 
              CustomScope.teacher, // Важно: права преподавателя для создания занятий
            }
          ),
        );

        final newClass = await endpoints.classes.createClass(
          groupHeadSession,
          subjectsId: 1,
          classTypesId: 1,
          teachersId: 1,
          semestersId: 1,
          subgroupsId: 1,
          date: DateTime(2023, 9, 16),
          topic: 'Тема занятия от старосты',
          notes: 'Примечания от старосты',
        );

        expect(newClass, isNotNull);
        expect(newClass.subjectsId, equals(1));
        expect(newClass.topic, equals('Тема занятия от старосты'));
      });

      test('throws exception for invalid subgroup', () async {
        Future<void> action() async {
          await endpoints.classes.createClass(
            authenticatedSessionBuilder,
            subjectsId: 1,
            classTypesId: 1,
            teachersId: 1,
            semestersId: 1,
            subgroupsId: -1, // Несуществующий ID подгруппы
            date: DateTime.now(),
          );
        }
        await expectLater(action, throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Подгруппа с ID "-1" не найдена.'),
        )));
      });

      test('throws exception for unauthorized user (student only)', () async {
        // Используем отдельного пользователя-студента
        var studentOnlySession = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            studentId, // Используем ID студента, а не админа
            {CustomScope.student}, // Только роль студента
          ),
        );

        Future<void> action() async {
          await endpoints.classes.createClass(
            studentOnlySession,
            subjectsId: 1,
            classTypesId: 1,
            teachersId: 1,
            semestersId: 1,
            subgroupsId: 1,
            date: DateTime.now(),
          );
        }

        await expectLater(action, throwsA(isA<Exception>()));
      });

      test('throws exception for invalid teacher ID', () async {
        Future<void> action() async {
          await endpoints.classes.createClass(
            authenticatedSessionBuilder,
            subjectsId: 1,
            classTypesId: 1,
            teachersId: -1, // Некорректный ID преподавателя
            semestersId: 1,
            subgroupsId: 1,
            date: DateTime.now(),
          );
        }

        await expectLater(action, throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Преподаватель с ID "-1" не найден.'),
        )));
      });

      test('throws exception for invalid subject ID', () async {
        Future<void> action() async {
          await endpoints.classes.createClass(
            authenticatedSessionBuilder,
            subjectsId: -1, // Некорректный ID предмета
            classTypesId: 1,
            teachersId: 1,
            semestersId: 1,
            subgroupsId: 1,
            date: DateTime.now(),
          );
        }

        await expectLater(action, throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Предмет с ID "-1" не найден.'),
        )));
      });

      test('throws exception for invalid semester ID', () async {
        Future<void> action() async {
          await endpoints.classes.createClass(
            authenticatedSessionBuilder,
            subjectsId: 1,
            classTypesId: 1,
            teachersId: 1,
            semestersId: -1, // Некорректный ID семестра
            subgroupsId: 1,
            date: DateTime.now(),
          );
        }

        await expectLater(action, throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Семестр с ID "-1" не найден.'),
        )));
      });

      test('throws exception for invalid class type ID', () async {
        Future<void> action() async {
          await endpoints.classes.createClass(
            authenticatedSessionBuilder,
            subjectsId: 1,
            classTypesId: -1, // Некорректный ID типа занятия
            teachersId: 1,
            semestersId: 1,
            subgroupsId: 1,
            date: DateTime.now(),
          );
        }

        await expectLater(action, throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Тип занятия с ID "-1" не найден.'),
        )));
      });

      test('creates a class with optional fields', () async {
        final newClass = await endpoints.classes.createClass(
          authenticatedSessionBuilder,
          subjectsId: 1,
          classTypesId: 1,
          teachersId: 1,
          semestersId: 1,
          subgroupsId: 1,
          date: DateTime.now(),
          topic: null, // Тема занятия не указана
          notes: null, // Примечания не указаны
        );

        expect(newClass, isNotNull);
        expect(newClass.subjectsId, equals(1));
        expect(newClass.topic, isNull);
        expect(newClass.notes, isNull);
      });
    });

    group('updateClass', () {
      test('updates an existing class', () async {
        final existingClass = await Classes.db.findById(session, 1);
        expect(existingClass, isNotNull);

        final updatedClass = await endpoints.classes.updateClass(
          authenticatedSessionBuilder,
          classId: 1,
          topic: 'Обновленная тема занятия',
          notes: 'Обновленные примечания',
        );

        expect(updatedClass, isNotNull);
        expect(updatedClass.topic, equals('Обновленная тема занятия'));
        expect(updatedClass.notes, equals('Обновленные примечания'));
      });

      test('throws exception for non-existing class', () async {
        Future<void> action() async {
          await endpoints.classes.updateClass(
            authenticatedSessionBuilder,
            classId: -1,
            topic: 'Тема',
          );
        }

        await expectLater(action, throwsA(isA<Exception>()));
      });

      test('throws exception for unauthorized user', () async {
        // Используем отдельного пользователя-студента
        var unauthorizedSession = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            studentId, // Используем ID студента
            {CustomScope.student},
          ),
        );

        Future<void> action() async {
          await endpoints.classes.updateClass(
            unauthorizedSession,
            classId: 1,
            topic: 'Тема',
          );
        }

        await expectLater(action, throwsA(isA<Exception>()));
      });
    });

    group('deleteClass', () {
      test('deletes an existing class', () async {
        final result = await endpoints.classes.deleteClass(
          authenticatedSessionBuilder,
          1,
        );

        expect(result, isTrue);

        final deletedClass = await Classes.db.findById(session, 1);
        expect(deletedClass, isNull);
      });

      test('throws exception for non-existing class', () async {
        Future<void> action() async {
          await endpoints.classes.deleteClass(authenticatedSessionBuilder, -1);
        }

        await expectLater(action, throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Занятие с ID "-1" не найдено.'),
        )));
      });

      test('throws exception for unauthorized user', () async {
        // Используем отдельного пользователя-студента
        var unauthorizedSession = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            studentId, // Используем ID студента
            {CustomScope.student},
          ),
        );

        Future<void> action() async {
          await endpoints.classes.deleteClass(unauthorizedSession, 1);
        }

        await expectLater(action, throwsA(isA<Exception>()));
      });
    });
  }); 
}