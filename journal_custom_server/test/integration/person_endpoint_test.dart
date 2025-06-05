import 'package:journal_custom_server/src/custom_scope.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:test/test.dart';
import 'package:serverpod/serverpod.dart';
import 'package:journal_custom_server/src/generated/protocol.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given PersonEndpoint', (sessionBuilder, endpoints) {
    const int userId = 1234;
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

      // Создаем тестовые данные
      await UserInfo.db.insertRow(session, UserInfo(
        id: userId,
        userIdentifier: 'user_$userId',
        created: DateTime.now(),
        scopeNames: [Scope.admin.name!],
        blocked: false,
      ));

      var person = Person(
        id: 1,
        firstName: 'Иван',
        lastName: 'Иванов',
        email: 'ivan.ivanov@example.com',
        userInfoId: userId,
      );
      await Person.db.insertRow(session, person);
    });

    tearDown(() async {
      final session = sessionBuilder.build();

      // Удаляем тестовые данные
      await Person.db.deleteWhere(session, where: (p) => p.id > 0);
      await UserInfo.db.deleteWhere(session, where: (u) => u.id > 0);
    });

    group('updatePerson', () {
      test('updates person successfully', () async {
        final session = sessionBuilder.build();

        var person = await Person.db.findById(session, 1);
        expect(person, isNotNull);

        // Обновляем данные
        person = person!.copyWith(firstName: 'Петр', lastName: 'Петров');
        final updatedPerson = await endpoints.person.updatePerson(authenticatedSessionBuilder, person);

        expect(updatedPerson.firstName, equals('Петр'));
        expect(updatedPerson.lastName, equals('Петров'));

        // Проверяем, что данные обновлены в базе
        final personFromDb = await Person.db.findById(session, 1);
        expect(personFromDb, isNotNull);
        expect(personFromDb!.firstName, equals('Петр'));
        expect(personFromDb.lastName, equals('Петров'));
      });

      test('throws exception for non-existing person', () async {
        final session = sessionBuilder.build();

        var nonExistingPerson = Person(
          id: -1,
          firstName: 'Неизвестный',
          lastName: 'Пользователь',
          email: 'unknown@example.com',
        );

        Future<void> action() async {
          await endpoints.person.updatePerson(authenticatedSessionBuilder, nonExistingPerson);
        }

        await expectLater(action, throwsA(isA<Exception>()));
      });

      test('logs error when update fails', () async {
        final session = sessionBuilder.build();

        // Создаем некорректный объект Person (например, с отсутствующим userInfoId)
        var invalidPerson = Person(
          id: 1,
          firstName: 'Иван',
          lastName: 'Иванов',
          email: 'ivan.ivanov@example.com',
          userInfoId: null, // Некорректное значение
        );

        Future<void> action() async {
          await endpoints.person.updatePerson(authenticatedSessionBuilder, invalidPerson);
        }

        await expectLater(action, throwsA(isA<Exception>()));
      });
    });
  
  
    });
}