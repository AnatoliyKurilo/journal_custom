import 'package:flutter/material.dart';
import 'package:journal_custom_flutter/src/features/attendance/students_page.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:journal_custom_flutter/core/serverpod_client.dart';
import 'package:journal_custom_flutter/src/features/admin_panel/presentation/pages/admin_panel.dart';
import 'package:journal_custom_flutter/src/features/group_management/presentation/pages/group_head_page.dart';
import 'package:journal_custom_flutter/src/features/attendance/presentation/pages/attendance_page.dart';
import 'package:journal_custom_flutter/src/features/attendance/presentation/pages/view_attendance_page.dart';
import 'package:journal_custom_flutter/src/features/admin_panel/presentation/tabs/students_tab.dart';
// import 'package:journal_custom_flutter/src/features/admin_panel/presentation/pages/students_page.dart'; // <-- Изменили импорт

import 'dart:developer' as developer;

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isAdmin = sessionManager.signedInUser?.scopeNames.contains('serverpod.admin') ?? false;
    final isGroupHead = sessionManager.signedInUser?.scopeNames.contains('groupHead') ?? false;
    final isCurator = sessionManager.signedInUser?.scopeNames.contains('curator') ?? false;
    final isDocumentSpecialist = sessionManager.signedInUser?.scopeNames.contains('documentSpecialist') ?? false;
    final isTeacher = sessionManager.signedInUser?.scopeNames.contains('teacher') ?? false; // Добавляем проверку для преподавателя

    developer.log(
      'User scopes: ${sessionManager.signedInUser?.scopeNames}',
      name: 'AccountPage',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль пользователя'),
      ),
      body: ListView(
        children: [
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            title: Text(sessionManager.signedInUser?.userName ?? "Пользователь"),
            subtitle: Text(sessionManager.signedInUser?.email ?? ''),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton(
              onPressed: () {
                sessionManager.signOut();
              },
              child: const Text('Выйти'),
            ),
          ),
          // Кнопка назначения админом (можно оставить для тестирования)
          // Padding(
          //   padding: const EdgeInsets.all(16),
          //   child: ElevatedButton(
          //     onPressed: () async {
          //       try {
          //         await client.makeUserAdmin.setUserScopes(
          //           sessionManager.signedInUser!.id!,
          //           // Если ваш setUserScopes на сервере принимает Set<String> scopes
          //           // и устанавливает их, то для назначения админом вы передавали бы {'serverpod.admin', ...другие скоупы}
          //           // В вашем случае, похоже, setUserScopes без второго аргумента назначает админа.
          //         );
          //         ScaffoldMessenger.of(context).showSnackBar(
          //           const SnackBar(content: Text('Права администратора назначены'))
          //         );
          //         // Обновляем сессию, чтобы isAdmin переключился
          //         await sessionManager.refreshSession();
          //         // Перестраиваем виджет, чтобы кнопка "Убрать права" появилась/исчезла корректно
          //         (context as Element).reassemble();
          //       } catch (e) {
          //         ScaffoldMessenger.of(context).showSnackBar(
          //           SnackBar(content: Text('Ошибка: $e'))
          //         );
          //       }
          //     },
          //     child: const Text('Сделать администратором (Тест)'),
          //   ),
          // ),
          // Новая кнопка для снятия прав администратора
          if (isAdmin) // Показываем кнопку, только если пользователь админ
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[700], // Другой цвет для отличия
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  try {
                    
                    // // Используем существующий метод removeRole из UserRolesEndpoint
                    // // Предполагаем, что sessionManager.signedInUser!.id! - это userInfoId,
                    // // и серверный UserRolesEndpoint.removeRole (через UserService)
                    // // сможет найти Person по этому userInfoId.
                    // final success = await client.userRoles.removeRole(
                    //    sessionManager.signedInUser!.id!, // Это UserInfo.id
                    //    'serverpod.admin', // Стандартное имя роли администратора
                    // );

                    // if (success) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(content: Text('Права администратора убраны'))
                    //   );
                    //   // Обновляем сессию, чтобы isAdmin переключился
                    //   await sessionManager.refreshSession();
                    //    // Перестраиваем виджет, чтобы кнопка "Убрать права" исчезла
                    //   (context as Element).reassemble();
                    // } else {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(content: Text('Не удалось убрать права администратора'))
                    //   );
                    // }
                  } catch (e) {
                     ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text('Ошибка при снятии прав: $e'))
                     );
                  }
                },
                child: const Text('Убрать права администратора (Тест)'),
              ),
            ),

          if (isAdmin)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
          
          // Кнопка Студенты
          if (isAdmin || isCurator || isDocumentSpecialist )
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[700],
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const StudentsPage()), // <-- Изменили на StudentsPage
                  );
                },
                child: const Text('Студенты'),
              ),
            ),

          if (isGroupHead || isAdmin) 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
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
          
          if (isGroupHead || isCurator || isAdmin || isTeacher)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[700], 
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

          // Кнопка "Просмотр посещаемости" остается доступной всем
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewAttendancePage()),
                );
              },
              child: const Text('Просмотр посещаемости'),
            ),
          ),
        ],
      ),
    );
  }
}