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
import 'students_protocol.dart' as _i2;
import 'subgroups_protocol.dart' as _i3;

abstract class StudentSubgroup implements _i1.SerializableModel {
  StudentSubgroup._({
    this.id,
    required this.studentsId,
    this.students,
    required this.subgroupsId,
    this.subgroups,
  });

  factory StudentSubgroup({
    int? id,
    required int studentsId,
    _i2.Students? students,
    required int subgroupsId,
    _i3.Subgroups? subgroups,
  }) = _StudentSubgroupImpl;

  factory StudentSubgroup.fromJson(Map<String, dynamic> jsonSerialization) {
    return StudentSubgroup(
      id: jsonSerialization['id'] as int?,
      studentsId: jsonSerialization['studentsId'] as int,
      students: jsonSerialization['students'] == null
          ? null
          : _i2.Students.fromJson(
              (jsonSerialization['students'] as Map<String, dynamic>)),
      subgroupsId: jsonSerialization['subgroupsId'] as int,
      subgroups: jsonSerialization['subgroups'] == null
          ? null
          : _i3.Subgroups.fromJson(
              (jsonSerialization['subgroups'] as Map<String, dynamic>)),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int studentsId;

  _i2.Students? students;

  int subgroupsId;

  _i3.Subgroups? subgroups;

  /// Returns a shallow copy of this [StudentSubgroup]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  StudentSubgroup copyWith({
    int? id,
    int? studentsId,
    _i2.Students? students,
    int? subgroupsId,
    _i3.Subgroups? subgroups,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'studentsId': studentsId,
      if (students != null) 'students': students?.toJson(),
      'subgroupsId': subgroupsId,
      if (subgroups != null) 'subgroups': subgroups?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StudentSubgroupImpl extends StudentSubgroup {
  _StudentSubgroupImpl({
    int? id,
    required int studentsId,
    _i2.Students? students,
    required int subgroupsId,
    _i3.Subgroups? subgroups,
  }) : super._(
          id: id,
          studentsId: studentsId,
          students: students,
          subgroupsId: subgroupsId,
          subgroups: subgroups,
        );

  /// Returns a shallow copy of this [StudentSubgroup]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  StudentSubgroup copyWith({
    Object? id = _Undefined,
    int? studentsId,
    Object? students = _Undefined,
    int? subgroupsId,
    Object? subgroups = _Undefined,
  }) {
    return StudentSubgroup(
      id: id is int? ? id : this.id,
      studentsId: studentsId ?? this.studentsId,
      students:
          students is _i2.Students? ? students : this.students?.copyWith(),
      subgroupsId: subgroupsId ?? this.subgroupsId,
      subgroups:
          subgroups is _i3.Subgroups? ? subgroups : this.subgroups?.copyWith(),
    );
  }
}
