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

abstract class GroupInfo
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  GroupInfo._({
    required this.id,
    required this.name,
    required this.facul,
    required this.kurs,
    this.spec,
  });

  factory GroupInfo({
    required int id,
    required String name,
    required String facul,
    required int kurs,
    String? spec,
  }) = _GroupInfoImpl;

  factory GroupInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return GroupInfo(
      id: jsonSerialization['id'] as int,
      name: jsonSerialization['name'] as String,
      facul: jsonSerialization['facul'] as String,
      kurs: jsonSerialization['kurs'] as int,
      spec: jsonSerialization['spec'] as String?,
    );
  }

  int id;

  String name;

  String facul;

  int kurs;

  String? spec;

  /// Returns a shallow copy of this [GroupInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  GroupInfo copyWith({
    int? id,
    String? name,
    String? facul,
    int? kurs,
    String? spec,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'facul': facul,
      'kurs': kurs,
      if (spec != null) 'spec': spec,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'id': id,
      'name': name,
      'facul': facul,
      'kurs': kurs,
      if (spec != null) 'spec': spec,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GroupInfoImpl extends GroupInfo {
  _GroupInfoImpl({
    required int id,
    required String name,
    required String facul,
    required int kurs,
    String? spec,
  }) : super._(
          id: id,
          name: name,
          facul: facul,
          kurs: kurs,
          spec: spec,
        );

  /// Returns a shallow copy of this [GroupInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  GroupInfo copyWith({
    int? id,
    String? name,
    String? facul,
    int? kurs,
    Object? spec = _Undefined,
  }) {
    return GroupInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      facul: facul ?? this.facul,
      kurs: kurs ?? this.kurs,
      spec: spec is String? ? spec : this.spec,
    );
  }
}
