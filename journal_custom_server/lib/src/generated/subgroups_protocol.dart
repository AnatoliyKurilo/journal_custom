/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'groups_protocol.dart' as _i2;

abstract class Subgroups
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Subgroups._({
    this.id,
    required this.name,
    required this.groupsId,
    this.groups,
  });

  factory Subgroups({
    int? id,
    required String name,
    required int groupsId,
    _i2.Groups? groups,
  }) = _SubgroupsImpl;

  factory Subgroups.fromJson(Map<String, dynamic> jsonSerialization) {
    return Subgroups(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      groupsId: jsonSerialization['groupsId'] as int,
      groups: jsonSerialization['groups'] == null
          ? null
          : _i2.Groups.fromJson(
              (jsonSerialization['groups'] as Map<String, dynamic>)),
    );
  }

  static final t = SubgroupsTable();

  static const db = SubgroupsRepository._();

  @override
  int? id;

  String name;

  int groupsId;

  _i2.Groups? groups;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Subgroups]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Subgroups copyWith({
    int? id,
    String? name,
    int? groupsId,
    _i2.Groups? groups,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'groupsId': groupsId,
      if (groups != null) 'groups': groups?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'groupsId': groupsId,
      if (groups != null) 'groups': groups?.toJsonForProtocol(),
    };
  }

  static SubgroupsInclude include({_i2.GroupsInclude? groups}) {
    return SubgroupsInclude._(groups: groups);
  }

  static SubgroupsIncludeList includeList({
    _i1.WhereExpressionBuilder<SubgroupsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SubgroupsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SubgroupsTable>? orderByList,
    SubgroupsInclude? include,
  }) {
    return SubgroupsIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Subgroups.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Subgroups.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SubgroupsImpl extends Subgroups {
  _SubgroupsImpl({
    int? id,
    required String name,
    required int groupsId,
    _i2.Groups? groups,
  }) : super._(
          id: id,
          name: name,
          groupsId: groupsId,
          groups: groups,
        );

  /// Returns a shallow copy of this [Subgroups]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Subgroups copyWith({
    Object? id = _Undefined,
    String? name,
    int? groupsId,
    Object? groups = _Undefined,
  }) {
    return Subgroups(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      groupsId: groupsId ?? this.groupsId,
      groups: groups is _i2.Groups? ? groups : this.groups?.copyWith(),
    );
  }
}

class SubgroupsTable extends _i1.Table<int?> {
  SubgroupsTable({super.tableRelation}) : super(tableName: 'subgroups') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    groupsId = _i1.ColumnInt(
      'groupsId',
      this,
    );
  }

  late final _i1.ColumnString name;

  late final _i1.ColumnInt groupsId;

  _i2.GroupsTable? _groups;

  _i2.GroupsTable get groups {
    if (_groups != null) return _groups!;
    _groups = _i1.createRelationTable(
      relationFieldName: 'groups',
      field: Subgroups.t.groupsId,
      foreignField: _i2.Groups.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.GroupsTable(tableRelation: foreignTableRelation),
    );
    return _groups!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        groupsId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'groups') {
      return groups;
    }
    return null;
  }
}

class SubgroupsInclude extends _i1.IncludeObject {
  SubgroupsInclude._({_i2.GroupsInclude? groups}) {
    _groups = groups;
  }

  _i2.GroupsInclude? _groups;

  @override
  Map<String, _i1.Include?> get includes => {'groups': _groups};

  @override
  _i1.Table<int?> get table => Subgroups.t;
}

class SubgroupsIncludeList extends _i1.IncludeList {
  SubgroupsIncludeList._({
    _i1.WhereExpressionBuilder<SubgroupsTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Subgroups.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Subgroups.t;
}

class SubgroupsRepository {
  const SubgroupsRepository._();

  final attachRow = const SubgroupsAttachRowRepository._();

  /// Returns a list of [Subgroups]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Subgroups>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SubgroupsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SubgroupsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SubgroupsTable>? orderByList,
    _i1.Transaction? transaction,
    SubgroupsInclude? include,
  }) async {
    return session.db.find<Subgroups>(
      where: where?.call(Subgroups.t),
      orderBy: orderBy?.call(Subgroups.t),
      orderByList: orderByList?.call(Subgroups.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [Subgroups] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Subgroups?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SubgroupsTable>? where,
    int? offset,
    _i1.OrderByBuilder<SubgroupsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SubgroupsTable>? orderByList,
    _i1.Transaction? transaction,
    SubgroupsInclude? include,
  }) async {
    return session.db.findFirstRow<Subgroups>(
      where: where?.call(Subgroups.t),
      orderBy: orderBy?.call(Subgroups.t),
      orderByList: orderByList?.call(Subgroups.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [Subgroups] by its [id] or null if no such row exists.
  Future<Subgroups?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    SubgroupsInclude? include,
  }) async {
    return session.db.findById<Subgroups>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [Subgroups]s in the list and returns the inserted rows.
  ///
  /// The returned [Subgroups]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Subgroups>> insert(
    _i1.Session session,
    List<Subgroups> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Subgroups>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Subgroups] and returns the inserted row.
  ///
  /// The returned [Subgroups] will have its `id` field set.
  Future<Subgroups> insertRow(
    _i1.Session session,
    Subgroups row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Subgroups>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Subgroups]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Subgroups>> update(
    _i1.Session session,
    List<Subgroups> rows, {
    _i1.ColumnSelections<SubgroupsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Subgroups>(
      rows,
      columns: columns?.call(Subgroups.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Subgroups]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Subgroups> updateRow(
    _i1.Session session,
    Subgroups row, {
    _i1.ColumnSelections<SubgroupsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Subgroups>(
      row,
      columns: columns?.call(Subgroups.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Subgroups]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Subgroups>> delete(
    _i1.Session session,
    List<Subgroups> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Subgroups>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Subgroups].
  Future<Subgroups> deleteRow(
    _i1.Session session,
    Subgroups row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Subgroups>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Subgroups>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SubgroupsTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Subgroups>(
      where: where(Subgroups.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SubgroupsTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Subgroups>(
      where: where?.call(Subgroups.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class SubgroupsAttachRowRepository {
  const SubgroupsAttachRowRepository._();

  /// Creates a relation between the given [Subgroups] and [Groups]
  /// by setting the [Subgroups]'s foreign key `groupsId` to refer to the [Groups].
  Future<void> groups(
    _i1.Session session,
    Subgroups subgroups,
    _i2.Groups groups, {
    _i1.Transaction? transaction,
  }) async {
    if (subgroups.id == null) {
      throw ArgumentError.notNull('subgroups.id');
    }
    if (groups.id == null) {
      throw ArgumentError.notNull('groups.id');
    }

    var $subgroups = subgroups.copyWith(groupsId: groups.id);
    await session.db.updateRow<Subgroups>(
      $subgroups,
      columns: [Subgroups.t.groupsId],
      transaction: transaction,
    );
  }
}
