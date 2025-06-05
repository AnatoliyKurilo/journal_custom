import 'package:journal_custom_server/src/custom_scope.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:test/test.dart';
import 'package:serverpod/serverpod.dart';
import 'package:journal_custom_server/src/generated/protocol.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given TeachersEndpoint', (sessionBuilder, endpoints) {
    const int userId = 1234;

    var authenticatedSessionBuilder = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        userId,
        {Scope.admin},
      ),
    );

    setUp(() async {
      final session = sessionBuilder.build();

      // Создаем тестовые данные пользователя
      await UserInfo.db.insertRow(session, UserInfo(
        id: userId,
        userIdentifier: 'user_$userId',
        created: DateTime.now(),
        scopeNames: [Scope.admin.name!],
        blocked: false,
      ));

      // Создаем тестовые данные существующего человека (для проверки дублирования email)
      await Person.db.insertRow(session, Person(
        id: 999,
        firstName: 'Существующий',
        lastName: 'Человек',
        email: 'existing@example.com',
        phoneNumber: '+7-900-000-0000',
      ));
    });

    tearDown(() async {
      final session = sessionBuilder.build();

      // Удаляем тестовые данные в правильном порядке
      await Teachers.db.deleteWhere(session, where: (t) => t.id > 0);
      await Person.db.deleteWhere(session, where: (p) => p.id > 0);
      await UserInfo.db.deleteWhere(session, where: (u) => u.id > 0);
    });

    group('createTeacher', () {
      test('creates teacher successfully with all required fields', () async {
        final teacher = await endpoints.teachers.createTeacher(
          authenticatedSessionBuilder,
          firstName: 'Иван',
          lastName: 'Петров',
          patronymic: 'Сергеевич',
          email: 'ivan.petrov@example.com',
          phoneNumber: '+7-900-123-4567',
        );

        expect(teacher, isNotNull);
        expect(teacher.id, isNotNull);
        expect(teacher.personId, isNotNull);

        // Проверяем, что Person создался корректно
        final session = sessionBuilder.build();
        final person = await Person.db.findById(session, teacher.personId);
        expect(person, isNotNull);
        expect(person!.firstName, equals('Иван'));
        expect(person.lastName, equals('Петров'));
        expect(person.patronymic, equals('Сергеевич'));
        expect(person.email, equals('ivan.petrov@example.com'));
        expect(person.phoneNumber, equals('+7-900-123-4567'));
      });

      test('creates teacher successfully with only required fields', () async {
        final teacher = await endpoints.teachers.createTeacher(
          authenticatedSessionBuilder,
          firstName: 'Анна',
          lastName: 'Сидорова',
          email: 'anna.sidorova@example.com',
        );

        expect(teacher, isNotNull);
        expect(teacher.id, isNotNull);
        expect(teacher.personId, isNotNull);

        // Проверяем, что Person создался с null значениями для необязательных полей
        final session = sessionBuilder.build();
        final person = await Person.db.findById(session, teacher.personId);
        expect(person, isNotNull);
        expect(person!.firstName, equals('Анна'));
        expect(person.lastName, equals('Сидорова'));
        expect(person.patronymic, isNull);
        expect(person.email, equals('anna.sidorova@example.com'));
        expect(person.phoneNumber, isNull);
      });

      test('throws exception when email already exists', () async {
        Future<void> action() async {
          await endpoints.teachers.createTeacher(
            authenticatedSessionBuilder,
            firstName: 'Дмитрий',
            lastName: 'Козлов',
            email: 'existing@example.com', // Этот email уже существует в setUp
          );
        }

        await expectLater(action, throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Человек с таким email уже существует'),
        )));
      });

      test('handles email case sensitivity', () async {
        final teacher = await endpoints.teachers.createTeacher(
          authenticatedSessionBuilder,
          firstName: 'Михаил',
          lastName: 'Новиков',
          email: 'MIKHAIL.NOVIKOV@EXAMPLE.COM',
        );

        expect(teacher, isNotNull);
        expect(teacher.personId, isNotNull);

        final session = sessionBuilder.build();
        final person = await Person.db.findById(session, teacher.personId);
        expect(person!.email, equals('MIKHAIL.NOVIKOV@EXAMPLE.COM'));
      });

      test('creates teacher with special characters in name', () async {
        final teacher = await endpoints.teachers.createTeacher(
          authenticatedSessionBuilder,
          firstName: 'Жан-Пьер',
          lastName: 'Дюпон-Морель',
          patronymic: 'Анри-Огюст',
          email: 'jean.pierre@example.com',
        );

        expect(teacher, isNotNull);
        
        final session = sessionBuilder.build();
        final person = await Person.db.findById(session, teacher.personId);
        expect(person!.firstName, equals('Жан-Пьер'));
        expect(person.lastName, equals('Дюпон-Морель'));
        expect(person.patronymic, equals('Анри-Огюст'));
      });

      test('creates teacher with long names', () async {
        final longFirstName = 'А' * 100; // Длинное имя
        final longLastName = 'Б' * 100; // Длинная фамилия

        final teacher = await endpoints.teachers.createTeacher(
          authenticatedSessionBuilder,
          firstName: longFirstName,
          lastName: longLastName,
          email: 'long.name@example.com',
        );

        expect(teacher, isNotNull);
        
        final session = sessionBuilder.build();
        final person = await Person.db.findById(session, teacher.personId);
        expect(person!.firstName, equals(longFirstName));
        expect(person.lastName, equals(longLastName));
      });
    });

    group('getAllTeachers', () {
      test('returns empty list when no teachers exist', () async {
        final teachers = await endpoints.teachers.getAllTeachers(authenticatedSessionBuilder);
        
        expect(teachers, isEmpty);
      });

      test('returns all teachers with person information', () async {
        // Создаем несколько преподавателей
        await endpoints.teachers.createTeacher(
          authenticatedSessionBuilder,
          firstName: 'Алексей',
          lastName: 'Смирнов',
          email: 'alexey.smirnov@example.com',
        );

        await endpoints.teachers.createTeacher(
          authenticatedSessionBuilder,
          firstName: 'Мария',
          lastName: 'Кузнецова',
          patronymic: 'Ивановна',
          email: 'maria.kuznetsova@example.com',
          phoneNumber: '+7-900-111-2233',
        );

        final teachers = await endpoints.teachers.getAllTeachers(authenticatedSessionBuilder);

        expect(teachers, hasLength(2));
        
        // Проверяем, что Person информация включена
        for (var teacher in teachers) {
          expect(teacher.person, isNotNull);
          expect(teacher.person!.firstName, isNotNull);
          expect(teacher.person!.lastName, isNotNull);
          expect(teacher.person!.email, isNotNull);
        }

        // Проверяем конкретных преподавателей
        final alexey = teachers.firstWhere((t) => t.person!.firstName == 'Алексей');
        expect(alexey.person!.lastName, equals('Смирнов'));
        expect(alexey.person!.email, equals('alexey.smirnov@example.com'));

        final maria = teachers.firstWhere((t) => t.person!.firstName == 'Мария');
        expect(maria.person!.lastName, equals('Кузнецова'));
        expect(maria.person!.patronymic, equals('Ивановна'));
        expect(maria.person!.phoneNumber, equals('+7-900-111-2233'));
      });

      test('handles teachers with null patronymic and phoneNumber', () async {
        await endpoints.teachers.createTeacher(
          authenticatedSessionBuilder,
          firstName: 'Сергей',
          lastName: 'Волков',
          email: 'sergey.volkov@example.com',
        );

        final teachers = await endpoints.teachers.getAllTeachers(authenticatedSessionBuilder);

        expect(teachers, hasLength(1));
        final teacher = teachers.first;
        expect(teacher.person!.patronymic, isNull);
        expect(teacher.person!.phoneNumber, isNull);
      });

      test('returns teachers in consistent order', () async {
        // Создаем преподавателей в определенном порядке
        final teacher1 = await endpoints.teachers.createTeacher(
          authenticatedSessionBuilder,
          firstName: 'Первый',
          lastName: 'Преподаватель',
          email: 'first@example.com',
        );

        final teacher2 = await endpoints.teachers.createTeacher(
          authenticatedSessionBuilder,
          firstName: 'Второй',
          lastName: 'Преподаватель',
          email: 'second@example.com',
        );

        final teachers = await endpoints.teachers.getAllTeachers(authenticatedSessionBuilder);

        expect(teachers, hasLength(2));
        
        // Проверяем, что порядок соответствует порядку создания (по ID)
        expect(teachers[0].id, equals(teacher1.id));
        expect(teachers[1].id, equals(teacher2.id));
      });
    });

    group('authorization', () {
      test('requires authentication', () async {
        var unauthenticatedSessionBuilder = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.unauthenticated(),
        );

        Future<void> createAction() async {
          await endpoints.teachers.createTeacher(
            unauthenticatedSessionBuilder,
            firstName: 'Иван',
            lastName: 'Петров',
            email: 'ivan@example.com',
          );
        }

        Future<void> getAllAction() async {
          await endpoints.teachers.getAllTeachers(unauthenticatedSessionBuilder);
        }

        await expectLater(createAction, throwsA(isA<ServerpodUnauthenticatedException>()));
        await expectLater(getAllAction, throwsA(isA<ServerpodUnauthenticatedException>()));
      });

      test('works with different scopes', () async {
        // Создаем пользователя с другими правами (например, куратор)
        const curatorUserId = 5678;
        await UserInfo.db.insertRow(sessionBuilder.build(), UserInfo(
          id: curatorUserId,
          userIdentifier: 'curator_$curatorUserId',
          created: DateTime.now(),
          scopeNames: [CustomScope.curator.name!],
          blocked: false,
        ));

        var curatorSessionBuilder = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            curatorUserId,
            {CustomScope.curator},
          ),
        );

        // Проверяем, что куратор может использовать методы (если нет специальных ограничений)
        final teachers = await endpoints.teachers.getAllTeachers(curatorSessionBuilder);
        expect(teachers, isNotNull);

        final teacher = await endpoints.teachers.createTeacher(
          curatorSessionBuilder,
          firstName: 'Куратор',
          lastName: 'Тестовый',
          email: 'curator.test@example.com',
        );
        expect(teacher, isNotNull);
      });
    });

    group('edge cases', () {
      test('handles empty string inputs gracefully', () async {
        Future<void> action() async {
          await endpoints.teachers.createTeacher(
            authenticatedSessionBuilder,
            firstName: '',
            lastName: '',
            email: '',
          );
        }

        // В зависимости от валидации на уровне базы данных или эндпоинта
        // может быть либо исключение, либо создание с пустыми строками
        await expectLater(action, throwsA(isA<Exception>()));
      });

      test('handles very long email addresses', () async {
        final longEmail = 'very.long.email.address.that.might.exceed.normal.limits@very-long-domain-name-that-could-cause-issues.example.com';

        final teacher = await endpoints.teachers.createTeacher(
          authenticatedSessionBuilder,
          firstName: 'Тест',
          lastName: 'Длинныйемайл',
          email: longEmail,
        );

        expect(teacher, isNotNull);
        
        final session = sessionBuilder.build();
        final person = await Person.db.findById(session, teacher.personId);
        expect(person!.email, equals(longEmail));
      });

      test('handles special characters in email', () async {
        final specialEmail = 'test+teacher@sub.domain.example.com';

        final teacher = await endpoints.teachers.createTeacher(
          authenticatedSessionBuilder,
          firstName: 'Спец',
          lastName: 'Символы',
          email: specialEmail,
        );

        expect(teacher, isNotNull);
        
        final session = sessionBuilder.build();
        final person = await Person.db.findById(session, teacher.personId);
        expect(person!.email, equals(specialEmail));
      });
    });
  });
}