
import 'package:journal_custom_server/src/custom_scope.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:test/test.dart';
import 'package:serverpod/serverpod.dart';
import 'package:journal_custom_server/src/generated/protocol.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given StudentsEndpoint', (sessionBuilder, endpoints) {
    const int userId = 1234;
    const int userId2 = 123;
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
    // late final Groups gr;

    setUp(() async {
      final session = sessionBuilder.build();

      // Создаем тестовые данные
      await UserInfo.db.insertRow(session, UserInfo(
        id: userId,
        userIdentifier: 'user_$userId',
        created: DateTime.now(),
        scopeNames: [Scope.admin.name!],
        blocked: false,
      ));

      await UserInfo.db.insertRow(session, UserInfo(
        id: userId2,
        userIdentifier: 'user_$userId2',
        created: DateTime.now(),
        scopeNames: [Scope.admin.name!],
        blocked: false,
      ));

      var group = Groups(id: 1, name: 'Группа 1');
      await Groups.db.insertRow(session, group);

      var person = Person(
        id: 1,
        firstName: 'Иван',
        lastName: 'Иванов',
        email: 'ivan.ivanov@example.com',
        userInfoId: userId,
      );
      await Person.db.insertRow(session, person);

      var student = Students(
        id: 1,
        personId: person.id!,
        groupsId: group.id!,
        isGroupHead: true,
      );
      await Students.db.insertRow(session, student);

      var person2 = Person(
        id: 12,
        firstName: 'Иван',
        lastName: 'Иванов',
        email: 'ivan.ivanov@example.com',
        userInfoId: userId2,
      );
      await Person.db.insertRow(session, person2);
      var teacher = Teachers(id: 12, personId: person2.id!);
      await Teachers.db.insertRow(session, teacher);

      var semester = Semesters(
        id: 1,
        name: 'Осенний семестр 2023',
        startDate: DateTime(2023, 9, 1),
        endDate: DateTime(2024, 1, 31),
        year: 2023,
      );
      await Semesters.db.insertRow(session, semester);

      var subgroup = Subgroups(id: 1, name: 'Подгруппа 1', groupsId: group.id!);
      await Subgroups.db.insertRow(session, subgroup);

      var studentSubgroup = StudentSubgroup(
        studentsId: student.id!,
        subgroupsId: subgroup.id!,
      );
      await StudentSubgroup.db.insertRow(session, studentSubgroup);

      var subject = Subjects(id: 1, name: 'Математика');
      await Subjects.db.insertRow(session, subject);

      var classType = ClassTypes(id: 1, name: 'Лекция');
      await ClassTypes.db.insertRow(session, classType);

      var classSession = Classes(
        id: 1,
        subjectsId: subject.id!,
        class_typesId: classType.id!,
        subgroupsId: subgroup.id!,
        date: DateTime(2023, 9, 15), 
        teachersId: 12, 
        semestersId: 1,
      );
      await Classes.db.insertRow(session, classSession);

      var attendance = Attendance(
        classesId: classSession.id!,
        studentsId: student.id!,
        isPresent: true,
        comment: 'Присутствовал',
      );
      await Attendance.db.insertRow(session, attendance);
    });

    // tearDown(() async {
    //   final session = sessionBuilder.build();

    //   // Удаляем тестовые данные
    //   await Attendance.db.deleteWhere(session, where: (a) => a.id > 0);
    //   await Classes.db.deleteWhere(session, where: (c) => c.id > 0);
    //   await StudentSubgroup.db.deleteWhere(session, where: (ss) => ss.id > 0);
    //   await Subgroups.db.deleteWhere(session, where: (s) => s.id > 0);
    //   await Students.db.deleteWhere(session, where: (s) => s.id > 0);
    //   await Groups.db.deleteWhere(session, where: (g) =>  g.id > 0);
    //   await Person.db.deleteWhere(session, where: (p) => p.id > 0);
    //   await Subjects.db.deleteWhere(session, where: (s) => s.id > 0);
    //   await ClassTypes.db.deleteWhere(session, where: (ct) => ct.id > 0);
    //   await UserInfo.db.deleteWhere(session, where: (u) => u.id > 0);
    // });

    group('getAllStudents', () {
      test('returns all students', () async {
        // final session = sessionBuilder.build();

        final result = await endpoints.students
        .getAllStudents(authenticatedSessionBuilder);

        expect(result, hasLength(1));
        expect(result.first.person?.firstName, equals('Иван'));
        expect(result.first.groups?.name, equals('Группа 1'));
      });
    });

    // group('getStudentById', () {
    //   test('returns student by ID', () async {
    //     final session = sessionBuilder.build();
    //     final result = await endpoints.students.getStudentById(session, 1);
    //     expect(result, isNotNull);
    //     expect(result!.person?.firstName, equals('Иван'));
    //     expect(result.groups?.name, equals('Группа 1'));
    //   });
    //   test('returns null for non-existing student ID', () async {
    //     final session = sessionBuilder.build();
    //     final result = await endpoints.students.getStudentById(session, -1);
    //     expect(result, isNull);
    //   });
    // });

    group('createStudent', () {
      test('creates a new student', () async {
        var session = authenticatedSessionBuilder.build(); 
        final newStudent = await endpoints.students.createStudent(
          authenticatedSessionBuilder,
          firstName: 'Петр',
          lastName: 'Петров',
          email: 'petr.petrov@example.com',
          groupName: 'Группа 1',
        );

        // expect(newStudent, equals(''));
        // expect(newStudent.person?.firstName, equals('Петр'));
        // expect(newStudent.groups?.name, equals('Группа 1'));
        expect(newStudent, isNotNull);
        final studentFromDb = await Students.db.findById(session, newStudent.id!);
        expect(studentFromDb, isNotNull); 

        final personFromDb = await Person.db.findById(session, studentFromDb!.personId);
        expect(personFromDb, isNotNull);
        expect(personFromDb!.firstName, equals('Петр'));
        expect(personFromDb.lastName, equals('Петров'));

      });

      test('throws exception for invalid group ID', () async {
        final session = sessionBuilder.build();

        Future<void> action() async {
          await endpoints.students.createStudent(
            authenticatedSessionBuilder,
            firstName: 'Петр',
            lastName: 'Петров',
            email: 'petr.petrov@example.com',
            groupName: 'afsa', // Несуществующий ID группы
          );
        }

        await expectLater(action, throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Группа с названием "afsa" не найдена'),
        )));
      });
    });

    group('updateStudent', () {
      test('updates student successfully', () async {
        final session = sessionBuilder.build();

        var student = await Students.db.findById(session, 1);
        expect(student, isNotNull);

        student = student!.copyWith(isGroupHead: false);
        final updatedStudent = await endpoints.students.updateStudent(authenticatedSessionBuilder, student);

        expect(updatedStudent.isGroupHead, isFalse);

        final studentFromDb = await Students.db.findById(session, 1);
        expect(studentFromDb, isNotNull);
        expect(studentFromDb!.isGroupHead, isFalse);
      });

      test('throws exception for non-existing student', () async {
        final session = sessionBuilder.build();

        var nonExistingStudent = Students(
          id: -1,
          personId: 1,
          groupsId: 1,
        );

        Future<void> action() async {
          await endpoints.students.updateStudent(authenticatedSessionBuilder, nonExistingStudent);
        }

        await expectLater(action, throwsA(isA<Exception>()));
      });
    });

    group('getAllStudents', () {
      test('returns all students', () async {
        final session = sessionBuilder.build();

        final result = await endpoints.students.getAllStudents(authenticatedSessionBuilder);

        expect(result, hasLength(1));
        expect(result.first.person?.firstName, equals('Иван'));
        expect(result.first.groups?.name, equals('Группа 1'));
      });
    });

    group('getStudentOverallAttendanceRecords', () {
      test('returns attendance records for existing student', () async {
        final session = sessionBuilder.build();

        final result = await endpoints.students.getStudentOverallAttendanceRecords(authenticatedSessionBuilder, 1);

        expect(result, isNotEmpty);
        expect(result.first.subjectName, equals('Математика'));
        expect(result.first.isPresent, isTrue);
        expect(result.first.comment, equals('Присутствовал'));
      });

      test('throws exception for non-existing student', () async {
        final session = sessionBuilder.build();

        Future<void> action() async {
          await endpoints.students.getStudentOverallAttendanceRecords(authenticatedSessionBuilder, -1);
        }

        await expectLater(action, throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Студент с ID -1 не найден'),
        )));
      });
    });

  });
}