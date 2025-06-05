import 'package:journal_custom_server/src/custom_scope.dart';
import 'package:journal_custom_server/src/generated/protocol.dart';
import 'package:serverpod/server.dart';
// import 'package:journal_custom_server/src/generated/protocol.dart';
// import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'test_tools/serverpod_test_tools.dart';
// Импортируйте сгенерированный файл-помощник для тестов
// import 'test_tools/serverpod_test_tools.dart';

void main() {
  // Группа тестов для SearchEndpoint
  withServerpod('Given SearchEndpoint', (sessionBuilder, endpoints) {
    // Пример теста для метода searchStudents (если такой существует в вашем SearchEndpoint)
    // Замените 'searchStudents' и параметры на реальные методы вашего эндпоинта
    var session = sessionBuilder.build();
    const int userId = 1234;

setUp(() async {
      var ps1 = Person(id:1, firstName: 'Анатолий', lastName: 'Тестов', email: 'anatoliy.testov@example.com');
      await Person.db.insertRow(session, ps1);
      var g1 = Groups(id:1 , name: 'ТестГруппа-ИТ21');
      await Groups.db.insertRow(session, g1);
      var g2 = Groups(id:2 , name: 'ТестГруппа-ИТ22');
      await Groups.db.insertRow(session, g2);
      
      var s = Students(personId: ps1.id!, groupsId: g1.id!);
      await Students.db.insertRow(session, s);
      
      var pt1 = Person(
        id: 2,
        firstName: 'Иван',
        lastName: 'Петров',
        email: 'ivan.petrov@example.com',
      );
      await Person.db.insertRow(session, pt1);
      var t1 = Teachers(personId: pt1.id!);
      await Teachers.db.insertRow(session, t1);
      
      var pt2 = Person(
        id: 3,
        firstName: 'Анна',
        lastName: 'Сидорова',
        email: 'anna.sidorova@example.com',
      );
      await Person.db.insertRow(session, pt2);
      var t2 = Teachers(personId: pt2.id!);
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
      });

group('auth Subgroups', () {
    var authenticatedSessionBuilder = sessionBuilder.copyWith(
      authentication:
          AuthenticationOverride.authenticationInfo(userId, 
          // {CustomScope.documentSpecialist,Scope.admin}
          { 
            CustomScope.groupHead, 
            CustomScope.teacher, 
            CustomScope.student, 
            CustomScope.documentSpecialist
          }
          ),
    );

   test('test searchSubgroups finds matching subgroups', () async {
        // final session = await authenticatedSessionBuilder.create();
        final result = await endpoints.search.searchSubgroups(authenticatedSessionBuilder, query: '1');

        expect(result, isNotEmpty);
        expect(result.any((subgroup) => subgroup.name == 'Подгруппа 1'), isTrue);
      });

      test('test searchSubgroups returns empty for non-matching query', () async {
        // final session = await authenticatedSessionBuilder.create();
        final result = await endpoints.search.searchSubgroups(authenticatedSessionBuilder, query: 'Несуществующий');

        expect(result, isEmpty);
      });
    
  });

  group('unauth Subgroups', () {
    var unauthenticatedSessionBuilder = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.unauthenticated(),
        );

    test('test searchSubgroups should throw ServerpodUnauthenticatedException', () async {
        // final session = await unauthenticatedSessionBuilder.create();

        Future<void> action() async {
          await endpoints.search.searchSubgroups(unauthenticatedSessionBuilder, query: 'Подгруппа 1');
        }

        await expectLater(action, throwsA(isA<ServerpodUnauthenticatedException>()));
      });

  });



group('auth ClassTypes', () {
    var authenticatedSessionBuilder = sessionBuilder.copyWith(
      authentication:
          AuthenticationOverride.authenticationInfo(userId, 
          // {CustomScope.documentSpecialist,Scope.admin}
          { 
            CustomScope.groupHead, 
            CustomScope.teacher, 
            CustomScope.student, 
            CustomScope.documentSpecialist
          }
          ),
    );
    test('test searchClassTypes finds matching class types', () async {
        // final session = await authenticatedSessionBuilder.create();
        final result = await endpoints.search.searchClassTypes(authenticatedSessionBuilder, query: 'Лекция');

        expect(result, isNotEmpty);
        expect(result.any((classType) => classType.name == 'Лекция'), isTrue);
      });

      test('test searchClassTypes returns empty for non-matching query', () async {
        // final session = await authenticatedSessionBuilder.create();
        final result = await endpoints.search.searchClassTypes(authenticatedSessionBuilder, query: 'Несуществующий');

        expect(result, isEmpty);
      });

    
  });

  group('unauth ClassTypes', () {
    var unauthenticatedSessionBuilder = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.unauthenticated(),
        );
    test('test searchClassTypes should throw ServerpodUnauthenticatedException', () async {
        // final session = await unauthenticatedSessionBuilder.create();

        Future<void> action() async {
          await endpoints.search.searchClassTypes(unauthenticatedSessionBuilder, query: 'Лекция');
        }

        await expectLater(action, throwsA(isA<ServerpodUnauthenticatedException>()));
      });
     
  });


  group('auth Subject', () {
    var authenticatedSessionBuilder = sessionBuilder.copyWith(
      authentication:
          AuthenticationOverride.authenticationInfo(userId, 
          // {CustomScope.documentSpecialist,Scope.admin}
          { 
            CustomScope.groupHead, 
            CustomScope.teacher, 
            CustomScope.student, 
            CustomScope.documentSpecialist
          }
          ),
    );
    
    test('test searchSubjects finds matching subjects', () async {
        // final session = await authenticatedSessionBuilder.create();
        final result = await endpoints.search.searchSubjects(authenticatedSessionBuilder, query: 'Математика');

        expect(result, isNotEmpty);
        expect(result.any((subject) => subject.name == 'Математика'), isTrue);
      });

      test('test searchSubjects returns empty for non-matching query', () async {
        // final session = await authenticatedSessionBuilder.create();
        final result = await endpoints.search.searchSubjects(authenticatedSessionBuilder, query: 'Несуществующий');

        expect(result, isEmpty);
      });

  });

  group('unauth subject', () {
    var unauthenticatedSessionBuilder = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.unauthenticated(),
        );
     test('test searchSubjects should throw ServerpodUnauthenticatedException', () async {
        // final session = await unauthenticatedSessionBuilder.create();

        Future<void> action() async {
          await endpoints.search.searchSubjects(unauthenticatedSessionBuilder, query: 'Математика');
        }

        await expectLater(action, throwsA(isA<ServerpodUnauthenticatedException>()));
      });
  });

  group('when authenticated', () {
    var authenticatedSessionBuilder = sessionBuilder.copyWith(
      authentication:
          AuthenticationOverride.authenticationInfo(userId, 
          // {CustomScope.documentSpecialist,Scope.admin}
          { 
            CustomScope.groupHead, 
            CustomScope.teacher, 
            CustomScope.student, 
            CustomScope.documentSpecialist
          }
          ),
    );
    

    test('test searchStudents', () async {
      final resutl = await endpoints.
      search.searchStudents(authenticatedSessionBuilder, query: 'А', );
      expect(resutl, isNotEmpty);
    });


    test('test searchTeachers finds matching teachers', () async {
        // final session = await authenticatedSessionBuilder.create();
        final result = await endpoints.search.searchTeachers(authenticatedSessionBuilder, query: 'Иван');

        expect(result, isNotEmpty);
        expect(result.any((teacher) => teacher.person?.firstName == 'Иван'), isTrue);
      });

      test('test searchTeachers returns empty for non-matching query', () async {
        // final session = await authenticatedSessionBuilder.create();
        final result = await endpoints.search.searchTeachers(authenticatedSessionBuilder, query: 'Несуществующий');

        expect(result, isEmpty);
      });

       test('test searchGroups finds matching groups', () async {
        // final session = await authenticatedSessionBuilder.create();
        final result = await endpoints.search.searchGroups(authenticatedSessionBuilder, query: 'ИТ21');

        expect(result, isNotEmpty);
        expect(result.any((group) => group.name == 'ТестГруппа-ИТ21'), isTrue);
      });

      test('test searchGroups returns empty for non-matching query', () async {
        // final session = await authenticatedSessionBuilder.create();
        final result = await endpoints.search.searchGroups(authenticatedSessionBuilder, query: 'Несуществующий');

        expect(result, isEmpty);
      });
  });

  group('when unauthenticated', () {
    var unauthenticatedSessionBuilder = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.unauthenticated(),
    );
    
    test('test searchStudents should throw ServerpodUnauthenticatedException', () async {
      
      final future = endpoints.search
          .searchStudents(unauthenticatedSessionBuilder, query: 'А');
      await expectLater(
          future, throwsA(isA<ServerpodUnauthenticatedException>()));
    });

    test('test searchGroups should throw ServerpodUnauthenticatedException', () async {
        // final session = await unauthenticatedSessionBuilder.create();

        Future<void> action() async {
          await endpoints.search.searchGroups(unauthenticatedSessionBuilder, query: 'ИТ21');
        }

        await expectLater(action, throwsA(isA<ServerpodUnauthenticatedException>()));
      });

  });


    
  });
}