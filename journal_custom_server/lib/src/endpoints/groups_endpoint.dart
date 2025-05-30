import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'user_roles_endpoint.dart';

class GroupsEndpoint extends Endpoint {
  @override
  bool get requireAuth => true;

  @override
  Set<String> get requiredRoles => {'serverpod.admin'};

  // Создание группы
  Future<Groups> createGroup(Session session, String name, int? curatorId) async {
    var group = Groups(
      name: name,
      curatorId: curatorId,
    );
    return await Groups.db.insertRow(session, group);
  }

  // Получение всех групп
  Future<List<Groups>> getAllGroups(Session session) async {
    return await Groups.db.find(
      session,
      include: Groups.include(
        curator: Teachers.include(person: Person.include()),
      ),
    );
  }

  // Получение группы по названию
  Future<Groups?> getGroupByName(Session session, String groupName) async {
    try {
      return await Groups.db.findFirstRow(
        session,
        where: (g) => g.name.equals(groupName),
        include: Groups.include(
          curator: Teachers.include(person: Person.include()),
        ),
      );
    } catch (e, stackTrace) {
      session.log(
        'Ошибка при поиске группы по названию: $e',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  // Обновление группы
  Future<Groups> updateGroup(
    Session session,
    Groups clientProvidedGroup, {
    int? newCuratorId,
    int? newGroupHeadId,
  }) async {
    session.log('GroupsEndpoint.updateGroup called. Group ID: ${clientProvidedGroup.id}');

    var existingGroup = await Groups.db.findById(session, clientProvidedGroup.id!);
    if (existingGroup == null) {
      throw Exception('Группа с ID ${clientProvidedGroup.id} не найдена.');
    }

    var groupToUpdate = existingGroup.copyWith();
    bool groupRecordChanged = false;

    // Логика обновления куратора
    if (newCuratorId != null) {
      if (groupToUpdate.curatorId != newCuratorId) {
        // Снимаем роль у старого куратора
        if (groupToUpdate.curatorId != null) {
          var oldCuratorTeacher = await Teachers.db.findById(session, groupToUpdate.curatorId!);
          if (oldCuratorTeacher != null && oldCuratorTeacher.personId != null) {
            await UserRolesEndpoint().removeRole(session, oldCuratorTeacher.personId, 'curator');
          }
        }
        
        // Назначаем нового куратора
        groupToUpdate.curatorId = newCuratorId;
        var newCuratorTeacher = await Teachers.db.findById(session, newCuratorId);
        if (newCuratorTeacher != null && newCuratorTeacher.personId != null) {
           await UserRolesEndpoint().assignCuratorRole(session, newCuratorTeacher.personId);
        }
        groupRecordChanged = true;
      }
    } else if (clientProvidedGroup.curatorId == null && existingGroup.curatorId != null) {
      // Снятие куратора
      var oldCuratorTeacher = await Teachers.db.findById(session, existingGroup.curatorId!);
      if (oldCuratorTeacher != null && oldCuratorTeacher.personId != null) {
        await UserRolesEndpoint().removeRole(session, oldCuratorTeacher.personId, 'curator');
      }
      groupToUpdate.curatorId = null;
      groupRecordChanged = true;
    }

    // Обновление имени группы
    if (clientProvidedGroup.name != existingGroup.name) {
      groupToUpdate.name = clientProvidedGroup.name;
      groupRecordChanged = true;
    }

    if (groupRecordChanged) {
      await Groups.db.updateRow(session, groupToUpdate);
      groupToUpdate = (await Groups.db.findById(session, clientProvidedGroup.id!))!;
    }

    // Логика обновления старосты
    if (newGroupHeadId != null) {
      var currentGroupHeadStudent = await Students.db.findFirstRow(
        session,
        where: (s) => s.groupsId.equals(existingGroup.id!) & s.isGroupHead.equals(true),
      );
      if (currentGroupHeadStudent != null && currentGroupHeadStudent.id != newGroupHeadId) {
        currentGroupHeadStudent.isGroupHead = false;
        await Students.db.updateRow(session, currentGroupHeadStudent);
        await UserRolesEndpoint().removeRole(session, currentGroupHeadStudent.personId, 'groupHead');
      }

      var studentToMakeHead = await Students.db.findById(session, newGroupHeadId);
      if (studentToMakeHead == null || studentToMakeHead.groupsId != existingGroup.id) {
        throw Exception('Студент с ID $newGroupHeadId не найден или не принадлежит к группе.');
      }
      if (studentToMakeHead.isGroupHead != true) {
        studentToMakeHead.isGroupHead = true;
        await Students.db.updateRow(session, studentToMakeHead);
      }
      await UserRolesEndpoint().assignGroupHeadRole(session, studentToMakeHead.id!);
    }

    return await Groups.db.findById(
      session,
      existingGroup.id!,
      include: Groups.include(
        curator: Teachers.include(person: Person.include()),
      ),
    ) ?? groupToUpdate;
  }

  // Удаление группы
  Future<bool> deleteGroup(Session session, int groupId) async {
    session.log('GroupsEndpoint.deleteGroup called. Group ID: $groupId');

    var group = await Groups.db.findById(session, groupId);
    if (group == null) {
      throw Exception('Группа с ID $groupId не найдена');
    }

    return await session.db.transaction((transaction) async {
      // Логика удаления группы и связанных записей
      // (перенести из AdminEndpoint)
      
      // Удаляем всех студентов группы
      final groupStudents = await Students.db.find(
        session,
        where: (s) => s.groupsId.equals(groupId),
        transaction: transaction,
      );

      for (var student in groupStudents) {
        // Удаляем связи с подгруппами
        await StudentSubgroup.db.deleteWhere(
          session,
          where: (ss) => ss.studentsId.equals(student.id!),
          transaction: transaction,
        );

        // Удаляем записи о посещаемости
        await Attendance.db.deleteWhere(
          session,
          where: (a) => a.studentsId.equals(student.id!),
          transaction: transaction,
        );

        // Удаляем студента
        await Students.db.deleteRow(session, student, transaction: transaction);

        // Удаляем Person если нет других связей
        if (student.personId != null) {
          final person = await Person.db.findById(session, student.personId!, transaction: transaction);
          if (person != null) {
            final hasOtherStudentRecords = await Students.db.count(
              session, 
              where: (s) => s.personId.equals(student.personId!),
              transaction: transaction
            ) > 0;
            
            final hasTeacherRecords = await Teachers.db.count(
              session, 
              where: (t) => t.personId.equals(student.personId!),
              transaction: transaction
            ) > 0;
            
            if (!hasOtherStudentRecords && !hasTeacherRecords) {
              await Person.db.deleteRow(session, person, transaction: transaction);
            }
          }
        }
      }

      // Удаляем подгруппы группы
      await Subgroups.db.deleteWhere(
        session,
        where: (s) => s.groupsId.equals(groupId),
        transaction: transaction,
      );
      
      // Удаляем саму группу
      await Groups.db.deleteRow(session, group, transaction: transaction);
      
      return true;
    });
  }
}