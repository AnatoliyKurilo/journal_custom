import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class PersonEndpoint extends Endpoint {
  @override
  bool get requireAuth => true;

  @override
  Set<String> get requiredRoles => {'serverpod.admin'};

  // Обновление данных человека
  Future<Person> updatePerson(Session session, Person person) async {
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