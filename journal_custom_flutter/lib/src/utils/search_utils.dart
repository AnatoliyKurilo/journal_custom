import 'package:journal_custom_client/journal_custom_client.dart';
import 'package:journal_custom_flutter/src/serverpod_client.dart';

class SearchUtils {
  static Future<List<Teachers>> searchTeachers(String query) async {
    try {
      // Выполняем поиск преподавателей через сервер
      return await client.admin.searchTeachers(query: query);
    } catch (e) {
      throw Exception('Ошибка поиска преподавателей: $e');
    }
  }
}