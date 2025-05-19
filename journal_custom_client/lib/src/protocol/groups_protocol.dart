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
import 'teachers_protocol.dart' as _i2;
import 'students_protocol.dart' as _i3;

abstract class Groups implements _i1.SerializableModel {
  Groups._({
    this.id,
    required this.name,
    this.curatorId,
    this.curator,
    this.groupHeadId,
    this.groupHead,
  });

  factory Groups({
    int? id,
    required String name,
    int? curatorId,
    _i2.Teachers? curator,
    int? groupHeadId,
    _i3.Students? groupHead,
  }) = _GroupsImpl;

  factory Groups.fromJson(Map<String, dynamic> jsonSerialization) {
    return Groups(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      curatorId: jsonSerialization['curatorId'] as int?,
      curator: jsonSerialization['curator'] == null
          ? null
          : _i2.Teachers.fromJson(
              (jsonSerialization['curator'] as Map<String, dynamic>)),
      groupHeadId: jsonSerialization['groupHeadId'] as int?,
      groupHead: jsonSerialization['groupHead'] == null
          ? null
          : _i3.Students.fromJson(
              (jsonSerialization['groupHead'] as Map<String, dynamic>)),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  int? curatorId;

  _i2.Teachers? curator;

  int? groupHeadId;

  _i3.Students? groupHead;

  /// Returns a shallow copy of this [Groups]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Groups copyWith({
    int? id,
    String? name,
    int? curatorId,
    _i2.Teachers? curator,
    int? groupHeadId,
    _i3.Students? groupHead,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (curatorId != null) 'curatorId': curatorId,
      if (curator != null) 'curator': curator?.toJson(),
      if (groupHeadId != null) 'groupHeadId': groupHeadId,
      if (groupHead != null) 'groupHead': groupHead?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GroupsImpl extends Groups {
  _GroupsImpl({
    int? id,
    required String name,
    int? curatorId,
    _i2.Teachers? curator,
    int? groupHeadId,
    _i3.Students? groupHead,
  }) : super._(
          id: id,
          name: name,
          curatorId: curatorId,
          curator: curator,
          groupHeadId: groupHeadId,
          groupHead: groupHead,
        );

  /// Returns a shallow copy of this [Groups]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Groups copyWith({
    Object? id = _Undefined,
    String? name,
    Object? curatorId = _Undefined,
    Object? curator = _Undefined,
    Object? groupHeadId = _Undefined,
    Object? groupHead = _Undefined,
  }) {
    return Groups(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      curatorId: curatorId is int? ? curatorId : this.curatorId,
      curator: curator is _i2.Teachers? ? curator : this.curator?.copyWith(),
      groupHeadId: groupHeadId is int? ? groupHeadId : this.groupHeadId,
      groupHead:
          groupHead is _i3.Students? ? groupHead : this.groupHead?.copyWith(),
    );
  }
}
