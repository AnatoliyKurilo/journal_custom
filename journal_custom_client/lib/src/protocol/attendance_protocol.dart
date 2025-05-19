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
import 'classes.dart' as _i2;
import 'students_protocol.dart' as _i3;

abstract class Attendance implements _i1.SerializableModel {
  Attendance._({
    this.id,
    required this.classesId,
    this.classes,
    required this.studentsId,
    this.students,
    required this.status,
    this.comment,
  });

  factory Attendance({
    int? id,
    required int classesId,
    _i2.Classes? classes,
    required int studentsId,
    _i3.Students? students,
    required String status,
    String? comment,
  }) = _AttendanceImpl;

  factory Attendance.fromJson(Map<String, dynamic> jsonSerialization) {
    return Attendance(
      id: jsonSerialization['id'] as int?,
      classesId: jsonSerialization['classesId'] as int,
      classes: jsonSerialization['classes'] == null
          ? null
          : _i2.Classes.fromJson(
              (jsonSerialization['classes'] as Map<String, dynamic>)),
      studentsId: jsonSerialization['studentsId'] as int,
      students: jsonSerialization['students'] == null
          ? null
          : _i3.Students.fromJson(
              (jsonSerialization['students'] as Map<String, dynamic>)),
      status: jsonSerialization['status'] as String,
      comment: jsonSerialization['comment'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int classesId;

  _i2.Classes? classes;

  int studentsId;

  _i3.Students? students;

  String status;

  String? comment;

  /// Returns a shallow copy of this [Attendance]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Attendance copyWith({
    int? id,
    int? classesId,
    _i2.Classes? classes,
    int? studentsId,
    _i3.Students? students,
    String? status,
    String? comment,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'classesId': classesId,
      if (classes != null) 'classes': classes?.toJson(),
      'studentsId': studentsId,
      if (students != null) 'students': students?.toJson(),
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
    required int classesId,
    _i2.Classes? classes,
    required int studentsId,
    _i3.Students? students,
    required String status,
    String? comment,
  }) : super._(
          id: id,
          classesId: classesId,
          classes: classes,
          studentsId: studentsId,
          students: students,
          status: status,
          comment: comment,
        );

  /// Returns a shallow copy of this [Attendance]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Attendance copyWith({
    Object? id = _Undefined,
    int? classesId,
    Object? classes = _Undefined,
    int? studentsId,
    Object? students = _Undefined,
    String? status,
    Object? comment = _Undefined,
  }) {
    return Attendance(
      id: id is int? ? id : this.id,
      classesId: classesId ?? this.classesId,
      classes: classes is _i2.Classes? ? classes : this.classes?.copyWith(),
      studentsId: studentsId ?? this.studentsId,
      students:
          students is _i3.Students? ? students : this.students?.copyWith(),
      status: status ?? this.status,
      comment: comment is String? ? comment : this.comment,
    );
  }
}
