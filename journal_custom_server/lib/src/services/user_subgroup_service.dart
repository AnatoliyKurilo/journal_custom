import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import '../generated/protocol.dart';

class UserSubgroupService {
  // Получить подгруппы, доступные пользователю
  static Future<List<int>> getUserAccessibleSubgroupIds(Session session) async {
    var userId = (await session.authenticated)!.userId;
    var authUser = await Users.findUserByUserId(session, userId);
    if (authUser == null) return [];

    // Администраторы видят все подгруппы
    if (authUser.scopeNames.contains('serverpod.admin')) {
      final allSubgroups = await Subgroups.db.find(session);
      return allSubgroups.map((s) => s.id!).toList();
    }

    // Находим связанную запись Person
    final person = await Person.db.findFirstRow(
      session,
      where: (p) => p.userInfoId.equals(userId),
    );
    if (person == null) return [];

    Set<int> accessibleSubgroupIds = {};

    // Если пользователь студент - добавляем его подгруппы
    if (authUser.scopeNames.contains('student')) {
      final student = await Students.db.findFirstRow(
        session,
        where: (s) => s.personId.equals(person.id!),
      );
      
      if (student != null) {
        final studentSubgroups = await StudentSubgroup.db.find(
          session,
          where: (ss) => ss.studentsId.equals(student.id!),
        );
        accessibleSubgroupIds.addAll(
          studentSubgroups.map((ss) => ss.subgroupsId),
        );
      }
    }

    // Если пользователь куратор - добавляем все подгруппы его групп
    if (authUser.scopeNames.contains('curator')) {
      final teacher = await Teachers.db.findFirstRow(
        session,
        where: (t) => t.personId.equals(person.id!),
      );
      
      if (teacher != null) {
        final curatedGroups = await Groups.db.find(
          session,
          where: (g) => g.curatorId.equals(teacher.id!),
        );
        
        for (final group in curatedGroups) {
          final groupSubgroups = await Subgroups.db.find(
            session,
            where: (s) => s.groupsId.equals(group.id!),
          );
          accessibleSubgroupIds.addAll(
            groupSubgroups.map((s) => s.id!),
          );
        }
      }
    }

    // Если пользователь староста - добавляем все подгруппы его группы
    if (authUser.scopeNames.contains('groupHead')) {
      final student = await Students.db.findFirstRow(
        session,
        where: (s) => s.personId.equals(person.id!) & s.isGroupHead.equals(true),
      );
      
      if (student != null) {
        final groupSubgroups = await Subgroups.db.find(
          session,
          where: (s) => s.groupsId.equals(student.groupsId),
        );
        accessibleSubgroupIds.addAll(
          groupSubgroups.map((s) => s.id!),
        );
      }
    }

    // Если пользователь преподаватель - добавляем подгруппы, где он ведет занятия
    if (authUser.scopeNames.contains('teacher')) {
      final teacher = await Teachers.db.findFirstRow(
        session,
        where: (t) => t.personId.equals(person.id!),
      );
      
      if (teacher != null) {
        final teacherClasses = await Classes.db.find(
          session,
          where: (c) => c.teachersId.equals(teacher.id!),
        );
        accessibleSubgroupIds.addAll(
          teacherClasses.map((c) => c.subgroupsId!),
        );
      }
    }

    return accessibleSubgroupIds.toList();
  }

  // Проверить, имеет ли пользователь доступ к конкретной подгруппе
  static Future<bool> hasAccessToSubgroup(Session session, int subgroupId) async {
    final accessibleIds = await getUserAccessibleSubgroupIds(session);
    return accessibleIds.contains(subgroupId);
  }

  // Получить предметы с занятиями, доступными пользователю
  static Future<List<Subjects>> getUserAccessibleSubjectsWithClasses(Session session) async {
    final accessibleSubgroupIds = await getUserAccessibleSubgroupIds(session);
    
    if (accessibleSubgroupIds.isEmpty) {
      return [];
    }

    // Получаем все занятия доступных подгрупп
    final accessibleClasses = await Classes.db.find(
      session,
      where: (c) => c.subgroupsId.inSet(accessibleSubgroupIds.toSet()),
    );

    if (accessibleClasses.isEmpty) {
      return [];
    }

    // Получаем уникальные ID предметов
    final subjectIds = accessibleClasses
        .map((c) => c.subjectsId)
        .toSet()
        .toList();

    // Получаем предметы
    return await Subjects.db.find(
      session,
      where: (s) => s.id.inSet(subjectIds.toSet()),
      orderBy: (s) => s.name,
    );
  }
}