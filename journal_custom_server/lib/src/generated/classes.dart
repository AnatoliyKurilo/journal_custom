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

abstract class Classes
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = ClassesTable();

  static const db = ClassesRepository._();

  @override
  int? id;

  int subjectId;

  int typeId;

  int teacherId;

  int semesterId;

  int? subgroupId;

  DateTime date;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static ClassesInclude include() {
    return ClassesInclude._();
  }

  static ClassesIncludeList includeList({
    _i1.WhereExpressionBuilder<ClassesTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ClassesTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ClassesTable>? orderByList,
    ClassesInclude? include,
  }) {
    return ClassesIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Classes.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Classes.t),
      include: include,
    );
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

class ClassesTable extends _i1.Table<int?> {
  ClassesTable({super.tableRelation}) : super(tableName: 'classes') {
    subjectId = _i1.ColumnInt(
      'subjectId',
      this,
    );
    typeId = _i1.ColumnInt(
      'typeId',
      this,
    );
    teacherId = _i1.ColumnInt(
      'teacherId',
      this,
    );
    semesterId = _i1.ColumnInt(
      'semesterId',
      this,
    );
    subgroupId = _i1.ColumnInt(
      'subgroupId',
      this,
    );
    date = _i1.ColumnDateTime(
      'date',
      this,
    );
  }

  late final _i1.ColumnInt subjectId;

  late final _i1.ColumnInt typeId;

  late final _i1.ColumnInt teacherId;

  late final _i1.ColumnInt semesterId;

  late final _i1.ColumnInt subgroupId;

  late final _i1.ColumnDateTime date;

  @override
  List<_i1.Column> get columns => [
        id,
        subjectId,
        typeId,
        teacherId,
        semesterId,
        subgroupId,
        date,
      ];
}

class ClassesInclude extends _i1.IncludeObject {
  ClassesInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Classes.t;
}

class ClassesIncludeList extends _i1.IncludeList {
  ClassesIncludeList._({
    _i1.WhereExpressionBuilder<ClassesTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Classes.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Classes.t;
}

class ClassesRepository {
  const ClassesRepository._();

  /// Returns a list of [Classes]s matching the given query parameters.
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
  Future<List<Classes>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ClassesTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ClassesTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ClassesTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Classes>(
      where: where?.call(Classes.t),
      orderBy: orderBy?.call(Classes.t),
      orderByList: orderByList?.call(Classes.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Classes] matching the given query parameters.
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
  Future<Classes?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ClassesTable>? where,
    int? offset,
    _i1.OrderByBuilder<ClassesTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ClassesTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Classes>(
      where: where?.call(Classes.t),
      orderBy: orderBy?.call(Classes.t),
      orderByList: orderByList?.call(Classes.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Classes] by its [id] or null if no such row exists.
  Future<Classes?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Classes>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Classes]s in the list and returns the inserted rows.
  ///
  /// The returned [Classes]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Classes>> insert(
    _i1.Session session,
    List<Classes> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Classes>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Classes] and returns the inserted row.
  ///
  /// The returned [Classes] will have its `id` field set.
  Future<Classes> insertRow(
    _i1.Session session,
    Classes row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Classes>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Classes]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Classes>> update(
    _i1.Session session,
    List<Classes> rows, {
    _i1.ColumnSelections<ClassesTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Classes>(
      rows,
      columns: columns?.call(Classes.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Classes]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Classes> updateRow(
    _i1.Session session,
    Classes row, {
    _i1.ColumnSelections<ClassesTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Classes>(
      row,
      columns: columns?.call(Classes.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Classes]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Classes>> delete(
    _i1.Session session,
    List<Classes> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Classes>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Classes].
  Future<Classes> deleteRow(
    _i1.Session session,
    Classes row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Classes>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Classes>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ClassesTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Classes>(
      where: where(Classes.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ClassesTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Classes>(
      where: where?.call(Classes.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
