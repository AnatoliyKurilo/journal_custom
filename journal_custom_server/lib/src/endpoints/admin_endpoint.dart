import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

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
    Groups clientProvidedGroup, // Переименовано для ясности, содержит в основном ID
    {int? newCuratorId, // Переименовано для ясности
    int? newGroupHeadId} // Переименовано для ясности
  ) async {
    session.log('AdminEndpoint.updateGroup called. Group ID: ${clientProvidedGroup.id}, New Curator ID: $newCuratorId, New GroupHead ID: $newGroupHeadId');

    var existingGroup = await Groups.db.findById(session, clientProvidedGroup.id!);
    if (existingGroup == null) {
      throw Exception('Группа с ID ${clientProvidedGroup.id} не найдена');
    }

    var groupToUpdate = existingGroup;

    // Логика обновления куратора
    // Если newCuratorId предоставлен (даже если null, что означает "снять куратора")
    // Мы должны обновить поле curatorId.
    // Проблема в том, что если мы обновляем старосту, newCuratorId будет null по умолчанию.
    // Нам нужен способ понять, был ли newCuratorId *намеренно* частью запроса.
    // С текущим клиентом, если newCuratorId не null, значит обновляем куратора.
    // Если newCuratorId null, это может быть "снять куратора" ИЛИ "обновляли старосту".

    // Решение: если мы обновляем куратора, то newGroupHeadId будет null.
    // Если мы обновляем старосту, то newCuratorId будет null.
    // Мы не можем обновить оба одновременно этим методом с текущим клиентом.

    bool curatorChanged = false;
    if (newCuratorId != null) { // Если передан конкретный ID для нового куратора
        if (groupToUpdate.curatorId != newCuratorId) {
            groupToUpdate = groupToUpdate.copyWith(curatorId: newCuratorId);
            curatorChanged = true;
            session.log('Set curator to $newCuratorId');
        }
    } else { // newCuratorId равен null
        // Это может означать "снять куратора" ИЛИ "curatorId не был целью этого обновления (обновляли старосту)".
        // Если newGroupHeadId ТОЖЕ null, то, возможно, это запрос на снятие куратора (или пустой вызов).
        // Если newGroupHeadId НЕ null, значит, мы обновляем старосту, и newCuratorId (который null) нужно игнорировать.
        if (newGroupHeadId == null && groupToUpdate.curatorId != null) { // Снимаем куратора, только если не обновляем старосту и куратор был
            groupToUpdate = groupToUpdate.copyWith(curatorId: null); // Явно устанавливаем null
            curatorChanged = true;
            session.log('Removed curator (set to null)');
        } else if (newGroupHeadId == null && newCuratorId == null && groupToUpdate.curatorId != null) {
            // Если оба null, и куратор был, снимаем его
             groupToUpdate = groupToUpdate.copyWith(curatorId: null);
             curatorChanged = true;
             session.log('Both new IDs are null, removing curator.');
        }
    }


    if (curatorChanged) {
        session.log('Updating group row for curator change. Group to save: ${groupToUpdate.toJson()}');
        await Groups.db.updateRow(session, groupToUpdate);
    } else {
        session.log('No changes to curatorId.');
    }

    // Логика обновления старосты (isGroupHead в таблице Students)
    if (newGroupHeadId != null) {
      // Сначала снимаем флаг isGroupHead со старого старосты этой группы (если он был)
      var oldGroupHeads = await Students.db.find(
        session,
        where: (s) => s.groupsId.equals(existingGroup.id!) & s.isGroupHead.equals(true),
      );

      for (var oldHead in oldGroupHeads) {
        if (oldHead.id != newGroupHeadId) { // Не снимаем флаг, если это тот же студент
          await Students.db.updateRow(session, oldHead.copyWith(isGroupHead: false));
          session.log('Reset old group head (ID: ${oldHead.id}) for group ${existingGroup.id}');
        }
      }

      // Затем устанавливаем флаг isGroupHead новому старосте
      var studentToMakeHead = await Students.db.findById(session, newGroupHeadId);
      if (studentToMakeHead != null && studentToMakeHead.groupsId == existingGroup.id) {
        if (studentToMakeHead.isGroupHead != true) {
            await Students.db.updateRow(session, studentToMakeHead.copyWith(isGroupHead: true));
            session.log('Set student $newGroupHeadId as new group head for group ${existingGroup.id}');
        }
      } else {
        session.log('Student $newGroupHeadId not found or not in group ${existingGroup.id} to be made head.');
      }
    } else if (newCuratorId == null && newGroupHeadId == null) { // Если оба null, возможно, это запрос на снятие старосты
        // Снимаем флаг isGroupHead со всех старост этой группы
        var currentHeads = await Students.db.find(
            session, 
            where: (s) => s.groupsId.equals(existingGroup.id!) & s.isGroupHead.equals(true)
        );
        for (var head in currentHeads) {
            await Students.db.updateRow(session, head.copyWith(isGroupHead: false));
            session.log('Removed group head (ID: ${head.id}) for group ${existingGroup.id} because newGroupHeadId and newCuratorId were null.');
        }
    }


    // Возвращаем обновленное состояние группы из БД, чтобы убедиться, что все связи корректны
    var reloadedGroup = await Groups.db.findById(
        session, 
        existingGroup.id!,
        include: Groups.include(curator: Teachers.include(person: Person.include())) // Включаем куратора для актуальности
    );
    
    session.log('AdminEndpoint.updateGroup finished. Reloaded group: ${reloadedGroup?.toJson()}');
    return reloadedGroup ?? groupToUpdate; // Возвращаем перезагруженную или обновленную группу
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

  // Метод для поиска преподавателей
  Future<List<Teachers>> searchTeachers(
    Session session, {
    required String query, // Принимаем строку запроса
  }) async {
    // 1. Разделяем строку на слова
    final tokens = query
        .trim()
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .toList();

    // Если строка пуста, возвращаем всех преподавателей
    if (tokens.isEmpty) {
      return await Teachers.db.find(
        session,
        include: Teachers.include(
          person: Person.include(),
        ),
      );
    }

    // 2. Построение списка условий
    var conditions = <Expression<dynamic>>[];
    for (var token in tokens) {
      final pattern = '%${token.toLowerCase()}%';
      conditions.add(
        Teachers.t.person.firstName.ilike(pattern) |
        Teachers.t.person.lastName.ilike(pattern) |
        Teachers.t.person.patronymic.ilike(pattern) |
        Teachers.t.person.email.ilike(pattern) |
        Teachers.t.person.phoneNumber.ilike(pattern),
      );
    }

    // 3. Объединение условий через AND
    var combinedCondition = conditions.reduce((a, b) => a & b);

    // 4. Выполняем запрос с использованием include
    return await Teachers.db.find(
      session,
      where: (t) => combinedCondition,
      include: Teachers.include(
        person: Person.include(),
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