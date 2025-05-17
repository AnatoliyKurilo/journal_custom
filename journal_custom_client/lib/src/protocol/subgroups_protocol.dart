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

abstract class Subgroups implements _i1.SerializableModel {
  Subgroups._({
    this.id,
    required this.name,
    required this.groupId,
  });

  factory Subgroups({
    int? id,
    required String name,
    required int groupId,
  }) = _SubgroupsImpl;

  factory Subgroups.fromJson(Map<String, dynamic> jsonSerialization) {
    return Subgroups(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      groupId: jsonSerialization['groupId'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  int groupId;

  /// Returns a shallow copy of this [Subgroups]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Subgroups copyWith({
    int? id,
    String? name,
    int? groupId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'groupId': groupId,
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
    required int groupId,
  }) : super._(
          id: id,
          name: name,
          groupId: groupId,
        );

  /// Returns a shallow copy of this [Subgroups]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Subgroups copyWith({
    Object? id = _Undefined,
    String? name,
    int? groupId,
  }) {
    return Subgroups(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      groupId: groupId ?? this.groupId,
    );
  }
}
