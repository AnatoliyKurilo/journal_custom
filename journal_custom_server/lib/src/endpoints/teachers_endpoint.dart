import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class TeachersEndpoint extends Endpoint {
  @override
  bool get requireLogin  => true;

  // @override
  // Set<Scope> get requiredScopes  => {Scope.admin};

  // Создание преподавателя
  Future<Teachers> createTeacher(
    Session session, {
    required String firstName,
    required String lastName,
    String? patronymic,
    required String email,
    String? phoneNumber,
  }) async {
    var existingPerson = await Person.db.findFirstRow(
      session,
      where: (p) => p.email.equals(email),
    );
    if (firstName.isEmpty || lastName.isEmpty || email.isEmpty) {
      throw Exception('Все поля должны быть заполнены');
    }

    if (existingPerson != null) {
      throw Exception('Человек с таким email уже существует');
    }

    var person = Person(
      firstName: firstName,
      lastName: lastName,
      patronymic: patronymic,
      email: email,
      phoneNumber: phoneNumber,
    );

    person = await Person.db.insertRow(session, person);

    var teacher = Teachers(
      personId: person.id!,
    );

    return await Teachers.db.insertRow(session, teacher);
  }

  // Получение всех преподавателей
  Future<List<Teachers>> getAllTeachers(Session session) async {
    return await Teachers.db.find(
      session,
      include: Teachers.include(person: Person.include()),
    );
  }
}