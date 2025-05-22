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

abstract class Semesters implements _i1.SerializableModel {
  Semesters._({
    this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.year,
  });

  factory Semesters({
    int? id,
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    required int year,
  }) = _SemestersImpl;

  factory Semesters.fromJson(Map<String, dynamic> jsonSerialization) {
    return Semesters(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      startDate:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['startDate']),
      endDate: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      year: jsonSerialization['year'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  DateTime startDate;

  DateTime endDate;

  int year;

  /// Returns a shallow copy of this [Semesters]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Semesters copyWith({
    int? id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    int? year,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'startDate': startDate.toJson(),
      'endDate': endDate.toJson(),
      'year': year,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SemestersImpl extends Semesters {
  _SemestersImpl({
    int? id,
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    required int year,
  }) : super._(
          id: id,
          name: name,
          startDate: startDate,
          endDate: endDate,
          year: year,
        );

  /// Returns a shallow copy of this [Semesters]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Semesters copyWith({
    Object? id = _Undefined,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    int? year,
  }) {
    return Semesters(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      year: year ?? this.year,
    );
  }
}
