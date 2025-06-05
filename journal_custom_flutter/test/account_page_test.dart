import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journal_custom_flutter/src/account_page.dart';
import 'package:journal_custom_flutter/src/serverpod_client.dart' as serverpod_client;
import 'package:mockito/mockito.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart';
import 'package:journal_custom_client/journal_custom_client.dart';

// Создаем мок для sessionManager
class MockSessionManager extends Mock implements SessionManager {
  UserInfo? _mockSignedInUser;
  
  @override
  UserInfo? get signedInUser => _mockSignedInUser;
  
  @override
  bool get isSignedIn => _mockSignedInUser != null;
  
  @override
  Future<bool> signOut() async {
    _mockSignedInUser = null;
    return true;
  }
  
  void setMockSignedInUser(UserInfo? user) {
    _mockSignedInUser = user;
  }
}

// Создаем мок для Client
class MockClient extends Mock implements Client {
  Modules? _modules;
  
  @override
  Modules get modules => _modules ??= MockModules();
}

// Создаем мок для Modules
class MockModules extends Mock implements Modules {
  Caller? _auth;
  
  @override
  Caller get auth => _auth ??= MockAuthModule();
}

// Создаем мок для AuthModule
class MockAuthModule extends Mock implements Caller {}

void main() {
  late MockSessionManager mockSessionManager;
  late MockClient mockClient;

  setUp(() {
    mockSessionManager = MockSessionManager();
    mockClient = MockClient();
    
    // Заменяем глобальные переменные на моки
    serverpod_client.sessionManager = mockSessionManager;
    serverpod_client.client = mockClient;
  });

  group('AccountPage Tests', () {
    testWidgets('displays basic user information', (WidgetTester tester) async {
      // Создаем обычного пользователя
      final mockUser = UserInfo(
        id: 1,
        userIdentifier: 'test@example.com',
        email: 'test@example.com',
        userName: 'Test User',
        fullName: 'Test User',
        created: DateTime.now(),
        imageUrl: null,
        scopeNames: ['user'],
        blocked: false,
      );
      
      mockSessionManager.setMockSignedInUser(mockUser);

      await tester.pumpWidget(
        MaterialApp(home: const AccountPage()),
      );
      await tester.pumpAndSettle();

      // Проверяем базовые элементы
      expect(find.byType(AccountPage), findsOneWidget);
      expect(find.text('Профиль пользователя'), findsOneWidget);
      expect(find.text('Курило Анатолий'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('Выйти'), findsOneWidget);
      expect(find.text('Просмотр посещаемости'), findsOneWidget);
    });

    testWidgets('displays admin panel button for admin users', (WidgetTester tester) async {
      // Создаем пользователя с правами администратора
      final adminUser = UserInfo(
        id: 1,
        userIdentifier: 'admin@example.com',
        email: 'admin@example.com',
        userName: 'Admin User',
        fullName: 'Admin User',
        created: DateTime.now(),
        imageUrl: null,
        scopeNames: ['user', 'serverpod.admin'],
        blocked: false,
      );
      
      mockSessionManager.setMockSignedInUser(adminUser);

      await tester.pumpWidget(
        MaterialApp(home: const AccountPage()),
      );
      await tester.pumpAndSettle();

      // Проверяем наличие кнопок администратора
      expect(find.text('Панель администратора'), findsOneWidget);
      expect(find.text('Убрать права администратора (Тест)'), findsOneWidget);
      expect(find.text('Управление подгруппами'), findsOneWidget);
      expect(find.text('Управление посещаемостью'), findsOneWidget);
    });

    testWidgets('displays group head buttons for group head users', (WidgetTester tester) async {
      // Создаем пользователя с правами старосты
      final groupHeadUser = UserInfo(
        id: 1,
        userIdentifier: 'grouphead@example.com',
        email: 'grouphead@example.com',
        userName: 'Group Head User',
        fullName: 'Group Head User',
        created: DateTime.now(),
        imageUrl: null,
        scopeNames: ['user', 'groupHead'],
        blocked: false,
      );
      
      mockSessionManager.setMockSignedInUser(groupHeadUser);

      await tester.pumpWidget(
        MaterialApp(home: const AccountPage()),
      );
      await tester.pumpAndSettle();

      // Проверяем наличие кнопок старосты
      expect(find.text('Управление подгруппами'), findsOneWidget);
      expect(find.text('Управление посещаемостью'), findsOneWidget);
      
      // Проверяем отсутствие кнопок администратора
      expect(find.text('Панель администратора'), findsNothing);
      expect(find.text('Убрать права администратора (Тест)'), findsNothing);
    });

    testWidgets('displays curator buttons for curator users', (WidgetTester tester) async {
      // Создаем пользователя с правами куратора
      final curatorUser = UserInfo(
        id: 1,
        userIdentifier: 'curator@example.com',
        email: 'curator@example.com',
        userName: 'Curator User',
        fullName: 'Curator User',
        created: DateTime.now(),
        imageUrl: null,
        scopeNames: ['user', 'curator'],
        blocked: false,
      );
      
      mockSessionManager.setMockSignedInUser(curatorUser);

      await tester.pumpWidget(
        MaterialApp(home: const AccountPage()),
      );
      await tester.pumpAndSettle();

      // Проверяем наличие кнопки управления посещаемостью для куратора
      expect(find.text('Управление посещаемостью'), findsOneWidget);
      
      // Проверяем отсутствие кнопок администратора и старосты
      expect(find.text('Панель администратора'), findsNothing);
      expect(find.text('Управление подгруппами'), findsNothing);
    });

    testWidgets('regular user sees only basic buttons', (WidgetTester tester) async {
      // Создаем обычного пользователя без специальных прав
      final regularUser = UserInfo(
        id: 1,
        userIdentifier: 'user@example.com',
        email: 'user@example.com',
        userName: 'Regular User',
        fullName: 'Regular User',
        created: DateTime.now(),
        imageUrl: null,
        scopeNames: ['user'],
        blocked: false,
      );
      
      mockSessionManager.setMockSignedInUser(regularUser);

      await tester.pumpWidget(
        MaterialApp(home: const AccountPage()),
      );
      await tester.pumpAndSettle();

      // Проверяем наличие базовых кнопок
      expect(find.text('Выйти'), findsOneWidget);
      expect(find.text('Просмотр посещаемости'), findsOneWidget);
      
      // Проверяем отсутствие специальных кнопок
      expect(find.text('Панель администратора'), findsNothing);
      expect(find.text('Управление подгруппами'), findsNothing);
      expect(find.text('Управление посещаемостью'), findsNothing);
    });

    testWidgets('sign out button works correctly', (WidgetTester tester) async {
      final mockUser = UserInfo(
        id: 1,
        userIdentifier: 'test@example.com',
        email: 'test@example.com',
        userName: 'Test User',
        fullName: 'Test User',
        created: DateTime.now(),
        imageUrl: null,
        scopeNames: ['user'],
        blocked: false,
      );
      
      mockSessionManager.setMockSignedInUser(mockUser);

      await tester.pumpWidget(
        MaterialApp(home: const AccountPage()),
      );
      await tester.pumpAndSettle();

      // Нажимаем кнопку выхода
      await tester.tap(find.text('Выйти'));
      await tester.pumpAndSettle();

      // Проверяем, что пользователь больше не авторизован
      expect(mockSessionManager.signedInUser, isNull);
      expect(mockSessionManager.isSignedIn, isFalse);
    });

    testWidgets('user with multiple roles sees all relevant buttons', (WidgetTester tester) async {
      // Создаем пользователя с несколькими ролями
      final multiRoleUser = UserInfo(
        id: 1,
        userIdentifier: 'multirole@example.com',
        email: 'multirole@example.com',
        userName: 'Multi Role User',
        fullName: 'Multi Role User',
        created: DateTime.now(),
        imageUrl: null,
        scopeNames: ['user', 'serverpod.admin', 'groupHead', 'curator'],
        blocked: false,
      );
      
      mockSessionManager.setMockSignedInUser(multiRoleUser);

      await tester.pumpWidget(
        MaterialApp(home: const AccountPage()),
      );
      await tester.pumpAndSettle();

      // Проверяем наличие всех кнопок
      expect(find.text('Панель администратора'), findsOneWidget);
      expect(find.text('Убрать права администратора (Тест)'), findsOneWidget);
      expect(find.text('Управление подгруппами'), findsOneWidget);
      expect(find.text('Управление посещаемостью'), findsOneWidget);
      expect(find.text('Просмотр посещаемости'), findsOneWidget);
      expect(find.text('Выйти'), findsOneWidget);
    });

    testWidgets('buttons have correct colors', (WidgetTester tester) async {
      final adminUser = UserInfo(
        id: 1,
        userIdentifier: 'admin@example.com',
        email: 'admin@example.com',
        userName: 'Admin User',
        fullName: 'Admin User',
        created: DateTime.now(),
        imageUrl: null,
        scopeNames: ['user', 'serverpod.admin', 'groupHead', 'curator'],
        blocked: false,
      );
      
      mockSessionManager.setMockSignedInUser(adminUser);

      await tester.pumpWidget(
        MaterialApp(home: const AccountPage()),
      );
      await tester.pumpAndSettle();

      // Проверяем, что кнопки отображаются
      expect(find.byType(ElevatedButton), findsAtLeastNWidgets(5));
      
      // Проверяем, что каждая кнопка имеет соответствующий текст
      final buttonTexts = [
        'Выйти',
        'Убрать права администратора (Тест)',
        'Панель администратора',
        'Управление подгруппами',
        'Управление посещаемостью',
        'Просмотр посещаемости'
      ];
      
      for (final text in buttonTexts) {
        expect(find.text(text), findsOneWidget);
      }
    });

    testWidgets('layout renders correctly with ListView', (WidgetTester tester) async {
      final mockUser = UserInfo(
        id: 1,
        userIdentifier: 'test@example.com',
        email: 'test@example.com',
        userName: 'Test User',
        fullName: 'Test User',
        created: DateTime.now(),
        imageUrl: null,
        scopeNames: ['user'],
        blocked: false,
      );
      
      mockSessionManager.setMockSignedInUser(mockUser);

      await tester.pumpWidget(
        MaterialApp(home: const AccountPage()),
      );
      await tester.pumpAndSettle();

      // Проверяем структуру виджетов
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ListTile), findsOneWidget);
      expect(find.byType(Padding), findsAtLeastNWidgets(1));
    });
  });
}