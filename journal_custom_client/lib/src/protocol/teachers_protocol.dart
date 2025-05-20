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

abstract class Teachers implements _i1.SerializableModel {
  Teachers._({
    this.id,
    required this.personId,
    this.person,
    this.groups,
  });

  factory Teachers({
    int? id,
    required int personId,
    _i2.Person? person,
    List<_i3.Groups>? groups,
  }) = _TeachersImpl;

  factory Teachers.fromJson(Map<String, dynamic> jsonSerialization) {
    return Teachers(
      id: jsonSerialization['id'] as int?,
      personId: jsonSerialization['personId'] as int,
      person: jsonSerialization['person'] == null
          ? null
          : _i2.Person.fromJson(
              (jsonSerialization['person'] as Map<String, dynamic>)),
      groups: (jsonSerialization['groups'] as List?)
          ?.map((e) => _i3.Groups.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int personId;

  _i2.Person? person;

  List<_i3.Groups>? groups;

  /// Returns a shallow copy of this [Teachers]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Teachers copyWith({
    int? id,
    int? personId,
    _i2.Person? person,
    List<_i3.Groups>? groups,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'personId': personId,
      if (person != null) 'person': person?.toJson(),
      if (groups != null)
        'groups': groups?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TeachersImpl extends Teachers {
  _TeachersImpl({
    int? id,
    required int personId,
    _i2.Person? person,
    List<_i3.Groups>? groups,
  }) : super._(
          id: id,
          personId: personId,
          person: person,
          groups: groups,
        );

  /// Returns a shallow copy of this [Teachers]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Teachers copyWith({
    Object? id = _Undefined,
    int? personId,
    Object? person = _Undefined,
    Object? groups = _Undefined,
  }) {
    return Teachers(
      id: id is int? ? id : this.id,
      personId: personId ?? this.personId,
      person: person is _i2.Person? ? person : this.person?.copyWith(),
      groups: groups is List<_i3.Groups>?
          ? groups
          : this.groups?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
