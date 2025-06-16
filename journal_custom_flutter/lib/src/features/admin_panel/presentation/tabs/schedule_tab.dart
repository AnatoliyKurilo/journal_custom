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
  String? resultMessage;
  
  // Контроллеры для ввода данных
  final TextEditingController _yearController = TextEditingController(text: '2024-2025');
  final TextEditingController _groupIdController = TextEditingController();
  final TextEditingController _teacherIdController = TextEditingController();
  final TextEditingController _facultyController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Здесь можно добавить инициализацию данных расписания
  }

  @override
  void dispose() {
    _yearController.dispose();
    _groupIdController.dispose();
    _teacherIdController.dispose();
    _facultyController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return Padding(
      padding: EdgeInsets.all(isMobile ? 8.0 : 16.0),
      child: Column(
        children: [
          // Заголовок
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Тестирование API расписания',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (isLoading)
                const CircularProgressIndicator()
              else
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {
                      errorMessage = null;
                      resultMessage = null;
                    });
                  },
                  tooltip: 'Очистить результаты',
                ),
            ],
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Поля ввода
                  _buildInputSection(),
                  
                  const SizedBox(height: 20),
                  
                  // Кнопки тестирования
                  _buildTestButtons(isMobile),
                  
                  const SizedBox(height: 20),
                  
                  // Результаты
                  _buildResultsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Параметры для тестирования',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _yearController,
                    decoration: const InputDecoration(
                      labelText: 'Учебный год',
                      hintText: '2024-2025',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _groupIdController,
                    decoration: const InputDecoration(
                      labelText: 'ID группы',
                      hintText: '123',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _teacherIdController,
                    decoration: const InputDecoration(
                      labelText: 'ID преподавателя',
                      hintText: '456',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _facultyController,
                    decoration: const InputDecoration(
                      labelText: 'Факультет',
                      hintText: 'ФИТ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _courseController,
              decoration: const InputDecoration(
                labelText: 'Курс',
                hintText: '1',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestButtons(bool isMobile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Методы для тестирования',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            
            // Основные методы
            const Text('Основные методы:', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildTestButton('Получить годы', _testGetAvailableYears, Colors.blue),
                _buildTestButton('Список групп', _testGetGroupsList, Colors.green),
                _buildTestButton('Список преподавателей', _testGetTeachersList, Colors.orange),
                _buildTestButton('Факультеты', _testGetFaculties, Colors.purple),
                _buildTestButton('Кафедры', _testGetDepartments, Colors.teal),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Методы для групп
            const Text('Методы для групп:', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildTestButton('Группы по факультету', _testGetGroupsByFaculty, Colors.indigo),
                _buildTestButton('Группы по курсу', _testGetGroupsByCourse, Colors.cyan),
                _buildTestButton('Группа по ID', _testGetGroupById, Colors.lime),
                _buildTestButton('Расписание группы', _testGetScheduleForGroup, Colors.amber),
                _buildTestButton('Занятия группы', _testGetClassesForGroup, Colors.pink),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Методы для преподавателей
            const Text('Методы для преподавателей:', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildTestButton('Преподаватель по ID', _testGetTeacherById, Colors.deepOrange),
                _buildTestButton('Поиск преподавателей', _testSearchTeachersByName, Colors.brown),
                _buildTestButton('Преподаватели кафедры', _testGetTeachersByDepartment, Colors.blueGrey),
                _buildTestButton('Расписание преподавателя', _testGetScheduleForTeacher, Colors.red),
                _buildTestButton('Занятия преподавателя', _testGetClassesForTeacher, Colors.green[700]!),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Дополнительные методы
            const Text('Дополнительные методы:', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildTestButton('Предметы группы', _testGetSubjectsForGroup, Colors.deepPurple),
                _buildTestButton('Преподаватели группы', _testGetTeachersForGroup, Colors.indigo[300]!),
                _buildTestButton('Недельное расписание', _testGetWeekSchedule, Colors.teal[300]!),
                _buildTestButton('Расписание на дату', _testGetScheduleForDate, Colors.orange[300]!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestButton(String title, VoidCallback onPressed, Color color) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(title, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildResultsSection() {
    if (errorMessage == null && resultMessage == null) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Результат',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Результат скопирован в буфер обмена')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: errorMessage != null ? Colors.red[50] : Colors.green[50],
                border: Border.all(
                  color: errorMessage != null ? Colors.red : Colors.green,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: Text(
                  errorMessage ?? resultMessage ?? '',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    color: errorMessage != null ? Colors.red[800] : Colors.green[800],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ИСПРАВЛЕННЫЕ методы тестирования, соответствующие реальному RaspEndpoint
  
  Future<void> _testGetAvailableYears() async {
    await _executeTest(() async {
      final result = await client.rasp.getAvailableYears();
      print('Доступные годы (${result.length}):\n${result.join(', ')}');
      return 'Доступные годы (${result.length}):\n${result.join(', ')}';
    });
  }

  Future<void> _testGetGroupsList() async {
    await _executeTest(() async {
      final year = _yearController.text.trim();
      if (year.isEmpty) throw Exception('Укажите учебный год');
      
      final result = await client.rasp.getGroupsList(year);
      return 'Список групп для $year (${result.length}):\n${result.take(5).map((g) => '${g.id}: ${g.name} (${g.facul}, курс ${g.kurs})').join('\n')}${result.length > 5 ? '\n... и еще ${result.length - 5}' : ''}';
    });
  }

  Future<void> _testGetTeachersList() async {
    await _executeTest(() async {
      final year = _yearController.text.trim();
      if (year.isEmpty) throw Exception('Укажите учебный год');
      
      final result = await client.rasp.getTeachersList(year);
      return 'Список преподавателей для $year (${result.length}):\n${result.take(5).map((t) => '${t.id}: ${t.name} (${t.kaf ?? 'без кафедры'})').join('\n')}${result.length > 5 ? '\n... и еще ${result.length - 5}' : ''}';
    });
  }

  Future<void> _testGetFaculties() async {
    await _executeTest(() async {
      final year = _yearController.text.trim();
      if (year.isEmpty) throw Exception('Укажите учебный год');
      
      final result = await client.rasp.getFaculties(year);
      return 'Факультеты для $year (${result.length}):\n${result.join('\n')}';
    });
  }

  Future<void> _testGetDepartments() async {
    await _executeTest(() async {
      final year = _yearController.text.trim();
      if (year.isEmpty) throw Exception('Укажите учебный год');
      
      final result = await client.rasp.getDepartments(year);
      return 'Кафедры для $year (${result.length}):\n${result.take(10).join('\n')}${result.length > 10 ? '\n... и еще ${result.length - 10}' : ''}';
    });
  }

  Future<void> _testGetGroupsByFaculty() async {
    await _executeTest(() async {
      final year = _yearController.text.trim();
      final faculty = _facultyController.text.trim();
      if (year.isEmpty) throw Exception('Укажите учебный год');
      if (faculty.isEmpty) throw Exception('Укажите факультет');
      
      final result = await client.rasp.getGroupsByFaculty(year, faculty);
      return 'Группы факультета "$faculty" для $year (${result.length}):\n${result.map((g) => '${g.id}: ${g.name} (курс ${g.kurs})').join('\n')}';
    });
  }

  Future<void> _testGetGroupsByCourse() async {
    await _executeTest(() async {
      final year = _yearController.text.trim();
      final courseText = _courseController.text.trim();
      if (year.isEmpty) throw Exception('Укажите учебный год');
      if (courseText.isEmpty) throw Exception('Укажите курс');
      
      final course = int.parse(courseText);
      final result = await client.rasp.getGroupsByCourse(year, course);
      return 'Группы $course курса для $year (${result.length}):\n${result.map((g) => '${g.id}: ${g.name} (${g.facul})').join('\n')}';
    });
  }

  Future<void> _testGetGroupById() async {
    await _executeTest(() async {
      final year = _yearController.text.trim();
      final groupIdText = _groupIdController.text.trim();
      if (year.isEmpty) throw Exception('Укажите учебный год');
      if (groupIdText.isEmpty) throw Exception('Укажите ID группы');
      
      final groupId = int.parse(groupIdText);
      final result = await client.rasp.getGroupById(year, groupId);
      if (result == null) {
        return 'Группа с ID $groupId не найдена';
      }
      return 'Группа $groupId:\nНазвание: ${result.name}\nФакультет: ${result.facul}\nКурс: ${result.kurs}\nСпециальность: ${result.spec ?? 'не указана'}';
    });
  }

  Future<void> _testGetScheduleForGroup() async {
    await _executeTest(() async {
      final groupIdText = _groupIdController.text.trim();
      if (groupIdText.isEmpty) throw Exception('Укажите ID группы');
      
      final groupId = int.parse(groupIdText);
      final result = await client.rasp.getScheduleForGroup(groupId);
      return 'Расписание для группы $groupId:\n${result.toString()}';
    });
  }

  Future<void> _testGetClassesForGroup() async {
    await _executeTest(() async {
      final groupIdText = _groupIdController.text.trim();
      if (groupIdText.isEmpty) throw Exception('Укажите ID группы');
      
      final groupId = int.parse(groupIdText);
      final result = await client.rasp.getClassesForGroup(groupId);
      return 'Занятия для группы $groupId (${result.length}):\n${result.take(3).join('\n')}${result.length > 3 ? '\n... и еще ${result.length - 3}' : ''}';
    });
  }

  Future<void> _testGetTeacherById() async {
    await _executeTest(() async {
      final year = _yearController.text.trim();
      final teacherIdText = _teacherIdController.text.trim();
      if (year.isEmpty) throw Exception('Укажите учебный год');
      if (teacherIdText.isEmpty) throw Exception('Укажите ID преподавателя');
      
      final teacherId = int.parse(teacherIdText);
      final result = await client.rasp.getTeacherById(year, teacherId);
      if (result == null) {
        return 'Преподаватель с ID $teacherId не найден';
      }
      return 'Преподаватель $teacherId:\nИмя: ${result.name}\nКафедра: ${result.kaf ?? 'не указана'}';
    });
  }

  Future<void> _testSearchTeachersByName() async {
    await _executeTest(() async {
      final year = _yearController.text.trim();
      if (year.isEmpty) throw Exception('Укажите учебный год');
      
      final searchQuery = await _showInputDialog('Поиск преподавателей', 'Введите имя для поиска:');
      if (searchQuery == null || searchQuery.isEmpty) throw Exception('Укажите запрос для поиска');
      
      final result = await client.rasp.searchTeachersByName(year, searchQuery);
      return 'Найденные преподаватели для "$searchQuery" (${result.length}):\n${result.map((t) => '${t.id}: ${t.name} (${t.kaf ?? 'без кафедры'})').join('\n')}';
    });
  }

  Future<void> _testGetTeachersByDepartment() async {
    await _executeTest(() async {
      final year = _yearController.text.trim();
      if (year.isEmpty) throw Exception('Укажите учебный год');
      
      final department = await _showInputDialog('Преподаватели кафедры', 'Введите название кафедры:');
      if (department == null || department.isEmpty) throw Exception('Укажите кафедру');
      
      final result = await client.rasp.getTeachersByDepartment(year, department);
      return 'Преподаватели кафедры "$department" (${result.length}):\n${result.map((t) => '${t.id}: ${t.name}').join('\n')}';
    });
  }

  Future<void> _testGetScheduleForTeacher() async {
    await _executeTest(() async {
      final year = _yearController.text.trim();
      final teacherIdText = _teacherIdController.text.trim();
      if (year.isEmpty) throw Exception('Укажите учебный год');
      if (teacherIdText.isEmpty) throw Exception('Укажите ID преподавателя');
      
      final teacherId = int.parse(teacherIdText);
      final result = await client.rasp.getScheduleForTeacher(teacherId, year);
      return 'Расписание преподавателя $teacherId:\n${result.toString()}';
    });
  }

  Future<void> _testGetClassesForTeacher() async {
    await _executeTest(() async {
      final year = _yearController.text.trim();
      final teacherIdText = _teacherIdController.text.trim();
      if (year.isEmpty) throw Exception('Укажите учебный год');
      if (teacherIdText.isEmpty) throw Exception('Укажите ID преподавателя');
      
      final teacherId = int.parse(teacherIdText);
      final result = await client.rasp.getClassesForTeacher(teacherId, year);
      return 'Занятия преподавателя $teacherId (${result.length}):\n${result.take(3).join('\n')}${result.length > 3 ? '\n... и еще ${result.length - 3}' : ''}';
    });
  }

  Future<void> _testGetSubjectsForGroup() async {
    await _executeTest(() async {
      final groupIdText = _groupIdController.text.trim();
      if (groupIdText.isEmpty) throw Exception('Укажите ID группы');
      
      final groupId = int.parse(groupIdText);
      final result = await client.rasp.getSubjectsForGroup(groupId);
      return 'Предметы для группы $groupId (${result.length}):\n${result.join('\n')}';
    });
  }

  Future<void> _testGetTeachersForGroup() async {
    await _executeTest(() async {
      final groupIdText = _groupIdController.text.trim();
      if (groupIdText.isEmpty) throw Exception('Укажите ID группы');
      
      final groupId = int.parse(groupIdText);
      final result = await client.rasp.getTeachersForGroup(groupId);
      return 'Преподаватели группы $groupId (${result.length}):\n${result.join('\n')}';
    });
  }

  Future<void> _testGetWeekSchedule() async {
    await _executeTest(() async {
      final groupIdText = _groupIdController.text.trim();
      if (groupIdText.isEmpty) throw Exception('Укажите ID группы');
      
      final groupId = int.parse(groupIdText);
      final weekStart = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
      final result = await client.rasp.getWeekSchedule(groupId, weekStart);
      
      String output = 'Недельное расписание группы $groupId:\n';
      result.forEach((day, classes) {
        output += '$day: ${classes.length} занятий\n';
      });
      return output;
    });
  }

  Future<void> _testGetScheduleForDate() async {
    await _executeTest(() async {
      final groupIdText = _groupIdController.text.trim();
      if (groupIdText.isEmpty) throw Exception('Укажите ID группы');
      
      final groupId = int.parse(groupIdText);
      final date = DateTime.now();
      final result = await client.rasp.getScheduleForDate(groupId, date);
      
      // result уже является List<String>, поэтому обрабатываем его как строки
      return 'Расписание на ${date.toIso8601String().split('T')[0]} для группы $groupId (${result.length} занятий):\n${result.join('\n')}';
    });
  }

  // Вспомогательные методы

  Future<void> _executeTest(Future<String> Function() testFunction) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      resultMessage = null;
    });

    try {
      final result = await testFunction();
      setState(() {
        resultMessage = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Ошибка: $e';
        isLoading = false;
      });
    }
  }

  Future<String?> _showInputDialog(String title, String hint) async {
    String? result;
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: hint),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                result = controller.text.trim();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    return result;
  }
}