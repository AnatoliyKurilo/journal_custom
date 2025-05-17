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

abstract class Attendance
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Attendance._({
    this.id,
    required this.classId,
    required this.studentId,
    required this.status,
    this.comment,
  });

  factory Attendance({
    int? id,
    required int classId,
    required int studentId,
    required String status,
    String? comment,
  }) = _AttendanceImpl;

  factory Attendance.fromJson(Map<String, dynamic> jsonSerialization) {
    return Attendance(
      id: jsonSerialization['id'] as int?,
      classId: jsonSerialization['classId'] as int,
      studentId: jsonSerialization['studentId'] as int,
      status: jsonSerialization['status'] as String,
      comment: jsonSerialization['comment'] as String?,
    );
  }

  static final t = AttendanceTable();

  static const db = AttendanceRepository._();

  @override
  int? id;

  int classId;

  int studentId;

  String status;

  String? comment;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Attendance]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Attendance copyWith({
    int? id,
    int? classId,
    int? studentId,
    String? status,
    String? comment,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'classId': classId,
      'studentId': studentId,
      'status': status,
      if (comment != null) 'comment': comment,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'classId': classId,
      'studentId': studentId,
      'status': status,
      if (comment != null) 'comment': comment,
    };
  }

  static AttendanceInclude include() {
    return AttendanceInclude._();
  }

  static AttendanceIncludeList includeList({
    _i1.WhereExpressionBuilder<AttendanceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AttendanceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AttendanceTable>? orderByList,
    AttendanceInclude? include,
  }) {
    return AttendanceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Attendance.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Attendance.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AttendanceImpl extends Attendance {
  _AttendanceImpl({
    int? id,
    required int classId,
    required int studentId,
    required String status,
    String? comment,
  }) : super._(
          id: id,
          classId: classId,
          studentId: studentId,
          status: status,
          comment: comment,
        );

  /// Returns a shallow copy of this [Attendance]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Attendance copyWith({
    Object? id = _Undefined,
    int? classId,
    int? studentId,
    String? status,
    Object? comment = _Undefined,
  }) {
    return Attendance(
      id: id is int? ? id : this.id,
      classId: classId ?? this.classId,
      studentId: studentId ?? this.studentId,
      status: status ?? this.status,
      comment: comment is String? ? comment : this.comment,
    );
  }
}

class AttendanceTable extends _i1.Table<int?> {
  AttendanceTable({super.tableRelation}) : super(tableName: 'attendance') {
    classId = _i1.ColumnInt(
      'classId',
      this,
    );
    studentId = _i1.ColumnInt(
      'studentId',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    comment = _i1.ColumnString(
      'comment',
      this,
    );
  }

  late final _i1.ColumnInt classId;

  late final _i1.ColumnInt studentId;

  late final _i1.ColumnString status;

  late final _i1.ColumnString comment;

  @override
  List<_i1.Column> get columns => [
        id,
        classId,
        studentId,
        status,
        comment,
      ];
}

class AttendanceInclude extends _i1.IncludeObject {
  AttendanceInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Attendance.t;
}

class AttendanceIncludeList extends _i1.IncludeList {
  AttendanceIncludeList._({
    _i1.WhereExpressionBuilder<AttendanceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Attendance.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Attendance.t;
}

class AttendanceRepository {
  const AttendanceRepository._();

  /// Returns a list of [Attendance]s matching the given query parameters.
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
  Future<List<Attendance>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AttendanceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AttendanceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AttendanceTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Attendance>(
      where: where?.call(Attendance.t),
      orderBy: orderBy?.call(Attendance.t),
      orderByList: orderByList?.call(Attendance.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Attendance] matching the given query parameters.
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
  Future<Attendance?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AttendanceTable>? where,
    int? offset,
    _i1.OrderByBuilder<AttendanceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AttendanceTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Attendance>(
      where: where?.call(Attendance.t),
      orderBy: orderBy?.call(Attendance.t),
      orderByList: orderByList?.call(Attendance.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Attendance] by its [id] or null if no such row exists.
  Future<Attendance?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Attendance>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Attendance]s in the list and returns the inserted rows.
  ///
  /// The returned [Attendance]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Attendance>> insert(
    _i1.Session session,
    List<Attendance> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Attendance>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Attendance] and returns the inserted row.
  ///
  /// The returned [Attendance] will have its `id` field set.
  Future<Attendance> insertRow(
    _i1.Session session,
    Attendance row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Attendance>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Attendance]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Attendance>> update(
    _i1.Session session,
    List<Attendance> rows, {
    _i1.ColumnSelections<AttendanceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Attendance>(
      rows,
      columns: columns?.call(Attendance.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Attendance]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Attendance> updateRow(
    _i1.Session session,
    Attendance row, {
    _i1.ColumnSelections<AttendanceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Attendance>(
      row,
      columns: columns?.call(Attendance.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Attendance]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Attendance>> delete(
    _i1.Session session,
    List<Attendance> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Attendance>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Attendance].
  Future<Attendance> deleteRow(
    _i1.Session session,
    Attendance row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Attendance>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Attendance>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AttendanceTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Attendance>(
      where: where(Attendance.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AttendanceTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Attendance>(
      where: where?.call(Attendance.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
