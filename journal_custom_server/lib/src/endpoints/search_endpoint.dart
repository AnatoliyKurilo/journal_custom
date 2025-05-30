import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/search_service.dart';
import '../services/user_subgroup_service.dart';

class SearchEndpoint extends Endpoint {
  @override
  bool get requireAuth => true;

  // Поиск студентов
  Future<List<Students>> searchStudents(Session session, {required String query}) async {
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
    final accessibleSubgroupIds = await UserSubgroupService.getUserAccessibleSubgroupIds(session);
    
    if (accessibleSubgroupIds.isEmpty) {
      return [];
    }

    final tokens = SearchService.tokenizeQuery(query);

    if (tokens.isEmpty) {
      return await Subgroups.db.find(
        session,
        where: (s) => s.id.inSet(accessibleSubgroupIds.toSet()),
        orderBy: (s) => s.name,
        orderDescending: false,
      );
    }

    final conditions = SearchService.createSearchConditions(tokens, [
      (pattern) => Subgroups.t.name.ilike(pattern),
    ]);

    final whereCondition = SearchService.combineConditions(conditions);
    final accessCondition = Subgroups.t.id.inSet(accessibleSubgroupIds.toSet());
    
    final finalCondition = whereCondition != null 
        ? whereCondition & accessCondition
        : accessCondition;

    return await Subgroups.db.find(
      session,
      where: (t) => finalCondition,
      orderBy: (t) => t.name,
      orderDescending: false,
    );
  }
}