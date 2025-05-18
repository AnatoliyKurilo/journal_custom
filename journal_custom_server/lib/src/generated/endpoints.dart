/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../endpoints/user_endpoint.dart' as _i2;
import '../endpoints/user_roles_endpoint.dart' as _i3;
import '../greeting_endpoint.dart' as _i4;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i5;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'makeUserAdmin': _i2.MakeUserAdminEndpoint()
        ..initialize(
          server,
          'makeUserAdmin',
          null,
        ),
      'userRoles': _i3.UserRolesEndpoint()
        ..initialize(
          server,
          'userRoles',
          null,
        ),
      'greeting': _i4.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
    connectors['makeUserAdmin'] = _i1.EndpointConnector(
      name: 'makeUserAdmin',
      endpoint: endpoints['makeUserAdmin']!,
      methodConnectors: {
        'setUserScopes': _i1.MethodConnector(
          name: 'setUserScopes',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['makeUserAdmin'] as _i2.MakeUserAdminEndpoint)
                  .setUserScopes(
            session,
            params['userId'],
          ),
        )
      },
    );
    connectors['userRoles'] = _i1.EndpointConnector(
      name: 'userRoles',
      endpoint: endpoints['userRoles']!,
      methodConnectors: {
        'getUserRoles': _i1.MethodConnector(
          name: 'getUserRoles',
          params: {
            'personId': _i1.ParameterDescription(
              name: 'personId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['userRoles'] as _i3.UserRolesEndpoint).getUserRoles(
            session,
            params['personId'],
          ),
        ),
        'assignCuratorRole': _i1.MethodConnector(
          name: 'assignCuratorRole',
          params: {
            'teacherId': _i1.ParameterDescription(
              name: 'teacherId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['userRoles'] as _i3.UserRolesEndpoint)
                  .assignCuratorRole(
            session,
            params['teacherId'],
          ),
        ),
        'assignGroupHeadRole': _i1.MethodConnector(
          name: 'assignGroupHeadRole',
          params: {
            'studentId': _i1.ParameterDescription(
              name: 'studentId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['userRoles'] as _i3.UserRolesEndpoint)
                  .assignGroupHeadRole(
            session,
            params['studentId'],
          ),
        ),
        'removeRole': _i1.MethodConnector(
          name: 'removeRole',
          params: {
            'personId': _i1.ParameterDescription(
              name: 'personId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'role': _i1.ParameterDescription(
              name: 'role',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['userRoles'] as _i3.UserRolesEndpoint).removeRole(
            session,
            params['personId'],
            params['role'],
          ),
        ),
      },
    );
    connectors['greeting'] = _i1.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['greeting'] as _i4.GreetingEndpoint).hello(
            session,
            params['name'],
          ),
        )
      },
    );
    modules['serverpod_auth'] = _i5.Endpoints()..initializeEndpoints(server);
  }
}
