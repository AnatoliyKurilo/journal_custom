import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class SubjectsEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  // Метод для поиска дисциплин
  Future<List<Subjects>> searchSubjects(Session session, {required String query}) async {
    // Убираем лишние пробелы и приводим строку к нижнему регистру
    final trimmedQuery = query.trim().toLowerCase();

    // Если строка запроса пуста, возвращаем все дисциплины
    if (trimmedQuery.isEmpty) {
      return await Subjects.db.find(
        session,
        orderBy: (t) => t.name, // Сортировка по возрастанию
        orderDescending: false,
      );
    }

    // Разделяем строку запроса на слова
    final tokens = trimmedQuery.split(RegExp(r'\s+'));

    // Создаем условия для поиска
    var conditions = <Expression<dynamic>>[];
    for (var token in tokens) {
      conditions.add(Subjects.t.name.ilike('%$token%'));
    }

    // Объединяем условия через OR
    var whereClause = conditions.reduce((value, element) => value | element);

    // Выполняем запрос с фильтром
    return await Subjects.db.find(
      session,
      where: (t) => whereClause,
      orderBy: (t) => t.name, // Сортировка по возрастанию
      orderDescending: false,
    );
  }
}