// filepath: c:\Users\anato\source\Flutter\Serverpod\journal_custom\journal_custom_flutter\lib\src\utils\name_formatters.dart
class NameFormatters {
  static String formatFullName({
    String? lastName,
    String? firstName,
    String? patronymic,
  }) {
    List<String> parts = [];
    if (lastName != null && lastName.isNotEmpty) parts.add(lastName);
    if (firstName != null && firstName.isNotEmpty) parts.add(firstName);
    if (patronymic != null && patronymic.isNotEmpty) parts.add(patronymic);
    return parts.join(' ');
  }
}