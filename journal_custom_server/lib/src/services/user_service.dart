import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as auth;
import '../generated/protocol.dart';

class UserService {
  // Получение Person и UserInfo по personId
  static Future<({Person person, auth.UserInfo userInfo})?> getPersonAndUserInfo(
    Session session, 
    int personId
  ) async {
    var person = await Person.db.findById(session, personId);
    if (person == null || person.userInfoId == null) {
      session.log('UserService.getPersonAndUserInfo: Person or userInfoId not found for personId: $personId', level: LogLevel.warning);
      return null;
    }

    var userInfo = await auth.Users.findUserByUserId(session, person.userInfoId!);
    if (userInfo == null) {
      session.log('UserService.getPersonAndUserInfo: Could not retrieve UserInfo for userInfoId: ${person.userInfoId}', level: LogLevel.error);
      return null;
    }
    
    return (person: person, userInfo: userInfo);
  }

  // Обновление ролей пользователя
  static Future<bool> updateUserScopes(
    Session session, 
    int userInfoId, 
    Set<String> scopes
  ) async {
    try {
      await auth.Users.updateUserScopes(
        session,
        userInfoId,
        scopes.map((scopeName) => Scope(scopeName)).toSet(),
      );
      return true;
    } catch (e) {
      session.log('UserService.updateUserScopes: Error updating scopes: $e', level: LogLevel.error);
      return false;
    }
  }

  // Проверка прав доступа
  static Future<bool> hasAnyRole(Session session, int personId, Set<String> requiredRoles) async {
    final data = await getPersonAndUserInfo(session, personId);
    if (data == null) return false;
    
    return data.userInfo.scopeNames.any((scope) => requiredRoles.contains(scope));
  }
}