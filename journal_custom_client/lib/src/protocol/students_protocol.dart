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

abstract class Students implements _i1.SerializableModel {
  Students._({
    this.id,
    required this.personId,
    required this.groupId,
  });

  factory Students({
    int? id,
    required int personId,
    required int groupId,
  }) = _StudentsImpl;

  factory Students.fromJson(Map<String, dynamic> jsonSerialization) {
    return Students(
      id: jsonSerialization['id'] as int?,
      personId: jsonSerialization['personId'] as int,
      groupId: jsonSerialization['groupId'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int personId;

  int groupId;

  /// Returns a shallow copy of this [Students]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Students copyWith({
    int? id,
    int? personId,
    int? groupId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'personId': personId,
      'groupId': groupId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StudentsImpl extends Students {
  _StudentsImpl({
    int? id,
    required int personId,
    required int groupId,
  }) : super._(
          id: id,
          personId: personId,
          groupId: groupId,
        );

  /// Returns a shallow copy of this [Students]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Students copyWith({
    Object? id = _Undefined,
    int? personId,
    int? groupId,
  }) {
    return Students(
      id: id is int? ? id : this.id,
      personId: personId ?? this.personId,
      groupId: groupId ?? this.groupId,
    );
  }
}
