import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import '../generated/protocol.dart';
import '../custom_scope.dart'; // Убедитесь, что CustomScope.groupHead.name существует

class SubgroupsEndpoint extends Endpoint {
  // Вспомогательный метод для проверки прав доступа к управлению подгруппами группы
  // Доступ разрешен администраторам, старосте этой группы или куратору этой группы.
  Future<bool> _canManageGroupSubgroups(Session session, int groupId) async {
    // 1) Получаем ID текущего пользователя
    var userId = (await session.authenticated)!.userId;

    // 2) Загружаем полную информацию о пользователе
    var authUser = await Users.findUserByUserId(session, userId);
    if (authUser == null) {
      return false; // Не удалось получить информацию о пользователе
    }

    // Администраторы имеют полный доступ
    if (authUser.scopeNames.contains('serverpod.admin')) {
      return true;
    }

    // Находим связанную запись Person
    final person = await Person.db.findFirstRow(
      session,
      where: (p) => p.userInfoId.equals(userId),
    );
    if (person == null) {
      return false; // Профиль пользователя не найден
    }

    // Проверка на старосту группы
    if (authUser.scopeNames.contains('groupHead')) {
      final student = await Students.db.findFirstRow(
        session,
        where: (s) => s.personId.equals(person.id!) & s.groupsId.equals(groupId) & s.isGroupHead.equals(true),
      );
      if (student != null) {
        return true; // Пользователь является старостой этой группы
      }
    }

    // Проверка на куратора группы
    if (authUser.scopeNames.contains('curator')) {
      // Находим запись Teacher для этого пользователя
      final teacher = await Teachers.db.findFirstRow(
        session,
        where: (t) => t.personId.equals(person.id!),
      );
      
      if (teacher != null) {
        // Проверяем, является ли преподаватель куратором данной группы
        final group = await Groups.db.findById(session, groupId);
        if (group != null && group.curatorId == teacher.id) {
          return true; // Пользователь является куратором этой группы
        }
      }
    }

    return false; // Нет прав доступа
  }

  @override
  bool get requireAuth => true;

  @override
  Set<String> get requiredRoles=> {'groupHead', 'curator', 'serverpod.admin'};

  // Получить группу текущего аутентифицированного пользователя (если он староста)
  Future<Groups?> getCurrentUserGroup(Session session) async {
    // 1) Получаем ID текущего пользователя
    var userId = (await session.authenticated)!.userId;

    // 2) Загружаем полную информацию о пользователе
    var authUser = await Users.findUserByUserId(session, userId);
    if (authUser == null) {
      throw Exception('Не удалось получить информацию о пользователе.');
    }

    // Проверяем, имеет ли пользователь роль администратора
    if (authUser.scopeNames.contains('serverpod.admin')) {
      // Для админов можно получить любую группу (или первую в списке)
      var allGroups = await Groups.db.find(
        session,
        limit: 1, // Берем первую группу для демонстрации
      );
      return allGroups.isNotEmpty ? allGroups.first : null;
    }

    // Находим связанную запись Person
    final person = await Person.db.findFirstRow(
      session,
      where: (p) => p.userInfoId.equals(userId),
    );
    if (person == null) {
      throw Exception('Связанный профиль пользователя не найден.');
    }

    // Проверка на старосту группы
    // 1. Находим студента по personId
    if (authUser.scopeNames.contains('groupHead')) {
      final student = await Students.db.findFirstRow(
        session,
        where: (s) => s.personId.equals(person.id!) & s.isGroupHead.equals(true),
      );

      // 2. Проверяем, что студент существует и является старостой
      if (student != null) {
        // Получаем группу студента
        final group = await Groups.db.findById(session, student.groupsId);
        return group;
      }
    }

    // Проверка на куратора группы (если пользователь не староста)
    if (authUser.scopeNames.contains('curator')) {
      final teacher = await Teachers.db.findFirstRow(
        session,
        where: (t) => t.personId.equals(person.id!),
      );

      if (teacher != null) {
        // Находим группу, где учитель является куратором
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

    // Если не нашли группу или пользователь не имеет нужных прав
    return null;
  }

  // Создать новую подгруппу
  Future<Subgroups> createSubgroup(
    Session session,
    int groupId,
    String name,
    String? description,
  ) async {
    if (!await _canManageGroupSubgroups(session, groupId)) {
      throw Exception('Доступ запрещен: нет прав на управление подгруппами этой группы.');
    }

    final groupExists = await Groups.db.findById(session, groupId);
    if (groupExists == null) {
      throw Exception('Основная группа не найдена.');
    }

    final existingSubgroup = await Subgroups.db.findFirstRow(
      session,
      where: (s) => s.groupsId.equals(groupId) & s.name.equals(name),
    );
    if (existingSubgroup != null) {
      throw Exception('Подгруппа с таким названием уже существует в этой группе.');
    }

    final newSubgroup = Subgroups(
      name: name,
      description: description,
      groupsId: groupId,
    );
    return Subgroups.db.insertRow(session, newSubgroup);
  }

  // Метод для создания подгруппы со всеми студентами группы
  Future<Subgroups> createFullGroupSubgroup(
    Session session,
    int groupId,
    String name,
    String? description,
  ) async {
    if (!await _canManageGroupSubgroups(session, groupId)) {
      throw Exception('Доступ запрещен: нет прав на управление подгруппами этой группы.');
    }

    final groupExists = await Groups.db.findById(session, groupId);
    if (groupExists == null) {
      throw Exception('Основная группа не найдена.');
    }

    // Проверяем, нет ли уже подгруппы с таким названием
    final existingSubgroup = await Subgroups.db.findFirstRow(
      session,
      where: (s) => s.groupsId.equals(groupId) & s.name.equals(name),
    );
    if (existingSubgroup != null) {
      throw Exception('Подгруппа с таким названием уже существует в этой группе.');
    }

    // Создаем новую подгруппу
    final newSubgroup = Subgroups(
      name: name,
      description: description,
      groupsId: groupId,
    );
    
    // Сохраняем подгруппу в базе
    final createdSubgroup = await Subgroups.db.insertRow(session, newSubgroup);

    // Получаем всех студентов группы
    final allGroupStudents = await Students.db.find(
      session,
      where: (s) => s.groupsId.equals(groupId),
    );

    // Добавляем всех студентов в подгруппу
    for (var student in allGroupStudents) {
      final newLink = StudentSubgroup(
        subgroupsId: createdSubgroup.id!,
        studentsId: student.id!,
      );
      await StudentSubgroup.db.insertRow(session, newLink);
    }

    return createdSubgroup;
  }

  // Получить все подгруппы для указанной группы
  Future<List<Subgroups>> getGroupSubgroups(Session session, int groupId) async {
    // Разрешим просмотр подгрупп, если пользователь может ими управлять
    if (!await _canManageGroupSubgroups(session, groupId)) {
      throw Exception('Доступ запрещен: нет прав на просмотр подгрупп этой группы.');
    }
    return Subgroups.db.find(session, where: (s) => s.groupsId.equals(groupId));
  }

  // Обновить подгруппу
  Future<Subgroups> updateSubgroup(
    Session session,
    int subgroupId,
    String name,
    String? description,
  ) async {
    final subgroup = await Subgroups.db.findById(session, subgroupId);
    if (subgroup == null) {
      throw Exception('Подгруппа не найдена.');
    }
    if (!await _canManageGroupSubgroups(session, subgroup.groupsId!)) {
      throw Exception('Доступ запрещен: нет прав на управление этой подгруппой.');
    }

    final conflictingSubgroup = await Subgroups.db.findFirstRow(
      session,
      where: (s) =>
          s.groupsId.equals(subgroup.groupsId!) &
          s.name.equals(name) &
          s.id.notEquals(subgroupId),
    );
    if (conflictingSubgroup != null) {
      throw Exception('Другая подгруппа с таким названием уже существует в этой группе.');
    }

    final updatedSubgroup = subgroup.copyWith(name: name, description: description);
    return Subgroups.db.updateRow(session, updatedSubgroup);
  }

  // Удалить подгруппу
  Future<bool> deleteSubgroup(Session session, int subgroupId) async {
    final subgroup = await Subgroups.db.findById(session, subgroupId);
    if (subgroup == null) {
      throw Exception('Подгруппа не найдена.');
    }
    if (!await _canManageGroupSubgroups(session, subgroup.groupsId!)) {
      throw Exception('Доступ запрещен: нет прав на управление этой подгруппой.');
    }

    // Удаляем все связи студентов с этой подгруппой
    await StudentSubgroup.db.deleteWhere(
      session,
      where: (ss) => ss.subgroupsId.equals(subgroupId),
    );

    await Subgroups.db.deleteRow(session, subgroup);
    return true;
  }

  // Получить студентов в указанной подгруппе
  Future<List<Students>> getSubgroupStudents(Session session, int subgroupId) async {
    final subgroup = await Subgroups.db.findById(session, subgroupId);
    if (subgroup == null) {
      throw Exception('Подгруппа не найдена.');
    }
    if (!await _canManageGroupSubgroups(session, subgroup.groupsId!)) {
      throw Exception('Доступ запрещен: нет прав на просмотр студентов этой подгруппы.');
    }

    final studentLinks = await StudentSubgroup.db.find(
      session,
      where: (ss) => ss.subgroupsId.equals(subgroupId),
      include: StudentSubgroup.include(
        students: Students.include(
          person: Person.include(),
        ),
      ),
    );
    return studentLinks.map((link) => link.students!).toList();
  }

  // Получить студентов из основной группы, которые НЕ состоят в указанной подгруппе
  Future<List<Students>> getStudentsNotInSubgroup(Session session, int subgroupId) async {
    final subgroup = await Subgroups.db.findById(session, subgroupId);
    if (subgroup == null) {
      throw Exception('Подгруппа не найдена.');
    }
    if (!await _canManageGroupSubgroups(session, subgroup.groupsId!)) {
      throw Exception('Доступ запрещен.');
    }

    // Получаем всех студентов основной группы
    final allGroupStudents = await Students.db.find(
      session,
      where: (s) => s.groupsId.equals(subgroup.groupsId!),
      include: Students.include(person: Person.include()),
    );

    // Получаем id студентов, которые уже в подгруппе
    final studentLinks = await StudentSubgroup.db.find(
      session,
      where: (ss) => ss.subgroupsId.equals(subgroupId),
    );
    final idsInSubgroup = studentLinks.map((link) => link.studentsId).toSet();

    // Фильтруем студентов, которых нет в подгруппе
    final result = allGroupStudents.where((student) => !idsInSubgroup.contains(student.id)).toList();

    return result;
  }

  // Добавить студента в подгруппу
  Future<bool> addStudentToSubgroup(Session session, int subgroupId, int studentId) async {
    final subgroup = await Subgroups.db.findById(session, subgroupId);
    if (subgroup == null) {
      throw Exception('Подгруппа не найдена.');
    }
    if (!await _canManageGroupSubgroups(session, subgroup.groupsId!)) {
      throw Exception('Доступ запрещен: нет прав на управление этой подгруппой.');
    }

    final student = await Students.db.findById(session, studentId);
    if (student == null) {
      throw Exception('Студент не найден.');
    }
    if (student.groupsId != subgroup.groupsId) {
      throw Exception('Студент не принадлежит к основной группе этой подгруппы.');
    }

    final existingLink = await StudentSubgroup.db.findFirstRow(
      session,
      where: (ss) =>
          ss.subgroupsId.equals(subgroupId) & ss.studentsId.equals(studentId),
    );
    if (existingLink != null) {
      throw Exception('Студент уже состоит в этой подгруппе.');
    }

    final newLink = StudentSubgroup(
      subgroupsId: subgroupId,
      studentsId: studentId,
    );
    await StudentSubgroup.db.insertRow(session, newLink);
    return true;
  }

  // Удалить студента из подгруппы
  Future<bool> removeStudentFromSubgroup(Session session, int subgroupId, int studentId) async {
    final subgroup = await Subgroups.db.findById(session, subgroupId);
    if (subgroup == null) {
      throw Exception('Подгруппа не найдена.');
    }
    if (!await _canManageGroupSubgroups(session, subgroup.groupsId!)) {
      throw Exception('Доступ запрещен: нет прав на управление этой подгруппой.');
    }

    final deleteCount = await StudentSubgroup.db.deleteWhere(
      session,
      where: (ss) =>
          ss.subgroupsId.equals(subgroupId) & ss.studentsId.equals(studentId),
    );
    return deleteCount.isNotEmpty; // Возвращает true, если строка была удалена
  }
}