import 'package:flutter/material.dart';
import 'package:journal_custom_client/journal_custom_client.dart';
import 'package:journal_custom_flutter/core/serverpod_client.dart';

class ScheduleTab extends StatefulWidget {
  const ScheduleTab({Key? key}) : super(key: key);

  @override
  _ScheduleTabState createState() => _ScheduleTabState();
}

class _ScheduleTabState extends State<ScheduleTab> {
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    // Здесь можно добавить инициализацию данных расписания
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage!),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  errorMessage = null;
                });
              },
              child: const Text('Попробовать снова'),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(isMobile ? 8.0 : 16.0),
      child: Column(
        children: [
          // Заголовок и кнопки управления
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Управление расписанием',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (isMobile) ...[
                IconButton(
                  icon: const Icon(Icons.upload_file),
                  onPressed: _importSchedule,
                  tooltip: 'Импорт расписания',
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _showCreateScheduleDialog,
                  tooltip: 'Добавить занятие',
                ),
              ]
            ],
          ),
          const SizedBox(height: 16),
          
          // Кнопки для больших экранов
          if (!isMobile)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Импорт расписания'),
                  onPressed: _importSchedule,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  label: const Text('Экспорт расписания'),
                  onPressed: _exportSchedule,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Добавить занятие'),
                  onPressed: _showCreateScheduleDialog,
                ),
              ],
            ),
          
          const SizedBox(height: 20),
          
          // Основное содержимое - пока что заглушка
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.schedule,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Управление расписанием',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Здесь будет интерфейс для управления расписанием занятий',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  
                  // Список запланированных функций
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Планируемый функционал:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildFeatureItem('📅', 'Создание и редактирование расписания'),
                          _buildFeatureItem('👥', 'Назначение преподавателей на занятия'),
                          _buildFeatureItem('🏫', 'Управление аудиториями'),
                          _buildFeatureItem('📊', 'Просмотр расписания по группам'),
                          _buildFeatureItem('📤', 'Импорт/экспорт расписания'),
                          _buildFeatureItem('🔔', 'Уведомления об изменениях'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Future<void> _importSchedule() async {
    // Заглушка для импорта расписания
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Импорт расписания пока не реализован'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Future<void> _exportSchedule() async {
    // Заглушка для экспорта расписания
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Экспорт расписания пока не реализован'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Future<void> _showCreateScheduleDialog() async {
    // Заглушка для создания занятия
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Добавить занятие'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.construction, size: 48, color: Colors.orange),
              SizedBox(height: 16),
              Text(
                'Функция создания занятий находится в разработке',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }
}