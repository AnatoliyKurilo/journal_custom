/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:journal_custom_client/src/protocol/groups_protocol.dart' as _i3;
import 'package:journal_custom_client/src/protocol/teachers_protocol.dart'
    as _i4;
import 'package:journal_custom_client/src/protocol/greeting.dart' as _i5;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i6;
import 'protocol.dart' as _i7;

/// {@category Endpoint}
class EndpointAdmin extends _i1.EndpointRef {
  EndpointAdmin(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'admin';

  _i2.Future<_i3.Groups> createGroup(
    String name,
    int? curatorId,
    int? groupHeadId,
  ) =>
      caller.callServerEndpoint<_i3.Groups>(
        'admin',
        'createGroup',
        {
          'name': name,
          'curatorId': curatorId,
          'groupHeadId': groupHeadId,
        },
      );

  _i2.Future<List<_i3.Groups>> getAllGroups() =>
      caller.callServerEndpoint<List<_i3.Groups>>(
        'admin',
        'getAllGroups',
        {},
      );

  _i2.Future<_i4.Teachers> createTeacher({
    required String firstName,
    required String lastName,
    String? patronymic,
    required String email,
    String? phoneNumber,
  }) =>
      caller.callServerEndpoint<_i4.Teachers>(
        'admin',
        'createTeacher',
        {
          'firstName': firstName,
          'lastName': lastName,
          'patronymic': patronymic,
          'email': email,
          'phoneNumber': phoneNumber,
        },
      );

  _i2.Future<List<_i4.Teachers>> getAllTeachers() =>
      caller.callServerEndpoint<List<_i4.Teachers>>(
        'admin',
        'getAllTeachers',
        {},
      );
}

/// {@category Endpoint}
class EndpointMakeUserAdmin extends _i1.EndpointRef {
  EndpointMakeUserAdmin(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'makeUserAdmin';

  _i2.Future<bool> setUserScopes(int userId) => caller.callServerEndpoint<bool>(
        'makeUserAdmin',
        'setUserScopes',
        {'userId': userId},
      );
}

/// {@category Endpoint}
class EndpointUserRoles extends _i1.EndpointRef {
  EndpointUserRoles(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'userRoles';

  _i2.Future<List<String>> getUserRoles(int personId) =>
      caller.callServerEndpoint<List<String>>(
        'userRoles',
        'getUserRoles',
        {'personId': personId},
      );

  _i2.Future<bool> assignCuratorRole(int teacherId) =>
      caller.callServerEndpoint<bool>(
        'userRoles',
        'assignCuratorRole',
        {'teacherId': teacherId},
      );

  _i2.Future<bool> assignGroupHeadRole(int studentId) =>
      caller.callServerEndpoint<bool>(
        'userRoles',
        'assignGroupHeadRole',
        {'studentId': studentId},
      );

  _i2.Future<bool> removeRole(
    int personId,
    String role,
  ) =>
      caller.callServerEndpoint<bool>(
        'userRoles',
        'removeRole',
        {
          'personId': personId,
          'role': role,
        },
      );
}

/// This is an example endpoint that returns a greeting message through its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _i1.EndpointRef {
  EndpointGreeting(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _i2.Future<_i5.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i5.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

class Modules {
  Modules(Client client) {
    auth = _i6.Caller(client);
  }

  late final _i6.Caller auth;
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )? onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
          host,
          _i7.Protocol(),
          securityContext: securityContext,
          authenticationKeyManager: authenticationKeyManager,
          streamingConnectionTimeout: streamingConnectionTimeout,
          connectionTimeout: connectionTimeout,
          onFailedCall: onFailedCall,
          onSucceededCall: onSucceededCall,
          disconnectStreamsOnLostInternetConnection:
              disconnectStreamsOnLostInternetConnection,
        ) {
    admin = EndpointAdmin(this);
    makeUserAdmin = EndpointMakeUserAdmin(this);
    userRoles = EndpointUserRoles(this);
    greeting = EndpointGreeting(this);
    modules = Modules(this);
  }

  late final EndpointAdmin admin;

  late final EndpointMakeUserAdmin makeUserAdmin;

  late final EndpointUserRoles userRoles;

  late final EndpointGreeting greeting;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'admin': admin,
        'makeUserAdmin': makeUserAdmin,
        'userRoles': userRoles,
        'greeting': greeting,
      };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup =>
      {'auth': modules.auth};
}
