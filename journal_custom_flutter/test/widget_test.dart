// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
//
// import 'package:PROJECTNAME_flutter/main.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journal_custom_client/journal_custom_client.dart';
import 'package:journal_custom_flutter/src/serverpod_client.dart' as serverpod;
import 'package:journal_custom_flutter/src/sign_in_page.dart';
import 'package:mockito/annotations.dart'; // Для аннотации @GenerateMocks
import 'package:mockito/mockito.dart'; // Для when, any и т.д.
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as auth_client;
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Генерируем мок для FlutterSecureStorage
@GenerateMocks([FlutterSecureStorage])
import 'widget_test.mocks.dart'; // Этот файл будет сгенерирован

void main() {
  // Переменные для моков
  late MockFlutterSecureStorage mockSecureStorage;
  late auth_client.FlutterAuthenticationKeyManager testAuthKeyManager;

  // Группа тестов для SignInPage
  group('SignInPage Widget Tests', () {
    setUp(() async {
      // Создаем мок для FlutterSecureStorage
      mockSecureStorage = MockFlutterSecureStorage();

      // Настраиваем поведение мока (например, возвращать null при чтении, если ключ не найден)
      // Это важно, чтобы FlutterAuthenticationKeyManager не падал при попытке чтения.
      when(mockSecureStorage.read(key: anyNamed('key'))).thenAnswer((_) async => null);
      when(mockSecureStorage.write(key: anyNamed('key'), value: anyNamed('value'))).thenAnswer((_) async {});
      when(mockSecureStorage.delete(key: anyNamed('key'))).thenAnswer((_) async {});


      // Создаем FlutterAuthenticationKeyManager с мокированным хранилищем
      testAuthKeyManager = auth_client.FlutterAuthenticationKeyManager(
        mockSecureStorage, // Передаем мок
        'test_auth_key',   // Любой ключ для теста
      );

      // Инициализируем глобальный объект client
      serverpod.client = Client(
        'http://localhost:8080/',
        authenticationKeyManager: testAuthKeyManager, // Используем наш настроенный менеджер
      );

      // Инициализируем глобальный объект sessionManager
      serverpod.sessionManager = SessionManager(
        caller: serverpod.client.modules.auth,
      );

      // Важно: Инициализируем sessionManager, так как он будет пытаться прочитать ключ
      // из authenticationKeyManager (который теперь использует мокированное хранилище).
      // Это должно предотвратить ошибки, связанные с неинициализированным состоянием.
      await serverpod.sessionManager.initialize();
    });

    testWidgets('App starts with SignInPage and renders key elements', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          // Важно добавить делегаты локализации, если SignInPage или его дочерние виджеты
          // (например, SignInWithEmailButton) их используют.
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            ServerpodAuthSharedFlutterLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en', ''),
            Locale('ru', ''),
          ],
          home: SignInPage(),
        ),
      );

      expect(find.text('Журнал посещаемости'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      expect(find.widgetWithText(SignInWithEmailButton, 'Войти с Email'), findsOneWidget);
    });
  });
}
