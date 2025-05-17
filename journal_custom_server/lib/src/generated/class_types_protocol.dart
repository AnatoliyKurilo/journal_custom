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

abstract class ClassTypes
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ClassTypes._({
    this.id,
    required this.name,
  });

  factory ClassTypes({
    int? id,
    required String name,
  }) = _ClassTypesImpl;

  factory ClassTypes.fromJson(Map<String, dynamic> jsonSerialization) {
    return ClassTypes(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
    );
  }

  static final t = ClassTypesTable();

  static const db = ClassTypesRepository._();

  @override
  int? id;

  String name;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ClassTypes]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ClassTypes copyWith({
    int? id,
    String? name,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
    };
  }

  static ClassTypesInclude include() {
    return ClassTypesInclude._();
  }

  static ClassTypesIncludeList includeList({
    _i1.WhereExpressionBuilder<ClassTypesTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ClassTypesTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ClassTypesTable>? orderByList,
    ClassTypesInclude? include,
  }) {
    return ClassTypesIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ClassTypes.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ClassTypes.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ClassTypesImpl extends ClassTypes {
  _ClassTypesImpl({
    int? id,
    required String name,
  }) : super._(
          id: id,
          name: name,
        );

  /// Returns a shallow copy of this [ClassTypes]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ClassTypes copyWith({
    Object? id = _Undefined,
    String? name,
  }) {
    return ClassTypes(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
    );
  }
}

class ClassTypesTable extends _i1.Table<int?> {
  ClassTypesTable({super.tableRelation}) : super(tableName: 'class_types') {
    name = _i1.ColumnString(
      'name',
      this,
    );
  }

  late final _i1.ColumnString name;

  @override
  List<_i1.Column> get columns => [
        id,
        name,
      ];
}

class ClassTypesInclude extends _i1.IncludeObject {
  ClassTypesInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ClassTypes.t;
}

class ClassTypesIncludeList extends _i1.IncludeList {
  ClassTypesIncludeList._({
    _i1.WhereExpressionBuilder<ClassTypesTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ClassTypes.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ClassTypes.t;
}

class ClassTypesRepository {
  const ClassTypesRepository._();

  /// Returns a list of [ClassTypes]s matching the given query parameters.
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
  Future<List<ClassTypes>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ClassTypesTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ClassTypesTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ClassTypesTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ClassTypes>(
      where: where?.call(ClassTypes.t),
      orderBy: orderBy?.call(ClassTypes.t),
      orderByList: orderByList?.call(ClassTypes.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ClassTypes] matching the given query parameters.
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
  Future<ClassTypes?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ClassTypesTable>? where,
    int? offset,
    _i1.OrderByBuilder<ClassTypesTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ClassTypesTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ClassTypes>(
      where: where?.call(ClassTypes.t),
      orderBy: orderBy?.call(ClassTypes.t),
      orderByList: orderByList?.call(ClassTypes.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ClassTypes] by its [id] or null if no such row exists.
  Future<ClassTypes?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ClassTypes>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ClassTypes]s in the list and returns the inserted rows.
  ///
  /// The returned [ClassTypes]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ClassTypes>> insert(
    _i1.Session session,
    List<ClassTypes> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ClassTypes>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ClassTypes] and returns the inserted row.
  ///
  /// The returned [ClassTypes] will have its `id` field set.
  Future<ClassTypes> insertRow(
    _i1.Session session,
    ClassTypes row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ClassTypes>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ClassTypes]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ClassTypes>> update(
    _i1.Session session,
    List<ClassTypes> rows, {
    _i1.ColumnSelections<ClassTypesTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ClassTypes>(
      rows,
      columns: columns?.call(ClassTypes.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ClassTypes]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ClassTypes> updateRow(
    _i1.Session session,
    ClassTypes row, {
    _i1.ColumnSelections<ClassTypesTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ClassTypes>(
      row,
      columns: columns?.call(ClassTypes.t),
      transaction: transaction,
    );
  }

  /// Deletes all [ClassTypes]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ClassTypes>> delete(
    _i1.Session session,
    List<ClassTypes> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ClassTypes>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ClassTypes].
  Future<ClassTypes> deleteRow(
    _i1.Session session,
    ClassTypes row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ClassTypes>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ClassTypes>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ClassTypesTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ClassTypes>(
      where: where(ClassTypes.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ClassTypesTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ClassTypes>(
      where: where?.call(ClassTypes.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
