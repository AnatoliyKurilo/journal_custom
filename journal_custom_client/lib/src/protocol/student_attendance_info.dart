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

abstract class StudentAttendanceInfo implements _i1.SerializableModel {
  StudentAttendanceInfo._({
    required this.student,
    required this.isPresent,
    this.comment,
    this.attendanceId,
  });

  factory StudentAttendanceInfo({
    required _i2.Students student,
    required bool isPresent,
    String? comment,
    int? attendanceId,
  }) = _StudentAttendanceInfoImpl;

  factory StudentAttendanceInfo.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return StudentAttendanceInfo(
      student: _i2.Students.fromJson(
          (jsonSerialization['student'] as Map<String, dynamic>)),
      isPresent: jsonSerialization['isPresent'] as bool,
      comment: jsonSerialization['comment'] as String?,
      attendanceId: jsonSerialization['attendanceId'] as int?,
    );
  }

  _i2.Students student;

  bool isPresent;

  String? comment;

  int? attendanceId;

  /// Returns a shallow copy of this [StudentAttendanceInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  StudentAttendanceInfo copyWith({
    _i2.Students? student,
    bool? isPresent,
    String? comment,
    int? attendanceId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'student': student.toJson(),
      'isPresent': isPresent,
      if (comment != null) 'comment': comment,
      if (attendanceId != null) 'attendanceId': attendanceId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StudentAttendanceInfoImpl extends StudentAttendanceInfo {
  _StudentAttendanceInfoImpl({
    required _i2.Students student,
    required bool isPresent,
    String? comment,
    int? attendanceId,
  }) : super._(
          student: student,
          isPresent: isPresent,
          comment: comment,
          attendanceId: attendanceId,
        );

  /// Returns a shallow copy of this [StudentAttendanceInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  StudentAttendanceInfo copyWith({
    _i2.Students? student,
    bool? isPresent,
    Object? comment = _Undefined,
    Object? attendanceId = _Undefined,
  }) {
    return StudentAttendanceInfo(
      student: student ?? this.student.copyWith(),
      isPresent: isPresent ?? this.isPresent,
      comment: comment is String? ? comment : this.comment,
      attendanceId: attendanceId is int? ? attendanceId : this.attendanceId,
    );
  }
}
