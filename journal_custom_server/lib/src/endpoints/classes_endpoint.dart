import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class ClassesEndpoint extends Endpoint {
  @override
  bool get requireAuth => true;

  @override
  Set<String> get requiredRoles => {'serverpod.admin', 'curator'};

  // Метод для создания занятия
  Future<Classes> createClass(
    Session session, {
    required String subject,
    required String teacher,
    required DateTime date,
  }) async {
    // Проверяем, существует ли дисциплина
    final existingSubject = await Subjects.db.findFirstRow(
      session,
      where: (s) => s.name.equals(subject),
    );
    if (existingSubject == null) {
      throw Exception('Дисциплина "$subject" не найдена.');
    }

    // Проверяем, существует ли преподаватель
    final existingTeacher = await Teachers.db.findFirstRow(
      session,
      where: (t) => t.person!.firstName.equals(teacher.split(' ')[0]) &
          t.person!.lastName.equals(teacher.split(' ')[1]),
      include: Teachers.include(person: Person.include()),
    );
    if (existingTeacher == null) {
      throw Exception('Преподаватель "$teacher" не найден.');
    }

    // Создаем запись о занятии
    final newClass = Classes(
      subjectsId: existingSubject.id!,
      class_typesId: 1, // Replace with the appropriate class type ID
      teachersId: existingTeacher.id!,
      semestersId: 1, // Replace with the appropriate semester ID
      subgroupsId: 1, // Replace with the appropriate subgroup ID
      date: date,
    );

    return await Classes.db.insertRow(session, newClass);
  }
}