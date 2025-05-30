import 'package:journal_custom_server/src/services/user_subgroup_service.dart';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'package:collection/collection.dart';
import 'user_roles_endpoint.dart'; // Убедитесь, что этот эндпоинт импортирован

class AdminEndpoint extends Endpoint {
  @override
  bool get requireAuth => true;

  @override
  Set<String> get requiredRoles => {'serverpod.admin'};

  // Метод для создания группы
  Future<Groups> createGroup(Session session, String name, int? curatorId) async {
    var group = Groups(
      name: name,
      curatorId: curatorId,
    );

    return await Groups.db.insertRow(session, group);
  }

  // Метод для получения всех групп с использованием include
  Future<List<Groups>> getAllGroups(Session session) async {
    var groups = await Groups.db.find(
      session,
      include: Groups.include(
        curator: Teachers.include(person: Person.include()),
      ),
    );

    // // Добавляем информацию о старосте для каждой группы
    // for (var group in groups) {
    //   var groupHead = await Students.db.findFirstRow(
    //     session,
    //     where: (s) => s.groupsId.equals(group.id!) & s.isGroupHead.equals(true),
    //     include: Students.include(person: Person.include()),
    //   );
    //   group = group.copyWith(extraData: {'groupHead': groupHead}); // Сохраняем старосту в extraData
    // }

    return groups;
  }

  // Метод для получения группы по названию
  Future<Groups?> getGroupByName(Session session, String groupName) async {
    try {
      var group = await Groups.db.findFirstRow(
        session,
        where: (g) => g.name.equals(groupName),
        include: Groups.include(
          curator: Teachers.include(person: Person.include()),
        ),
      );

      // if (group != null) {
      //   var groupHead = await Students.db.findFirstRow(
      //     session,
      //     where: (s) => s.groupsId.equals(group.id!) & s.isGroupHead.equals(true),
      //     include: Students.include(person: Person.include()),
      //   );
      //   group = group.copyWith(extraData: {'groupHead': groupHead}); // Сохраняем старосту в extraData
      // }

      return group;
    } catch (e, stackTrace) {
      session.log(
        'Ошибка при поиске группы по названию: $e',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  // Метод для обновления данных группы
  Future<Groups> updateGroup(
    Session session,
    Groups clientProvidedGroup, {
    int? newCuratorId,
    int? newGroupHeadId,
    // bool? clearGroupHead, // Если вы добавили этот параметр ранее
  }) async {
    session.log('AdminEndpoint.updateGroup called. Group ID: ${clientProvidedGroup.id}, New Curator ID: $newCuratorId, New GroupHead ID: $newGroupHeadId');

    var existingGroup = await Groups.db.findById(session, clientProvidedGroup.id!);
    if (existingGroup == null) {
      throw Exception('Группа с ID ${clientProvidedGroup.id} не найдена.');
    }

    var groupToUpdate = existingGroup.copyWith();
    bool groupRecordChanged = false;

    // Логика обновления куратора и его прав
    if (newCuratorId != null) { // Если передан ID нового куратора (назначение или смена)
      if (groupToUpdate.curatorId != newCuratorId) {
        // Снимаем роль у старого куратора, если он был
        if (groupToUpdate.curatorId != null) {
          var oldCuratorTeacher = await Teachers.db.findById(session, groupToUpdate.curatorId!);
          if (oldCuratorTeacher != null && oldCuratorTeacher.personId != null) {
            await UserRolesEndpoint().removeRole(session, oldCuratorTeacher.personId, 'curator');
            session.log('AdminEndpoint: Removed "curator" role from old curator (Teacher ID: ${oldCuratorTeacher.id}, Person ID: ${oldCuratorTeacher.personId}) for group ${groupToUpdate.id}');
          }
        }
        
        // Назначаем нового куратора и его роль
        groupToUpdate.curatorId = newCuratorId;
        var newCuratorTeacher = await Teachers.db.findById(session, newCuratorId);
        if (newCuratorTeacher != null && newCuratorTeacher.personId != null) {
           await UserRolesEndpoint().assignCuratorRole(session, newCuratorTeacher.personId);
           session.log('AdminEndpoint: Assigned "curator" role to new curator (Teacher ID: ${newCuratorTeacher.id}, Person ID: ${newCuratorTeacher.personId}) for group ${groupToUpdate.id}');
        }
        groupRecordChanged = true;
      }
    } else if (clientProvidedGroup.curatorId == null && existingGroup.curatorId != null) {
      // Если в clientProvidedGroup curatorId равен null, а в existingGroup он был - это явное снятие куратора
      var oldCuratorTeacher = await Teachers.db.findById(session, existingGroup.curatorId!);
      if (oldCuratorTeacher != null && oldCuratorTeacher.personId != null) {
        await UserRolesEndpoint().removeRole(session, oldCuratorTeacher.personId, 'curator');
        session.log('AdminEndpoint: Explicitly removed "curator" role from (Teacher ID: ${oldCuratorTeacher.id}, Person ID: ${oldCuratorTeacher.personId}) for group ${groupToUpdate.id}');
      }
      groupToUpdate.curatorId = null;
      groupRecordChanged = true;
    }


    // Обновляем имя группы, если оно было передано и изменилось
    if (clientProvidedGroup.name != existingGroup.name) {
      groupToUpdate.name = clientProvidedGroup.name;
      groupRecordChanged = true;
    }

    if (groupRecordChanged) {
      await Groups.db.updateRow(session, groupToUpdate);
      // Перезагружаем, чтобы иметь актуальные данные для дальнейших операций
      groupToUpdate = (await Groups.db.findById(session, clientProvidedGroup.id!))!;
    }

    // Логика обновления старосты и его прав
    if (newGroupHeadId != null) {
      var currentGroupHeadStudent = await Students.db.findFirstRow(
        session,
        where: (s) => s.groupsId.equals(existingGroup.id!) & s.isGroupHead.equals(true),
      );
      if (currentGroupHeadStudent != null && currentGroupHeadStudent.id != newGroupHeadId) {
        currentGroupHeadStudent.isGroupHead = false;
        await Students.db.updateRow(session, currentGroupHeadStudent);
        await UserRolesEndpoint().removeRole(session, currentGroupHeadStudent.personId, 'groupHead');
        session.log('AdminEndpoint: Removed groupHead role from old head student ID: ${currentGroupHeadStudent.id}, Person ID: ${currentGroupHeadStudent.personId}');
      }

      var studentToMakeHead = await Students.db.findById(session, newGroupHeadId);
      if (studentToMakeHead == null || studentToMakeHead.groupsId != existingGroup.id) {
        throw Exception('Студент с ID $newGroupHeadId не найден или не принадлежит к группе ${existingGroup.name}.');
      }
      if (studentToMakeHead.isGroupHead != true) {
        studentToMakeHead.isGroupHead = true;
        await Students.db.updateRow(session, studentToMakeHead);
      }
      await UserRolesEndpoint().assignGroupHeadRole(session, studentToMakeHead.id!);
      session.log('AdminEndpoint: Assigned groupHead role to new head student ID: ${studentToMakeHead.id}');

    } else if (newGroupHeadId == null && newCuratorId == null && clientProvidedGroup.id != null /* && (clearGroupHead == true) */ ) {
      // Условие для снятия старосты, если clearGroupHead был бы параметром
      // Или если newGroupHeadId и newCuratorId оба null, и это не просто обновление имени
      // Текущая логика может быть слишком агрессивной, если просто обновляется имя группы.
      // Для явного снятия старосты лучше использовать отдельный флаг или специальное значение newGroupHeadId.
      // Пока оставим как было, но с комментарием.
      var currentGroupHeadStudent = await Students.db.findFirstRow(
        session,
        where: (s) => s.groupsId.equals(existingGroup.id!) & s.isGroupHead.equals(true),
      );
      if (currentGroupHeadStudent != null) {
        // Проверяем, не является ли это просто обновлением имени группы или куратора,
        // когда староста не должен меняться.
        // Это условие нужно уточнить, чтобы избежать случайного снятия старосты.
        // Например, если clientProvidedGroup.groupHeadId (если бы такое поле было) тоже null.
        // Пока что, если newGroupHeadId null и newCuratorId null, будем снимать старосту.
        currentGroupHeadStudent.isGroupHead = false;
        await Students.db.updateRow(session, currentGroupHeadStudent);
        await UserRolesEndpoint().removeRole(session, currentGroupHeadStudent.personId, 'groupHead');
        session.log('AdminEndpoint: Explicitly removed groupHead role from student ID: ${currentGroupHeadStudent.id}, Person ID: ${currentGroupHeadStudent.personId}');
      }
    }

    var reloadedGroup = await Groups.db.findById(
      session,
      existingGroup.id!,
      include: Groups.include(
        curator: Teachers.include(person: Person.include()),
      ),
    );

    session.log('AdminEndpoint.updateGroup finished. Reloaded group: ${reloadedGroup?.toJson()}');
    return reloadedGroup ?? groupToUpdate;
  }

  // Метод для создания преподавателя
  Future<Teachers> createTeacher(
    Session session, {
    required String firstName,
    required String lastName,
    String? patronymic,
    required String email,
    String? phoneNumber,
  }) async {
    // Проверяем, существует ли уже человек с таким email
    var existingPerson = await Person.db.findFirstRow(
      session,
      where: (p) => p.email.equals(email),
    );

    if (existingPerson != null) {
      throw Exception('Человек с таким email уже существует');
    }

    // Создаем запись Person
    var person = Person(
      firstName: firstName,
      lastName: lastName,
      patronymic: patronymic,
      email: email,
      phoneNumber: phoneNumber,
    );

    person = await Person.db.insertRow(session, person);

    // Создаем запись Teacher
    var teacher = Teachers(
      personId: person.id!,
    );

    return await Teachers.db.insertRow(session, teacher);
  }

  // Метод для создания студента
  Future<Students> createStudent(
    Session session, {
    required String firstName,
    required String lastName,
    String? patronymic,
    required String email,
    String? phoneNumber,
    required String groupName,
  }) async {
    session.log('Начало создания студента: $firstName $lastName');

    try {
      // Проверяем, существует ли уже человек с таким email
      var existingPerson = await Person.db.findFirstRow(
        session,
        where: (p) => p.email.equals(email),
      );

      if (existingPerson != null) {
        session.log('Человек с таким email уже существует: $email');
        throw Exception('Человек с таким email уже существует');
      }

      // Ищем группу по названию
      var group = await Groups.db.findFirstRow(
        session,
        where: (g) => g.name.equals(groupName),
      );

      if (group == null) {
        session.log('Группа с названием "$groupName" не найдена');
        throw Exception('Группа с названием "$groupName" не найдена');
      }

      // Создаем запись Person
      var person = Person(
        firstName: firstName,
        lastName: lastName,
        patronymic: patronymic,
        email: email,
        phoneNumber: phoneNumber,
      );

      person = await Person.db.insertRow(session, person);
      session.log('Создана запись в таблице Person: ${person.id}');

      // Создаем запись Student
      var student = Students(
        personId: person.id!,
        groupsId: group.id!,
      );

      student = await Students.db.insertRow(session, student);
      session.log('Создана запись в таблице Students: ${student.id}');

      return student;
    } catch (e, stackTrace) {
      session.log(
        'Ошибка при создании студента: $e',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  // Метод для получения всех преподавателей с использованием include
  Future<List<Teachers>> getAllTeachers(Session session) async {
    return await Teachers.db.find(
      session,
      include: Teachers.include(person: Person.include()),
    );
  }

  // Метод для получения всех студентов с использованием include
  Future<List<Students>> getAllStudents(Session session) async {
    return await Students.db.find(
      session,
      include: Students.include(
        person: Person.include(), // Включаем данные о человеке
        groups: Groups.include(), // Включаем данные о группе
      ),
    );
  }

  // Метод для обновления данных человека
  Future<Person> updatePerson(Session session, Person person) async {
    return await _executeWithErrorHandling<Person>(
      session,
      () async {
        await Person.db.updateRow(session, person);
        return person;
      },
    );
  }
  
  // Метод для поиска студентов
  Future<List<Students>> searchStudents(
    Session session, {
    required String query, // Принимаем строку запроса
  }) async {
    // 1. Разделяем строку на слова
    final tokens = query
        .trim()
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .toList();

    // Если строка пуста, возвращаем всех студентов
    if (tokens.isEmpty) {
      return await Students.db.find(
        session,
        include: Students.include(
          person: Person.include(),
          groups: Groups.include(),
        ),
      );
    }

    // 2. Построение списка условий
    var conditions = <Expression<dynamic>>[];
    for (var token in tokens) {
      final pattern = '%${token.toLowerCase()}%';
      conditions.add(
        Students.t.person.firstName.ilike(pattern) |
        Students.t.person.lastName.ilike(pattern) |
        Students.t.person.patronymic.ilike(pattern) |
        Students.t.person.email.ilike(pattern) |
        Students.t.person.phoneNumber.ilike(pattern) |
        Students.t.groups.name.ilike(pattern),
      );
    }

    // 3. Объединение условий через AND
    var combinedCondition = conditions.reduce((a, b) => a & b);

    // 4. Выполняем запрос с использованием include
    return await Students.db.find(
      session,
      where: (t) => combinedCondition,
      include: Students.include(
        person: Person.include(),
        groups: Groups.include(),
      ),
    );
  }

  
  // Метод для поиска групп
  Future<List<Groups>> searchGroups(
    Session session, {
    required String query, // Принимаем строку запроса
  }) async {
    // 1. Разделяем строку на слова
    final tokens = query
        .trim()
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .toList();

    // Если строка пуста, возвращаем все группы
    if (tokens.isEmpty) {
      return await Groups.db.find(
        session,
        include: Groups.include(
          curator: Teachers.include(person: Person.include()),
        ),
      );
    }

    // 2. Построение списка условий
    var conditions = <Expression<dynamic>>[];
    for (var token in tokens) {
      final pattern = '%${token.toLowerCase()}%';
      conditions.add(
        Groups.t.name.ilike(pattern) |
        Groups.t.curator.person.firstName.ilike(pattern) |
        Groups.t.curator.person.lastName.ilike(pattern)
        // Удалены ссылки на groupHead
      );
    }

    // 3. Объединение условий через AND
    var combinedCondition = conditions.reduce((a, b) => a & b);

    // 4. Выполняем запрос с использованием include
    return await Groups.db.find(
      session,
      where: (t) => combinedCondition,
      include: Groups.include(
        curator: Teachers.include(person: Person.include()),
      ),
    );
  }

  // Метод для обновления данных студента
  Future<Students> updateStudent(
    Session session,
    Students student,
  ) async {
    // Проверяем, существует ли студент с таким ID
    var existingStudent = await Students.db.findById(session, student.id!);
    if (existingStudent == null) {
      throw Exception('Студент с ID ${student.id} не найден');
    }

    // Обновляем данные студента
    await Students.db.updateRow(session, student);

    return student;
  }

  // Дополненный метод для удаления группы, студентов и связанных записей Person
  Future<bool> deleteGroup(Session session, int groupId) async {
    session.log('AdminEndpoint.deleteGroup called. Group ID: $groupId');

    // Проверяем, существует ли группа
    var group = await Groups.db.findById(session, groupId);
    if (group == null) {
      throw Exception('Группа с ID $groupId не найдена');
    }

    // Транзакция для обеспечения атомарности операций
    return await session.db.transaction((transaction) async {
      try {
        // 1. Находим всех студентов группы
        var students = await Students.db.find(
          session,
          where: (s) => s.groupsId.equals(groupId),
          transaction: transaction,
          include: Students.include(person: Person.include()),
        );
        
        // 2. Для каждого студента удаляем запись в таблице Students и Person
        for (var student in students) {
          // Сохраняем ID человека для последующего удаления
          final personId = student.personId;
          
          // Удаляем запись студента
          await Students.db.deleteRow(session, student, transaction: transaction);
          
          // Получаем запись человека
          final person = await Person.db.findById(session, personId, transaction: transaction);
          if (person != null) {
            // Проверяем, нет ли других связей (например, если человек одновременно студент и преподаватель)
            final hasOtherStudentRecords = await Students.db.count(
              session, 
              where: (s) => s.personId.equals(personId),
              transaction: transaction
            ) > 0;
            
            final hasTeacherRecords = await Teachers.db.count(
              session, 
              where: (t) => t.personId.equals(personId),
              transaction: transaction
            ) > 0;
            
            // Удаляем запись Person только если нет других связей
            if (!hasOtherStudentRecords && !hasTeacherRecords) {
              await Person.db.deleteRow(session, person, transaction: transaction);
            }
          }
        }
        
        // 3. Удаляем саму группу
        await Groups.db.deleteRow(session, group, transaction: transaction);
        
        session.log('Группа и все связанные записи успешно удалены. ID: $groupId');
        return true;
      } catch (e, stackTrace) {
        session.log('Ошибка при удалении группы: $e', level: LogLevel.error, stackTrace: stackTrace);
        return false;
      }
    });
  }

  // Метод для получения всех записей о посещаемости для конкретного студента
  Future<List<StudentOverallAttendanceRecord>> getStudentOverallAttendanceRecords(Session session, int studentId) async {
    final student = await Students.db.findById(session, studentId);
    if (student == null) {
      throw Exception('Студент с ID $studentId не найден.');
    }

    // Получаем доступные подгруппы для текущего пользователя
    final accessibleSubgroupIds = await UserSubgroupService.getUserAccessibleSubgroupIds(session);
    
    if (accessibleSubgroupIds.isEmpty) {
      return [];
    }

    // Находим связи студента с подгруппами, но только с доступными
    final studentSubgroupLinks = await StudentSubgroup.db.find(
      session,
      where: (ss) => ss.studentsId.equals(studentId) & ss.subgroupsId.inSet(accessibleSubgroupIds.toSet()),
    );

    if (studentSubgroupLinks.isEmpty) {
      return [];
    }

    final subgroupIds = studentSubgroupLinks.map((link) => link.subgroupsId).toSet();

    // Находим занятия только для доступных подгрупп студента
    final classes = await Classes.db.find(
      session,
      where: (c) => c.subgroupsId.inSet(subgroupIds),
      include: Classes.include(
        subjects: Subjects.include(),
        class_types: ClassTypes.include(),
        subgroups: Subgroups.include(),
      ),
      orderBy: (c) => c.date,
      orderDescending: true,
    );

    if (classes.isEmpty) {
      return [];
    }

    final classIds = classes.map((c) => c.id!).toSet();

    final attendanceRecords = await Attendance.db.find(
      session,
      where: (a) => a.studentsId.equals(studentId) & a.classesId.inSet(classIds),
    );

    final List<StudentOverallAttendanceRecord> result = [];
    for (var classItem in classes) {
      final attendance = attendanceRecords.firstWhereOrNull(
        (ar) => ar.classesId == classItem.id,
      );

      result.add(StudentOverallAttendanceRecord(
        subjectName: classItem.subjects?.name ?? 'Неизвестный предмет',
        classTopic: classItem.topic,
        classTypeName: classItem.class_types?.name,
        classDate: classItem.date,
        isPresent: attendance?.isPresent ?? false,
        comment: attendance?.comment,
        subgroupName: classItem.subgroups?.name,
      ));
    }
    return result;
  }

  // Вспомогательный метод для обработки ошибок
  Future<T> _executeWithErrorHandling<T>(
    Session session,
    Future<T> Function() action,
  ) async {
    try {
      return await action();
    } catch (e, stackTrace) {
      session.log(
        'Ошибка: $e',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}