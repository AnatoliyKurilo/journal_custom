// import 'package:flutter_test/flutter_test.dart';
import 'package:journal_custom_server/src/custom_scope.dart';
import 'package:serverpod/serverpod.dart';
import 'package:journal_custom_server/src/services/user_subgroup_service.dart';
import 'package:journal_custom_server/src/generated/protocol.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given UserSubgroupService', (sessionBuilder, endpoints) {
    
    var session = sessionBuilder.build();
    const int userId = 1234;

    session = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        userId,
        {CustomScope.student, CustomScope.documentSpecialist},
      ),
    ).build();

    group('UserSubgroupService', () {
      

      setUp(() async {
        List<String> scopeNames = [
        Scope.admin.name!,
        // CustomScope.groupHead.name!,
        // CustomScope.teacher.name!,
        // CustomScope.student.name!,
        // CustomScope.documentSpecialist.name!
      ];
        UserInfo.db.insertRow(session, UserInfo(
          id: userId,
          userIdentifier: 'user_$userId', 
          created: DateTime.now(), 
          scopeNames: scopeNames, 
          blocked: false));
        // Создаем тестовые данные
        
      var group = Groups(id: 1, name: 'Группа 1', );
        await Groups.db.insertRow(session, group);

        var subgroup = Subgroups(id: 1, name: 'Подгруппа 1', groupsId: 1);
        await Subgroups.db.insertRow(session, subgroup);
        

        var person = Person(id: 1, firstName: 'Иван', lastName: 'Иванов', email: '123@a.ru',userInfoId: userId);
        await Person.db.insertRow(session, person);

        var student = Students(id: 1, personId: person.id!, groupsId: group.id!);
        await Students.db.insertRow(session, student);

        var studentSubgroup = StudentSubgroup(studentsId: student.id!, subgroupsId: subgroup.id!);
        await StudentSubgroup.db.insertRow(session, studentSubgroup);

        var teacher = Teachers(id: 1, personId: person.id!);
        await Teachers.db.insertRow(session, teacher);

        var sj1 = Subjects(name: 'Математика', id: 1);
        var sj2 = Subjects(name: 'Физика', id: 2);
        var sj3 = Subjects(name: 'Химия', id: 3);
        await Subjects.db.insert(session, [sj1, sj2, sj3]);

        var semester1 = Semesters(
          id: 1,
          name: 'Осенний семестр 2023',
          startDate: DateTime(2023, 9, 1),
          endDate: DateTime(2024, 1, 31), 
          year: 2023,
          );
        await Semesters.db.insertRow(session, semester1);

        var ct1 = ClassTypes(id: 1, name: 'Лекция');
        var ct2 = ClassTypes(id: 2, name: 'Практика');
        var ct3 = ClassTypes(id: 3, name: 'Лабораторная');
        await ClassTypes.db.insert(session, [ct1, ct2, ct3]);

        var classSession = Classes(
          id: 1,
          subjectsId: 1,
          subgroupsId: subgroup.id!,
          teachersId: teacher.id!,
          date: DateTime.now(), 
          class_typesId: 1, 
          semestersId: 1,
        );
        await Classes.db.insertRow(session, classSession);
      });

      // tearDown(() async {
      //   // Очистка данных после тестов
      //   await Subgroups.db.deleteWhere(session, where: (s) => Constant(true));
      //   await Groups.db.deleteWhere(session, where: (g) => Constant(true));
      //   await Person.db.deleteWhere(session, where: (p) => Constant(true));
      //   await Students.db.deleteWhere(session, where: (s) => Constant(true));
      //   await StudentSubgroup.db.deleteWhere(session, where: (ss) => Constant(true));
      //   await Teachers.db.deleteWhere(session, where: (t) => Constant(true));
      //   await Classes.db.deleteWhere(session, where: (c) => Constant(true));
      // });

      test('getUserAccessibleSubgroupIds returns correct subgroups for student', () async {
        // Устанавливаем скоуп пользователя как "student"

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

        // var ses = authenticatedSessionBuilder.build();
        
        final accessibleSubgroups = await UserSubgroupService.getUserAccessibleSubgroupIds(
          authenticatedSessionBuilder.build(),
        );

        expect(accessibleSubgroups, contains(1));
      });

      // test('getUserAccessibleSubgroupIds returns correct subgroups for teacher', () async {
      //   // Устанавливаем скоуп пользователя как "teacher"
      //   session.authenticated = AuthenticatedUser(userId: 1234, scopeNames: ['teacher']);

      //   final accessibleSubgroups = await UserSubgroupService.getUserAccessibleSubgroupIds(session);

      //   expect(accessibleSubgroups, contains(1));
      // });

      // test('getUserAccessibleSubgroupIds returns empty for unauthenticated user', () async {
      //   // Устанавливаем сессию как неаутентифицированную
      //   session.authenticated = null;

      //   final accessibleSubgroups = await UserSubgroupService.getUserAccessibleSubgroupIds(session);

      //   expect(accessibleSubgroups, isEmpty);
      // });

      // test('hasAccessToSubgroup returns true for accessible subgroup', () async {
      //   // Устанавливаем скоуп пользователя как "student"
      //   session.authenticated = AuthenticatedUser(userId: 1234, scopeNames: ['student']);

      //   final hasAccess = await UserSubgroupService.hasAccessToSubgroup(session, 1);

      //   expect(hasAccess, isTrue);
      // });

      // test('hasAccessToSubgroup returns false for inaccessible subgroup', () async {
      //   // Устанавливаем скоуп пользователя как "student"
      //   session.authenticated = AuthenticatedUser(userId: 1234, scopeNames: ['student']);

      //   final hasAccess = await UserSubgroupService.hasAccessToSubgroup(session, 999);

      //   expect(hasAccess, isFalse);
      // });

      // test('getUserAccessibleSubjectsWithClasses returns correct subjects', () async {
      //   // Устанавливаем скоуп пользователя как "teacher"
      //   session.authenticated = AuthenticatedUser(userId: 1234, scopeNames: ['teacher']);

      //   final subjects = await UserSubgroupService.getUserAccessibleSubjectsWithClasses(session);

      //   expect(subjects, isNotEmpty);
      //   expect(subjects.first.name, isNotNull);
      // });
    
    });

  

  });
}