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
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i2;

abstract class Person implements _i1.SerializableModel {
  Person._({
    this.id,
    required this.firstName,
    required this.lastName,
    this.patronymic,
    required this.email,
    this.phoneNumber,
    required this.userInfoId,
    this.userInfo,
  });

  factory Person({
    int? id,
    required String firstName,
    required String lastName,
    String? patronymic,
    required String email,
    String? phoneNumber,
    required int userInfoId,
    _i2.UserInfo? userInfo,
  }) = _PersonImpl;

  factory Person.fromJson(Map<String, dynamic> jsonSerialization) {
    return Person(
      id: jsonSerialization['id'] as int?,
      firstName: jsonSerialization['firstName'] as String,
      lastName: jsonSerialization['lastName'] as String,
      patronymic: jsonSerialization['patronymic'] as String?,
      email: jsonSerialization['email'] as String,
      phoneNumber: jsonSerialization['phoneNumber'] as String?,
      userInfoId: jsonSerialization['userInfoId'] as int,
      userInfo: jsonSerialization['userInfo'] == null
          ? null
          : _i2.UserInfo.fromJson(
              (jsonSerialization['userInfo'] as Map<String, dynamic>)),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String firstName;

  String lastName;

  String? patronymic;

  String email;

  String? phoneNumber;

  int userInfoId;

  _i2.UserInfo? userInfo;

  /// Returns a shallow copy of this [Person]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Person copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? patronymic,
    String? email,
    String? phoneNumber,
    int? userInfoId,
    _i2.UserInfo? userInfo,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'firstName': firstName,
      'lastName': lastName,
      if (patronymic != null) 'patronymic': patronymic,
      'email': email,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      'userInfoId': userInfoId,
      if (userInfo != null) 'userInfo': userInfo?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PersonImpl extends Person {
  _PersonImpl({
    int? id,
    required String firstName,
    required String lastName,
    String? patronymic,
    required String email,
    String? phoneNumber,
    required int userInfoId,
    _i2.UserInfo? userInfo,
  }) : super._(
          id: id,
          firstName: firstName,
          lastName: lastName,
          patronymic: patronymic,
          email: email,
          phoneNumber: phoneNumber,
          userInfoId: userInfoId,
          userInfo: userInfo,
        );

  /// Returns a shallow copy of this [Person]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Person copyWith({
    Object? id = _Undefined,
    String? firstName,
    String? lastName,
    Object? patronymic = _Undefined,
    String? email,
    Object? phoneNumber = _Undefined,
    int? userInfoId,
    Object? userInfo = _Undefined,
  }) {
    return Person(
      id: id is int? ? id : this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      patronymic: patronymic is String? ? patronymic : this.patronymic,
      email: email ?? this.email,
      phoneNumber: phoneNumber is String? ? phoneNumber : this.phoneNumber,
      userInfoId: userInfoId ?? this.userInfoId,
      userInfo:
          userInfo is _i2.UserInfo? ? userInfo : this.userInfo?.copyWith(),
    );
  }
}
