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
import 'subjects_protocol.dart' as _i2;
import 'class_types_protocol.dart' as _i3;
import 'teachers_protocol.dart' as _i4;
import 'semesters_protocol.dart' as _i5;
import 'subgroups_protocol.dart' as _i6;

abstract class Classes implements _i1.SerializableModel {
  Classes._({
    this.id,
    required this.subjectId,
    required this.subjectsId,
    this.subjects,
    required this.class_typesId,
    this.class_types,
    required this.teachersId,
    this.teachers,
    required this.semestersId,
    this.semesters,
    required this.subgroupsId,
    this.subgroups,
    required this.date,
  });

  factory Classes({
    int? id,
    required int subjectId,
    required int subjectsId,
    _i2.Subjects? subjects,
    required int class_typesId,
    _i3.ClassTypes? class_types,
    required int teachersId,
    _i4.Teachers? teachers,
    required int semestersId,
    _i5.Semesters? semesters,
    required int subgroupsId,
    _i6.Subgroups? subgroups,
    required DateTime date,
  }) = _ClassesImpl;

  factory Classes.fromJson(Map<String, dynamic> jsonSerialization) {
    return Classes(
      id: jsonSerialization['id'] as int?,
      subjectId: jsonSerialization['subjectId'] as int,
      subjectsId: jsonSerialization['subjectsId'] as int,
      subjects: jsonSerialization['subjects'] == null
          ? null
          : _i2.Subjects.fromJson(
              (jsonSerialization['subjects'] as Map<String, dynamic>)),
      class_typesId: jsonSerialization['class_typesId'] as int,
      class_types: jsonSerialization['class_types'] == null
          ? null
          : _i3.ClassTypes.fromJson(
              (jsonSerialization['class_types'] as Map<String, dynamic>)),
      teachersId: jsonSerialization['teachersId'] as int,
      teachers: jsonSerialization['teachers'] == null
          ? null
          : _i4.Teachers.fromJson(
              (jsonSerialization['teachers'] as Map<String, dynamic>)),
      semestersId: jsonSerialization['semestersId'] as int,
      semesters: jsonSerialization['semesters'] == null
          ? null
          : _i5.Semesters.fromJson(
              (jsonSerialization['semesters'] as Map<String, dynamic>)),
      subgroupsId: jsonSerialization['subgroupsId'] as int,
      subgroups: jsonSerialization['subgroups'] == null
          ? null
          : _i6.Subgroups.fromJson(
              (jsonSerialization['subgroups'] as Map<String, dynamic>)),
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int subjectId;

  int subjectsId;

  _i2.Subjects? subjects;

  int class_typesId;

  _i3.ClassTypes? class_types;

  int teachersId;

  _i4.Teachers? teachers;

  int semestersId;

  _i5.Semesters? semesters;

  int subgroupsId;

  _i6.Subgroups? subgroups;

  DateTime date;

  /// Returns a shallow copy of this [Classes]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Classes copyWith({
    int? id,
    int? subjectId,
    int? subjectsId,
    _i2.Subjects? subjects,
    int? class_typesId,
    _i3.ClassTypes? class_types,
    int? teachersId,
    _i4.Teachers? teachers,
    int? semestersId,
    _i5.Semesters? semesters,
    int? subgroupsId,
    _i6.Subgroups? subgroups,
    DateTime? date,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'subjectId': subjectId,
      'subjectsId': subjectsId,
      if (subjects != null) 'subjects': subjects?.toJson(),
      'class_typesId': class_typesId,
      if (class_types != null) 'class_types': class_types?.toJson(),
      'teachersId': teachersId,
      if (teachers != null) 'teachers': teachers?.toJson(),
      'semestersId': semestersId,
      if (semesters != null) 'semesters': semesters?.toJson(),
      'subgroupsId': subgroupsId,
      if (subgroups != null) 'subgroups': subgroups?.toJson(),
      'date': date.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ClassesImpl extends Classes {
  _ClassesImpl({
    int? id,
    required int subjectId,
    required int subjectsId,
    _i2.Subjects? subjects,
    required int class_typesId,
    _i3.ClassTypes? class_types,
    required int teachersId,
    _i4.Teachers? teachers,
    required int semestersId,
    _i5.Semesters? semesters,
    required int subgroupsId,
    _i6.Subgroups? subgroups,
    required DateTime date,
  }) : super._(
          id: id,
          subjectId: subjectId,
          subjectsId: subjectsId,
          subjects: subjects,
          class_typesId: class_typesId,
          class_types: class_types,
          teachersId: teachersId,
          teachers: teachers,
          semestersId: semestersId,
          semesters: semesters,
          subgroupsId: subgroupsId,
          subgroups: subgroups,
          date: date,
        );

  /// Returns a shallow copy of this [Classes]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Classes copyWith({
    Object? id = _Undefined,
    int? subjectId,
    int? subjectsId,
    Object? subjects = _Undefined,
    int? class_typesId,
    Object? class_types = _Undefined,
    int? teachersId,
    Object? teachers = _Undefined,
    int? semestersId,
    Object? semesters = _Undefined,
    int? subgroupsId,
    Object? subgroups = _Undefined,
    DateTime? date,
  }) {
    return Classes(
      id: id is int? ? id : this.id,
      subjectId: subjectId ?? this.subjectId,
      subjectsId: subjectsId ?? this.subjectsId,
      subjects:
          subjects is _i2.Subjects? ? subjects : this.subjects?.copyWith(),
      class_typesId: class_typesId ?? this.class_typesId,
      class_types: class_types is _i3.ClassTypes?
          ? class_types
          : this.class_types?.copyWith(),
      teachersId: teachersId ?? this.teachersId,
      teachers:
          teachers is _i4.Teachers? ? teachers : this.teachers?.copyWith(),
      semestersId: semestersId ?? this.semestersId,
      semesters:
          semesters is _i5.Semesters? ? semesters : this.semesters?.copyWith(),
      subgroupsId: subgroupsId ?? this.subgroupsId,
      subgroups:
          subgroups is _i6.Subgroups? ? subgroups : this.subgroups?.copyWith(),
      date: date ?? this.date,
    );
  }
}
