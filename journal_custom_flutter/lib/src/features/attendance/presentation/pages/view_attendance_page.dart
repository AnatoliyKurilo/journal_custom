import 'package:flutter/material.dart';
import 'package:journal_custom_client/journal_custom_client.dart';
import 'package:journal_custom_flutter/core/serverpod_client.dart';
import 'package:journal_custom_flutter/src/features/attendance/presentation/pages/view_subject_classes_page.dart';

class ViewAttendancePage extends StatefulWidget {
  const ViewAttendancePage({Key? key}) : super(key: key);

  @override
  _ViewAttendancePageState createState() => _ViewAttendancePageState();
}

class _ViewAttendancePageState extends State<ViewAttendancePage> {
  bool _isLoading = true;
  String? _errorMessage;
  List<Groups> _groups = [];
  List<Subjects> _subjects = [];
  Groups? _selectedGroup;

  @override
  void initState() {
    super.initState();
    _fetchGroups();
  }

  Future<void> _fetchGroups() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final groups = await client.groups.getAllGroups(); // Получаем группы пользователя
      if (mounted) {
        setState(() {
          _groups = groups;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Ошибка загрузки групп: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchSubjectsForGroup(Groups group) async {
  setState(() {
    _isLoading = true;
    _errorMessage = null;
    _selectedGroup = group;
  });
  try {
    final subjects = await client.classes.getSubjectsForGroup(group.id!); // Используем новый метод
    if (mounted) {
      setState(() {
        _subjects = subjects;
        _isLoading = false;
      });
    }
  } catch (e) {
    if (mounted) {
      setState(() {
        _errorMessage = 'Ошибка загрузки предметов: $e';
        _isLoading = false;
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedGroup == null
            ? 'Выберите группу'
            : 'Предметы: ${_selectedGroup!.name}'),
        leading: _selectedGroup != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _selectedGroup = null;
                    _subjects = [];
                  });
                },
              )
            : null,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_errorMessage!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _selectedGroup == null
                            ? _fetchGroups
                            : () => _fetchSubjectsForGroup(_selectedGroup!),
                        child: const Text('Попробовать снова'),
                      ),
                    ],
                  ),
                )
              : _selectedGroup == null
                  ? _buildGroupsList()
                  : _buildSubjectsList(),
    );
  }

  Widget _buildGroupsList() {
    if (_groups.isEmpty) {
      return const Center(
        child: Text('Нет доступных групп.'),
      );
    }
    return ListView.builder(
      itemCount: _groups.length,
      itemBuilder: (context, index) {
        final group = _groups[index];
        return ListTile(
          title: Text(group.name ?? 'Группа без названия'),
          onTap: () => _fetchSubjectsForGroup(group),
        );
      },
    );
  }

  Widget _buildSubjectsList() {
    if (_subjects.isEmpty) {
      return const Center(
        child: Text('Нет предметов в этой группе.'),
      );
    }
    return ListView.builder(
      itemCount: _subjects.length,
      itemBuilder: (context, index) {
        final subject = _subjects[index];
        return ListTile(
          title: Text(subject.name ?? 'Предмет без названия'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewSubjectClassesPage(subject: subject),
              ),
            );
          },
        );
      },
    );
  }
}