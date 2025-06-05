import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as auth;
import '../generated/protocol.dart';
import 'package:serverpod_test/src/function_call_wrappers.dart';

class ScopeService {
  /// Возвращает список областей доступа пользователя
  Future<List<String?>> getUserScopes(Session session) async {
    final authInfo = await session.authenticated;

    if (authInfo == null) {
      throw ServerpodUnauthenticatedException();
    }

    return authInfo.scopes.map((scope) => scope.name).toList();
  }

  /// Проверяет, имеет ли пользователь необходимые области доступа
  static Future<void> checkScopes(Session session, {required Set<Scope> requiredScopes}) async {
    final authInfo = await session.authenticated;

    if (authInfo == null) {
      throw ServerpodUnauthenticatedException();
    }

    final userScopes = authInfo.scopes.map((scope) => scope.name).toSet();
    final requiredScopeNames = requiredScopes.map((scope) => scope.name).toSet();

    // Проверяем, есть ли пересечение между областями доступа пользователя и необходимыми областями
    if (userScopes.intersection(requiredScopeNames).isEmpty) {
      throw ServerpodInsufficientAccessException();
    }
  }
}