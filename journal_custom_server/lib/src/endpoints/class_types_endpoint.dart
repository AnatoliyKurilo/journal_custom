import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class ClassTypesEndpoint extends Endpoint {
  @override
  bool get requireAuth => true;

  // Метод для поиска типов занятий
  Future<List<ClassTypes>> searchClassTypes(Session session, {required String query}) async {
    // Убираем лишние пробелы и приводим строку к нижнему регистру
    final trimmedQuery = query.trim().toLowerCase();

    // Если строка запроса пуста, возвращаем все типы занятий
    if (trimmedQuery.isEmpty) {
      return await ClassTypes.db.find(
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
      conditions.add(ClassTypes.t.name.ilike('%$token%')); // Используем ilike для нечувствительного к регистру поиска
    }

    // Объединяем условия через OR
    Expression<dynamic>? whereClause;
    if (conditions.isNotEmpty) {
      whereClause = conditions.reduce((value, element) => value | element);
    }

    // Выполняем запрос с фильтром
    return await ClassTypes.db.find(
      session,
      where: whereClause != null ? (t) => whereClause! : null,
      orderBy: (t) => t.name, // Сортировка по возрастанию
      orderDescending: false,
    );
  }
}