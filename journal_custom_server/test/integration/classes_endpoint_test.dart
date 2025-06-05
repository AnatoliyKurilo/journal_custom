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
    const int GHid =12;

    var authenticatedSessionBuilder = sessionBuilder.copyWith(
      authentication:
          AuthenticationOverride.authenticationInfo(userId, 
          // {CustomScope.documentSpecialist,Scope.admin}
          { 
            Scope.admin,
            // CustomScope.groupHead, 
            // CustomScope.teacher, 
            // CustomScope.student, 
            // CustomScope.documentSpecialist
          }
          ),
    );

    setUp(() async {
      final session = sessionBuilder.build();

      List<String> scopeNames = [
        Scope.admin.name!,
        CustomScope.groupHead.name!,
        CustomScope.teacher.name!,
        CustomScope.student.name!,
        CustomScope.documentSpecialist.name!
      ];
      await UserInfo.db.insertRow(session, UserInfo(
          id: userId,
          userIdentifier: 'user_$userId', 
          created: DateTime.now(), 
          scopeNames: scopeNames, 
          blocked: false));

      await UserInfo.db.insertRow(session, UserInfo(
          id: GHid,
          userIdentifier: 'user_$GHid', 
          created: DateTime.now(), 
          scopeNames: scopeNames, 
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
      
    });


    group('getSubjectsWithClasses', () {
      
      test('returns subjects with classes', () async {
        // final session = sessionBuilder.build();
        final result = await endpoints.classes
        .getSubjectsWithClasses(authenticatedSessionBuilder);

        expect(result, isNotEmpty);
        expect(result.any((subject) => subject.name == 'Математика'), isTrue);
      });
    });

    group('getClassesBySubject', () {
      test('returns classes for existing subject', () async {
        // final session = sessionBuilder.build();
        final result = await endpoints.classes
        .getClassesBySubject(authenticatedSessionBuilder, subjectId: 1);

        expect(result, isNotEmpty);
        expect(result.any((classSession) => classSession.subjectsId == 1), isTrue);
      });

      test('returns empty for non-existing subject', () async {
        // final session = sessionBuilder.build();
        final result = await endpoints.classes
        .getClassesBySubject(authenticatedSessionBuilder, subjectId: -1);

        expect(result, isEmpty);
      });

    });

    group('createClass', () {
      
      test('creates a new class', () async {
        // final session = sessionBuilder.build();
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

      test('throws exception for invalid subgroup', () async {
        var ses = sessionBuilder.copyWith(
      authentication:
          AuthenticationOverride.authenticationInfo(GHid, 
          // {CustomScope.documentSpecialist,Scope.admin}
          { 
            // Scope.admin,
            CustomScope.groupHead, 
            CustomScope.teacher, 
            // CustomScope.student, 
            // CustomScope.documentSpecialist
          }
          ),
    );

        Future<void> action() async {
          await endpoints.classes.createClass(
            ses,
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

    });

  }); 
}