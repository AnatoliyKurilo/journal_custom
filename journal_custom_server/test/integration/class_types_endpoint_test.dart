// import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod/serverpod.dart';
import 'package:journal_custom_server/src/endpoints/class_types_endpoint.dart';
import 'package:journal_custom_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {

  withServerpod('Given ClassTypesEndpoint', (sessionBuilder, endpoints) {
    // Пример теста для метода searchStudents (если такой существует в вашем SearchEndpoint)
    // Замените 'searchStudents' и параметры на реальные методы вашего эндпоинта
    var session = sessionBuilder.build();
    const int userId = 1234;
    group('ClassTypesEndpoint', () {
    // late Session session;
    // late ClassTypesEndpoint endpoint;

    setUp(() async {
      // Инициализация сессии и эндпоинта
      // session = await TestSessionBuilder().build();
      // endpoint = ClassTypesEndpoint();

      // Создаем тестовые данные
      await ClassTypes.db.insertRow(session, ClassTypes(id: 1, name: 'Лекция'));
      await ClassTypes.db.insertRow(session, ClassTypes(id: 2, name: 'Практика'));
      await ClassTypes.db.insertRow(session, ClassTypes(id: 3, name: 'Лабораторная работа'));
    });

    // tearDown(() async {
    //   // Очистка данных после тестов
    //   await ClassTypes.db.deleteWhere(session, where: (t) => Constant(true));
    // });

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

    test('searchClassTypes returns all class types for empty query', () async {
      final result = await endpoints.classTypes.searchClassTypes(authenticatedSessionBuilder, query: '');

      // Проверяем, что возвращены все типы занятий
      expect(result, hasLength(3));
      expect(result.map((t) => t.name), containsAll(['Лекция', 'Практика', 'Лабораторная работа']));
    });

    test('searchClassTypes returns matching class types for query', () async {
      final result = await endpoints.classTypes.searchClassTypes(authenticatedSessionBuilder, query: 'Лекция');

      // Проверяем, что возвращен только один тип занятия
      expect(result, hasLength(1));
      expect(result.first.name, equals('Лекция'));
    });

    test('searchClassTypes returns matching class types for partial query', () async {
      final result = await endpoints.classTypes.searchClassTypes(authenticatedSessionBuilder, query: 'Пра');

      // Проверяем, что возвращен только один тип занятия
      expect(result, hasLength(1));
      expect(result.first.name, equals('Практика'));
    });

    test('searchClassTypes returns matching class types for case-insensitive query', () async {
      final result = await endpoints.classTypes.searchClassTypes(authenticatedSessionBuilder, query: 'лЕкЦиЯ');

      // Проверяем, что поиск нечувствителен к регистру
      expect(result, hasLength(1));
      expect(result.first.name, equals('Лекция'));
    });

    test('searchClassTypes returns empty for non-matching query', () async {
      final result = await endpoints.classTypes.searchClassTypes(authenticatedSessionBuilder, query: 'Семинар');

      // Проверяем, что ничего не найдено
      expect(result, isEmpty);
    });

    test('searchClassTypes handles multi-word queries', () async {
      final result = await endpoints.classTypes.searchClassTypes(authenticatedSessionBuilder, query: 'Лабораторная работа');

      // Проверяем, что найдено соответствие для многословного запроса
      expect(result, hasLength(1));
      expect(result.first.name, equals('Лабораторная работа'));
    });
  });


  });
  
}