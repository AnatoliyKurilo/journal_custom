import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as auth;
import '../generated/protocol.dart';
import '../custom_scope.dart';
import '../services/user_service.dart';

class UserRolesEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  // @override
  // Set<Scope> get requiredScopes  => {CustomScope.documentSpecialist, Scope.admin, CustomScope.curator, CustomScope.groupHead, CustomScope.teacher, CustomScope.student};

  // Получить все роли пользователя по personId
  Future<List<String>> getUserRoles(Session session, int personId) async {
    final data = await UserService.getPersonAndUserInfo(session, personId);
    return data?.userInfo.scopeNames ?? [];
  }

  // Общий метод для назначения роли пользователю по personId
  Future<bool> assignRole(Session session, int personId, String roleToAssign) async {
    if (roleToAssign.isEmpty) {
      session.log('UserRolesEndpoint.assignRole: roleToAssign cannot be empty.', level: LogLevel.warning);
      return false;
    }

    final data = await UserService.getPersonAndUserInfo(session, personId);
    if (data == null) return false;

    var currentScopes = data.userInfo.scopeNames.toSet();

    if (!currentScopes.contains(roleToAssign)) {
      currentScopes.add(roleToAssign);
      final success = await UserService.updateUserScopes(session, data.person.userInfoId!, currentScopes);
      if (success) {
        session.log('UserRolesEndpoint.assignRole: Role "$roleToAssign" assigned to personId: $personId', level: LogLevel.info);
      }
      return success;
    } else {
      session.log('UserRolesEndpoint.assignRole: User (personId: $personId) already has role "$roleToAssign".', level: LogLevel.debug);
      return true;
    }
  }

  // Удалить роль у пользователя по personId
  Future<bool> removeRole(Session session, int personId, String roleToRemove) async {
    if (roleToRemove.isEmpty) {
      session.log('UserRolesEndpoint.removeRole: roleToRemove cannot be empty.', level: LogLevel.warning);
      return false;
    }

    final data = await UserService.getPersonAndUserInfo(session, personId);
    if (data == null) return false;

    var currentScopes = data.userInfo.scopeNames.toSet();

    if (currentScopes.contains(roleToRemove)) {
      currentScopes.remove(roleToRemove);
      final success = await UserService.updateUserScopes(session, data.person.userInfoId!, currentScopes);
      if (success) {
        session.log('UserRolesEndpoint.removeRole: Role "$roleToRemove" removed from personId: $personId', level: LogLevel.info);
      }
      return success;
    } else {
      session.log('UserRolesEndpoint.removeRole: User (personId: $personId) does not have role "$roleToRemove".', level: LogLevel.debug);
      return true;
    }
  }

  // Назначить роль куратора преподавателю
  Future<bool> assignCuratorRole(Session session, int teacherId) async {
    var teacher = await Teachers.db.findById(session, teacherId);
    if (teacher == null || teacher.personId == null) {
      session.log('UserRolesEndpoint.assignCuratorRole: Teacher not found or personId is null for teacherId: $teacherId', level: LogLevel.warning);
      return false;
    }
    
    if (CustomScope.curator.name == null) {
      session.log('UserRolesEndpoint.assignCuratorRole: CustomScope.curator.name is null.', level: LogLevel.error);
      return false;
    }
    
    return await assignRole(session, teacher.personId!, CustomScope.curator.name!);
  }

  // Назначить роль старосты студенту
  Future<bool> assignGroupHeadRole(Session session, int studentId) async {
    var student = await Students.db.findById(session, studentId);
    if (student == null || student.personId == null) {
      session.log('UserRolesEndpoint.assignGroupHeadRole: Student not found or personId is null for studentId: $studentId', level: LogLevel.warning);
      return false;
    }
    
    if (CustomScope.groupHead.name == null) {
      session.log('UserRolesEndpoint.assignGroupHeadRole: CustomScope.groupHead.name is null.', level: LogLevel.error);
      return false;
    }
    
    return await assignRole(session, student.personId!, CustomScope.groupHead.name!);
  }
}