import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class SemestersEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  // Метод для поиска семестров
  Future<List<Semesters>> searchSemesters(Session session, {required String query}) async {
    // Убираем лишние пробелы и приводим строку к нижнему регистру
    final trimmedQuery = query.trim().toLowerCase();

    // Если строка запроса пуста, возвращаем все семестры
    if (trimmedQuery.isEmpty) {
      return await Semesters.db.find(
        session,
        orderBy: (t) => t.name, // Сортировка по названию
        orderDescending: false,
      );
    }

    // Разделяем строку запроса на слова
    final tokens = trimmedQuery.split(RegExp(r'\s+'));

    // Создаем условия для поиска
    var conditions = <Expression<dynamic>>[];
    for (var token in tokens) {
      var yearToken = int.tryParse(token); // Преобразуем токен в число
      if (yearToken != null) {
        // Если токен — это число, ищем по году
        conditions.add(Semesters.t.year.equals(yearToken));
      } else {
        // Если токен — это строка, ищем по названию
        conditions.add(Semesters.t.name.ilike('%$token%'));
      }
    }

    // Объединяем условия через AND
    Expression<dynamic>? whereClause;
    if (conditions.isNotEmpty) {
      whereClause = conditions.reduce((value, element) => value & element);
    }

    // Выполняем запрос с фильтром
    return await Semesters.db.find(
      session,
      where: whereClause != null ? (t) => whereClause! : null,
      orderBy: (t) => t.name, // Сортировка по названию
      orderDescending: false,
    );
  }
}