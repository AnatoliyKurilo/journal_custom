import 'package:journal_custom_server/src/custom_scope.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:test/test.dart';
import 'package:serverpod/serverpod.dart';
import 'package:journal_custom_server/src/generated/protocol.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given GroupsEndpoint', (sessionBuilder, endpoints) {
    const int adminUserId = 1;
    const int curatorUserId = 2;
    const int curator2UserId = 3;
    final session = sessionBuilder.build();

    var authenticatedSessionBuilder = sessionBuilder.copyWith(
          authentication:
          AuthenticationOverride.authenticationInfo(adminUserId, 
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

      // Создаем тестовые данные
      await UserInfo.db.insertRow(session, UserInfo(
        id: adminUserId,
        userIdentifier: 'admin_user',
        created: DateTime.now(),
        scopeNames: [Scope.admin.name!],
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
        id: curator2UserId,
        userIdentifier: 'curator_user2',
        created: DateTime.now(),
        scopeNames: [CustomScope.curator.name!],
        blocked: false,
      ));

      var person = Person(id: 1, firstName: 'Иван', lastName: 'Иванов', userInfoId: curatorUserId, email: '');
      await Person.db.insertRow(session, person);
      var teacher = Teachers(id: 1, personId: person.id!);
      await Teachers.db.insertRow(session, teacher);

      var person2 = Person(id: 2, firstName: 'Иван', lastName: 'Иванов', userInfoId: curator2UserId, email: '');
      await Person.db.insertRow(session, person2);
      var teacher2 = Teachers(id: 2, personId: person2.id!);
      await Teachers.db.insertRow(session, teacher2);

      var group = Groups(id: 1, name: 'Группа 1', curatorId: teacher.id!);
      await Groups.db.insertRow(session, group);
    });

    tearDown(() async {
      final session = sessionBuilder.build();

      // Удаляем тестовые данные
      await Groups.db.deleteWhere(session, where: (g) => g.id > 0);
      await Teachers.db.deleteWhere(session, where: (t) => t.id > 0);
      await Person.db.deleteWhere(session, where: (p) => p.id > 0);
      await UserInfo.db.deleteWhere(session, where: (u) => u.id > 0);
    });

    group('createGroup', () 
    {
      test('creates a new group', () async {
        
        final newGroup = await endpoints.groups.createGroup(
          authenticatedSessionBuilder,
          'Группа 2',
          2, // ID куратора
        );

        expect(newGroup, isNotNull);
        expect(newGroup.name, equals('Группа 2'));
        expect(newGroup.curatorId, equals(2));
      });

      test('throws exception when creating a group without admin scope', () async {
        var Session = sessionBuilder.copyWith(
          authentication:
          AuthenticationOverride.authenticationInfo(adminUserId, 
            // {CustomScope.documentSpecialist,Scope.admin}
            { 
              // Scope.admin,
              // CustomScope.groupHead, 
              // CustomScope.teacher, 
              CustomScope.student, 
              // CustomScope.documentSpecialist
            }
          ),
        );

        Future<void> action() async {
          await endpoints.groups.createGroup(Session, 'Группа 3', null);
        }

        await expectLater(action, throwsA(isA<ServerpodInsufficientAccessException>()));
      });
    });

    group('getAllGroups', () {
      test('returns all groups', () async {
        // final session = sessionBuilder.build();

        final groups = await endpoints.groups.getAllGroups(authenticatedSessionBuilder);

        expect(groups, isNotEmpty);
        expect(groups.any((group) => group.name == 'Группа 1'), isTrue);
      });
    });

    group('getGroupByName', () {
      test('returns group by name', () async {
        // final session = sessionBuilder.build();

        final group = await endpoints.groups.getGroupByName(authenticatedSessionBuilder, 'Группа 1');

        expect(group, isNotNull);
        expect(group!.name, equals('Группа 1'));
      });

      test('returns null for non-existing group name', () async {
        // final session = sessionBuilder.build();

        final group = await endpoints.groups.getGroupByName(authenticatedSessionBuilder, 'Несуществующая группа');

        expect(group, isNull);
      });
    });

    group('updateGroup', () {
      test('updates group name', () async {
        // final session = sessionBuilder.build();

        final group = await Groups.db.findById(session, 1);
        expect(group, isNotNull);

        final updatedGroup = await endpoints.groups.updateGroup(
          authenticatedSessionBuilder,
          group!.copyWith(name: 'Обновленная группа'),
        );

        expect(updatedGroup.name, equals('Обновленная группа'));
      });

      test('throws exception for non-existing group', () async {
        // final session = sessionBuilder.build();

        Future<void> action() async {
          await endpoints.groups.updateGroup(
            authenticatedSessionBuilder,
            Groups(id: -1, name: 'Несуществующая группа'),
          );
        }

        await expectLater(action, throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Группа с ID -1 не найдена.'),
        )));
      });
    });

    group('deleteGroup', () {
      test('deletes an existing group', () async {
        // final session = sessionBuilder.build();

        final result = await endpoints.groups.deleteGroup(authenticatedSessionBuilder, 1);

        expect(result, isTrue);

        final group = await Groups.db.findById(session, 1);
        expect(group, isNull);
      });

      test('throws exception for non-existing group', () async {
        // final session = sessionBuilder.build();

        Future<void> action() async {
          await endpoints.groups.deleteGroup(authenticatedSessionBuilder, -1);
        }

        await expectLater(action, throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Группа с ID -1 не найдена'),
        )));
      });
    });
  });
}