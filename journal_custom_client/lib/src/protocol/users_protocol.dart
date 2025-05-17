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

abstract class Users implements _i1.SerializableModel {
  Users._({
    this.id,
    required this.login,
    required this.passwordHash,
    required this.roleId,
    required this.personId,
  });

  factory Users({
    int? id,
    required String login,
    required String passwordHash,
    required int roleId,
    required int personId,
  }) = _UsersImpl;

  factory Users.fromJson(Map<String, dynamic> jsonSerialization) {
    return Users(
      id: jsonSerialization['id'] as int?,
      login: jsonSerialization['login'] as String,
      passwordHash: jsonSerialization['passwordHash'] as String,
      roleId: jsonSerialization['roleId'] as int,
      personId: jsonSerialization['personId'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String login;

  String passwordHash;

  int roleId;

  int personId;

  /// Returns a shallow copy of this [Users]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Users copyWith({
    int? id,
    String? login,
    String? passwordHash,
    int? roleId,
    int? personId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'login': login,
      'passwordHash': passwordHash,
      'roleId': roleId,
      'personId': personId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UsersImpl extends Users {
  _UsersImpl({
    int? id,
    required String login,
    required String passwordHash,
    required int roleId,
    required int personId,
  }) : super._(
          id: id,
          login: login,
          passwordHash: passwordHash,
          roleId: roleId,
          personId: personId,
        );

  /// Returns a shallow copy of this [Users]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Users copyWith({
    Object? id = _Undefined,
    String? login,
    String? passwordHash,
    int? roleId,
    int? personId,
  }) {
    return Users(
      id: id is int? ? id : this.id,
      login: login ?? this.login,
      passwordHash: passwordHash ?? this.passwordHash,
      roleId: roleId ?? this.roleId,
      personId: personId ?? this.personId,
    );
  }
}
