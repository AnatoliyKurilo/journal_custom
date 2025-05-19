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
import 'person.dart' as _i2;
import 'groups_protocol.dart' as _i3;

abstract class Students implements _i1.SerializableModel {
  Students._({
    this.id,
    required this.personId,
    this.person,
    required this.groupsId,
    this.groups,
  });

  factory Students({
    int? id,
    required int personId,
    _i2.Person? person,
    required int groupsId,
    _i3.Groups? groups,
  }) = _StudentsImpl;

  factory Students.fromJson(Map<String, dynamic> jsonSerialization) {
    return Students(
      id: jsonSerialization['id'] as int?,
      personId: jsonSerialization['personId'] as int,
      person: jsonSerialization['person'] == null
          ? null
          : _i2.Person.fromJson(
              (jsonSerialization['person'] as Map<String, dynamic>)),
      groupsId: jsonSerialization['groupsId'] as int,
      groups: jsonSerialization['groups'] == null
          ? null
          : _i3.Groups.fromJson(
              (jsonSerialization['groups'] as Map<String, dynamic>)),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int personId;

  _i2.Person? person;

  int groupsId;

  _i3.Groups? groups;

  /// Returns a shallow copy of this [Students]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Students copyWith({
    int? id,
    int? personId,
    _i2.Person? person,
    int? groupsId,
    _i3.Groups? groups,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'personId': personId,
      if (person != null) 'person': person?.toJson(),
      'groupsId': groupsId,
      if (groups != null) 'groups': groups?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StudentsImpl extends Students {
  _StudentsImpl({
    int? id,
    required int personId,
    _i2.Person? person,
    required int groupsId,
    _i3.Groups? groups,
  }) : super._(
          id: id,
          personId: personId,
          person: person,
          groupsId: groupsId,
          groups: groups,
        );

  /// Returns a shallow copy of this [Students]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Students copyWith({
    Object? id = _Undefined,
    int? personId,
    Object? person = _Undefined,
    int? groupsId,
    Object? groups = _Undefined,
  }) {
    return Students(
      id: id is int? ? id : this.id,
      personId: personId ?? this.personId,
      person: person is _i2.Person? ? person : this.person?.copyWith(),
      groupsId: groupsId ?? this.groupsId,
      groups: groups is _i3.Groups? ? groups : this.groups?.copyWith(),
    );
  }
}
