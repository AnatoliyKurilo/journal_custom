import 'package:journal_custom_server/src/custom_scope.dart';
import 'package:journal_custom_server/src/services/Scope_service.dart';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/search_service.dart';
import '../services/user_subgroup_service.dart';

class SearchEndpoint extends Endpoint {
  @override
  bool get requireLogin  => true;

  // @override
  // Set<Scope> get requiredScopes  => {CustomScope.curator, CustomScope.groupHead, CustomScope.teacher, CustomScope.student, CustomScope.documentSpecialist};


  // Поиск студентов
  Future<List<Students>> searchStudents(Session session, {required String query}) async {
    
    ScopeService.checkScopes(
      session,
      requiredScopes: {CustomScope.curator, CustomScope.groupHead, CustomScope.teacher, CustomScope.student, CustomScope.documentSpecialist},
    );

    final tokens = SearchService.tokenizeQuery(query);

    if (tokens.isEmpty) {
      return await Students.db.find(
        session,
        include: Students.include(
          person: Person.include(),
          groups: Groups.include(),
        ),
      );
    }

    final conditions = SearchService.createSearchConditions(tokens, [
      (pattern) => Students.t.person.firstName.ilike(pattern),
      (pattern) => Students.t.person.lastName.ilike(pattern),
      (pattern) => Students.t.person.patronymic.ilike(pattern),
      (pattern) => Students.t.person.email.ilike(pattern),
      (pattern) => Students.t.person.phoneNumber.ilike(pattern),
      (pattern) => Students.t.groups.name.ilike(pattern),
    ]);

    final whereCondition = SearchService.combineConditions(conditions);

    return await Students.db.find(
      session,
      where: whereCondition != null ? (t) => whereCondition : null,
      include: Students.include(
        person: Person.include(),
        groups: Groups.include(),
      ),
    );
  }



  // Поиск преподавателей
  Future<List<Teachers>> searchTeachers(Session session, {required String query}) async {
    ScopeService.checkScopes(
      session,
      requiredScopes: {CustomScope.curator, CustomScope.groupHead, CustomScope.teacher, CustomScope.student, CustomScope.documentSpecialist},
    );
    
    
    final tokens = SearchService.tokenizeQuery(query);

    if (tokens.isEmpty) {
      return await Teachers.db.find(
        session,
        include: Teachers.include(person: Person.include()),
      );
    }

    final conditions = SearchService.createSearchConditions(tokens, [
      (pattern) => Teachers.t.person.firstName.ilike(pattern),
      (pattern) => Teachers.t.person.lastName.ilike(pattern),
      (pattern) => Teachers.t.person.patronymic.ilike(pattern),
      (pattern) => Teachers.t.person.email.ilike(pattern),
      (pattern) => Teachers.t.person.phoneNumber.ilike(pattern),
    ]);

    final whereCondition = SearchService.combineConditions(conditions);

    return await Teachers.db.find(
      session,
      where: whereCondition != null ? (t) => whereCondition : null,
      include: Teachers.include(person: Person.include()),
    );
  }

  // Поиск групп
  Future<List<Groups>> searchGroups(Session session, {required String query}) async {
    ScopeService.checkScopes(
      session,
      requiredScopes: {CustomScope.curator, CustomScope.groupHead, CustomScope.teacher, CustomScope.student, CustomScope.documentSpecialist},
    );
    
    final tokens = SearchService.tokenizeQuery(query);

    if (tokens.isEmpty) {
      return await Groups.db.find(
        session,
        include: Groups.include(
          curator: Teachers.include(person: Person.include()),
        ),
      );
    }

    final conditions = SearchService.createSearchConditions(tokens, [
      (pattern) => Groups.t.name.ilike(pattern),
      (pattern) => Groups.t.curator.person.firstName.ilike(pattern),
      (pattern) => Groups.t.curator.person.lastName.ilike(pattern),
    ]);

    final whereCondition = SearchService.combineConditions(conditions);

    return await Groups.db.find(
      session,
      where: whereCondition != null ? (t) => whereCondition : null,
      include: Groups.include(
        curator: Teachers.include(person: Person.include()),
      ),
    );
  }

  // Поиск дисциплин
  Future<List<Subjects>> searchSubjects(Session session, {required String query}) async {
    final tokens = SearchService.tokenizeQuery(query);

    if (tokens.isEmpty) {
      return await Subjects.db.find(
        session,
        orderBy: (t) => t.name,
        orderDescending: false,
      );
    }

    final conditions = SearchService.createSearchConditions(tokens, [
      (pattern) => Subjects.t.name.ilike(pattern),
    ]);

    final whereCondition = SearchService.combineConditions(conditions);

    return await Subjects.db.find(
      session,
      where: whereCondition != null ? (t) => whereCondition : null,
      orderBy: (t) => t.name,
      orderDescending: false,
    );
  }

  // Поиск типов занятий
  Future<List<ClassTypes>> searchClassTypes(Session session, {required String query}) async {
    final tokens = SearchService.tokenizeQuery(query);

    if (tokens.isEmpty) {
      return await ClassTypes.db.find(
        session,
        orderBy: (t) => t.name,
        orderDescending: false,
      );
    }

    final conditions = SearchService.createSearchConditions(tokens, [
      (pattern) => ClassTypes.t.name.ilike(pattern),
    ]);

    final whereCondition = SearchService.combineConditions(conditions);

    return await ClassTypes.db.find(
      session,
      where: whereCondition != null ? (t) => whereCondition : null,
      orderBy: (t) => t.name,
      orderDescending: false,
    );
  }

  // Обновленный поиск подгрупп с фильтрацией по доступу
  Future<List<Subgroups>> searchSubgroups(Session session, {required String query}) async {
    // Получаем список доступных ID подгрупп для пользователя
    final accessibleSubgroupIds = await UserSubgroupService.getUserAccessibleSubgroupIds(session);

    // Если у пользователя нет доступа ни к одной подгруппе, возвращаем пустой список
    if (accessibleSubgroupIds.isEmpty) {
      return [];
    }

    // Токенизируем запрос
    final tokens = SearchService.tokenizeQuery(query);

    // Если запрос пустой, возвращаем все доступные подгруппы, отсортированные по имени
    if (tokens.isEmpty) {
      return await Subgroups.db.find(
        session,
        where: (s) => s.id.inSet(accessibleSubgroupIds.toSet()),
        orderBy: (s) => s.name,
        orderDescending: false,
      );
    }

    // Создаем условия поиска на основе токенов
    final conditions = SearchService.createSearchConditions(tokens, [
      (pattern) => Subgroups.t.name.ilike(pattern),
    ]);

    // Условие для фильтрации доступных подгрупп
    final accessCondition = Subgroups.t.id.inSet(accessibleSubgroupIds.toSet());

    // Объединяем условия поиска и доступности
    final combinedConditions = SearchService.combineConditions(conditions);
    final finalCondition = combinedConditions != null 
        ? combinedConditions & accessCondition
        : accessCondition;

    // Выполняем поиск с учетом условий и сортировки
    return await Subgroups.db.find(
      session,
      where: (s) => finalCondition,
      orderBy: (s) => s.name,
      orderDescending: false,
    );
  }
}