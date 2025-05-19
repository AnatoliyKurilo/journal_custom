import 'package:journal_custom_server/src/custom_scope.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart';      // ← обязательно


class MakeUserAdminEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<bool> setUserScopes(Session session, int userId) async {
    // пример: даём пользователю права admin и userRead
    await Users.updateUserScopes(
      session,
      userId,
      { Scope.admin, CustomScope.documentSpecialist },
    );
    return true;
  }
}