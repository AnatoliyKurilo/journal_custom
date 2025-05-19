import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class AdminEndpoint extends Endpoint {
  @override
  bool get requireAuth => true;

  @override
  Set<String> get requiredRoles => {'serverpod.admin'};

  // Метод для создания группы
  Future<Groups> createGroup(Session session, String name, int? curatorId, int? groupHeadId) async {
    var group = Groups(
      name: name,
      curatorId: curatorId,
      groupHeadId: groupHeadId,
    );

    return await Groups.db.insertRow(session, group);
  }

  // Метод для получения всех групп с использованием include
  Future<List<Groups>> getAllGroups(Session session) async {
    return await Groups.db.find(
      session,
      include: Groups.include(
        curator: Teachers.include(person: Person.include()),
        groupHead: Students.include(person: Person.include()),
      ),
    );
  }



  // Метод для обновления данных группы
  Future<Groups> updateGroup(
    Session session,
    Groups group, {
    int? curatorId,
    int? groupHeadId,
  }) async {
    // Проверяем, существует ли группа с таким ID
    var existingGroup = await Groups.db.findById(session, group.id!);
    if (existingGroup == null) {
      throw Exception('Группа с ID ${group.id} не найдена');
    }

    // // Обновляем данные группы
    // var updatedGroup = existingGroup.copyWith(
    //   curatorId: curatorId ?? existingGroup.curatorId,
    //   groupHeadId: groupHeadId ?? existingGroup.groupHeadId,
    // );

    await Groups.db.updateRow(session, group);

    return group; // Возвращаем обновленную группу
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
          groupHead: Students.include(person: Person.include()),
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
        Groups.t.curator.person.lastName.ilike(pattern) |
        Groups.t.groupHead.person.firstName.ilike(pattern) |
        Groups.t.groupHead.person.lastName.ilike(pattern),
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
        groupHead: Students.include(person: Person.include()),
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