import 'package:journal_custom_server/src/custom_scope.dart';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class PersonEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  // @override
  // Set<Scope> get requiredScopes => {Scope.admin, CustomScope.curator, CustomScope.groupHead, CustomScope.teacher, CustomScope.student, CustomScope.documentSpecialist};

  // Обновление данных человека
  Future<Person> updatePerson(Session session, Person person) async {
    if (person.id == null) {
    throw Exception('Person ID must not be null');
  }
  if (person.firstName == null || person.lastName == null) {
    throw Exception('Person firstName and lastName must not be null');
  }
  if (person.email == null || person.email!.isEmpty) {
    throw Exception('Person email must not be null or empty');
  }
  if (person.userInfoId == null) {
    throw Exception('Person userInfoId must not be null');
  }

    try {
      await Person.db.updateRow(session, person);
      return person;
    } catch (e, stackTrace) {
      session.log(
        'PersonEndpoint: Ошибка при обновлении Person: $e',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}