import 'package:journal_custom_server/src/custom_scope.dart';
import 'package:journal_custom_server/src/services/Scope_service.dart';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'user_roles_endpoint.dart';
import 'rasp_endpoint.dart';

class GroupsEndpoint extends Endpoint {
  @override
  bool get requireLogin  => true;

  // @override
  // Set<Scope> get requiredScopes => {Scope.admin};
  
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
  final authInfo = await session.authenticated;
  session.log('Области доступа пользователя: ${authInfo!.scopes.map((s) => s.name).toList()}');

  // Если пользователь администратор, возвращаем все группы
  if (await ScopeService.checkScopes(session, requiredScopes: {Scope.admin,CustomScope.documentSpecialist})) {
    return await Groups.db.find(session);
  }

  // Если пользователь староста или студент, возвращаем только связанные группы
  if (await ScopeService.checkScopes(session, requiredScopes: {CustomScope.groupHead, CustomScope.student})) {
    final person = await Person.db.findFirstRow(
      session,
      where: (p) => p.userInfoId.equals(authInfo.userId),
    );
    final student = await Students.db.findFirstRow(
      session,
      where: (s) => s.personId.equals(person?.id),
    );

    if (student?.groupsId != null) {
      return await Groups.db.find(
        session,
        where: (g) => g.id.equals(student!.groupsId),
      );
    }
  }

  // Для кураторов и преподавателей - существующая логика
  if (await ScopeService.checkScopes(session, requiredScopes: {CustomScope.curator})) {
    final person = await Person.db.findFirstRow(
      session,
      where: (p) => p.userInfoId.equals(authInfo.userId),
    );
    final teacher = await Teachers.db.findFirstRow(
      session,
      where: (s) => s.personId.equals(person?.id),
    );

    if (teacher != null) {
      // Для кураторов - группы где они кураторы
      if (authInfo.scopes.any((scope) => scope.name == CustomScope.curator.name)) {
        return await Groups.db.find(
          session,
          where: (g) => g.curatorId.equals(teacher.id),
        );
      }
      
      // Для преподавателей - группы где они ведут занятия
      if (authInfo.scopes.any((scope) => scope.name == CustomScope.teacher.name)) {
        // Получаем все занятия преподавателя
        final teacherClasses = await Classes.db.find(
          session,
          where: (c) => c.teachersId.equals(teacher.id),
        );
        
        if (teacherClasses.isEmpty) {
          return [];
        }
        
        // Получаем подгруппы из занятий
        final subgroupIds = teacherClasses
            .where((c) => c.subgroupsId != null)
            .map((c) => c.subgroupsId!)
            .toSet();
        
        if (subgroupIds.isEmpty) {
          return [];
        }
        
        // Получаем группы через подгруппы
        final subgroups = await Subgroups.db.find(
          session,
          where: (s) => s.id.inSet(subgroupIds),
        );
        
        final groupIds = subgroups
            .where((s) => s.groupsId != null)
            .map((s) => s.groupsId!)
            .toSet();
        
        if (groupIds.isEmpty) {
          return [];
        }
        
        return await Groups.db.find(
          session,
          where: (g) => g.id.inSet(groupIds),
        );
      }
    }
  }
  
  if (authInfo.scopes.contains(CustomScope.teacher)) {
    final person = await Person.db.findFirstRow(
      session,
      where: (p) => p.userInfoId.equals(authInfo.userId),
    );

    if (person != null) {
      final teacher = await Teachers.db.findFirstRow(
        session,
        where: (t) => t.personId.equals(person.id),
      );

      if (teacher != null) {
        final teacherClasses = await Classes.db.find(
          session,
          where: (c) => c.teachersId.equals(teacher.id),
        );

        if (teacherClasses.isNotEmpty) {
          final subgroupIds = teacherClasses.map((c) => c.subgroupsId!).toSet();

          final subgroups = await Subgroups.db.find(
            session,
            where: (s) => s.id.inSet(subgroupIds),
          );

          final groupIds = subgroups.map((s) => s.groupsId!).toSet();

          return await Groups.db.find(
            session,
            where: (g) => g.id.inSet(groupIds),
          );
        }
      }
    }

    return [];
  }



  // Если пользователь не имеет прав, возвращаем пустой список
  return [];
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

  /// Удаление группы
  Future<bool> deleteGroup(Session session, int groupId) async {
    session.log('GroupsEndpoint.deleteGroup called. Group ID: $groupId');

    var group = await Groups.db.findById(session, groupId);
    if (group == null) {
      throw Exception('Группа с ID $groupId не найдена');
    }

    return await session.db.transaction((transaction) async {
      try {
        // 1. Сначала получаем всех студентов группы
        final groupStudents = await Students.db.find(
          session,
          where: (s) => s.groupsId.equals(groupId),
          transaction: transaction,
        );

        session.log('Найдено ${groupStudents.length} студентов в группе $groupId');

        // 2. Удаляем связи студентов с подгруппами
        for (var student in groupStudents) {
          await StudentSubgroup.db.deleteWhere(
            session,
            where: (ss) => ss.studentsId.equals(student.id!),
            transaction: transaction,
          );
          session.log('Удалены связи студента ${student.id} с подгруппами');
        }

        // 3. Удаляем записи о посещаемости для всех студентов группы
        for (var student in groupStudents) {
          await Attendance.db.deleteWhere(
            session,
            where: (a) => a.studentsId.equals(student.id!),
            transaction: transaction,
          );
          session.log('Удалены записи посещаемости для студента ${student.id}');
        }

        // 4. Получаем подгруппы группы
        final subgroups = await Subgroups.db.find(
          session,
          where: (s) => s.groupsId.equals(groupId),
          transaction: transaction,
        );

        session.log('Найдено ${subgroups.length} подгрупп в группе $groupId');

        // 5. Удаляем занятия (Classes), связанные с подгруппами этой группы
        for (var subgroup in subgroups) {
          await Classes.db.deleteWhere(
            session,
            where: (c) => c.subgroupsId.equals(subgroup.id!),
            transaction: transaction,
          );
          session.log('Удалены занятия для подгруппы ${subgroup.id}');
        }

        // 6. Теперь можно безопасно удалить подгруппы
        await Subgroups.db.deleteWhere(
          session,
          where: (s) => s.groupsId.equals(groupId),
          transaction: transaction,
        );
        session.log('Удалены подгруппы группы $groupId');

        // 7. Удаляем студентов
        for (var student in groupStudents) {
          await Students.db.deleteRow(session, student, transaction: transaction);
          session.log('Удален студент ${student.id}');

          // 8. Проверяем, можно ли удалить связанную запись Person
          if (student.personId != null) {
            final person = await Person.db.findById(session, student.personId!, transaction: transaction);
            if (person != null) {
              // Проверяем, нет ли других ссылок на эту Person
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
              
              // Если нет других связей, удаляем Person
              if (!hasOtherStudentRecords && !hasTeacherRecords) {
                await Person.db.deleteRow(session, person, transaction: transaction);
                session.log('Удалена запись Person ${person.id} для студента ${student.id}');
              } else {
                session.log('Person ${person.id} сохранена, так как используется в других таблицах');
              }
            }
          }
        }

        // 9. Снимаем роль куратора, если она была назначена
        if (group.curatorId != null) {
          try {
            final curatorTeacher = await Teachers.db.findById(session, group.curatorId!, transaction: transaction);
            if (curatorTeacher != null && curatorTeacher.personId != null) {
              await UserRolesEndpoint().removeRole(session, curatorTeacher.personId, 'curator');
              session.log('Снята роль куратора с преподавателя ${curatorTeacher.id}');
            }
          } catch (e) {
            session.log('Предупреждение: не удалось снять роль куратора: $e', level: LogLevel.warning);
            // Не прерываем транзакцию из-за этой ошибки
          }
        }

        // 10. Наконец, удаляем саму группу
        await Groups.db.deleteRow(session, group, transaction: transaction);
        session.log('Удалена группа $groupId');
        
        return true;
      } catch (e, stackTrace) {
        session.log(
          'Ошибка при удалении группы $groupId: $e',
          level: LogLevel.error,
          stackTrace: stackTrace,
        );
        // Транзакция автоматически откатится при исключении
        rethrow;
      }
    });
  }

  /// Импортирует группы из внешнего API расписания для указанного года.
  Future<String> importGroupsFromSchedule(Session session, String year) async {
    try {
      session.log('Начало импорта групп из расписания для года: $year');
      
      final raspEndpoint = RaspEndpoint();
      List<GroupInfo> groupsFromScheduleApi;
      
      try {
        groupsFromScheduleApi = await raspEndpoint.getGroupsList(session, year);
        session.log('Получено ${groupsFromScheduleApi.length} групп из API расписания для года $year.');
      } catch (e) {
        session.log('Ошибка при получении групп из API расписания для года $year: $e', level: LogLevel.error);
        throw Exception('Не удалось получить группы из API расписания: $e');
      }

      if (groupsFromScheduleApi.isEmpty) {
        return 'Не найдено групп в расписании для года $year.';
      }

      int importedCount = 0;
      int existingCount = 0;
      int updatedCount = 0;
      int conflictCount = 0;
      List<String> errors = [];

      for (var groupInfo in groupsFromScheduleApi) {
        try {
          // Сначала проверяем, существует ли группа с таким ID из API
          var existingGroupById = await Groups.db.findById(session, groupInfo.id);
          
          if (existingGroupById != null) {
            // Группа с таким ID уже существует
            if (existingGroupById.name == groupInfo.name) {
              existingCount++;
              session.log('Группа с ID ${groupInfo.id} и названием "${groupInfo.name}" уже существует');
            } else {
              // ID совпадает, но название отличается - обновляем
              existingGroupById.name = groupInfo.name;
              await Groups.db.updateRow(session, existingGroupById);
              updatedCount++;
              session.log('Обновлено название группы с ID ${groupInfo.id}: "${existingGroupById.name}" -> "${groupInfo.name}"');
            }
            continue;
          }

          // Проверяем, существует ли группа с таким названием (но другим ID)
          var existingGroupByName = await Groups.db.findFirstRow(
            session,
            where: (g) => g.name.equals(groupInfo.name),
          );

          if (existingGroupByName != null) {
            // Группа с таким названием существует, но ID отличается
            if (existingGroupByName.id != groupInfo.id) {
              conflictCount++;
              errors.add('Конфликт: группа "${groupInfo.name}" существует с ID ${existingGroupByName.id}, но в API имеет ID ${groupInfo.id}');
              session.log('Конфликт ID для группы "${groupInfo.name}": БД=${existingGroupByName.id}, API=${groupInfo.id}');
              continue;
            }
          }

          // Создаем новую группу с ID из API
          var newGroup = Groups(
            id: groupInfo.id, // Используем ID из API
            name: groupInfo.name,
            curatorId: null, // Куратор будет назначен отдельно
          );
          
          await Groups.db.insertRow(session, newGroup);
          importedCount++;
          session.log('Создана новая группа: ID=${groupInfo.id}, название="${groupInfo.name}"');

        } catch (e) {
          session.log('Ошибка импорта группы "${groupInfo.name}" (ID: ${groupInfo.id}) из расписания: $e', level: LogLevel.error);
          errors.add('Ошибка импорта группы "${groupInfo.name}" (ID: ${groupInfo.id}): $e');
        }
      }

      String summary = 'Импорт групп из расписания для года $year завершен.\n';
      summary += 'Новых групп импортировано: $importedCount\n';
      summary += 'Существующих групп (пропущено): $existingCount\n';
      summary += 'Обновленных групп: $updatedCount\n';
      summary += 'Конфликтов ID: $conflictCount\n';
      
      if (errors.isNotEmpty) {
        summary += 'Ошибки и конфликты (${errors.length}):\n${errors.join('\n')}';
      }

      session.log(summary);
      return summary;
      
    } catch (e, stackTrace) {
      session.log(
        'Критическая ошибка при импорте групп из расписания: $e',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      throw Exception('Не удалось импортировать группы из расписания: $e');
    }
  }

  /// Синхронизирует ID групп с API расписания (отдельный метод для исправления конфликтов)
  Future<String> synchronizeGroupIdsWithSchedule(Session session, String year) async {
    try {
      session.log('Начало синхронизации ID групп с API расписания для года: $year');
      
      final raspEndpoint = RaspEndpoint();
      List<GroupInfo> groupsFromScheduleApi = await raspEndpoint.getGroupsList(session, year);
      
      int synchronizedCount = 0;
      int conflictCount = 0;
      List<String> conflicts = [];

      return await session.db.transaction((transaction) async {
        for (var apiGroup in groupsFromScheduleApi) {
          try {
            // Ищем группу по названию
            var existingGroup = await Groups.db.findFirstRow(
              session,
              where: (g) => g.name.equals(apiGroup.name),
              transaction: transaction,
            );

            if (existingGroup != null && existingGroup.id != apiGroup.id) {
              // Проверяем, не занят ли целевой ID
              var groupWithTargetId = await Groups.db.findById(
                session, 
                apiGroup.id,
                transaction: transaction,
              );

              if (groupWithTargetId != null) {
                conflictCount++;
                conflicts.add('Невозможно изменить ID группы "${existingGroup.name}" с ${existingGroup.id} на ${apiGroup.id}: ID ${apiGroup.id} уже занят группой "${groupWithTargetId.name}"');
                continue;
              }

              // Сохраняем старый ID для логирования
              final oldId = existingGroup.id;

              // Обновляем связанные записи
              await _updateGroupIdReferences(session, transaction, oldId!, apiGroup.id);

              // Обновляем ID группы
              existingGroup.id = apiGroup.id;
              await Groups.db.updateRow(session, existingGroup, transaction: transaction);

              synchronizedCount++;
              session.log('Синхронизирован ID группы "${existingGroup.name}": $oldId -> ${apiGroup.id}');
            }
          } catch (e) {
            conflictCount++;
            conflicts.add('Ошибка синхронизации группы "${apiGroup.name}": $e');
          }
        }

        String summary = 'Синхронизация ID групп с API завершена.\n';
        summary += 'Синхронизировано групп: $synchronizedCount\n';
        summary += 'Конфликтов: $conflictCount\n';
        
        if (conflicts.isNotEmpty) {
          summary += 'Детали конфликтов:\n${conflicts.join('\n')}';
        }

        session.log(summary);
        return summary;
      });

    } catch (e, stackTrace) {
      session.log(
        'Критическая ошибка при синхронизации ID групп: $e',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      throw Exception('Не удалось синхронизировать ID групп: $e');
    }
  }

  /// Обновляет все ссылки на группу при изменении её ID
  Future<void> _updateGroupIdReferences(
    Session session, 
    Transaction transaction, 
    int oldGroupId, 
    int newGroupId
  ) async {
    // Обновляем студентов - получаем все записи и обновляем по одной
    final studentsToUpdate = await Students.db.find(
      session,
      where: (s) => s.groupsId.equals(oldGroupId),
      transaction: transaction,
    );
    
    for (final student in studentsToUpdate) {
      await Students.db.updateRow(
        session,
        student.copyWith(groupsId: newGroupId),
        transaction: transaction,
      );
    }

    // Обновляем подгруппы - аналогично
    final subgroupsToUpdate = await Subgroups.db.find(
      session,
      where: (s) => s.groupsId.equals(oldGroupId),
      transaction: transaction,
    );
    
    for (final subgroup in subgroupsToUpdate) {
      await Subgroups.db.updateRow(
        session,
        subgroup.copyWith(groupsId: newGroupId),
        transaction: transaction,
      );
    }
  }
}