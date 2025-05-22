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
import 'classes.dart' as _i3;

abstract class StudentClassAttendanceFlatRecord
    implements _i1.SerializableModel {
  StudentClassAttendanceFlatRecord._({
    required this.student,
    required this.classInfo,
    required this.isPresent,
    this.comment,
  });

  factory StudentClassAttendanceFlatRecord({
    required _i2.Students student,
    required _i3.Classes classInfo,
    required bool isPresent,
    String? comment,
  }) = _StudentClassAttendanceFlatRecordImpl;

  factory StudentClassAttendanceFlatRecord.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return StudentClassAttendanceFlatRecord(
      student: _i2.Students.fromJson(
          (jsonSerialization['student'] as Map<String, dynamic>)),
      classInfo: _i3.Classes.fromJson(
          (jsonSerialization['classInfo'] as Map<String, dynamic>)),
      isPresent: jsonSerialization['isPresent'] as bool,
      comment: jsonSerialization['comment'] as String?,
    );
  }

  _i2.Students student;

  _i3.Classes classInfo;

  bool isPresent;

  String? comment;

  /// Returns a shallow copy of this [StudentClassAttendanceFlatRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  StudentClassAttendanceFlatRecord copyWith({
    _i2.Students? student,
    _i3.Classes? classInfo,
    bool? isPresent,
    String? comment,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'student': student.toJson(),
      'classInfo': classInfo.toJson(),
      'isPresent': isPresent,
      if (comment != null) 'comment': comment,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StudentClassAttendanceFlatRecordImpl
    extends StudentClassAttendanceFlatRecord {
  _StudentClassAttendanceFlatRecordImpl({
    required _i2.Students student,
    required _i3.Classes classInfo,
    required bool isPresent,
    String? comment,
  }) : super._(
          student: student,
          classInfo: classInfo,
          isPresent: isPresent,
          comment: comment,
        );

  /// Returns a shallow copy of this [StudentClassAttendanceFlatRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  StudentClassAttendanceFlatRecord copyWith({
    _i2.Students? student,
    _i3.Classes? classInfo,
    bool? isPresent,
    Object? comment = _Undefined,
  }) {
    return StudentClassAttendanceFlatRecord(
      student: student ?? this.student.copyWith(),
      classInfo: classInfo ?? this.classInfo.copyWith(),
      isPresent: isPresent ?? this.isPresent,
      comment: comment is String? ? comment : this.comment,
    );
  }
}
