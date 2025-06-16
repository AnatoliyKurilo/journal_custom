import 'package:flutter/material.dart';
import 'package:journal_custom_client/journal_custom_client.dart';
import 'package:journal_custom_flutter/core/serverpod_client.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // Добавляем этот импорт

class AutoImportTab extends StatefulWidget {
  const AutoImportTab({Key? key}) : super(key: key);

  @override
  _AutoImportTabState createState() => _AutoImportTabState();
}

class _AutoImportTabState extends State<AutoImportTab> {
  bool isLoading = false;
  bool _localeInitialized = false; // Добавляем флаг инициализации
  String? errorMessage;
  String? resultMessage;
  DateTime selectedDate = DateTime.now();
  List<Groups> availableGroups = [];
  List<Groups> selectedGroups = [];
  bool selectAllGroups = false;
  
  // Настройки автоимпорта
  String selectedYear = '2024-2025';
  bool autoCreateMissingGroups = true;
  bool skipExistingClasses = true;
  bool createMainSubgroups = true;

  @override
  void initState() {
    super.initState();
    _initializeLocaleAndLoadData();
  }

  // Инициализируем локализацию и загружаем данные
  Future<void> _initializeLocaleAndLoadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Инициализируем локализацию
      await initializeDateFormatting('ru', null);
      setState(() {
        _localeInitialized = true;
      });
      
      // Загружаем группы
      await _loadAvailableGroups();
    } catch (e) {
      setState(() {
        errorMessage = 'Ошибка инициализации: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _loadAvailableGroups() async {
    if (!_localeInitialized) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final groups = await client.groups.getAllGroups();
      setState(() {
        availableGroups = groups;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Ошибка загрузки групп: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _performAutoImport() async {
    if (selectedGroups.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите хотя бы одну группу для импорта')),
      );
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
      resultMessage = null;
    });

    try {
      // Показываем прогресс диалог
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Автоимпорт занятий'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text('Импорт занятий на ${_formatDate(selectedDate, 'dd.MM.yyyy')}...'),
                Text('Групп: ${selectedGroups.length}'),
              ],
            ),
          );
        },
      );

      List<String> importResults = [];
      int successCount = 0;
      int errorCount = 0;

      for (var group in selectedGroups) {
        try {
          // ИСПРАВЛЕНИЕ: Устанавливаем точные границы дня
          final startOfDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 0, 0, 0);
          final endOfDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59);
          
          final result = await client.classes.importClassesFromScheduleForGroup(
            group.id!,
            selectedYear,
            startDate: _formatDate(startOfDay, 'yyyy-MM-dd'),
            endDate: _formatDate(endOfDay, 'yyyy-MM-dd'),
          );
          
          importResults.add('✅ ${group.name}: Успешно');
          successCount++;
        } catch (e) {
          importResults.add('❌ ${group.name}: $e');
          errorCount++;
        }
      }

      Navigator.pop(context); // Закрываем прогресс диалог

      // Показываем результаты
      final summaryResult = '''
Автоимпорт завершен для ${_formatDate(selectedDate, 'dd.MM.yyyy')}

📊 Сводка:
• Успешно: $successCount групп
• Ошибки: $errorCount групп
• Всего обработано: ${selectedGroups.length} групп

📋 Детали:
${importResults.join('\n')}
      ''';

      setState(() {
        resultMessage = summaryResult;
        isLoading = false;
      });

      // Показываем диалог с результатами
      _showResultDialog(summaryResult, successCount, errorCount);

    } catch (e) {
      Navigator.pop(context); // Закрываем прогресс диалог
      setState(() {
        errorMessage = 'Критическая ошибка автоимпорта: $e';
        isLoading = false;
      });
    }
  }

  // Безопасное форматирование даты
  String _formatDate(DateTime date, String pattern) {
    if (!_localeInitialized) {
      // Fallback если локализация не инициализирована
      switch (pattern) {
        case 'dd.MM.yyyy':
          return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
        case 'yyyy-MM-dd':
          return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        default:
          return date.toString().split(' ')[0];
      }
    }
    try {
      return DateFormat(pattern, 'ru').format(date);
    } catch (e) {
      // Fallback на английскую локаль
      return DateFormat(pattern).format(date);
    }
  }

  // Безопасное форматирование даты с полным названием
  String _formatDateFull(DateTime date) {
    if (!_localeInitialized) {
      final weekdays = ['Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота', 'Воскресенье'];
      final months = ['января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 
                     'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'];
      
      final weekday = weekdays[date.weekday - 1];
      final month = months[date.month - 1];
      
      return '$weekday, ${date.day} $month ${date.year}';
    }
    
    try {
      return DateFormat('EEEE, dd MMMM yyyy', 'ru').format(date);
    } catch (e) {
      return DateFormat('EEEE, dd MMMM yyyy').format(date);
    }
  }

  void _showResultDialog(String results, int successCount, int errorCount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                successCount > errorCount ? Icons.check_circle : Icons.warning,
                color: successCount > errorCount ? Colors.green : Colors.orange,
              ),
              const SizedBox(width: 8),
              const Text('Результат автоимпорта'),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Дата: ${_formatDate(selectedDate, 'dd.MM.yyyy')}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Успешно: $successCount'),
                        Text('Ошибки: $errorCount'),
                        Text('Всего: ${selectedGroups.length}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Детальный отчет:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    results,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Закрыть'),
            ),
            if (errorCount > 0)
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showRetryDialog();
                },
                child: const Text('Повторить ошибочные'),
              ),
          ],
        );
      },
    );
  }

  void _showRetryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Повторить импорт'),
          content: const Text('Повторить импорт для групп с ошибками?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Здесь можно реализовать логику повтора для ошибочных групп
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Функция повтора будет реализована')),
                );
              },
              child: const Text('Повторить'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('ru', 'RU'),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Widget _buildDateSelector() {
    // Показываем загрузку если локализация не инициализирована
    if (!_localeInitialized) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 8),
              Text('Инициализация локализации...'),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📅 Выбор даты',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Выбранная дата:'),
                        Text(
                          _formatDateFull(selectedDate),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _selectDate,
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Изменить'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      selectedDate = DateTime.now();
                    });
                  },
                  icon: const Icon(Icons.today),
                  label: const Text('Сегодня'),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      selectedDate = DateTime.now().add(const Duration(days: 1));
                    });
                  },
                  icon: const Icon(Icons.skip_next),
                  label: const Text('Завтра'),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      selectedDate = DateTime.now().add(const Duration(days: 7));
                    });
                  },
                  icon: const Icon(Icons.fast_forward),
                  label: const Text('Через неделю'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  '🎓 Выбор групп',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text('Выбрано: ${selectedGroups.length}/${availableGroups.length}'),
              ],
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              title: const Text('Выбрать все группы'),
              value: selectAllGroups,
              onChanged: (bool? value) {
                setState(() {
                  selectAllGroups = value ?? false;
                  if (selectAllGroups) {
                    selectedGroups = List.from(availableGroups);
                  } else {
                    selectedGroups.clear();
                  }
                });
              },
            ),
            const Divider(),
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: availableGroups.length,
                itemBuilder: (context, index) {
                  final group = availableGroups[index];
                  final isSelected = selectedGroups.contains(group);
                  
                  return CheckboxListTile(
                    title: Text(group.name ?? 'Группа без названия'),
                    subtitle: group.curator?.person != null
                        ? Text('Куратор: ${group.curator!.person!.firstName} ${group.curator!.person!.lastName}')
                        : const Text('Куратор не назначен'),
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedGroups.add(group);
                        } else {
                          selectedGroups.remove(group);
                        }
                        selectAllGroups = selectedGroups.length == availableGroups.length;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '⚙️ Настройки импорта',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedYear,
              decoration: const InputDecoration(
                labelText: 'Учебный год',
                border: OutlineInputBorder(),
              ),
              items: [
                '2023-2024',
                '2024-2025',
                '2025-2026',
              ].map((year) {
                return DropdownMenuItem(
                  value: year,
                  child: Text(year),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedYear = newValue ?? '2024-2025';
                });
              },
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              title: const Text('Пропускать существующие занятия'),
              subtitle: const Text('Не создавать дубликаты занятий'),
              value: skipExistingClasses,
              onChanged: (bool? value) {
                setState(() {
                  skipExistingClasses = value ?? true;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Создавать основные подгруппы'),
              subtitle: const Text('Автоматически создать подгруппу "Основная подгруппа"'),
              value: createMainSubgroups,
              onChanged: (bool? value) {
                setState(() {
                  createMainSubgroups = value ?? true;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Создавать отсутствующие группы'),
              subtitle: const Text('Автоматически создать группы из расписания'),
              value: autoCreateMissingGroups,
              onChanged: (bool? value) {
                setState(() {
                  autoCreateMissingGroups = value ?? true;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🚀 Действия',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isLoading || !_localeInitialized ? null : _performAutoImport,
                    icon: isLoading 
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.play_arrow),
                    label: Text(isLoading ? 'Импортируем...' : 'Начать автоимпорт'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: isLoading || !_localeInitialized ? null : _loadAvailableGroups,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Обновить'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
            if (selectedGroups.isNotEmpty && _localeInitialized) ...[
              const SizedBox(height: 8),
              Text(
                'Будет выполнен импорт занятий на ${_formatDate(selectedDate, 'dd.MM.yyyy')} для ${selectedGroups.length} групп.',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    if (errorMessage == null && resultMessage == null) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  errorMessage != null ? Icons.error : Icons.check_circle,
                  color: errorMessage != null ? Colors.red : Colors.green,
                ),
                const SizedBox(width: 8),
                Text(
                  errorMessage != null ? 'Ошибка' : 'Результат',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: errorMessage != null ? Colors.red[50] : Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: errorMessage != null ? Colors.red : Colors.green,
                ),
              ),
              child: Text(
                errorMessage ?? resultMessage ?? '',
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading && availableGroups.isEmpty && !_localeInitialized
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🤖 Автоматический импорт занятий',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Импорт занятий из внешнего API расписания для выбранных групп на конкретную дату',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  _buildDateSelector(),
                  const SizedBox(height: 16),
                  _buildGroupSelector(),
                  const SizedBox(height: 16),
                  _buildSettings(),
                  const SizedBox(height: 16),
                  _buildActionButtons(),
                  const SizedBox(height: 16),
                  _buildResults(),
                ],
              ),
            ),
    );
  }
}