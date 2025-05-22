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

abstract class StudentOverallAttendanceRecord implements _i1.SerializableModel {
  StudentOverallAttendanceRecord._({
    required this.subjectName,
    this.classTopic,
    this.classTypeName,
    required this.classDate,
    required this.isPresent,
    this.comment,
    this.subgroupName,
  });

  factory StudentOverallAttendanceRecord({
    required String subjectName,
    String? classTopic,
    String? classTypeName,
    required DateTime classDate,
    required bool isPresent,
    String? comment,
    String? subgroupName,
  }) = _StudentOverallAttendanceRecordImpl;

  factory StudentOverallAttendanceRecord.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return StudentOverallAttendanceRecord(
      subjectName: jsonSerialization['subjectName'] as String,
      classTopic: jsonSerialization['classTopic'] as String?,
      classTypeName: jsonSerialization['classTypeName'] as String?,
      classDate:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['classDate']),
      isPresent: jsonSerialization['isPresent'] as bool,
      comment: jsonSerialization['comment'] as String?,
      subgroupName: jsonSerialization['subgroupName'] as String?,
    );
  }

  String subjectName;

  String? classTopic;

  String? classTypeName;

  DateTime classDate;

  bool isPresent;

  String? comment;

  String? subgroupName;

  /// Returns a shallow copy of this [StudentOverallAttendanceRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  StudentOverallAttendanceRecord copyWith({
    String? subjectName,
    String? classTopic,
    String? classTypeName,
    DateTime? classDate,
    bool? isPresent,
    String? comment,
    String? subgroupName,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'subjectName': subjectName,
      if (classTopic != null) 'classTopic': classTopic,
      if (classTypeName != null) 'classTypeName': classTypeName,
      'classDate': classDate.toJson(),
      'isPresent': isPresent,
      if (comment != null) 'comment': comment,
      if (subgroupName != null) 'subgroupName': subgroupName,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StudentOverallAttendanceRecordImpl
    extends StudentOverallAttendanceRecord {
  _StudentOverallAttendanceRecordImpl({
    required String subjectName,
    String? classTopic,
    String? classTypeName,
    required DateTime classDate,
    required bool isPresent,
    String? comment,
    String? subgroupName,
  }) : super._(
          subjectName: subjectName,
          classTopic: classTopic,
          classTypeName: classTypeName,
          classDate: classDate,
          isPresent: isPresent,
          comment: comment,
          subgroupName: subgroupName,
        );

  /// Returns a shallow copy of this [StudentOverallAttendanceRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  StudentOverallAttendanceRecord copyWith({
    String? subjectName,
    Object? classTopic = _Undefined,
    Object? classTypeName = _Undefined,
    DateTime? classDate,
    bool? isPresent,
    Object? comment = _Undefined,
    Object? subgroupName = _Undefined,
  }) {
    return StudentOverallAttendanceRecord(
      subjectName: subjectName ?? this.subjectName,
      classTopic: classTopic is String? ? classTopic : this.classTopic,
      classTypeName:
          classTypeName is String? ? classTypeName : this.classTypeName,
      classDate: classDate ?? this.classDate,
      isPresent: isPresent ?? this.isPresent,
      comment: comment is String? ? comment : this.comment,
      subgroupName: subgroupName is String? ? subgroupName : this.subgroupName,
    );
  }
}
