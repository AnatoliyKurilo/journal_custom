import 'package:flutter/material.dart';
import 'package:journal_custom_flutter/src/admin/teacher_tab.dart';
import 'package:journal_custom_flutter/src/serverpod_client.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:journal_custom_flutter/src/group_head/group_head_page.dart'; // Добавляем импорт страницы старосты
import 'package:journal_custom_flutter/src/account_page.dart'; // Добавляем импорт страницы аккаунта

import 'groups_tab.dart';
import 'students_tab.dart'; // Импортируем новую вкладку

class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final _tabs = [
    const Tab(text: 'Пользователи'),
    const Tab(text: 'Группы'),
    const Tab(text: 'Преподаватели'),
    const Tab(text: 'Студенты'), // Новая вкладка
    const Tab(text: 'Настройки'),
  ];

  @override
  Widget build(BuildContext context) {
    // Проверка роли администратора
    final isAdmin = sessionManager.signedInUser?.scopeNames.contains('serverpod.admin') ?? false;
    // Проверка роли старосты
    final isGroupHead = sessionManager.signedInUser?.scopeNames.contains('groupHead') ?? false;
    // Проверка роли куратора
    final isCurator = sessionManager.signedInUser?.scopeNames.contains('curator') ?? false;

    // Проверяем, имеет ли пользователь права на доступ к админ-панели
    if (!isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Доступ запрещен')),
        body: const Center(
          child: Text('Для доступа к этой странице требуются права администратора'),
        ),
      );
    }

    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Панель администратора'),
          actions: [
            // Кнопка перехода на страницу старосты (только для админов, кураторов и старост)
            if (isAdmin || isGroupHead || isCurator)
              IconButton(
                icon: const Icon(Icons.group),
                tooltip: 'Управление подгруппами',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const GroupHeadPage()),
                  );
                },
              ),
          ],
          bottom: TabBar(
            isScrollable: true, // Make TabBar scrollable
            tabs: _tabs,
          ),
        ),
        body: TabBarView(
          children: [
            UsersTab(),
            GroupsTab(),
            TeachersTab(),
            StudentsTab(), // Подключаем новую вкладку
            SettingsTab(),
          ],
        ),
      ),
    );
  }
}

// Вкладка управления пользователями
class UsersTab extends StatefulWidget {
  @override
  _UsersTabState createState() => _UsersTabState();
}

class _UsersTabState extends State<UsersTab> {
  bool isLoading = true;
  List<dynamic> users = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Пока используем заглушку:
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        users = [
          {'id': 1, 'name': 'Администратор', 'email': 'admin@example.com', 'roles': ['admin']},
          {'id': 2, 'name': 'Преподаватель', 'email': 'teacher@example.com', 'roles': ['teacher']},
          {'id': 3, 'name': 'Студент', 'email': 'student@example.com', 'roles': ['student']},
        ];
        isLoading = false;
      });

    } catch (e) {
      setState(() {
        errorMessage = 'Ошибка загрузки: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(child: Text(errorMessage!));
    }

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          title: Text(user['name']),
          subtitle: Text(user['email']),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Показать диалог для редактирования пользователя
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // Показать диалог для подтверждения удаления
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Настройки системы'));
  }
}