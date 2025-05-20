import 'package:flutter/material.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:journal_custom_flutter/src/serverpod_client.dart';
import 'package:journal_custom_flutter/src/admin/admin_panel.dart';
import 'package:journal_custom_flutter/src/group_head/group_head_page.dart'; // Импортируем страницу старосты
import 'package:journal_custom_flutter/src/attendance/attendance_page.dart'; // Импортируем новую страницу

import 'dart:developer' as developer;
class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Проверяем, есть ли у пользователя роль admin
    final isAdmin = sessionManager.signedInUser?.scopeNames.contains('serverpod.admin') ?? false;
    // Проверяем, есть ли у пользователя роль groupHead
    final isGroupHead = sessionManager.signedInUser?.scopeNames.contains('groupHead') ?? false;
    // print(sessionManager.signedInUser?.scopeNames);
    developer.log(
      'User scopes: ${sessionManager.signedInUser?.scopeNames}',
      name: 'AccountPage',
    );
    
    // Оборачиваем всё в Scaffold, чтобы обеспечить правильную работу навигации
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль пользователя'),
      ),
      body: ListView(
        children: [
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            leading: CircularUserImage(
              userInfo: sessionManager.signedInUser,
              size: 42,
            ),
            title: Text(sessionManager.signedInUser!.userName!),
            subtitle: Text(sessionManager.signedInUser!.email ?? ''),
          ),
          
          // Кнопка выхода
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                sessionManager.signOut();
              },
              child: const Text('Выйти'),
            ),
          ),
          
          // Кнопка назначения админом (можно оставить для тестирования)
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                client.makeUserAdmin.setUserScopes(
                  sessionManager.signedInUser!.id!,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Права администратора назначены'))
                );
              },
              child: const Text('Сделать администратором'),
            ),
          ),
          
          // Кнопка доступа к админ-панели (только для админов)
          if (isAdmin)
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AdminPanel()),
                  );
                },
                child: const Text('Панель администратора'),
              ),
            ),
          //kalinin.anatoly@example.com
          // Кнопка доступа к странице старосты (только для старост)
          if (isGroupHead || isAdmin)
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700], // Можете выбрать другой цвет
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const GroupHeadPage()),
                  );
                },
                child: const Text('Управление подгруппами'),
              ),
            ),
          
          // Кнопка доступа к странице управления посещаемостью
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AttendancePage()),
                );
              },
              child: const Text('Управление посещаемостью'),
            ),
          ),
        ],
      ),
    );
  }
}