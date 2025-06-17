import 'package:journal_custom_server/src/custom_scope.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import '../generated/protocol.dart';

class PermissionService {
  // Проверка прав на управление подгруппами группы
  static Future<bool> canManageGroupSubgroups(Session session, int groupId) async {
    var userId = (await session.authenticated)!.userId;
    var authUser = await Users.findUserByUserId(session, userId);
    if (authUser == null) return false;

    // Администраторы имеют полный доступ
    if (authUser.scopes.contains(CustomScope.documentSpecialist)||authUser.scopes.contains(Scope.admin)) {
      return true;
    }

    // Находим связанную запись Person
    final person = await Person.db.findFirstRow(
      session,
      where: (p) => p.userInfoId.equals(userId),
    );
    if (person == null) return false;

    // Проверка на старосту группы
    if (authUser.scopeNames.contains('groupHead')) {
      final student = await Students.db.findFirstRow(
        session,
        where: (s) => s.personId.equals(person.id!) & s.groupsId.equals(groupId) & s.isGroupHead.equals(true),
      );
      if (student != null) return true;
    }

    // Проверка на куратора группы
    if (authUser.scopeNames.contains('curator')) {
      final teacher = await Teachers.db.findFirstRow(
        session,
        where: (t) => t.personId.equals(person.id!),
      );
      
      if (teacher != null) {
        final group = await Groups.db.findById(session, groupId);
        if (group != null && group.curatorId == teacher.id) {
          return true;
        }
      }
    }

    return false;
  }

  // Получение группы текущего пользователя
  static Future<Groups?> getCurrentUserGroup(Session session) async {
    var userId = (await session.authenticated)!.userId;
    var authUser = await Users.findUserByUserId(session, userId);
    if (authUser == null) return null;

    // Для админов возвращаем первую группу
    if (authUser.scopeNames.contains('serverpod.admin')) {
      var allGroups = await Groups.db.find(session, limit: 1);
      return allGroups.isNotEmpty ? allGroups.first : null;
    }

    final person = await Person.db.findFirstRow(
      session,
      where: (p) => p.userInfoId.equals(userId),
    );
    if (person == null) return null;

    // Проверка на старосту группы
    if (authUser.scopeNames.contains('groupHead')) {
      final student = await Students.db.findFirstRow(
        session,
        where: (s) => s.personId.equals(person.id!) & s.isGroupHead.equals(true),
      );

      if (student != null) {
        return await Groups.db.findById(session, student.groupsId);
      }
    }

    // Проверка на куратора группы
    if (authUser.scopeNames.contains('curator')) {
      final teacher = await Teachers.db.findFirstRow(
        session,
        where: (t) => t.personId.equals(person.id!),
      );

      if (teacher != null) {
        final groups = await Groups.db.find(
          session,
          where: (g) => g.curatorId.equals(teacher.id!),
          limit: 1,
        );
        
        if (groups.isNotEmpty) {
          return groups.first;
        }
      }
    }

    return null;
  }

  // Проверка прав на просмотр подгрупп группы
  static Future<bool> canViewGroupSubgroups(Session session, int groupId) async {
    var userId = (await session.authenticated)!.userId;
    var authUser = await Users.findUserByUserId(session, userId);
    if (authUser == null) return false;

    // Администраторы и документалисты имеют полный доступ
    if (authUser.scopes.contains(CustomScope.documentSpecialist) || authUser.scopes.contains(Scope.admin)) {
      return true;
    }

    // Находим связанную запись Person
    final person = await Person.db.findFirstRow(
      session,
      where: (p) => p.userInfoId.equals(userId),
    );
    if (person == null) return false;

    // Проверка на старосту группы
    if (authUser.scopeNames.contains('groupHead')) {
      final student = await Students.db.findFirstRow(
        session,
        where: (s) => s.personId.equals(person.id!) & s.groupsId.equals(groupId) & s.isGroupHead.equals(true),
      );
      if (student != null) return true;
    }

    // Проверка на куратора группы
    if (authUser.scopeNames.contains('curator')) {
      final teacher = await Teachers.db.findFirstRow(
        session,
        where: (t) => t.personId.equals(person.id!),
      );

      if (teacher != null) {
        final group = await Groups.db.findById(session, groupId);
        if (group != null && group.curatorId == teacher.id) {
          return true;
        }
      }
    }

    // Проверка на студентов группы
    if (authUser.scopeNames.contains('student')) {
      final student = await Students.db.findFirstRow(
        session,
        where: (s) => s.personId.equals(person.id!) & s.groupsId.equals(groupId),
      );
      if (student != null) return true;
    }

    return false;
  }

  // Проверка прав на просмотр предметов группы
  static Future<bool> canViewGroupSubjects(Session session, int groupId) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) return false;

    final userInfo = await Users.findUserByUserId(session, authInfo.userId);
    if (userInfo == null) return false;

    // Администратор может видеть все
    if (userInfo.scopes.contains(Scope.admin)) {
      return true;
    }

    // Специалист по документообороту может видеть все
    if (userInfo.scopes.contains(CustomScope.documentSpecialist)) {
      return true;
    }

    // Находим связанную запись Person
    final person = await Person.db.findFirstRow(
      session,
      where: (p) => p.userInfoId.equals(authInfo.userId),
    );
    if (person == null) return false;

    // Куратор может видеть свои группы
    if (userInfo.scopes.contains(CustomScope.curator)) {
      final teacher = await Teachers.db.findFirstRow(
        session,
        where: (t) => t.personId.equals(person.id),
      );
      
      if (teacher != null) {
        final group = await Groups.db.findById(session, groupId);
        return group?.curatorId == teacher.id;
      }
    }

    // Староста может видеть свою группу
    if (userInfo.scopes.contains(CustomScope.groupHead)) {
      final student = await Students.db.findFirstRow(
        session,
        where: (s) => s.personId.equals(person.id),
      );
      
      return student?.groupsId == groupId;
    }

    // ДОБАВЛЯЕМ: Преподаватель может видеть группы, в которых ведет занятия
    if (userInfo.scopes.contains(CustomScope.teacher)) {
      final teacher = await Teachers.db.findFirstRow(
        session,
        where: (t) => t.personId.equals(person.id),
      );

      if (teacher != null) {
        final subgroups = await Subgroups.db.find(
          session,
          where: (s) => s.groupsId.equals(groupId),
        );

        if (subgroups.isNotEmpty) {
          final subgroupIds = subgroups.map((s) => s.id!).toSet();

          final teacherClasses = await Classes.db.find(
            session,
            where: (c) => c.teachersId.equals(teacher.id) & c.subgroupsId.inSet(subgroupIds),
            limit: 1,
          );

          return teacherClasses.isNotEmpty;
        }
      }
    }

    // ДОБАВЛЯЕМ: Студент может видеть предметы своей группы
    if (userInfo.scopes.contains(CustomScope.student)) {
      final student = await Students.db.findFirstRow(
        session,
        where: (s) => s.personId.equals(person.id),
      );
      
      return student?.groupsId == groupId;
    }

    return false;
  }
}