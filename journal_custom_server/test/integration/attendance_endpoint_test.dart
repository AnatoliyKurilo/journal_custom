import 'package:journal_custom_server/src/custom_scope.dart';
import 'package:journal_custom_server/src/generated/protocol.dart';
import 'package:serverpod/server.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
// import 'package:journal_custom_server/src/generated/protocol.dart';
// import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'test_tools/serverpod_test_tools.dart';
// Импортируйте сгенерированный файл-помощник для тестов
// import 'test_tools/serverpod_test_tools.dart';


void main(){
withServerpod('Given AttendanceEndpoint', (sessionBuilder, endpoints) {
    // Пример теста для метода searchStudents (если такой существует в вашем SearchEndpoint)
    // Замените 'searchStudents' и параметры на реальные методы вашего эндпоинта
    var session = sessionBuilder.build();
    const int userId = 1234;

    

    setUp(() async {

      List<String> scopeNames = [
        Scope.admin.name!,
        CustomScope.groupHead.name!,
        CustomScope.teacher.name!,
        CustomScope.student.name!,
        CustomScope.documentSpecialist.name!
      ];
      UserInfo.db.insertRow(session, UserInfo(
          id: userId,
          userIdentifier: 'user_$userId', 
          created: DateTime.now(), 
          scopeNames: scopeNames, 
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
      
      // var s = Students(personId: ps1.id!, groupsId: g1.id!);
      // await Students.db.insertRow(session, s);
      
      var pt1 = Person(
        id: 3,
        firstName: 'Иван',
        lastName: 'Петров',
        email: 'ivan.petrov@example.com',
      );
      await Person.db.insertRow(session, pt1);
      var t1 = Teachers(id: 1, personId: pt1.id!);
      await Teachers.db.insertRow(session, t1);
      
      var pt2 = Person(
        id: 4,
        firstName: 'Анна',
        lastName: 'Сидорова',
        email: 'anna.sidorova@example.com',
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
        id: 1,
        studentsId: st1.id!,
        subgroupsId: sg1.id!,
      );
      var stsg2 = StudentSubgroup(
        id: 2,
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
        subjectsId: sj1.id!, 
        class_typesId: ct1.id!,
        teachersId: t1.id!,
        semestersId: semester1.id!, 
        subgroupsId: sg1.id!, 
        date: DateTime(2023, 9, 15),
        );
      // classSession = 
      await Classes.db.insertRow(session, classSession);

      var attendance1 = Attendance(
        id: 1,
        classesId: classSession.id!, 
        studentsId: st1.id!, 
        isPresent:  true
      );
      await Attendance.db.insertRow(session, attendance1);

      var attendance2 = Attendance(
        id: 2,
        classesId: classSession.id!, 
        studentsId: st2.id!, 
        isPresent:  false
      );
      await Attendance.db.insertRow(session, attendance2);
   
      });


  // НЕ ТРОГАТЬ!!!!!!!!!!
  group('auth getStudentsForClassWithAttendance', () {
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

    test('test getStudentsForClassWithAttendance returns correct attendance data', () async {
  final classSession = await Classes.db.findById(
    session, 1,
  );

  // Проверяем, что classSession не является null
  expect(classSession, isNotNull, reason: 'Class session with id=1 should exist.');

  final result = await endpoints.attendance.getStudentsForClassWithAttendance(
    authenticatedSessionBuilder,
    classId: classSession!.id!,
  );

  expect(result, isNotEmpty);
  expect(result.any((attendance) => attendance.student.id == 1 && attendance.isPresent == true), isTrue);
  expect(result.any((attendance) => attendance.student.id == 2 && attendance.isPresent == false), isTrue);
});

      test('test getStudentsForClassWithAttendance returns empty for non-existing class', () async {
        // final session = await authenticatedSessionBuilder.create();

        // final result = await endpoints.attendance.getStudentsForClassWithAttendance(
        //   authenticatedSessionBuilder,
        //   classId: -1, // Несуществующий ID занятия
        // );

        Future<void> action() async {
            await endpoints.attendance.getStudentsForClassWithAttendance(
              authenticatedSessionBuilder,
              classId: -1, // Несуществующий ID занятия
            );
          }
        
        await expectLater(action, throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Занятие с ID -1 не найдено.'),
        )));
        
        // expect(result, isEmpty);
      });
    });
  // НЕ ТРОГАТЬ!!!!!!!!!!

  group('unauth getStudentsForClassWithAttendance', () {
  var unauthenticatedSessionBuilder = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.unauthenticated(),
      );

    test('test getStudentsForClassWithAttendance should throw ServerpodUnauthenticatedException', () async {
      // final session = await unauthenticatedSessionBuilder.create();

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
      authentication:
          AuthenticationOverride.authenticationInfo(userId, 
          // {CustomScope.documentSpecialist,Scope.admin}
          { 
            Scope.admin,
            CustomScope.groupHead, 
            CustomScope.teacher, 
            CustomScope.student, 
            CustomScope.documentSpecialist
          }
          ),
    );

    test('test updateStudentAttendance updates attendance correctly', () async {
    final classSession = await Classes.db.findById(session, 1);

    // Проверяем, что classSession не является null
    expect(classSession, isNotNull, reason: 'Class session with id=1 should exist.');

    // Обновляем посещаемость студента
    final updatedAttendance = await endpoints.attendance.updateStudentAttendance(
      authenticatedSessionBuilder,
      classId: 1,
      studentId: 2,
      isPresent: false,
      comment: 'Опоздание',  
    );

    // Проверяем, что посещаемость обновлена
    expect(updatedAttendance, isNotNull);
    expect(updatedAttendance.isPresent, isFalse);
    expect(updatedAttendance.comment, equals('Опоздание'));

    // Проверяем, что данные в базе обновлены
    final attendanceRecord = await Attendance.db.findById(session, 2);
    expect(attendanceRecord, isNotNull);
    expect(attendanceRecord!.isPresent, isFalse);
    expect(attendanceRecord.comment, equals('Опоздание'));
  });

  test('test updateStudentAttendance throws exception for non-existing student', () async {
    Future<void> action() async {
      await endpoints.attendance.updateStudentAttendance(
        authenticatedSessionBuilder,
        classId: 1,
        studentId: -1, // Несуществующий ID студента
        isPresent: true,
        comment: 'Присутствует',
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
        classId: -1,  // Несуществующий ID занятия
        studentId: 1, 
        isPresent: true,
        comment: 'Присутствует',
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

    test('test updateStudentAttendance should throw ServerpodUnauthenticatedException', () async {
      Future<void> action() async {
        await endpoints.attendance.updateStudentAttendance(
          unauthenticatedSessionBuilder,
          classId: 1,
          studentId: 1,
          isPresent: true,
          comment: 'Присутствует',
        );
      }

      await expectLater(action, throwsA(isA<ServerpodUnauthenticatedException>()));
    });
  });


  group('getSubjectOverallAttendance', () {

    var authenticatedSessionBuilder = sessionBuilder.copyWith(
      authentication:
          AuthenticationOverride.authenticationInfo(userId, 
          // {CustomScope.documentSpecialist,Scope.admin}
          { 
            Scope.admin,
            CustomScope.groupHead, 
            CustomScope.teacher, 
            CustomScope.student, 
            CustomScope.documentSpecialist
          }
          ),
    );
    
    test('test getSubjectOverallAttendance returns correct attendance data', () async {
      final result = await endpoints.attendance.getSubjectOverallAttendance(
        authenticatedSessionBuilder,
        subjectId: 1, // ID предмета "Математика"
      );

      expect(result, isNotEmpty);
      expect(result.any((attendance) => attendance.student.id == 1 && attendance.isPresent == true), isTrue);
      expect(result.any((attendance) => attendance.student.id == 2 && attendance.isPresent == false), isTrue);
    });

    test('test getSubjectOverallAttendance returns empty for non-existing subject', () async {
      Future<void> action() async {
        await endpoints.attendance.getSubjectOverallAttendance(
          authenticatedSessionBuilder,
          subjectId: -1, // Несуществующий ID предмета
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
      authentication:
          AuthenticationOverride.authenticationInfo(userId, 
          // {CustomScope.documentSpecialist,Scope.admin}
          { 
            Scope.admin,
            CustomScope.groupHead, 
            CustomScope.teacher, 
            CustomScope.student, 
            CustomScope.documentSpecialist
          }
          ),
    );

    test('test getSubjectAttendanceMatrix returns correct matrix data', () async {
      final result = await endpoints.attendance.getSubjectAttendanceMatrix(
        authenticatedSessionBuilder,
        subjectId: 1, // ID предмета "Математика"
      );

      expect(result.students, isNotEmpty);
      expect(result.classes, isNotEmpty);
      expect(result.attendanceData, isNotEmpty);

      // Проверяем наличие студента с ID 1 и его посещаемость
      final student1 = result.students.firstWhere((s) => s.id == 1, orElse: () => throw Exception('Student with ID 1 not found.'));
      expect(student1, isNotNull);
      expect(result.attendanceData[student1.id], isNotNull);
    });

    test('test getSubjectAttendanceMatrix returns empty for non-existing subject', () async {
      Future<void> action() async {
        await endpoints.attendance.getSubjectAttendanceMatrix(
          authenticatedSessionBuilder,
          subjectId: -1, // Несуществующий ID предмета
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











  });
}