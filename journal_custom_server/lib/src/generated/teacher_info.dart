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

abstract class TeacherInfo
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  TeacherInfo._({
    required this.id,
    required this.name,
    this.kaf,
  });

  factory TeacherInfo({
    required int id,
    required String name,
    String? kaf,
  }) = _TeacherInfoImpl;

  factory TeacherInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return TeacherInfo(
      id: jsonSerialization['id'] as int,
      name: jsonSerialization['name'] as String,
      kaf: jsonSerialization['kaf'] as String?,
    );
  }

  int id;

  String name;

  String? kaf;

  /// Returns a shallow copy of this [TeacherInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TeacherInfo copyWith({
    int? id,
    String? name,
    String? kaf,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (kaf != null) 'kaf': kaf,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'id': id,
      'name': name,
      if (kaf != null) 'kaf': kaf,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TeacherInfoImpl extends TeacherInfo {
  _TeacherInfoImpl({
    required int id,
    required String name,
    String? kaf,
  }) : super._(
          id: id,
          name: name,
          kaf: kaf,
        );

  /// Returns a shallow copy of this [TeacherInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TeacherInfo copyWith({
    int? id,
    String? name,
    Object? kaf = _Undefined,
  }) {
    return TeacherInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      kaf: kaf is String? ? kaf : this.kaf,
    );
  }
}
