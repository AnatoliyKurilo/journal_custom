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

abstract class StudentSubgroup implements _i1.SerializableModel {
  StudentSubgroup._({
    this.id,
    required this.studentId,
    required this.subgroupId,
  });

  factory StudentSubgroup({
    int? id,
    required int studentId,
    required int subgroupId,
  }) = _StudentSubgroupImpl;

  factory StudentSubgroup.fromJson(Map<String, dynamic> jsonSerialization) {
    return StudentSubgroup(
      id: jsonSerialization['id'] as int?,
      studentId: jsonSerialization['studentId'] as int,
      subgroupId: jsonSerialization['subgroupId'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int studentId;

  int subgroupId;

  /// Returns a shallow copy of this [StudentSubgroup]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  StudentSubgroup copyWith({
    int? id,
    int? studentId,
    int? subgroupId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'studentId': studentId,
      'subgroupId': subgroupId,
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
    required int studentId,
    required int subgroupId,
  }) : super._(
          id: id,
          studentId: studentId,
          subgroupId: subgroupId,
        );

  /// Returns a shallow copy of this [StudentSubgroup]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  StudentSubgroup copyWith({
    Object? id = _Undefined,
    int? studentId,
    int? subgroupId,
  }) {
    return StudentSubgroup(
      id: id is int? ? id : this.id,
      studentId: studentId ?? this.studentId,
      subgroupId: subgroupId ?? this.subgroupId,
    );
  }
}
