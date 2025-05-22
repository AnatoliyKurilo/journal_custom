/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'students_protocol.dart' as _i2;
import 'classes.dart' as _i3;

abstract class SubjectAttendanceMatrix
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  SubjectAttendanceMatrix._({
    required this.students,
    required this.classes,
    required this.attendanceData,
  });

  factory SubjectAttendanceMatrix({
    required List<_i2.Students> students,
    required List<_i3.Classes> classes,
    required Map<int, Map<int, bool>> attendanceData,
  }) = _SubjectAttendanceMatrixImpl;

  factory SubjectAttendanceMatrix.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return SubjectAttendanceMatrix(
      students: (jsonSerialization['students'] as List)
          .map((e) => _i2.Students.fromJson((e as Map<String, dynamic>)))
          .toList(),
      classes: (jsonSerialization['classes'] as List)
          .map((e) => _i3.Classes.fromJson((e as Map<String, dynamic>)))
          .toList(),
      attendanceData: (jsonSerialization['attendanceData'] as List)
          .fold<Map<int, Map<int, bool>>>(
              {},
              (t, e) => {
                    ...t,
                    e['k'] as int: (e['v'] as List).fold<Map<int, bool>>(
                        {}, (t, e) => {...t, e['k'] as int: e['v'] as bool})
                  }),
    );
  }

  List<_i2.Students> students;

  List<_i3.Classes> classes;

  Map<int, Map<int, bool>> attendanceData;

  /// Returns a shallow copy of this [SubjectAttendanceMatrix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SubjectAttendanceMatrix copyWith({
    List<_i2.Students>? students,
    List<_i3.Classes>? classes,
    Map<int, Map<int, bool>>? attendanceData,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'students': students.toJson(valueToJson: (v) => v.toJson()),
      'classes': classes.toJson(valueToJson: (v) => v.toJson()),
      'attendanceData': attendanceData.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'students': students.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'classes': classes.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'attendanceData': attendanceData.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _SubjectAttendanceMatrixImpl extends SubjectAttendanceMatrix {
  _SubjectAttendanceMatrixImpl({
    required List<_i2.Students> students,
    required List<_i3.Classes> classes,
    required Map<int, Map<int, bool>> attendanceData,
  }) : super._(
          students: students,
          classes: classes,
          attendanceData: attendanceData,
        );

  /// Returns a shallow copy of this [SubjectAttendanceMatrix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SubjectAttendanceMatrix copyWith({
    List<_i2.Students>? students,
    List<_i3.Classes>? classes,
    Map<int, Map<int, bool>>? attendanceData,
  }) {
    return SubjectAttendanceMatrix(
      students: students ?? this.students.map((e0) => e0.copyWith()).toList(),
      classes: classes ?? this.classes.map((e0) => e0.copyWith()).toList(),
      attendanceData: attendanceData ??
          this.attendanceData.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0.map((
                      key1,
                      value1,
                    ) =>
                        MapEntry(
                          key1,
                          value1,
                        )),
                  )),
    );
  }
}
