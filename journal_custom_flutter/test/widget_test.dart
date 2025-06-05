// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journal_custom_flutter/main.dart';
import 'package:journal_custom_flutter/src/account_page.dart';
import 'package:journal_custom_flutter/src/serverpod_client.dart' as serverpod_client;
import 'package:journal_custom_flutter/src/sign_in_page.dart';
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
  
  // Добавляем все необходимые методы SessionManager
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
  
  // Добавляем поддержку слушателей
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
    _notifyListeners(); // Уведомляем слушателей об изменении
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
    // Инициализируем моки перед каждым тестом
    mockSessionManager = MockSessionManager();
    mockClient = MockClient();
    
    // Настраиваем структуру моков
    final mockModules = MockModules();
    final mockAuthModule = MockAuthModule();
    
    mockModules.auth = mockAuthModule;
    mockClient.modules = mockModules;
    
    // Заменяем глобальные переменные на моки
    serverpod_client.sessionManager = mockSessionManager;
    serverpod_client.client = mockClient;
  });

  testWidgets('MyHomePage displays AccountPage when signed in', (WidgetTester tester) async {
    // Создаем мок пользователя
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
    
    // Устанавливаем пользователя в мок
    mockSessionManager.setMockSignedInUser(mockUser);

    // Загружаем виджет MyApp
    await tester.pumpWidget(const MyApp());
    
    // Ждем завершения анимаций
    await tester.pumpAndSettle();

    // Проверяем, что отображается AccountPage
    expect(find.byType(AccountPage), findsOneWidget);
  });

  testWidgets('MyHomePage displays SignInPage when not signed in', (WidgetTester tester) async {
    // Устанавливаем null пользователя (не авторизован)
    mockSessionManager.setMockSignedInUser(null);

    // Загружаем виджет MyApp
    await tester.pumpWidget(const MyApp());
    
    // Ждем завершения анимаций
    await tester.pumpAndSettle();

    // Проверяем, что отображается SignInPage
    expect(find.byType(SignInPage), findsOneWidget);
  });
  
  testWidgets('MyHomePage switches between pages based on auth state', (WidgetTester tester) async {
    // Начинаем с неавторизованного состояния
    mockSessionManager.setMockSignedInUser(null);

    // Загружаем виджет MyApp
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Проверяем, что отображается SignInPage
    expect(find.byType(SignInPage), findsOneWidget);
    expect(find.byType(AccountPage), findsNothing);

    // Эмулируем авторизацию
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
    
    // Устанавливаем пользователя - это автоматически вызовет _notifyListeners()
    mockSessionManager.setMockSignedInUser(mockUser);

    // Даем время для перерисовки после уведомления слушателей
    await tester.pump();
    await tester.pumpAndSettle();

    // Проверяем, что теперь отображается AccountPage
    expect(find.byType(AccountPage), findsOneWidget);
    expect(find.byType(SignInPage), findsNothing);
  });

  testWidgets('SignInPage displays correctly with auth button', (WidgetTester tester) async {
    // Устанавливаем неавторизованное состояние
    mockSessionManager.setMockSignedInUser(null);

    // Загружаем виджет MyApp
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Проверяем, что отображается SignInPage
    expect(find.byType(SignInPage), findsOneWidget);

    // Проверяем наличие виджета SignInWithEmailButton
    expect(find.byType(SignInWithEmailButton), findsOneWidget);

    // Проверяем наличие заголовка
    expect(find.text('Журнал посещаемости'), findsOneWidget);

    // Проверяем наличие текста кнопки входа
    expect(find.text('Войти с Email'), findsOneWidget);

    // Проверяем наличие логотипа (Image)
    expect(find.byType(Image), findsOneWidget);

    // Проверяем, что можно нажать на кнопку входа по тексту
    await tester.tap(find.text('Войти с Email'));
    await tester.pumpAndSettle();

    // После нажатия может появиться диалог входа
    // (здесь можно добавить проверки для диалога, если нужно)
  });

  testWidgets('AccountPage displays user information when signed in', (WidgetTester tester) async {
    // Создаем мок пользователя с тестовыми данными
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
    
    // Устанавливаем пользователя в мок
    mockSessionManager.setMockSignedInUser(mockUser);

    // Загружаем виджет MyApp
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Проверяем, что отображается AccountPage
    expect(find.byType(AccountPage), findsOneWidget);

    // Проверяем наличие email пользователя
    expect(find.text('test@example.com'), findsOneWidget);
    
    // Проверяем наличие кнопки выхода
    expect(find.text('Выйти'), findsOneWidget);
  });
}

