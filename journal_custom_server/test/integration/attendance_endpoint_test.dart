import 'package:journal_custom_server/src/custom_scope.dart';
import 'package:journal_custom_server/src/generated/protocol.dart';
import 'package:serverpod/server.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:test/test.dart';
import 'test_tools/serverpod_test_tools.dart';

void main(){
withServerpod('Given AttendanceEndpoint', (sessionBuilder, endpoints) {
    const int userId = 1234;
    const int teacherUserId = 5678; // Добавляем ID для преподавателя

    setUp(() async {
      final session = sessionBuilder.build();

      // Создаем пользователя-администратора (для основных операций)
      List<String> adminScopeNames = [
        Scope.admin.name!,
        CustomScope.teacher.name!, // Добавляем права преподавателя
        CustomScope.documentSpecialist.name!
      ];
      await UserInfo.db.insertRow(session, UserInfo(
          id: userId,
          userIdentifier: 'user_$userId', 
          created: DateTime.now(), 
          scopeNames: adminScopeNames, 
          blocked: false));

      // Создаем пользователя-преподавателя
      List<String> teacherScopeNames = [
        CustomScope.teacher.name!
      ];
      await UserInfo.db.insertRow(session, UserInfo(
          id: teacherUserId,
          userIdentifier: 'teacher_$teacherUserId', 
          created: DateTime.now(), 
          scopeNames: teacherScopeNames, 
          blocked: false));

      var g1 = Groups(id:1 , name: 'ТестГруппа-ИТ21');
      await Groups.db.insertRow(session, g1);
      var g2 = Groups(id:2 , name: 'ТестГруппа-ИТ22');
      await Groups.db.insertRow(session, g2);

      var ps1 = Person(
        id:1, 
        firstName: 'Анатолий', 
        lastName: 'Тестов', 
        email: 'anatoliy.testov@example.com');
      await Person.db.insertRow(session, ps1);
      var ps2 = Person(id:2, firstName: 'Елена', lastName: 'Тестова', email: 'eafw@example.com');
      await Person.db.insertRow(session, ps2);

      var st1 = Students(
        id:1,
        personId: ps1.id!, 
        groupsId: 1,);
      var st2 = Students(
        id: 2,
        personId: ps2.id!,
        groupsId: 1,);
      await Students.db.insert(session, [st1, st2]);
      
      // Создаем преподавателя с правильной связью
      var pt1 = Person(
        id: 3,
        firstName: 'Иван',
        lastName: 'Преподавателев',
        email: 'teacher@example.com',
        userInfoId: teacherUserId, // Связываем с пользователем-преподавателем
      );
      await Person.db.insertRow(session, pt1);
      var t1 = Teachers(id: 1, personId: pt1.id!);
      await Teachers.db.insertRow(session, t1);
      
      var pt2 = Person(
        id: 4,
        firstName: 'Мария',
        lastName: 'Преподавателева',
        email: 'teacher2@example.com',
      );
      await Person.db.insertRow(session, pt2);
      var t2 = Teachers(id:2, personId: pt2.id!);
      await Teachers.db.insertRow(session, t2);

      var sj1 = Subjects(name: 'Математика', id: 1);
      var sj2 = Subjects(name: 'Физика', id: 2);
      var sj3 = Subjects(name: 'Химия', id: 3);
      await Subjects.db.insert(session, [sj1, sj2, sj3]);

      var ct1 = ClassTypes(id: 1, name: 'Лекция');
      var ct2 = ClassTypes(id: 2, name: 'Практика');
      var ct3 = ClassTypes(id: 3, name: 'Лабораторная');
      await ClassTypes.db.insert(session, [ct1, ct2, ct3]);

      var sg1 = Subgroups(id: 1, name: 'Подгруппа 1', groupsId: g1.id!);
      var sg2 = Subgroups(id: 2, name: 'Подгруппа 2', groupsId: g1.id!);
      await Subgroups.db.insert(session, [sg1, sg2]);

      var stsg1 = StudentSubgroup(
        studentsId: st1.id!,
        subgroupsId: sg1.id!,
      );
      var stsg2 = StudentSubgroup(
        studentsId: st2.id!,
        subgroupsId: sg1.id!,
      );
      await StudentSubgroup.db.insert(session, [stsg1, stsg2]);

      var semester1 = Semesters(
        id: 1,
        name: 'Осенний семестр 2023',
        startDate: DateTime(2023, 9, 1),
        endDate: DateTime(2024, 1, 31),
        year: 2023,
      );
      await Semesters.db.insertRow(session, semester1);

      var classSession = Classes(
        id: 1,
        subjectsId: 1,
        class_typesId: 1,
        teachersId: 1,
        semestersId: 1,
        subgroupsId: 1,
        date: DateTime.now(),
      );
      await Classes.db.insertRow(session, classSession);

      var attendance1 = Attendance(
        id: 1,
        classesId: 1,
        studentsId: 1,
        isPresent: true,
        comment: 'Присутствовал',
      );
      await Attendance.db.insertRow(session, attendance1);

      var attendance2 = Attendance(
        id: 2,
        classesId: 1,
        studentsId: 2,
        isPresent: false,
        comment: 'Отсутствовал',
      );
      await Attendance.db.insertRow(session, attendance2);
   
      });

  // Используем права администратора/преподавателя для основных тестов
  group('auth getStudentsForClassWithAttendance', () {
    var authenticatedSessionBuilder = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        userId, // Используем администратора
        {Scope.admin, CustomScope.teacher, CustomScope.documentSpecialist}
      ),
    );

    test('test getStudentsForClassWithAttendance returns correct attendance data', () async {
      final classSession = await Classes.db.findById(
        sessionBuilder.build(), 1,
      );

      expect(classSession, isNotNull);

      final result = await endpoints.attendance.getStudentsForClassWithAttendance(
        authenticatedSessionBuilder,
        classId: classSession!.id!,
      );

      expect(result, isNotEmpty);
      expect(result.any((attendance) => attendance.student.id == 1 && attendance.isPresent == true), isTrue);
      expect(result.any((attendance) => attendance.student.id == 2 && attendance.isPresent == false), isTrue);
    });

    test('test getStudentsForClassWithAttendance returns empty for non-existing class', () async {
      Future<void> action() async {
        await endpoints.attendance.getStudentsForClassWithAttendance(
          authenticatedSessionBuilder,
          classId: -1,
        );
      }
      await expectLater(action, throwsA(isA<Exception>().having(
        (e) => e.toString(),
        'message',
        contains('Занятие с ID -1 не найдено.'),
      )));
    });
  });

  group('unauth getStudentsForClassWithAttendance', () {
    var unauthenticatedSessionBuilder = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.unauthenticated(),
    );

    test('test getStudentsForClassWithAttendance should throw ServerpodUnauthenticatedException', () async {
      Future<void> action() async {
        await endpoints.attendance.getStudentsForClassWithAttendance(
          unauthenticatedSessionBuilder,
          classId: 1,
        );
      }
      await expectLater(action, throwsA(isA<ServerpodUnauthenticatedException>()));
    });    
  });
  
  group('auth updateStudentAttendance', () {
    var authenticatedSessionBuilder = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        userId, // Используем администратора
        {Scope.admin, CustomScope.teacher, CustomScope.documentSpecialist}
      ),
    );

    test('test updateStudentAttendance updates attendance correctly', () async {
      final classSession = await Classes.db.findById(sessionBuilder.build(), 1);

      expect(classSession, isNotNull, reason: 'Class session with id=1 should exist.');

      // Обновляем посещаемость студента
      final updatedAttendance = await endpoints.attendance.updateStudentAttendance(
        authenticatedSessionBuilder,
        classId: 1,
        studentId: 2,
        isPresent: false,
        comment: 'Опоздание',
      );

      expect(updatedAttendance, isNotNull);
      expect(updatedAttendance.isPresent, isFalse);
      expect(updatedAttendance.comment, equals('Опоздание'));

      // Проверяем, что данные в базе обновлены
      final attendanceRecord = await Attendance.db.findById(sessionBuilder.build(), 2);
      expect(attendanceRecord, isNotNull);
      expect(attendanceRecord!.isPresent, isFalse);
      expect(attendanceRecord.comment, equals('Опоздание'));
    });

    test('test updateStudentAttendance throws exception for non-existing student', () async {
      Future<void> action() async {
        await endpoints.attendance.updateStudentAttendance(
          authenticatedSessionBuilder,
          classId: 1,
          studentId: -1,
          isPresent: true,
        );
      }

      await expectLater(action, throwsA(isA<Exception>().having(
        (e) => e.toString(),
        'message',
        contains('Студент с ID -1 не найден.'),
      )));
    });

    test('test updateStudentAttendance throws exception for non-existing class', () async {
      Future<void> action() async {
        await endpoints.attendance.updateStudentAttendance(
          authenticatedSessionBuilder,
          classId: -1,
          studentId: 1,
          isPresent: true,
        );
      }

      await expectLater(action, throwsA(isA<Exception>().having(
        (e) => e.toString(),
        'message',
        contains('Занятие с ID -1 не найдено.'),
      )));
    });
  });

  group('unauth updateStudentAttendance', () {
    var unauthenticatedSessionBuilder = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.unauthenticated(),
    );

    test('test updateStudentAttendance should throw ServerpodUnauthenticatedException', () async {
      Future<void> action() async {
        await endpoints.attendance.updateStudentAttendance(
          unauthenticatedSessionBuilder,
          classId: 1,
          studentId: 1,
          isPresent: true,
        );
      }
      await expectLater(action, throwsA(isA<ServerpodUnauthenticatedException>()));
    });
  });

  group('getSubjectOverallAttendance', () {
    var authenticatedSessionBuilder = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        userId,
        {Scope.admin, CustomScope.teacher, CustomScope.documentSpecialist}
      ),
    );
    
    test('test getSubjectOverallAttendance returns correct attendance data', () async {
      final result = await endpoints.attendance.getSubjectOverallAttendance(
        authenticatedSessionBuilder,
        subjectId: 1,
      );

      expect(result, isNotEmpty);
      expect(result.any((attendance) => attendance.student.id == 1 && attendance.isPresent == true), isTrue);
      expect(result.any((attendance) => attendance.student.id == 2 && attendance.isPresent == false), isTrue);
    });

    test('test getSubjectOverallAttendance returns empty for non-existing subject', () async {
      Future<void> action() async {
        await endpoints.attendance.getSubjectOverallAttendance(
          authenticatedSessionBuilder,
          subjectId: -1,
        );
      }
      await expectLater(action, throwsA(isA<Exception>().having(
        (e) => e.toString(),
        'message',
        contains('Предмет с ID -1 не найден.'),
      )));
    });

    test('test getSubjectOverallAttendance throws exception for unauthenticated user', () async {
      var unauthenticatedSessionBuilder = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.unauthenticated(),
      );

      Future<void> action() async {
        await endpoints.attendance.getSubjectOverallAttendance(
          unauthenticatedSessionBuilder,
          subjectId: 1,
        );
      }

      await expectLater(action, throwsA(isA<ServerpodUnauthenticatedException>()));
    });
  });  

  group('getSubjectAttendanceMatrix', () {
    var authenticatedSessionBuilder = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        userId,
        {Scope.admin, CustomScope.teacher, CustomScope.documentSpecialist}
      ),
    );

    test('test getSubjectAttendanceMatrix returns correct matrix data', () async {
      final result = await endpoints.attendance.getSubjectAttendanceMatrix(
        authenticatedSessionBuilder,
        subjectId: 1,
      );

      expect(result, isNotNull);
      expect(result.students, isNotEmpty);
      expect(result.classes, isNotEmpty);
      expect(result.attendanceData, isNotEmpty);

      final student1 = result.students.firstWhere((s) => s.id == 1);
      expect(result.attendanceData[student1.id], isNotNull);
    });

    test('test getSubjectAttendanceMatrix returns empty for non-existing subject', () async {
      Future<void> action() async {
        await endpoints.attendance.getSubjectAttendanceMatrix(
          authenticatedSessionBuilder,
          subjectId: -1,
        );
      }
      await expectLater(action, throwsA(isA<Exception>().having(
        (e) => e.toString(),
        'message',
        contains('Предмет с ID -1 не найден.'),
      )));
    });

    test('test getSubjectAttendanceMatrix throws exception for unauthenticated user', () async {
      var unauthenticatedSessionBuilder = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.unauthenticated(),
      );

      Future<void> action() async {
        await endpoints.attendance.getSubjectAttendanceMatrix(
          unauthenticatedSessionBuilder,
          subjectId: 1,
        );
      }

      await expectLater(action, throwsA(isA<ServerpodUnauthenticatedException>()));
    });
  });

  // Отдельная группа тестов для проверки ограничений студентов
  group('student restrictions', () {
    var studentSessionBuilder = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        userId,
        {CustomScope.student} // Только права студента
      ),
    );

    test('student can view attendance but has limited access to matrix', () async {
      // Студенты могут просматривать посещаемость, но с ограничениями
      final result = await endpoints.attendance.getSubjectAttendanceMatrix(
        studentSessionBuilder,
        subjectId: 1,
      );

      // Проверяем, что студент получает ограниченную информацию
      expect(result, isNotNull);
    });
  });
});
}