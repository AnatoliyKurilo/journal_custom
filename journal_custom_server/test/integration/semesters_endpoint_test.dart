import 'package:test/test.dart';
import 'package:serverpod/serverpod.dart';
import 'package:journal_custom_server/src/generated/protocol.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given SemestersEndpoint', (sessionBuilder, endpoints) {
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
      await Semesters.db.insertRow(session, Semesters(
        id: 1,
        name: 'Осенний семестр 2023',
        startDate: DateTime(2023, 9, 1),
        endDate: DateTime(2024, 1, 31),
        year: 2023,
      ));

      await Semesters.db.insertRow(session, Semesters(
        id: 2,
        name: 'Весенний семестр 2024',
        startDate: DateTime(2024, 2, 1),
        endDate: DateTime(2024, 6, 30),
        year: 2024,
      ));

      await Semesters.db.insertRow(session, Semesters(
        id: 3,
        name: 'Летний семестр 2024',
        startDate: DateTime(2024, 7, 1),
        endDate: DateTime(2024, 8, 31),
        year: 2024,
      ));
    });

    tearDown(() async {
      final session = sessionBuilder.build();

      // Удаляем тестовые данные
      await Semesters.db.deleteWhere(session, where: (s) => s.id > 0);
    });

    group('searchSemesters', () {
      test('returns all semesters for empty query', () async {
        final session = sessionBuilder.build();

        final result = await endpoints.semesters.searchSemesters(authenticatedSessionBuilder, query: '');

        expect(result, hasLength(3));
        expect(result.map((s) => s.name), containsAll(['Осенний семестр 2023', 'Весенний семестр 2024', 'Летний семестр 2024']));
      });

      test('returns matching semesters for query by name', () async {
        final session = sessionBuilder.build();

        final result = await endpoints.semesters.searchSemesters(authenticatedSessionBuilder, query: 'Осенний');

        expect(result, hasLength(1));
        expect(result.first.name, equals('Осенний семестр 2023'));
      });

      test('returns matching semesters for query by year', () async {
        final session = sessionBuilder.build();

        final result = await endpoints.semesters.searchSemesters(authenticatedSessionBuilder, query: '2024');

        expect(result, hasLength(2));
        expect(result.map((s) => s.name), containsAll(['Весенний семестр 2024', 'Летний семестр 2024']));
      });

      test('returns empty for non-matching query', () async {
        // final session = sessionBuilder.build();

        final result = await endpoints.semesters.searchSemesters(authenticatedSessionBuilder, query: 'Несуществующий семестр');

        expect(result, isEmpty);
      });

      test('handles multi-word queries', () async {
        final session = sessionBuilder.build();

        final result = await endpoints.semesters.searchSemesters(authenticatedSessionBuilder, query: 'Весенний семестр');

        expect(result, hasLength(1));
        expect(result.first.name, equals('Весенний семестр 2024'));
      });

      test('is case-insensitive', () async {
        final session = sessionBuilder.build();

        final result = await endpoints.semesters.searchSemesters(authenticatedSessionBuilder, query: 'оСеНнИй');

        expect(result, hasLength(1));
        expect(result.first.name, equals('Осенний семестр 2023'));
      });
    });
  });
}