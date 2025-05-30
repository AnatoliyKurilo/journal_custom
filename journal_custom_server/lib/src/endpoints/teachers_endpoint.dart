import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class TeachersEndpoint extends Endpoint {
  @override
  bool get requireAuth => true;

  @override
  Set<String> get requiredRoles => {'serverpod.admin'};

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