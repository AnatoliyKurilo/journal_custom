import 'package:journal_custom_server/src/custom_scope.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:test/test.dart';
import 'package:serverpod/serverpod.dart';
import 'package:journal_custom_server/src/generated/protocol.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given SubjectsEndpoint', (sessionBuilder, endpoints) {
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

      // Создаем тестовые предметы
      await Subjects.db.insertRow(session, Subjects(
        id: 1,
        name: 'Математика',
      ));

      await Subjects.db.insertRow(session, Subjects(
        id: 2,
        name: 'Физика',
      ));

      await Subjects.db.insertRow(session, Subjects(
        id: 3,
        name: 'Химия',
      ));

      await Subjects.db.insertRow(session, Subjects(
        id: 4,
        name: 'Высшая математика',
      ));

      await Subjects.db.insertRow(session, Subjects(
        id: 5,
        name: 'Теоретическая физика',
      ));

      await Subjects.db.insertRow(session, Subjects(
        id: 6,
        name: 'Органическая химия',
      ));
    });

    tearDown(() async {
      final session = sessionBuilder.build();

      // Удаляем тестовые данные
      await Subjects.db.deleteWhere(session, where: (s) => s.id > 0);
      await UserInfo.db.deleteWhere(session, where: (u) => u.id > 0);
    });

    group('searchSubjects', () {
      test('returns all subjects for empty query', () async {
        final result = await endpoints.subjects.searchSubjects(
          authenticatedSessionBuilder,
          query: '',
        );

        expect(result, hasLength(6));
        expect(result.map((s) => s.name), containsAll([
          'Математика',
          'Физика',
          'Химия',
          'Высшая математика',
          'Теоретическая физика',
          'Органическая химия'
        ]));

        // Проверяем сортировку по алфавиту
        final sortedNames = result.map((s) => s.name).toList();
        final expectedOrder = [
          'Высшая математика',
          'Математика',
          'Органическая химия',
          'Теоретическая физика',
          'Физика',
          'Химия'
        ];
        expect(sortedNames, equals(expectedOrder));
      });

      test('returns matching subjects for exact name query', () async {
        final result = await endpoints.subjects.searchSubjects(
          authenticatedSessionBuilder,
          query: 'Математика',
        );

        expect(result, hasLength(2)); // Изменено с 1 на 2
        expect(result.map((s) => s.name), containsAll(['Математика', 'Высшая математика']));
        
        // Проверяем, что точное совпадение есть в результатах
        expect(result.any((s) => s.name == 'Математика'), isTrue);
      });

      test('returns matching subjects for partial name query', () async {
        final result = await endpoints.subjects.searchSubjects(
          authenticatedSessionBuilder,
          query: 'математика',
        );

        expect(result, hasLength(2)); // Изменено с 1 на 2
        expect(result.map((s) => s.name), containsAll(['Математика', 'Высшая математика']));
      });

      test('is case-insensitive', () async {
        final result = await endpoints.subjects.searchSubjects(
          authenticatedSessionBuilder,
          query: 'ФИЗИКА',
        );

        expect(result, hasLength(2));
        expect(result.map((s) => s.name), containsAll(['Физика', 'Теоретическая физика']));
      });

      test('handles multi-word queries with OR logic', () async {
        final result = await endpoints.subjects.searchSubjects(
          authenticatedSessionBuilder,
          query: 'математика физика',
        );

        expect(result, hasLength(4));
        expect(result.map((s) => s.name), containsAll([
          'Математика',
          'Высшая математика',
          'Физика',
          'Теоретическая физика'
        ]));
      });

      test('returns matching subjects for partial word query', () async {
        final result = await endpoints.subjects.searchSubjects(
          authenticatedSessionBuilder,
          query: 'хим',
        );

        expect(result, hasLength(2));
        expect(result.map((s) => s.name), containsAll(['Химия', 'Органическая химия']));
      });

      test('returns empty for non-matching query', () async {
        final result = await endpoints.subjects.searchSubjects(
          authenticatedSessionBuilder,
          query: 'История',
        );

        expect(result, isEmpty);
      });

      test('handles queries with extra whitespace', () async {
        final result = await endpoints.subjects.searchSubjects(
          authenticatedSessionBuilder,
          query: '  математика  ',
        );

        expect(result, hasLength(2));
        expect(result.map((s) => s.name), containsAll(['Математика', 'Высшая математика']));
      });

      test('handles queries with multiple spaces between words', () async {
        final result = await endpoints.subjects.searchSubjects(
          authenticatedSessionBuilder,
          query: 'высшая    математика',
        );

        expect(result, hasLength(2)); // Изменено с 1 на 2
        expect(result.map((s) => s.name), containsAll(['Высшая математика', 'Математика']));
        
        // Проверяем, что "Высшая математика" находится первой (содержит оба токена)
        expect(result.first.name, equals('Высшая математика'));
      });

      test('returns subjects sorted by name', () async {
        final result = await endpoints.subjects.searchSubjects(
          authenticatedSessionBuilder,
          query: 'а', // Найдет предметы содержащие букву 'а'
        );

        expect(result, hasLength(5)); // Все предметы содержат букву 'а'

        // Проверяем, что результаты отсортированы по алфавиту
        for (int i = 0; i < result.length - 1; i++) {
          expect(
            result[i].name.toLowerCase().compareTo(result[i + 1].name.toLowerCase()),
            lessThanOrEqualTo(0),
          );
        }
      });

      test('handles special characters in query', () async {
        final result = await endpoints.subjects.searchSubjects(
          authenticatedSessionBuilder,
          query: 'математика%',
        );

        // Символ % обрабатывается как обычный символ, поэтому находятся предметы с "математика"
        expect(result, hasLength(2));
        expect(result.map((s) => s.name), containsAll(['Математика', 'Высшая математика']));
      });

      test('finds subjects with compound search terms', () async {
        final result = await endpoints.subjects.searchSubjects(
          authenticatedSessionBuilder,
          query: 'теоретическая',
        );

        expect(result, hasLength(1));
        expect(result.first.name, equals('Теоретическая физика'));
      });
    });

    group('searchSubjects authorization', () {
      test('requires authentication', () async {
        var unauthenticatedSessionBuilder = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.unauthenticated(),
        );

        Future<void> action() async {
          await endpoints.subjects.searchSubjects(
            unauthenticatedSessionBuilder,
            query: 'Математика',
          );
        }

        await expectLater(action, throwsA(isA<ServerpodUnauthenticatedException>()));
      });
    });
  });
}