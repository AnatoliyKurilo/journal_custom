import 'package:flutter/material.dart';

class CsvFormatDialog extends StatelessWidget {
  final String title;
  final String description;
  final String header;
  final String exampleData;
  final List<String> requirements;
  final String? tip;
  final VoidCallback? onProceed;

  const CsvFormatDialog({
    Key? key,
    required this.title,
    required this.description,
    required this.header,
    required this.exampleData,
    required this.requirements,
    this.tip,
    this.onProceed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(child: Text(title)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              description,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Заголовок (первая строка):',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  Text(
                    header,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Пример данных:',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  Text(
                    exampleData,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('📋 Требования к файлу:'),
            const SizedBox(height: 8),
            ...requirements.map((req) => _buildRequirementItem(req)),
            if (tip != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.tips_and_updates, color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        tip!,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            onProceed?.call();
          },
          child: const Text('Продолжить импорт'),
        ),
      ],
    );
  }

  Widget _buildRequirementItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13),
      ),
    );
  }

  static Future<bool?> showStudentCsvDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => CsvFormatDialog(
        title: 'Формат CSV файла для студентов',
        description: 'Для корректного импорта студентов CSV файл должен иметь следующий формат:',
        header: 'Имя,Фамилия,Отчество,Email,Телефон',
        exampleData: 'Иван,Иванов,Иванович,ivan@example.com,79001234567\nПетр,Петров,Петрович,petr@example.com,79007654321',
        requirements: [
          '• Кодировка: UTF-8',
          '• Разделитель: запятая (,) или точка с запятой (;)',
          '• Обязательные поля: Имя, Фамилия, Email',
          '• Необязательные поля: Отчество, Телефон',
          '• Email должен быть уникальным',
          '• Название группы будет взято из имени файла или запрошено отдельно',
        ],
        tip: 'Совет: Используйте корпоративные email адреса для студентов',
      ),
    );
  }

  static Future<bool?> showTeacherCsvDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => CsvFormatDialog(
        title: 'Формат CSV файла для преподавателей',
        description: 'Для корректного импорта преподавателей CSV файл должен иметь следующий формат:',
        header: 'Имя,Фамилия,Отчество,Email,Телефон',
        exampleData: 'Иван,Иванов,Иванович,ivan.teacher@university.edu,79001234567\nМария,Петрова,Сергеевна,maria.petrova@university.edu,79007654321',
        requirements: [
          '• Кодировка: UTF-8',
          '• Разделитель: запятая (,) или точка с запятой (;)',
          '• Обязательные поля: Имя, Фамилия, Email',
          '• Необязательные поля: Отчество, Телефон',
          '• Email должен быть уникальным в системе',
          '• Рекомендуется использовать корпоративные email',
        ],
        tip: 'Совет: Экспортируйте существующих преподавателей, чтобы увидеть правильный формат',
      ),
    );
  }
}