import 'package:journal_custom_server/src/custom_scope.dart';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class PersonEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  // @override
  // Set<Scope> get requiredScopes => {Scope.admin, CustomScope.curator, CustomScope.groupHead, CustomScope.teacher, CustomScope.student, CustomScope.documentSpecialist};

  // Создание новой персоны
  Future<Person> createPerson(Session session, Person person) async {
    // Дополнительная логика, если Person создается без UserInfo
    if (person.userInfoId == null) {
      // Можно, например, запретить создание Person без UserInfo, если это бизнес-правило
      // throw Exception('Cannot create Person without a UserInfo link.');
      // Или оставить как есть, если это допустимо
    }
    return await Person.db.insertRow(session, person);
  }

  // Получение персоны по ID
  Future<Person?> getPerson(Session session, int personId) async {
    return await Person.db.findById(session, personId);
  }

  // Обновление данных человека
  Future<Person> updatePerson(Session session, Person person) async {
    // Проверяем, что ID персоны указан для обновления
    if (person.id == null) {
      throw Exception('Person ID must not be null for update.');
    }

    // УБИРАЕМ ИЛИ ИЗМЕНЯЕМ СТРОГУЮ ПРОВЕРКУ НА userInfoId
    // Старая проверка:
    // if (person.userInfoId == null) {
    //   throw Exception('Person userInfoId must not be null');
    // }

    // Возможная новая логика:
    // Если userInfoId передается, он должен быть валидным (если есть такая проверка)
    // Если userInfoId не передается (null), это может быть допустимо.

    // Пример: если userInfoId передается, но не существует в UserInfo, можно выбросить ошибку
    // if (person.userInfoId != null) {
    //   final userInfoExists = await UserInfo.db.findById(session, person.userInfoId!);
    //   if (userInfoExists == null) {
    //     throw Exception('UserInfo with id ${person.userInfoId} does not exist.');
    //   }
    // }

    // Просто обновляем запись
    return await Person.db.updateRow(session, person);
  }

  // Удаление персоны
  Future<bool> deletePerson(Session session, int personId) async {
    var result = await Person.db.deleteWhere(session, where: (p) => p.id.equals(personId));
    return result.isNotEmpty;
  }

  // Получение всех персон
  Future<List<Person>> getAllPersons(Session session) async {
    return await Person.db.find(session, orderBy: (t) => t.lastName);
  }
}