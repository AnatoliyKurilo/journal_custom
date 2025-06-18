// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journal_custom_flutter/main.dart';
import 'package:journal_custom_flutter/src/features/auth/presentation/pages/account_page.dart';
import 'package:journal_custom_flutter/core/serverpod_client.dart' as serverpod_client;
import 'package:journal_custom_flutter/src/features/auth/presentation/pages/sign_in_page.dart';
import 'package:mockito/mockito.dart';
import 'package:serverpod_auth_email_flutter/serverpod_auth_email_flutter.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart';
import 'package:journal_custom_client/journal_custom_client.dart';

// Создаем мок для sessionManager
class MockSessionManager extends Mock implements SessionManager {
  UserInfo? _mockSignedInUser;
  final List<VoidCallback> _listeners = [];
  
  @override
  UserInfo? get signedInUser => _mockSignedInUser;
  
  @override
  bool get isSignedIn => _mockSignedInUser != null;
  
  @override
  Stream<UserInfo?> get onUserChanged => Stream.value(_mockSignedInUser);
  
  @override
  Future<UserInfo?> signInWithEmail(String email, String password) async {
    return _mockSignedInUser;
  }
  
  @override
  Future<bool> signOut() async {
    _mockSignedInUser = null;
    _notifyListeners();
    return true;
  }
  
  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }
  
  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }
  
  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }
  
  void setMockSignedInUser(UserInfo? user) {
    _mockSignedInUser = user;
    _notifyListeners();
  }
}

// Создаем мок для Client
class MockClient extends Mock implements Client {
  Modules? _modules;
  
  @override
  Modules get modules => _modules ??= MockModules();
  
  set modules(Modules value) {
    _modules = value;
  }
}

// Создаем мок для Modules
class MockModules extends Mock implements Modules {
  Caller? _auth;
  
  @override
  Caller get auth => _auth ??= MockAuthModule();
  
  set auth(Caller value) {
    _auth = value;
  }
}

// Создаем мок для AuthModule
class MockAuthModule extends Mock implements Caller {
  @override
  Future<UserInfo?> signInWithEmail(String email, String password) async {
    return null;
  }
  
  @override
  Future<void> signOut() async {
    // Mock implementation
  }
}

void main() {
  late MockSessionManager mockSessionManager;
  late MockClient mockClient;

  setUp(() {
    mockSessionManager = MockSessionManager();
    mockClient = MockClient();
    
    final mockModules = MockModules();
    final mockAuthModule = MockAuthModule();
    
    mockModules.auth = mockAuthModule;
    mockClient.modules = mockModules;
    
    serverpod_client.sessionManager = mockSessionManager;
    serverpod_client.client = mockClient;
  });

  group('App Navigation Tests', () {
    testWidgets('MyHomePage displays AccountPage when signed in', (WidgetTester tester) async {
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

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.byType(AccountPage), findsOneWidget);
    });

    testWidgets('MyHomePage displays SignInPage when not signed in', (WidgetTester tester) async {
      mockSessionManager.setMockSignedInUser(null);

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.byType(SignInPage), findsOneWidget);
    });
    
    testWidgets('MyHomePage switches between pages based on auth state', (WidgetTester tester) async {
      mockSessionManager.setMockSignedInUser(null);

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.byType(SignInPage), findsOneWidget);
      expect(find.byType(AccountPage), findsNothing);

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

      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byType(AccountPage), findsOneWidget);
      expect(find.byType(SignInPage), findsNothing);
    });
  });

  group('SignInPage Widget Tests', () {
    testWidgets('displays all required elements', (WidgetTester tester) async {
      mockSessionManager.setMockSignedInUser(null);

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.byType(SignInPage), findsOneWidget);
      expect(find.byType(SignInWithEmailButton), findsOneWidget);
      expect(find.text('Журнал посещаемости'), findsOneWidget);
      expect(find.text('Войти с Email'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('logo image loads correctly', (WidgetTester tester) async {
      mockSessionManager.setMockSignedInUser(null);

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);

      final Image image = tester.widget(imageFinder);
      expect(image.height, equals(150));
    });

    testWidgets('sign in button is interactive', (WidgetTester tester) async {
      mockSessionManager.setMockSignedInUser(null);

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final buttonFinder = find.byType(SignInWithEmailButton);
      expect(buttonFinder, findsOneWidget);

      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();
    });
  });

  group('AccountPage Navigation Tests', () {
    testWidgets('displays admin panel button for admin users', (WidgetTester tester) async {
      final mockUser = UserInfo(
        id: 1,
        userIdentifier: 'admin@example.com',
        email: 'admin@example.com',
        userName: 'Admin User',
        fullName: 'Admin User',
        created: DateTime.now(),
        imageUrl: null,
        scopeNames: ['serverpod.admin'], // ИСПРАВЛЕНО: правильная роль админа
        blocked: false,
      );
      
      mockSessionManager.setMockSignedInUser(mockUser);

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // ИСПРАВЛЕНО: правильный текст кнопки
      expect(find.text('Панель администратора'), findsOneWidget);
    });

    testWidgets('displays different options for different user roles', (WidgetTester tester) async {
      // Тест для куратора
      final curatorUser = UserInfo(
        id: 1,
        userIdentifier: 'curator@example.com',
        email: 'curator@example.com',
        userName: 'Curator User',
        fullName: 'Curator User',
        created: DateTime.now(),
        imageUrl: null,
        scopeNames: ['curator'],
        blocked: false,
      );
      
      mockSessionManager.setMockSignedInUser(curatorUser);

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.text('Управление посещаемостью'), findsOneWidget);
      expect(find.text('Просмотр посещаемости'), findsOneWidget);
      expect(find.text('Панель администратора'), findsNothing);
    });

    testWidgets('displays group head options', (WidgetTester tester) async {
      final groupHeadUser = UserInfo(
        id: 1,
        userIdentifier: 'grouphead@example.com',
        email: 'grouphead@example.com',
        userName: 'Group Head User',
        fullName: 'Group Head User',
        created: DateTime.now(),
        imageUrl: null,
        scopeNames: ['groupHead'],
        blocked: false,
      );
      
      mockSessionManager.setMockSignedInUser(groupHeadUser);

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.text('Управление подгруппами'), findsOneWidget);
      expect(find.text('Управление посещаемостью'), findsOneWidget);
      expect(find.text('Просмотр посещаемости'), findsOneWidget);
    });

    testWidgets('regular user sees only basic options', (WidgetTester tester) async {
      final regularUser = UserInfo(
        id: 1,
        userIdentifier: 'user@example.com',
        email: 'user@example.com',
        userName: 'Regular User',
        fullName: 'Regular User',
        created: DateTime.now(),
        imageUrl: null,
        scopeNames: ['student'], // обычный студент
        blocked: false,
      );
      
      mockSessionManager.setMockSignedInUser(regularUser);

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.text('Просмотр посещаемости'), findsOneWidget);
      expect(find.text('Выйти'), findsOneWidget);
      expect(find.text('Панель администратора'), findsNothing);
      expect(find.text('Управление подгруппами'), findsNothing);
      expect(find.text('Управление посещаемостью'), findsNothing);
    });
  });

  group('Auth Functionality Tests', () {
    testWidgets('sign out functionality works correctly', (WidgetTester tester) async {
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

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.byType(AccountPage), findsOneWidget);
      
      await tester.tap(find.text('Выйти'));
      await tester.pumpAndSettle();

      expect(find.byType(SignInPage), findsOneWidget);
      expect(find.byType(AccountPage), findsNothing);
    });

    testWidgets('app handles null user gracefully', (WidgetTester tester) async {
      mockSessionManager.setMockSignedInUser(null);

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(SignInPage), findsOneWidget);
    });

    testWidgets('app handles multiple auth state changes', (WidgetTester tester) async {
      mockSessionManager.setMockSignedInUser(null);

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.byType(SignInPage), findsOneWidget);

      // Первая авторизация
      final user1 = UserInfo(
        id: 1,
        userIdentifier: 'user1@example.com',
        email: 'user1@example.com',
        userName: 'User 1',
        fullName: 'User 1',
        created: DateTime.now(),
        imageUrl: null,
        scopeNames: ['user'],
        blocked: false,
      );
      
      mockSessionManager.setMockSignedInUser(user1);
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byType(AccountPage), findsOneWidget);

      // Выход
      mockSessionManager.setMockSignedInUser(null);
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byType(SignInPage), findsOneWidget);

      // Вторая авторизация с другим пользователем
      final user2 = UserInfo(
        id: 2,
        userIdentifier: 'user2@example.com',
        email: 'user2@example.com',
        userName: 'User 2',
        fullName: 'User 2',
        created: DateTime.now(),
        imageUrl: null,
        scopeNames: ['serverpod.admin'],
        blocked: false,
      );
      
      mockSessionManager.setMockSignedInUser(user2);
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byType(AccountPage), findsOneWidget);
      expect(find.text('Панель администратора'), findsOneWidget);
    });
  });

  group('User Interface Tests', () {
    testWidgets('displays user information correctly', (WidgetTester tester) async {
      final mockUser = UserInfo(
        id: 1,
        userIdentifier: 'test@example.com',
        email: 'test@example.com',
        userName: 'Test User Name',
        fullName: 'Full Test User Name',
        created: DateTime.now(),
        imageUrl: null,
        scopeNames: ['user'],
        blocked: false,
      );
      
      mockSessionManager.setMockSignedInUser(mockUser);

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('Профиль пользователя'), findsOneWidget);
    });

    testWidgets('app state persists during rebuilds', (WidgetTester tester) async {
      final mockUser = UserInfo(
        id: 1,
        userIdentifier: 'persistent@example.com',
        email: 'persistent@example.com',
        userName: 'Persistent User',
        fullName: 'Persistent User',
        created: DateTime.now(),
        imageUrl: null,
        scopeNames: ['user'],
        blocked: false,
      );
      
      mockSessionManager.setMockSignedInUser(mockUser);

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.text('persistent@example.com'), findsOneWidget);

      // Инициируем перестройку
      await tester.pump();
      await tester.pumpAndSettle();

      // Состояние должно сохраниться
      expect(find.text('persistent@example.com'), findsOneWidget);
      expect(find.byType(AccountPage), findsOneWidget);
    });

    testWidgets('app handles blocked user correctly', (WidgetTester tester) async {
      final blockedUser = UserInfo(
        id: 1,
        userIdentifier: 'blocked@example.com',
        email: 'blocked@example.com',
        userName: 'Blocked User',
        fullName: 'Blocked User',
        created: DateTime.now(),
        imageUrl: null,
        scopeNames: ['user'],
        blocked: true, // Заблокированный пользователь
      );
      
      mockSessionManager.setMockSignedInUser(blockedUser);

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Приложение должно корректно обработать заблокированного пользователя
      expect(tester.takeException(), isNull);
      // В зависимости от логики, можно проверить отображение AccountPage или SignInPage
    });
  });

  group('Button Interaction Tests', () {
    testWidgets('navigation buttons work correctly', (WidgetTester tester) async {
      final adminUser = UserInfo(
        id: 1,
        userIdentifier: 'admin@example.com',
        email: 'admin@example.com',
        userName: 'Admin User',
        fullName: 'Admin User',
        created: DateTime.now(),
        imageUrl: null,
        scopeNames: ['serverpod.admin', 'groupHead'],
        blocked: false,
      );
      
      mockSessionManager.setMockSignedInUser(adminUser);

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Проверяем, что кнопки отображаются и можно по ним нажать
      expect(find.text('Панель администратора'), findsOneWidget);
      expect(find.text('Управление подгруппами'), findsOneWidget);
      expect(find.text('Просмотр посещаемости'), findsOneWidget);

      // Тестируем нажатие (без фактической навигации в тестах)
      await tester.tap(find.text('Просмотр посещаемости'));
      await tester.pumpAndSettle();

      // Проверяем, что не произошло исключений
      expect(tester.takeException(), isNull);
    });
  });
}




