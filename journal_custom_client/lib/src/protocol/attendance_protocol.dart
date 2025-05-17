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

abstract class Attendance implements _i1.SerializableModel {
  Attendance._({
    this.id,
    required this.classId,
    required this.studentId,
    required this.status,
    this.comment,
  });

  factory Attendance({
    int? id,
    required int classId,
    required int studentId,
    required String status,
    String? comment,
  }) = _AttendanceImpl;

  factory Attendance.fromJson(Map<String, dynamic> jsonSerialization) {
    return Attendance(
      id: jsonSerialization['id'] as int?,
      classId: jsonSerialization['classId'] as int,
      studentId: jsonSerialization['studentId'] as int,
      status: jsonSerialization['status'] as String,
      comment: jsonSerialization['comment'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int classId;

  int studentId;

  String status;

  String? comment;

  /// Returns a shallow copy of this [Attendance]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Attendance copyWith({
    int? id,
    int? classId,
    int? studentId,
    String? status,
    String? comment,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'classId': classId,
      'studentId': studentId,
      'status': status,
      if (comment != null) 'comment': comment,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AttendanceImpl extends Attendance {
  _AttendanceImpl({
    int? id,
    required int classId,
    required int studentId,
    required String status,
    String? comment,
  }) : super._(
          id: id,
          classId: classId,
          studentId: studentId,
          status: status,
          comment: comment,
        );

  /// Returns a shallow copy of this [Attendance]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Attendance copyWith({
    Object? id = _Undefined,
    int? classId,
    int? studentId,
    String? status,
    Object? comment = _Undefined,
  }) {
    return Attendance(
      id: id is int? ? id : this.id,
      classId: classId ?? this.classId,
      studentId: studentId ?? this.studentId,
      status: status ?? this.status,
      comment: comment is String? ? comment : this.comment,
    );
  }
}
