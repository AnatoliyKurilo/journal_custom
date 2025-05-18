import 'package:journal_custom_server/src/birthday_reminder.dart';
import 'package:serverpod/serverpod.dart';

import 'package:journal_custom_server/src/web/routes/root.dart';

import 'src/generated/protocol.dart';
import 'src/generated/endpoints.dart';

import 'package:serverpod_auth_server/serverpod_auth_server.dart' as auth;
// This is the starting point of your Serverpod server. In most cases, you will
// only need to make additions to this file if you add future calls,  are
// configuring Relic (Serverpod's web-server), or need custom setup work.

void run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
    authenticationHandler: auth.authenticationHandler,
  );

  // Setup a default page at the web root.
  pod.webServer.addRoute(RouteRoot(), '/');
  pod.webServer.addRoute(RouteRoot(), '/index.html');
  // Serve all files in the /static directory.
  pod.webServer.addRoute(
    RouteStaticDirectory(serverDirectory: 'static', basePath: '/'),
    '/*',
  );

  auth.AuthConfig.set(auth.AuthConfig(
    sendValidationEmail: (session, email, validationCode) async {
      // TODO: integrate with mail server
      print('Validation code: $validationCode');
      return true;
    },
    sendPasswordResetEmail: (session, userInfo, validationCode) async {
      // TODO: integrate with mail server
      print('Validation code: $validationCode');
      return true;
    },
    // Заменяем onUserSignup на onUserCreated
    onUserCreated: (session, userInfo) async {
      // Ищем запись в таблице Person с таким же email
      var existingPerson = await Person.db.findFirstRow(
        session,
        where: (p) => p.email.equals(userInfo.email ?? ''),
      );
      
      if (existingPerson != null) {
        // Если нашли - связываем с созданным аккаунтом
        existingPerson = existingPerson.copyWith(
          userInfo: userInfo,
        );
        await Person.db.updateRow(session, existingPerson);
        
        // Проверяем, есть ли запись студента для этого человека
        var student = await Students.db.findFirstRow(
          session, 
          where: (s) => s.personId.equals(existingPerson?.id!),
        );
        
        if (student != null) {
          // Если это студент, добавляем роль student в scopes
          var scopes = userInfo.scopeNames?.toSet() ?? {};
          scopes.add('student');
          userInfo = userInfo.copyWith(scopeNames: scopes.toList());
          await auth.UserInfo.db.updateRow(session, userInfo);
        }
      }
    },
  ));

  // Start the server.
  await pod.start();

  // After starting the server, you can register future calls. Future calls are
  // tasks that need to happen in the future, or independently of the request/response
  // cycle. For example, you can use future calls to send emails, or to schedule
  // tasks to be executed at a later time. Future calls are executed in the
  // background. Their schedule is persisted to the database, so you will not
  // lose them if the server is restarted.

  pod.registerFutureCall(
    BirthdayReminder(),
    FutureCallNames.birthdayReminder.name,
  );

  // You can schedule future calls for a later time during startup. But you can also
  // schedule them in any endpoint or webroute through the session object.
  // there is also [futureCallAtTime] if you want to schedule a future call at a
  // specific time.
  await pod.futureCallWithDelay(
    FutureCallNames.birthdayReminder.name,
    Greeting(
      message: 'Hello!',
      author: 'Serverpod Server',
      timestamp: DateTime.now(),
    ),
    Duration(seconds: 5),
  );
}

/// Names of all future calls in the server.
///
/// This is better than using a string literal, as it will reduce the risk of
/// typos and make it easier to refactor the code.
enum FutureCallNames {
  birthdayReminder,
}
