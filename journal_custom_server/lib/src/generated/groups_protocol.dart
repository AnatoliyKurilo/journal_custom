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
import 'teachers_protocol.dart' as _i2;
import 'students_protocol.dart' as _i3;

abstract class Groups implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Groups._({
    this.id,
    required this.name,
    this.curatorId,
    this.curator,
    this.groupHeadId,
    this.groupHead,
  });

  factory Groups({
    int? id,
    required String name,
    int? curatorId,
    _i2.Teachers? curator,
    int? groupHeadId,
    _i3.Students? groupHead,
  }) = _GroupsImpl;

  factory Groups.fromJson(Map<String, dynamic> jsonSerialization) {
    return Groups(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      curatorId: jsonSerialization['curatorId'] as int?,
      curator: jsonSerialization['curator'] == null
          ? null
          : _i2.Teachers.fromJson(
              (jsonSerialization['curator'] as Map<String, dynamic>)),
      groupHeadId: jsonSerialization['groupHeadId'] as int?,
      groupHead: jsonSerialization['groupHead'] == null
          ? null
          : _i3.Students.fromJson(
              (jsonSerialization['groupHead'] as Map<String, dynamic>)),
    );
  }

  static final t = GroupsTable();

  static const db = GroupsRepository._();

  @override
  int? id;

  String name;

  int? curatorId;

  _i2.Teachers? curator;

  int? groupHeadId;

  _i3.Students? groupHead;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Groups]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Groups copyWith({
    int? id,
    String? name,
    int? curatorId,
    _i2.Teachers? curator,
    int? groupHeadId,
    _i3.Students? groupHead,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (curatorId != null) 'curatorId': curatorId,
      if (curator != null) 'curator': curator?.toJson(),
      if (groupHeadId != null) 'groupHeadId': groupHeadId,
      if (groupHead != null) 'groupHead': groupHead?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (curatorId != null) 'curatorId': curatorId,
      if (curator != null) 'curator': curator?.toJsonForProtocol(),
      if (groupHeadId != null) 'groupHeadId': groupHeadId,
      if (groupHead != null) 'groupHead': groupHead?.toJsonForProtocol(),
    };
  }

  static GroupsInclude include({
    _i2.TeachersInclude? curator,
    _i3.StudentsInclude? groupHead,
  }) {
    return GroupsInclude._(
      curator: curator,
      groupHead: groupHead,
    );
  }

  static GroupsIncludeList includeList({
    _i1.WhereExpressionBuilder<GroupsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GroupsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GroupsTable>? orderByList,
    GroupsInclude? include,
  }) {
    return GroupsIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Groups.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Groups.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GroupsImpl extends Groups {
  _GroupsImpl({
    int? id,
    required String name,
    int? curatorId,
    _i2.Teachers? curator,
    int? groupHeadId,
    _i3.Students? groupHead,
  }) : super._(
          id: id,
          name: name,
          curatorId: curatorId,
          curator: curator,
          groupHeadId: groupHeadId,
          groupHead: groupHead,
        );

  /// Returns a shallow copy of this [Groups]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Groups copyWith({
    Object? id = _Undefined,
    String? name,
    Object? curatorId = _Undefined,
    Object? curator = _Undefined,
    Object? groupHeadId = _Undefined,
    Object? groupHead = _Undefined,
  }) {
    return Groups(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      curatorId: curatorId is int? ? curatorId : this.curatorId,
      curator: curator is _i2.Teachers? ? curator : this.curator?.copyWith(),
      groupHeadId: groupHeadId is int? ? groupHeadId : this.groupHeadId,
      groupHead:
          groupHead is _i3.Students? ? groupHead : this.groupHead?.copyWith(),
    );
  }
}

class GroupsTable extends _i1.Table<int?> {
  GroupsTable({super.tableRelation}) : super(tableName: 'groups') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    curatorId = _i1.ColumnInt(
      'curatorId',
      this,
    );
    groupHeadId = _i1.ColumnInt(
      'groupHeadId',
      this,
    );
  }

  late final _i1.ColumnString name;

  late final _i1.ColumnInt curatorId;

  _i2.TeachersTable? _curator;

  late final _i1.ColumnInt groupHeadId;

  _i3.StudentsTable? _groupHead;

  _i2.TeachersTable get curator {
    if (_curator != null) return _curator!;
    _curator = _i1.createRelationTable(
      relationFieldName: 'curator',
      field: Groups.t.curatorId,
      foreignField: _i2.Teachers.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.TeachersTable(tableRelation: foreignTableRelation),
    );
    return _curator!;
  }

  _i3.StudentsTable get groupHead {
    if (_groupHead != null) return _groupHead!;
    _groupHead = _i1.createRelationTable(
      relationFieldName: 'groupHead',
      field: Groups.t.groupHeadId,
      foreignField: _i3.Students.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.StudentsTable(tableRelation: foreignTableRelation),
    );
    return _groupHead!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        curatorId,
        groupHeadId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'curator') {
      return curator;
    }
    if (relationField == 'groupHead') {
      return groupHead;
    }
    return null;
  }
}

class GroupsInclude extends _i1.IncludeObject {
  GroupsInclude._({
    _i2.TeachersInclude? curator,
    _i3.StudentsInclude? groupHead,
  }) {
    _curator = curator;
    _groupHead = groupHead;
  }

  _i2.TeachersInclude? _curator;

  _i3.StudentsInclude? _groupHead;

  @override
  Map<String, _i1.Include?> get includes => {
        'curator': _curator,
        'groupHead': _groupHead,
      };

  @override
  _i1.Table<int?> get table => Groups.t;
}

class GroupsIncludeList extends _i1.IncludeList {
  GroupsIncludeList._({
    _i1.WhereExpressionBuilder<GroupsTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Groups.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Groups.t;
}

class GroupsRepository {
  const GroupsRepository._();

  final attachRow = const GroupsAttachRowRepository._();

  final detachRow = const GroupsDetachRowRepository._();

  /// Returns a list of [Groups]s matching the given query parameters.
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
  Future<List<Groups>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<GroupsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GroupsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GroupsTable>? orderByList,
    _i1.Transaction? transaction,
    GroupsInclude? include,
  }) async {
    return session.db.find<Groups>(
      where: where?.call(Groups.t),
      orderBy: orderBy?.call(Groups.t),
      orderByList: orderByList?.call(Groups.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [Groups] matching the given query parameters.
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
  Future<Groups?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<GroupsTable>? where,
    int? offset,
    _i1.OrderByBuilder<GroupsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GroupsTable>? orderByList,
    _i1.Transaction? transaction,
    GroupsInclude? include,
  }) async {
    return session.db.findFirstRow<Groups>(
      where: where?.call(Groups.t),
      orderBy: orderBy?.call(Groups.t),
      orderByList: orderByList?.call(Groups.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [Groups] by its [id] or null if no such row exists.
  Future<Groups?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    GroupsInclude? include,
  }) async {
    return session.db.findById<Groups>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [Groups]s in the list and returns the inserted rows.
  ///
  /// The returned [Groups]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Groups>> insert(
    _i1.Session session,
    List<Groups> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Groups>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Groups] and returns the inserted row.
  ///
  /// The returned [Groups] will have its `id` field set.
  Future<Groups> insertRow(
    _i1.Session session,
    Groups row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Groups>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Groups]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Groups>> update(
    _i1.Session session,
    List<Groups> rows, {
    _i1.ColumnSelections<GroupsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Groups>(
      rows,
      columns: columns?.call(Groups.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Groups]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Groups> updateRow(
    _i1.Session session,
    Groups row, {
    _i1.ColumnSelections<GroupsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Groups>(
      row,
      columns: columns?.call(Groups.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Groups]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Groups>> delete(
    _i1.Session session,
    List<Groups> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Groups>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Groups].
  Future<Groups> deleteRow(
    _i1.Session session,
    Groups row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Groups>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Groups>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<GroupsTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Groups>(
      where: where(Groups.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<GroupsTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Groups>(
      where: where?.call(Groups.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class GroupsAttachRowRepository {
  const GroupsAttachRowRepository._();

  /// Creates a relation between the given [Groups] and [Teachers]
  /// by setting the [Groups]'s foreign key `curatorId` to refer to the [Teachers].
  Future<void> curator(
    _i1.Session session,
    Groups groups,
    _i2.Teachers curator, {
    _i1.Transaction? transaction,
  }) async {
    if (groups.id == null) {
      throw ArgumentError.notNull('groups.id');
    }
    if (curator.id == null) {
      throw ArgumentError.notNull('curator.id');
    }

    var $groups = groups.copyWith(curatorId: curator.id);
    await session.db.updateRow<Groups>(
      $groups,
      columns: [Groups.t.curatorId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [Groups] and [Students]
  /// by setting the [Groups]'s foreign key `groupHeadId` to refer to the [Students].
  Future<void> groupHead(
    _i1.Session session,
    Groups groups,
    _i3.Students groupHead, {
    _i1.Transaction? transaction,
  }) async {
    if (groups.id == null) {
      throw ArgumentError.notNull('groups.id');
    }
    if (groupHead.id == null) {
      throw ArgumentError.notNull('groupHead.id');
    }

    var $groups = groups.copyWith(groupHeadId: groupHead.id);
    await session.db.updateRow<Groups>(
      $groups,
      columns: [Groups.t.groupHeadId],
      transaction: transaction,
    );
  }
}

class GroupsDetachRowRepository {
  const GroupsDetachRowRepository._();

  /// Detaches the relation between this [Groups] and the [Teachers] set in `curator`
  /// by setting the [Groups]'s foreign key `curatorId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> curator(
    _i1.Session session,
    Groups groups, {
    _i1.Transaction? transaction,
  }) async {
    if (groups.id == null) {
      throw ArgumentError.notNull('groups.id');
    }

    var $groups = groups.copyWith(curatorId: null);
    await session.db.updateRow<Groups>(
      $groups,
      columns: [Groups.t.curatorId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [Groups] and the [Students] set in `groupHead`
  /// by setting the [Groups]'s foreign key `groupHeadId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> groupHead(
    _i1.Session session,
    Groups groups, {
    _i1.Transaction? transaction,
  }) async {
    if (groups.id == null) {
      throw ArgumentError.notNull('groups.id');
    }

    var $groups = groups.copyWith(groupHeadId: null);
    await session.db.updateRow<Groups>(
      $groups,
      columns: [Groups.t.groupHeadId],
      transaction: transaction,
    );
  }
}
