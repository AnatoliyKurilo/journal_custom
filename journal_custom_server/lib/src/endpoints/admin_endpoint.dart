import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class AdminEndpoint extends Endpoint {
  @override
  bool get requireAuth => true;

  @override
  Set<String> get requiredRoles => {'serverpod.admin'};

  // ======== Методы для работы с группами ========

  Future<List<Groups>> getAllGroups(Session session) async {
    // Получаем все группы
    var groups = await Groups.db.find(session);

    // Загружаем связанные данные для каждой группы
    for (var i = 0; i < groups.length; i++) {
      var group = groups[i];

      // Загружаем куратора
      if (group.curatorId != null) {
        var curator = await Teachers.db.findById(session, group.curatorId);
        if (curator != null) {
          var person = await Person.db.findById(session, curator.personId);
          if (person != null) {
            // Добавляем данные о человеке в куратора
            session.log('Куратор найден: ${person.firstName} ${person.lastName}');
          }
        }
      }

      // Загружаем старосту
      if (group.groupHeadId != null) {
        var groupHead = await Students.db.findById(session, group.groupHeadId);
        if (groupHead != null) {
          var person = await Person.db.findById(session, groupHead.personId);
          if (person != null) {
            // Добавляем данные о человеке в старосту
            session.log('Староста найден: ${person.firstName} ${person.lastName}');
          }
        }
      }

      groups[i] = group;
    }

    return groups;
  }

  Future<Groups?> getGroupById(Session session, int id) async {
    // Получаем группу по ID
    var group = await Groups.db.findById(session, id);
    if (group == null) {
      return null;
    }

    // Загружаем куратора
    if (group.curatorId != null) {
      var curator = await Teachers.db.findById(session, group.curatorId);
      if (curator != null) {
        var person = await Person.db.findById(session, curator.personId);
        if (person != null) {
          session.log('Куратор найден: ${person.firstName} ${person.lastName}');
        }
      }
    }

    // Загружаем старосту
    if (group.groupHeadId != null) {
      var groupHead = await Students.db.findById(session, group.groupHeadId);
      if (groupHead != null) {
        var person = await Person.db.findById(session, groupHead.personId);
        if (person != null) {
          session.log('Староста найден: ${person.firstName} ${person.lastName}');
        }
      }
    }

    return group;
  }

  Future<Groups> createGroup(Session session, String name, int curatorId, int groupHeadId) async {
    var group = Groups(
      name: name,
      curatorId: curatorId,
      groupHeadId: groupHeadId == 0 ? -1 : groupHeadId, // Если 0, то -1 (или другое значение по умолчанию)
    );

    return await Groups.db.insertRow(session, group);
  }

  Future<Groups> updateGroup(Session session, int id, String name, int curatorId, int? groupHeadId) async {
    var group = await Groups.db.findById(session, id);
    if (group == null) {
      throw Exception('Группа не найдена');
    }

    group = group.copyWith(
      name: name,
      curatorId: curatorId,
      groupHeadId: groupHeadId,
    );

    return await Groups.db.updateRow(session, group);
  }

  Future<bool> deleteGroup(Session session, int id) async {
    try {
      // Проверяем, есть ли в группе студенты
      var students = await Students.db.find(
        session,
        where: (s) => s.groupId.equals(id),
      );

      if (students.isNotEmpty) {
        throw Exception('Невозможно удалить группу, в которой есть студенты');
      }

      var group = await Groups.db.findById(session, id);
      if (group == null) {
        return false;
      }

      await Groups.db.deleteRow(session, group);
      return true;
    } catch (e) {
      session.log(e.toString());
      return false;
    }
  }

  // ======== Методы для работы с преподавателями ========

  Future<List<Teachers>> getAllTeachers(Session session) async {
    var teachers = await Teachers.db.find(session);

    for (var i = 0; i < teachers.length; i++) {
      var teacher = teachers[i];
      var person = await Person.db.findById(session, teacher.personId);
      if (person != null) {
        session.log('Преподаватель найден: ${person.firstName} ${person.lastName}');
      }
    }

    return teachers;
  }

  Future<Teachers?> getTeacherById(Session session, int id) async {
    var teacher = await Teachers.db.findById(session, id);
    if (teacher == null) {
      return null;
    }

    var person = await Person.db.findById(session, teacher.personId);
    if (person != null) {
      session.log('Преподаватель найден: ${person.firstName} ${person.lastName}');
    }

    return teacher;
  }

  Future<Teachers> createTeacher(Session session, {
    required String firstName,
    required String lastName,
    String? patronymic,
    required String email,
    String? phoneNumber,
  }) async {
    // Проверяем, не существует ли уже человек с таким email
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

  Future<bool> deleteTeacher(Session session, int id) async {
    try {
      var teacher = await Teachers.db.findById(session, id);
      if (teacher == null) {
        return false;
      }

      // Удаляем запись Teacher
      await Teachers.db.deleteRow(session, teacher);

      // Удаляем запись Person
      var person = await Person.db.findById(session, teacher.personId);
      if (person != null) {
        await Person.db.deleteRow(session, person);
      }

      return true;
    } catch (e) {
      session.log(e.toString());
      return false;
    }
  }
}