import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as auth; // Используем префикс auth
import '../generated/protocol.dart';
import '../custom_scope.dart'; // Убедитесь, что CustomScope.curator.name и другие существуют и не null

class UserRolesEndpoint extends Endpoint {
  @override
  bool get requireAuth => true;

  @override
  Set<String> get requiredRoles => {CustomScope.documentSpecialist.name!}; // Пример, настройте под свои нужды

  // Получить все роли пользователя по personId
  Future<List<String>> getUserRoles(Session session, int personId) async {
    var person = await Person.db.findById(
      session,
      personId,
      include: Person.include(userInfo: auth.UserInfo.include()),
    );
    if (person == null || person.userInfo == null) {
      session.log('UserRolesEndpoint.getUserRoles: Person or UserInfo not found for personId: $personId', level: LogLevel.debug);
      return [];
    }
    return person.userInfo!.scopeNames;
  }

  // Общий метод для назначения роли пользователю по personId
  Future<bool> assignRole(Session session, int personId, String roleToAssign) async {
    if (roleToAssign.isEmpty) {
      session.log('UserRolesEndpoint.assignRole: roleToAssign cannot be empty.', level: LogLevel.warning);
      return false;
    }

    var person = await Person.db.findById(
      session,
      personId,
      // Нам нужен userInfoId для Users.updateUserScopes
    );
    if (person == null || person.userInfoId == null) {
      session.log('UserRolesEndpoint.assignRole: Person or userInfoId not found for personId: $personId', level: LogLevel.warning);
      return false;
    }

    // Получаем текущие scopes пользователя
    var currentUserInfo = await auth.Users.findUserByUserId(session, person.userInfoId!);
    if (currentUserInfo == null) {
        session.log('UserRolesEndpoint.assignRole: Could not retrieve UserInfo for userInfoId: ${person.userInfoId}', level: LogLevel.error);
        return false;
    }

    var currentScopes = currentUserInfo.scopeNames.toSet();

    if (!currentScopes.contains(roleToAssign)) {
      currentScopes.add(roleToAssign);
      // Users.updateUserScopes ожидает Set<Scope>, но в serverpod_auth_server он принимает Set<String>
      // Если у вас Scope это enum, то нужно будет преобразовать Set<String> в Set<Scope>
      // В данном контексте, если CustomScope.curator.name! это строка, то все в порядке.
      await auth.Users.updateUserScopes(
        session,
        person.userInfoId!,
        currentScopes.map((scopeName) => Scope(scopeName)).toSet(),
      );
      session.log('UserRolesEndpoint.assignRole: Role "$roleToAssign" assigned to personId: $personId (UserInfo ID: ${person.userInfoId})', level: LogLevel.info);
      return true;
    } else {
      session.log('UserRolesEndpoint.assignRole: User (personId: $personId) already has role "$roleToAssign".', level: LogLevel.debug);
      return true; // Роль уже есть, считаем операцию успешной
    }
  }

  // Назначить роль куратора преподавателю
  Future<bool> assignCuratorRole(Session session, int teacherId) async {
    var teacher = await Teachers.db.findById(session, teacherId);
    if (teacher == null || teacher.personId == null) {
      session.log('UserRolesEndpoint.assignCuratorRole: Teacher not found or personId is null for teacherId: $teacherId', level: LogLevel.warning);
      return false;
    }
    // Убедимся, что CustomScope.curator.name не null
    if (CustomScope.curator.name == null) {
        session.log('UserRolesEndpoint.assignCuratorRole: CustomScope.curator.name is null.', level: LogLevel.error);
        return false;
    }
    return await assignRole(session, teacher.personId, CustomScope.curator.name!);
  }

  // Назначить роль старосты студенту
  Future<bool> assignGroupHeadRole(Session session, int studentId) async {
    var student = await Students.db.findById(session, studentId);
    if (student == null || student.personId == null) {
      session.log('UserRolesEndpoint.assignGroupHeadRole: Student not found or personId is null for studentId: $studentId', level: LogLevel.warning);
      return false;
    }
    // Убедимся, что CustomScope.groupHead.name не null
    if (CustomScope.groupHead.name == null) {
        session.log('UserRolesEndpoint.assignGroupHeadRole: CustomScope.groupHead.name is null.', level: LogLevel.error);
        return false;
    }
    return await assignRole(session, student.personId, CustomScope.groupHead.name!);
  }

  // Удалить роль у пользователя по personId
  Future<bool> removeRole(Session session, int personId, String roleToRemove) async {
    if (roleToRemove.isEmpty) {
      session.log('UserRolesEndpoint.removeRole: roleToRemove cannot be empty.', level: LogLevel.warning);
      return false;
    }
    // Пример: Нельзя удалить базовые роли, если они определены как таковые и управляются иначе
    // if (roleToRemove == CustomScope.student.name || roleToRemove == CustomScope.teacher.name) {
    //   session.log('UserRolesEndpoint.removeRole: Cannot remove base role "$roleToRemove".', level: LogLevel.warning);
    //   return false;
    // }

    var person = await Person.db.findById(
      session,
      personId,
      // Нам нужен userInfoId для Users.updateUserScopes
    );
    if (person == null || person.userInfoId == null) {
      session.log('UserRolesEndpoint.removeRole: Person or userInfoId not found for personId: $personId', level: LogLevel.warning);
      return false;
    }

    var currentUserInfo = await auth.Users.findUserByUserId(session, person.userInfoId!);
     if (currentUserInfo == null) {
        session.log('UserRolesEndpoint.removeRole: Could not retrieve UserInfo for userInfoId: ${person.userInfoId}', level: LogLevel.error);
        return false;
    }

    var currentScopes = currentUserInfo.scopeNames.toSet();

    if (currentScopes.contains(roleToRemove)) {
      currentScopes.remove(roleToRemove);
      await auth.Users.updateUserScopes(
        session,
        person.userInfoId!,
        currentScopes.map((scopeName) => Scope(scopeName)).toSet(),
      );
      session.log('UserRolesEndpoint.removeRole: Role "$roleToRemove" removed from personId: $personId (UserInfo ID: ${person.userInfoId})', level: LogLevel.info);
      return true;
    } else {
      session.log('UserRolesEndpoint.removeRole: User (personId: $personId) does not have role "$roleToRemove".', level: LogLevel.debug);
      return true; // Роли нет, считаем операцию успешной
    }
  }
}