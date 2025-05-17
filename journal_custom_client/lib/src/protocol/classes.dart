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

abstract class Classes implements _i1.SerializableModel {
  Classes._({
    this.id,
    required this.subjectId,
    required this.typeId,
    required this.teacherId,
    required this.semesterId,
    this.subgroupId,
    required this.date,
  });

  factory Classes({
    int? id,
    required int subjectId,
    required int typeId,
    required int teacherId,
    required int semesterId,
    int? subgroupId,
    required DateTime date,
  }) = _ClassesImpl;

  factory Classes.fromJson(Map<String, dynamic> jsonSerialization) {
    return Classes(
      id: jsonSerialization['id'] as int?,
      subjectId: jsonSerialization['subjectId'] as int,
      typeId: jsonSerialization['typeId'] as int,
      teacherId: jsonSerialization['teacherId'] as int,
      semesterId: jsonSerialization['semesterId'] as int,
      subgroupId: jsonSerialization['subgroupId'] as int?,
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int subjectId;

  int typeId;

  int teacherId;

  int semesterId;

  int? subgroupId;

  DateTime date;

  /// Returns a shallow copy of this [Classes]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Classes copyWith({
    int? id,
    int? subjectId,
    int? typeId,
    int? teacherId,
    int? semesterId,
    int? subgroupId,
    DateTime? date,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'subjectId': subjectId,
      'typeId': typeId,
      'teacherId': teacherId,
      'semesterId': semesterId,
      if (subgroupId != null) 'subgroupId': subgroupId,
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
    required int typeId,
    required int teacherId,
    required int semesterId,
    int? subgroupId,
    required DateTime date,
  }) : super._(
          id: id,
          subjectId: subjectId,
          typeId: typeId,
          teacherId: teacherId,
          semesterId: semesterId,
          subgroupId: subgroupId,
          date: date,
        );

  /// Returns a shallow copy of this [Classes]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Classes copyWith({
    Object? id = _Undefined,
    int? subjectId,
    int? typeId,
    int? teacherId,
    int? semesterId,
    Object? subgroupId = _Undefined,
    DateTime? date,
  }) {
    return Classes(
      id: id is int? ? id : this.id,
      subjectId: subjectId ?? this.subjectId,
      typeId: typeId ?? this.typeId,
      teacherId: teacherId ?? this.teacherId,
      semesterId: semesterId ?? this.semesterId,
      subgroupId: subgroupId is int? ? subgroupId : this.subgroupId,
      date: date ?? this.date,
    );
  }
}
