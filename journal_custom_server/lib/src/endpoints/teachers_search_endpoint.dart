// Метод для поиска преподавателей
  import 'package:journal_custom_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class TeacherSearchEndpoint extends Endpoint {
    Future<List<Teachers>> searchTeachers(
      Session session, {
      required String query, // Принимаем строку запроса
    }) async {
      // 1. Разделяем строку на слова
      final tokens = query
          .trim()
          .split(RegExp(r'\s+'))
          .where((t) => t.isNotEmpty)
          .toList();

      // Если строка пуста, возвращаем всех преподавателей
      if (tokens.isEmpty) {
        return await Teachers.db.find(
          session,
          include: Teachers.include(
            person: Person.include(),
          ),
        );
      }

      // 2. Построение списка условий
      var conditions = <Expression<dynamic>>[];
      for (var token in tokens) {
        final pattern = '%${token.toLowerCase()}%';
        conditions.add(
          Teachers.t.person.firstName.ilike(pattern) |
          Teachers.t.person.lastName.ilike(pattern) |
          Teachers.t.person.patronymic.ilike(pattern) |
          Teachers.t.person.email.ilike(pattern) |
          Teachers.t.person.phoneNumber.ilike(pattern),
        );
      }

      // 3. Объединение условий через AND
      var combinedCondition = conditions.reduce((a, b) => a & b);

      // 4. Выполняем запрос с использованием include
      return await Teachers.db.find(
        session,
        where: (t) => combinedCondition,
        include: Teachers.include(
          person: Person.include(),
        ),
      );
    }
  }
