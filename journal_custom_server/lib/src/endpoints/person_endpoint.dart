import 'package:journal_custom_server/src/custom_scope.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as emailAuth;
import '../generated/protocol.dart';
import 'package:serverpod_auth_server/module.dart' as auth; // Для UserInfo и EmailAuthController
// import 'package:serverpod_auth_email_server/module.dart' as emailAuth; // Для serverpod_email_auth

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
    if (person.id == null) {
      throw Exception('Person ID must not be null for update.');
    }

    // Получаем текущее состояние Person из базы данных
    final existingPerson = await Person.db.findById(session, person.id!);
    if (existingPerson == null) {
      throw Exception('Person with id ${person.id} not found.');
    }

    bool emailChangedInPerson = existingPerson.email != person.email;

    // 1. Обновляем запись Person
    final updatedPersonRow = await Person.db.updateRow(session, person);

    // 2. Если email изменился и есть связанный UserInfo
    if (emailChangedInPerson && updatedPersonRow.userInfoId != null) {
      final userInfo = await auth.UserInfo.db.findById(session, updatedPersonRow.userInfoId!);
      if (userInfo != null) {
        if (userInfo.email != updatedPersonRow.email) {
          // Проверяем, не занят ли новый email другим пользователем
          final conflictingUserInfo = await auth.UserInfo.db.findFirstRow(
            session,
            where: (u) => u.email.equals(updatedPersonRow.email) & u.id.notEquals(userInfo.id),
          );
          if (conflictingUserInfo != null) {
            throw Exception('Новый email (${updatedPersonRow.email}) уже используется другой учетной записью.');
          }

          // Обновляем email в UserInfo
          userInfo.email = updatedPersonRow.email;
          await auth.UserInfo.db.updateRow(session, userInfo);
          session.log('Email в UserInfo (id: ${userInfo.id}) изменен на: ${userInfo.email}');

          // 3. Обновляем email в таблице serverpod_email_auth
          final emailAuthRow = await emailAuth.EmailAuth.db.findFirstRow(
            session,
            where: (e) => e.userId.equals(userInfo.id),
          );
          if (emailAuthRow != null) {
            emailAuthRow.email = updatedPersonRow.email;
            await emailAuth.EmailAuth.db.updateRow(session, emailAuthRow);
            session.log('Email в serverpod_email_auth (userId: ${userInfo.id}) изменен на: ${emailAuthRow.email}');
          } else {
            session.log('Запись в serverpod_email_auth для userId: ${userInfo.id} не найдена.', level: LogLevel.warning);
          }
        }
      } else {
        session.log('UserInfo не найден для userInfoId: ${updatedPersonRow.userInfoId}.', level: LogLevel.warning);
      }
    }

    return updatedPersonRow;
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