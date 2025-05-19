import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as auth;
import '../generated/protocol.dart';
import '../custom_scope.dart';

class UserRolesEndpoint extends Endpoint {
  @override
  bool get requireAuth => true;
  
  @override
  Set<String> get requiredRoles => {CustomScope.documentSpecialist.name!};
  
  // Получить все роли пользователя
  Future<List<String>> getUserRoles(Session session, int personId) async {
    var person = await Person.db.findById(session, personId);
    if (person == null || person.userInfo == null) {
      return [];
    }
    
    return person.userInfo!.scopeNames;
  }
  
  // Назначить роль куратора преподавателю
  Future<bool> assignCuratorRole(Session session, int teacherId) async {
    var teacher = await Teachers.db.findById(session, teacherId);
    if (teacher == null) return false;
    
    var person = await Person.db.findById(session, teacher.personId);
    if (person == null || person.userInfo == null) return false;
    
    // Проверяем, есть ли у пользователя роль teacher
    if (!person.userInfo!.scopeNames.contains(CustomScope.teacher.name)) {
      return false;
    }
    
    // Добавляем роль curator
    var scopes = person.userInfo!.scopeNames.toSet();
    if (!scopes.contains(CustomScope.curator.name) && CustomScope.curator.name != null) {
      scopes.add(CustomScope.curator.name!);
      var userInfo = person.userInfo!.copyWith(scopeNames: scopes.toList());
      await auth.UserInfo.db.updateRow(session, userInfo);
    }
    
    return true;
  }
  
  // Назначить роль старосты студенту
  Future<bool> assignGroupHeadRole(Session session, int studentId) async {
    var student = await Students.db.findById(session, studentId);
    if (student == null) return false;
    
    var person = await Person.db.findById(session, student.personId);
    if (person == null || person.userInfo == null) return false;
    
    // Проверяем, есть ли у пользователя роль student
    if (!person.userInfo!.scopeNames.contains(CustomScope.student.name)) {
      return false;
    }
    
    // Добавляем роль groupHead
    var scopes = person.userInfo!.scopeNames.toSet();
    if (!scopes.contains(CustomScope.groupHead.name) && CustomScope.groupHead.name != null) {
      scopes.add(CustomScope.groupHead.name!);
      var userInfo = person.userInfo!.copyWith(scopeNames: scopes.toList());
      await auth.UserInfo.db.updateRow(session, userInfo);
    }
    
    return true;
  }
  
  // Удалить роль у пользователя
  Future<bool> removeRole(Session session, int personId, String role) async {
    // Нельзя удалить базовые роли
    if (role == CustomScope.student.name || role == CustomScope.teacher.name) {
      return false;
    }
    
    var person = await Person.db.findById(session, personId);
    if (person == null || person.userInfo == null) return false;
    
    var scopes = person.userInfo!.scopeNames.toSet();
    if (scopes.contains(role)) {
      scopes.remove(role);
      var userInfo = person.userInfo!.copyWith(scopeNames: scopes.toList());
      await auth.UserInfo.db.updateRow(session, userInfo);
    }
    
    return true;
  }
}