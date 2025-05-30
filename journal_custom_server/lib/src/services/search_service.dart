import 'package:serverpod/serverpod.dart';

class SearchService {
  // Разделение строки запроса на токены
  static List<String> tokenizeQuery(String query) {
    return query
        .trim()
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .toList();
  }

  // Создание условий ILIKE для поиска
  static List<Expression<dynamic>> createSearchConditions(
    List<String> tokens, 
    List<Expression<dynamic> Function(String)> fieldGetters, // Изменили тип возвращаемого значения
  ) {
    var conditions = <Expression<dynamic>>[];
    for (var token in tokens) {
      final pattern = '%${token.toLowerCase()}%';
      var tokenConditions = <Expression<dynamic>>[];
      
      for (var fieldGetter in fieldGetters) {
        tokenConditions.add(fieldGetter(pattern));
      }
      
      if (tokenConditions.isNotEmpty) {
        conditions.add(tokenConditions.reduce((a, b) => a | b));
      }
    }
    return conditions;
  }

  // Объединение условий через AND
  static Expression<dynamic>? combineConditions(List<Expression<dynamic>> conditions) {
    if (conditions.isEmpty) return null;
    return conditions.reduce((a, b) => a & b);
  }
}