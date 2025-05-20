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
import 'groups_protocol.dart' as _i2;

abstract class Subgroups implements _i1.SerializableModel {
  Subgroups._({
    this.id,
    required this.name,
    required this.groupsId,
    this.groups,
    this.description,
  });

  factory Subgroups({
    int? id,
    required String name,
    required int groupsId,
    _i2.Groups? groups,
    String? description,
  }) = _SubgroupsImpl;

  factory Subgroups.fromJson(Map<String, dynamic> jsonSerialization) {
    return Subgroups(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      groupsId: jsonSerialization['groupsId'] as int,
      groups: jsonSerialization['groups'] == null
          ? null
          : _i2.Groups.fromJson(
              (jsonSerialization['groups'] as Map<String, dynamic>)),
      description: jsonSerialization['description'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  int groupsId;

  _i2.Groups? groups;

  String? description;

  /// Returns a shallow copy of this [Subgroups]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Subgroups copyWith({
    int? id,
    String? name,
    int? groupsId,
    _i2.Groups? groups,
    String? description,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'groupsId': groupsId,
      if (groups != null) 'groups': groups?.toJson(),
      if (description != null) 'description': description,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SubgroupsImpl extends Subgroups {
  _SubgroupsImpl({
    int? id,
    required String name,
    required int groupsId,
    _i2.Groups? groups,
    String? description,
  }) : super._(
          id: id,
          name: name,
          groupsId: groupsId,
          groups: groups,
          description: description,
        );

  /// Returns a shallow copy of this [Subgroups]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Subgroups copyWith({
    Object? id = _Undefined,
    String? name,
    int? groupsId,
    Object? groups = _Undefined,
    Object? description = _Undefined,
  }) {
    return Subgroups(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      groupsId: groupsId ?? this.groupsId,
      groups: groups is _i2.Groups? ? groups : this.groups?.copyWith(),
      description: description is String? ? description : this.description,
    );
  }
}
