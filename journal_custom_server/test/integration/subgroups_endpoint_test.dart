import 'package:journal_custom_server/src/custom_scope.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:test/test.dart';
import 'package:serverpod/serverpod.dart';
import 'package:journal_custom_server/src/generated/protocol.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given SubgroupsEndpoint', (sessionBuilder, endpoints) {
    const int adminUserId = 1;
    const int groupHeadUserId = 2;
    const int curatorUserId = 3;
    const int studentUserId = 4;

    setUp(() async {
      final session = sessionBuilder.build();

      // Создаем тестовые данные
      await UserInfo.db.insertRow(session, UserInfo(
        id: adminUserId,
        userIdentifier: 'admin_user',
        created: DateTime.now(),
        scopeNames: [Scope.admin.name!],
        blocked: false,
      ));

      await UserInfo.db.insertRow(session, UserInfo(
        id: groupHeadUserId,
        userIdentifier: 'group_head_user',
        created: DateTime.now(),
        scopeNames: [CustomScope.groupHead.name!],
        blocked: false,
      ));

      await UserInfo.db.insertRow(session, UserInfo(
        id: curatorUserId,
        userIdentifier: 'curator_user',
        created: DateTime.now(),
        scopeNames: [CustomScope.curator.name!],
        blocked: false,
      ));

      await UserInfo.db.insertRow(session, UserInfo(
        id: studentUserId,
        userIdentifier: 'student_user',
        created: DateTime.now(),
        scopeNames: [CustomScope.student.name!],
        blocked: false,
      ));

      var group = Groups(id: 1, name: 'Группа 1');
      await Groups.db.insertRow(session, group);

      // Создаем трех студентов
      var person1 = Person(
        id: 1,
        firstName: 'Иван',
        lastName: 'Иванов',
        email: 'ivan.ivanov@example.com',
        userInfoId: groupHeadUserId,
      );
      await Person.db.insertRow(session, person1);

      var person2 = Person(
        id: 2,
        firstName: 'Петр',
        lastName: 'Петров',
        email: 'petr.petrov@example.com',
        userInfoId: null,
      );
      await Person.db.insertRow(session, person2);

      var person3 = Person(
        id: 3,
        firstName: 'Анна',
        lastName: 'Сидорова',
        email: 'anna.sidorova@example.com',
        userInfoId: null,
      );
      await Person.db.insertRow(session, person3);

      var student1 = Students(
        id: 1,
        personId: person1.id!,
        groupsId: group.id!,
        isGroupHead: true,
      );
      await Students.db.insertRow(session, student1);

      var student2 = Students(
        id: 2,
        personId: person2.id!,
        groupsId: group.id!,
        isGroupHead: false,
      );
      await Students.db.insertRow(session, student2);

      var student3 = Students(
        id: 3,
        personId: person3.id!,
        groupsId: group.id!,
        isGroupHead: false,
      );
      await Students.db.insertRow(session, student3);

      var curatorPerson = Person(
        id: 4,
        firstName: 'Куратор',
        lastName: 'Кураторов',
        email: 'curator@example.com',
        userInfoId: curatorUserId,
      );
      await Person.db.insertRow(session, curatorPerson);

      var teacher = Teachers(id: 1, personId: curatorPerson.id!);
      await Teachers.db.insertRow(session, teacher);

      await Groups.db.updateRow(session, group.copyWith(curatorId: teacher.id!));
    });

    tearDown(() async {
  final session = sessionBuilder.build();

  try {
    // Удаляем тестовые данные в правильном порядке (сначала зависимые записи)
    await StudentSubgroup.db.deleteWhere(session, where: (ss) => ss.id > 0);
    await Subgroups.db.deleteWhere(session, where: (s) => s.id > 0);
    await Attendance.db.deleteWhere(session, where: (a) => a.id > 0);
    await Classes.db.deleteWhere(session, where: (c) => c.id > 0);
    await Students.db.deleteWhere(session, where: (s) => s.id > 0);
    
    // Сначала обновляем Groups, убирая ссылку на curator
    await Groups.db.find(session).then((groups) async {
      for (var group in groups) {
        if (group.curatorId != null) {
          await Groups.db.updateRow(session, group.copyWith(curatorId: null));
        }
      }
    });
    
    // Затем удаляем Teachers и Groups
    await Teachers.db.deleteWhere(session, where: (t) => t.id > 0);
    await Groups.db.deleteWhere(session, where: (g) => g.id > 0);
    await Person.db.deleteWhere(session, where: (p) => p.id > 0);
    await Subjects.db.deleteWhere(session, where: (s) => s.id > 0);
    await ClassTypes.db.deleteWhere(session, where: (ct) => ct.id > 0);
    await Semesters.db.deleteWhere(session, where: (s) => s.id > 0);
    await UserInfo.db.deleteWhere(session, where: (u) => u.id > 0);
  } catch (e) {
    print('Error during tearDown: $e');
  }
});

    group('getCurrentUserGroup', () {
      test('returns group for group head', () async {
        var authenticatedSessionBuilder = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            groupHeadUserId,
            {CustomScope.groupHead},
          ),
        );

        final result = await endpoints.subgroups.getCurrentUserGroup(authenticatedSessionBuilder);

        expect(result, isNotNull);
        expect(result!.name, equals('Группа 1'));
      });

      test('returns group for curator', () async {
        var authenticatedSessionBuilder = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            curatorUserId,
            {CustomScope.curator},
          ),
        );

        final result = await endpoints.subgroups.getCurrentUserGroup(authenticatedSessionBuilder);

        expect(result, isNotNull);
        expect(result!.name, equals('Группа 1'));
      });

      test('returns null for student without group head role', () async {
        var authenticatedSessionBuilder = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            studentUserId,
            {CustomScope.student},
          ),
        );

        final result = await endpoints.subgroups.getCurrentUserGroup(authenticatedSessionBuilder);

        expect(result, isNull);
      });

      test('returns first group for admin', () async {
        var authenticatedSessionBuilder = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            adminUserId,
            {Scope.admin},
          ),
        );

        final result = await endpoints.subgroups.getCurrentUserGroup(authenticatedSessionBuilder);

        expect(result, isNotNull);
        expect(result!.name, equals('Группа 1'));
      });
    });

    group('createSubgroup', () {
      test('creates a new subgroup successfully', () async {
        var authenticatedSessionBuilder = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            adminUserId,
            {Scope.admin},
          ),
        );

        final result = await endpoints.subgroups.createSubgroup(
          authenticatedSessionBuilder,
          1, // ID группы
          'Подгруппа 1',
          'Описание подгруппы',
        );

        expect(result, isNotNull);
        expect(result.name, equals('Подгруппа 1'));
        expect(result.description, equals('Описание подгруппы'));
        expect(result.groupsId, equals(1));
      });

      test('throws exception for non-existing group', () async {
        var authenticatedSessionBuilder = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            adminUserId,
            {Scope.admin},
          ),
        );

        Future<void> action() async {
          await endpoints.subgroups.createSubgroup(
            authenticatedSessionBuilder,
            -1, // Несуществующий ID группы
            'Подгруппа 1',
            'Описание подгруппы',
          );
        }

        await expectLater(action, throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Основная группа не найдена.'),
        )));
      });

      test('throws exception for duplicate subgroup name', () async {
        var authenticatedSessionBuilder = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            adminUserId,
            {Scope.admin},
          ),
        );

        // Создаем подгруппу
        await endpoints.subgroups.createSubgroup(
          authenticatedSessionBuilder,
          1,
          'Подгруппа 1',
          'Описание подгруппы',
        );

        // Пытаемся создать подгруппу с тем же именем
        Future<void> action() async {
          await endpoints.subgroups.createSubgroup(
            authenticatedSessionBuilder,
            1,
            'Подгруппа 1',
            'Другое описание',
          );
        }

        await expectLater(action, throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Подгруппа с таким названием уже существует в этой группе.'),
        )));
      });

      test('throws exception for insufficient permissions', () async {
        var ses = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            studentUserId,
            {CustomScope.student}, // Убедитесь, что пользователь имеет только роль старосты
          ),
        );

        Future<void> action() async {
          await endpoints.subgroups.createSubgroup(
            ses,
            1,
            'Подгруппа 1',
            'Описание подгруппы',
          );
        }

        await expectLater(action, throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Доступ запрещен: нет прав на управление подгруппами этой группы.'),
          )));
      });
    });
  
    group('createFullGroupSubgroup', () {
      test('creates subgroup with all students successfully', () async {
        var authenticatedSessionBuilder = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            adminUserId,
            {Scope.admin},
          ),
        );

        final result = await endpoints.subgroups.createFullGroupSubgroup(
          authenticatedSessionBuilder,
          1, // ID группы
          'Все студенты',
          'Подгруппа со всеми студентами группы',
        );

        expect(result, isNotNull);
        expect(result.name, equals('Все студенты'));
        expect(result.description, equals('Подгруппа со всеми студентами группы'));
        expect(result.groupsId, equals(1));

        // Проверяем, что все студенты добавлены в подгруппу
        final session = sessionBuilder.build();
        final studentLinks = await StudentSubgroup.db.find(
          session,
          where: (ss) => ss.subgroupsId.equals(result.id!),
        );
        
        expect(studentLinks, hasLength(3)); // 3 студента в группе
        expect(studentLinks.map((sl) => sl.studentsId), containsAll([1, 2, 3]));
      });

      test('throws exception for non-existing group', () async {
        var authenticatedSessionBuilder = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            adminUserId,
            {Scope.admin},
          ),
        );

        Future<void> action() async {
          await endpoints.subgroups.createFullGroupSubgroup(
            authenticatedSessionBuilder,
            -1, // Несуществующий ID группы
            'Все студенты',
            'Описание',
          );
        }

        await expectLater(action, throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Основная группа не найдена.'),
        )));
      });

      test('throws exception for duplicate subgroup name', () async {
        var authenticatedSessionBuilder = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            adminUserId,
            {Scope.admin},
          ),
        );

        // Создаем подгруппу с именем "Все студенты"
        await endpoints.subgroups.createFullGroupSubgroup(
          authenticatedSessionBuilder,
          1,
          'Все студенты',
          'Первая подгруппа',
        );

        // Пытаемся создать еще одну подгруппу с тем же именем
        Future<void> action() async {
          await endpoints.subgroups.createFullGroupSubgroup(
            authenticatedSessionBuilder,
            1,
            'Все студенты',
            'Вторая подгруппа',
          );
        }

        await expectLater(action, throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Подгруппа с таким названием уже существует в этой группе.'),
        )));
      });

      test('throws exception for insufficient permissions', () async {
        var authenticatedSessionBuilder = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            studentUserId,
            {CustomScope.student},
          ),
        );

        Future<void> action() async {
          await endpoints.subgroups.createFullGroupSubgroup(
            authenticatedSessionBuilder,
            1,
            'Все студенты',
            'Описание',
          );
        }

        await expectLater(action, throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Доступ запрещен: нет прав на управление подгруппами этой группы.'),
        )));
      });

      test('creates subgroup and adds students even if group has no students', () async {
        var authenticatedSessionBuilder = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            adminUserId,
            {Scope.admin},
          ),
        );

        // Создаем пустую группу
        final session = sessionBuilder.build();
        var emptyGroup = Groups(id: 2, name: 'Пустая группа');
        await Groups.db.insertRow(session, emptyGroup);

        final result = await endpoints.subgroups.createFullGroupSubgroup(
          authenticatedSessionBuilder,
          2,
          'Все студенты пустой группы',
          'Подгруппа пустой группы',
        );

        expect(result, isNotNull);
        expect(result.name, equals('Все студенты пустой группы'));
        expect(result.groupsId, equals(2));

        // Проверяем, что никто не добавлен в подгруппу
        final studentLinks = await StudentSubgroup.db.find(
          session,
          where: (ss) => ss.subgroupsId.equals(result.id!),
        );
        
        expect(studentLinks, isEmpty);
      });

      test('works with curator permissions', () async {
        var authenticatedSessionBuilder = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            curatorUserId,
            {CustomScope.curator},
          ),
        );

        final result = await endpoints.subgroups.createFullGroupSubgroup(
          authenticatedSessionBuilder,
          1,
          'Все студенты группы',
          'Подгруппа куратора',
        );

        expect(result, isNotNull);
        expect(result.name, equals('Все студенты группы'));
        expect(result.groupsId, equals(1));

        // Проверяем, что все студенты добавлены
        final session = sessionBuilder.build();
        final studentLinks = await StudentSubgroup.db.find(
          session,
          where: (ss) => ss.subgroupsId.equals(result.id!),
        );
        
        expect(studentLinks, hasLength(3));
      });
    });

  });
}