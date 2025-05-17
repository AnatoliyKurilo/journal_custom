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

abstract class Semesters
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Semesters._({
    this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
  });

  factory Semesters({
    int? id,
    required String name,
    required DateTime startDate,
    required DateTime endDate,
  }) = _SemestersImpl;

  factory Semesters.fromJson(Map<String, dynamic> jsonSerialization) {
    return Semesters(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      startDate:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['startDate']),
      endDate: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
    );
  }

  static final t = SemestersTable();

  static const db = SemestersRepository._();

  @override
  int? id;

  String name;

  DateTime startDate;

  DateTime endDate;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Semesters]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Semesters copyWith({
    int? id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'startDate': startDate.toJson(),
      'endDate': endDate.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'startDate': startDate.toJson(),
      'endDate': endDate.toJson(),
    };
  }

  static SemestersInclude include() {
    return SemestersInclude._();
  }

  static SemestersIncludeList includeList({
    _i1.WhereExpressionBuilder<SemestersTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SemestersTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SemestersTable>? orderByList,
    SemestersInclude? include,
  }) {
    return SemestersIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Semesters.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Semesters.t),
      include: include,
    );
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
  }) : super._(
          id: id,
          name: name,
          startDate: startDate,
          endDate: endDate,
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
  }) {
    return Semesters(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

class SemestersTable extends _i1.Table<int?> {
  SemestersTable({super.tableRelation}) : super(tableName: 'semesters') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    startDate = _i1.ColumnDateTime(
      'startDate',
      this,
    );
    endDate = _i1.ColumnDateTime(
      'endDate',
      this,
    );
  }

  late final _i1.ColumnString name;

  late final _i1.ColumnDateTime startDate;

  late final _i1.ColumnDateTime endDate;

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        startDate,
        endDate,
      ];
}

class SemestersInclude extends _i1.IncludeObject {
  SemestersInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Semesters.t;
}

class SemestersIncludeList extends _i1.IncludeList {
  SemestersIncludeList._({
    _i1.WhereExpressionBuilder<SemestersTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Semesters.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Semesters.t;
}

class SemestersRepository {
  const SemestersRepository._();

  /// Returns a list of [Semesters]s matching the given query parameters.
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
  Future<List<Semesters>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SemestersTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SemestersTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SemestersTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Semesters>(
      where: where?.call(Semesters.t),
      orderBy: orderBy?.call(Semesters.t),
      orderByList: orderByList?.call(Semesters.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Semesters] matching the given query parameters.
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
  Future<Semesters?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SemestersTable>? where,
    int? offset,
    _i1.OrderByBuilder<SemestersTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SemestersTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Semesters>(
      where: where?.call(Semesters.t),
      orderBy: orderBy?.call(Semesters.t),
      orderByList: orderByList?.call(Semesters.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Semesters] by its [id] or null if no such row exists.
  Future<Semesters?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Semesters>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Semesters]s in the list and returns the inserted rows.
  ///
  /// The returned [Semesters]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Semesters>> insert(
    _i1.Session session,
    List<Semesters> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Semesters>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Semesters] and returns the inserted row.
  ///
  /// The returned [Semesters] will have its `id` field set.
  Future<Semesters> insertRow(
    _i1.Session session,
    Semesters row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Semesters>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Semesters]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Semesters>> update(
    _i1.Session session,
    List<Semesters> rows, {
    _i1.ColumnSelections<SemestersTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Semesters>(
      rows,
      columns: columns?.call(Semesters.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Semesters]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Semesters> updateRow(
    _i1.Session session,
    Semesters row, {
    _i1.ColumnSelections<SemestersTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Semesters>(
      row,
      columns: columns?.call(Semesters.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Semesters]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Semesters>> delete(
    _i1.Session session,
    List<Semesters> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Semesters>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Semesters].
  Future<Semesters> deleteRow(
    _i1.Session session,
    Semesters row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Semesters>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Semesters>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SemestersTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Semesters>(
      where: where(Semesters.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SemestersTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Semesters>(
      where: where?.call(Semesters.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
