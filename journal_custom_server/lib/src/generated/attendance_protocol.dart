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
import 'classes.dart' as _i2;
import 'students_protocol.dart' as _i3;

abstract class Attendance
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Attendance._({
    this.id,
    required this.classesId,
    this.classes,
    required this.studentsId,
    this.students,
    required this.status,
    this.comment,
  });

  factory Attendance({
    int? id,
    required int classesId,
    _i2.Classes? classes,
    required int studentsId,
    _i3.Students? students,
    required String status,
    String? comment,
  }) = _AttendanceImpl;

  factory Attendance.fromJson(Map<String, dynamic> jsonSerialization) {
    return Attendance(
      id: jsonSerialization['id'] as int?,
      classesId: jsonSerialization['classesId'] as int,
      classes: jsonSerialization['classes'] == null
          ? null
          : _i2.Classes.fromJson(
              (jsonSerialization['classes'] as Map<String, dynamic>)),
      studentsId: jsonSerialization['studentsId'] as int,
      students: jsonSerialization['students'] == null
          ? null
          : _i3.Students.fromJson(
              (jsonSerialization['students'] as Map<String, dynamic>)),
      status: jsonSerialization['status'] as String,
      comment: jsonSerialization['comment'] as String?,
    );
  }

  static final t = AttendanceTable();

  static const db = AttendanceRepository._();

  @override
  int? id;

  int classesId;

  _i2.Classes? classes;

  int studentsId;

  _i3.Students? students;

  String status;

  String? comment;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Attendance]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Attendance copyWith({
    int? id,
    int? classesId,
    _i2.Classes? classes,
    int? studentsId,
    _i3.Students? students,
    String? status,
    String? comment,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'classesId': classesId,
      if (classes != null) 'classes': classes?.toJson(),
      'studentsId': studentsId,
      if (students != null) 'students': students?.toJson(),
      'status': status,
      if (comment != null) 'comment': comment,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'classesId': classesId,
      if (classes != null) 'classes': classes?.toJsonForProtocol(),
      'studentsId': studentsId,
      if (students != null) 'students': students?.toJsonForProtocol(),
      'status': status,
      if (comment != null) 'comment': comment,
    };
  }

  static AttendanceInclude include({
    _i2.ClassesInclude? classes,
    _i3.StudentsInclude? students,
  }) {
    return AttendanceInclude._(
      classes: classes,
      students: students,
    );
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
    required int classesId,
    _i2.Classes? classes,
    required int studentsId,
    _i3.Students? students,
    required String status,
    String? comment,
  }) : super._(
          id: id,
          classesId: classesId,
          classes: classes,
          studentsId: studentsId,
          students: students,
          status: status,
          comment: comment,
        );

  /// Returns a shallow copy of this [Attendance]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Attendance copyWith({
    Object? id = _Undefined,
    int? classesId,
    Object? classes = _Undefined,
    int? studentsId,
    Object? students = _Undefined,
    String? status,
    Object? comment = _Undefined,
  }) {
    return Attendance(
      id: id is int? ? id : this.id,
      classesId: classesId ?? this.classesId,
      classes: classes is _i2.Classes? ? classes : this.classes?.copyWith(),
      studentsId: studentsId ?? this.studentsId,
      students:
          students is _i3.Students? ? students : this.students?.copyWith(),
      status: status ?? this.status,
      comment: comment is String? ? comment : this.comment,
    );
  }
}

class AttendanceTable extends _i1.Table<int?> {
  AttendanceTable({super.tableRelation}) : super(tableName: 'attendance') {
    classesId = _i1.ColumnInt(
      'classesId',
      this,
    );
    studentsId = _i1.ColumnInt(
      'studentsId',
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

  late final _i1.ColumnInt classesId;

  _i2.ClassesTable? _classes;

  late final _i1.ColumnInt studentsId;

  _i3.StudentsTable? _students;

  late final _i1.ColumnString status;

  late final _i1.ColumnString comment;

  _i2.ClassesTable get classes {
    if (_classes != null) return _classes!;
    _classes = _i1.createRelationTable(
      relationFieldName: 'classes',
      field: Attendance.t.classesId,
      foreignField: _i2.Classes.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ClassesTable(tableRelation: foreignTableRelation),
    );
    return _classes!;
  }

  _i3.StudentsTable get students {
    if (_students != null) return _students!;
    _students = _i1.createRelationTable(
      relationFieldName: 'students',
      field: Attendance.t.studentsId,
      foreignField: _i3.Students.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.StudentsTable(tableRelation: foreignTableRelation),
    );
    return _students!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        classesId,
        studentsId,
        status,
        comment,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'classes') {
      return classes;
    }
    if (relationField == 'students') {
      return students;
    }
    return null;
  }
}

class AttendanceInclude extends _i1.IncludeObject {
  AttendanceInclude._({
    _i2.ClassesInclude? classes,
    _i3.StudentsInclude? students,
  }) {
    _classes = classes;
    _students = students;
  }

  _i2.ClassesInclude? _classes;

  _i3.StudentsInclude? _students;

  @override
  Map<String, _i1.Include?> get includes => {
        'classes': _classes,
        'students': _students,
      };

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

  final attachRow = const AttendanceAttachRowRepository._();

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
    AttendanceInclude? include,
  }) async {
    return session.db.find<Attendance>(
      where: where?.call(Attendance.t),
      orderBy: orderBy?.call(Attendance.t),
      orderByList: orderByList?.call(Attendance.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
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
    AttendanceInclude? include,
  }) async {
    return session.db.findFirstRow<Attendance>(
      where: where?.call(Attendance.t),
      orderBy: orderBy?.call(Attendance.t),
      orderByList: orderByList?.call(Attendance.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [Attendance] by its [id] or null if no such row exists.
  Future<Attendance?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    AttendanceInclude? include,
  }) async {
    return session.db.findById<Attendance>(
      id,
      transaction: transaction,
      include: include,
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

class AttendanceAttachRowRepository {
  const AttendanceAttachRowRepository._();

  /// Creates a relation between the given [Attendance] and [Classes]
  /// by setting the [Attendance]'s foreign key `classesId` to refer to the [Classes].
  Future<void> classes(
    _i1.Session session,
    Attendance attendance,
    _i2.Classes classes, {
    _i1.Transaction? transaction,
  }) async {
    if (attendance.id == null) {
      throw ArgumentError.notNull('attendance.id');
    }
    if (classes.id == null) {
      throw ArgumentError.notNull('classes.id');
    }

    var $attendance = attendance.copyWith(classesId: classes.id);
    await session.db.updateRow<Attendance>(
      $attendance,
      columns: [Attendance.t.classesId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [Attendance] and [Students]
  /// by setting the [Attendance]'s foreign key `studentsId` to refer to the [Students].
  Future<void> students(
    _i1.Session session,
    Attendance attendance,
    _i3.Students students, {
    _i1.Transaction? transaction,
  }) async {
    if (attendance.id == null) {
      throw ArgumentError.notNull('attendance.id');
    }
    if (students.id == null) {
      throw ArgumentError.notNull('students.id');
    }

    var $attendance = attendance.copyWith(studentsId: students.id);
    await session.db.updateRow<Attendance>(
      $attendance,
      columns: [Attendance.t.studentsId],
      transaction: transaction,
    );
  }
}
