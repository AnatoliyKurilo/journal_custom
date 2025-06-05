import 'package:journal_custom_server/src/custom_scope.dart';
import 'package:journal_custom_server/src/services/Scope_service.dart';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/permission_service.dart';

class SubgroupsEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  // @override
  // Set<Scope> get requiredScopes => {Scope.admin, CustomScope.curator, CustomScope.groupHead, CustomScope.teacher, CustomScope.student, CustomScope.documentSpecialist};

  // Получить группу текущего пользователя
  Future<Groups?> getCurrentUserGroup(Session session) async {
    return await PermissionService.getCurrentUserGroup(session);
  }

  
  // Создать новую подгруппу
  Future<Subgroups> createSubgroup(
    Session session,
    int groupId,
    String name,
    String? description,
  ) async {

    

    final canManage = await PermissionService.canManageGroupSubgroups(session, groupId);
    if (canManage != true) { // Убедитесь, что проверяется именно `true`
      throw Exception('Доступ запрещен: нет прав на управление подгруппами этой группы.');
    }

    ScopeService.checkScopes(
      session,
      requiredScopes: {CustomScope.documentSpecialist, Scope.admin},
    );

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

  // Создать подгруппу со всеми студентами группы
  Future<Subgroups> createFullGroupSubgroup(Session session,int groupId,String name,String? description,) async 
  {
    if (!await PermissionService.canManageGroupSubgroups(session, groupId)) {
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
    
    final createdSubgroup = await Subgroups.db.insertRow(session, newSubgroup);

    // Получаем всех студентов группы и добавляем в подгруппу
    final allGroupStudents = await Students.db.find(
      session,
      where: (s) => s.groupsId.equals(groupId),
    );

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
    if (!await PermissionService.canManageGroupSubgroups(session, groupId)) {
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
    if (!await PermissionService.canManageGroupSubgroups(session, subgroup.groupsId!)) {
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
    if (!await PermissionService.canManageGroupSubgroups(session, subgroup.groupsId!)) {
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
    if (!await PermissionService.canManageGroupSubgroups(session, subgroup.groupsId!)) {
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
    if (!await PermissionService.canManageGroupSubgroups(session, subgroup.groupsId!)) {
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
    if (!await PermissionService.canManageGroupSubgroups(session, subgroup.groupsId!)) {
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
    if (!await PermissionService.canManageGroupSubgroups(session, subgroup.groupsId!)) {
      throw Exception('Доступ запрещен: нет прав на управление этой подгруппой.');
    }

    final deleteCount = await StudentSubgroup.db.deleteWhere(
      session,
      where: (ss) =>
          ss.subgroupsId.equals(subgroupId) & ss.studentsId.equals(studentId),
    );
    return deleteCount.isNotEmpty; // Возвращает true, если строка была удалена
  }

  // Метод для поиска подгрупп
  Future<List<Subgroups>> searchSubgroups(Session session, {required String query}) async {
    // Убираем лишние пробелы и приводим строку к нижнему регистру
    final trimmedQuery = query.trim().toLowerCase();

    // Если строка запроса пуста, возвращаем все подгруппы
    if (trimmedQuery.isEmpty) {
      return await Subgroups.db.find(
        session,
        orderBy: (t) => t.name, // Сортировка по названию
        orderDescending: false,
      );
    }

    // Разделяем строку запроса на слова
    final tokens = trimmedQuery.split(RegExp(r'\s+'));

    // Создаем условия для поиска
    var conditions = <Expression<dynamic>>[];
    for (var token in tokens) {
      conditions.add(Subgroups.t.name.ilike('%$token%')); // Поиск по названию
    }

    // Объединяем условия через OR
    var whereClause = conditions.reduce((value, element) => value | element);

    // Выполняем запрос с фильтром
    return await Subgroups.db.find(
      session,
      where: (t) => whereClause,
      orderBy: (t) => t.name, // Сортировка по названию
      orderDescending: false,
    );
  }
}