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
import 'students_protocol.dart' as _i2;
import 'subgroups_protocol.dart' as _i3;

abstract class StudentSubgroup
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  StudentSubgroup._({
    this.id,
    required this.studentsId,
    this.students,
    required this.subgroupsId,
    this.subgroups,
  });

  factory StudentSubgroup({
    int? id,
    required int studentsId,
    _i2.Students? students,
    required int subgroupsId,
    _i3.Subgroups? subgroups,
  }) = _StudentSubgroupImpl;

  factory StudentSubgroup.fromJson(Map<String, dynamic> jsonSerialization) {
    return StudentSubgroup(
      id: jsonSerialization['id'] as int?,
      studentsId: jsonSerialization['studentsId'] as int,
      students: jsonSerialization['students'] == null
          ? null
          : _i2.Students.fromJson(
              (jsonSerialization['students'] as Map<String, dynamic>)),
      subgroupsId: jsonSerialization['subgroupsId'] as int,
      subgroups: jsonSerialization['subgroups'] == null
          ? null
          : _i3.Subgroups.fromJson(
              (jsonSerialization['subgroups'] as Map<String, dynamic>)),
    );
  }

  static final t = StudentSubgroupTable();

  static const db = StudentSubgroupRepository._();

  @override
  int? id;

  int studentsId;

  _i2.Students? students;

  int subgroupsId;

  _i3.Subgroups? subgroups;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [StudentSubgroup]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  StudentSubgroup copyWith({
    int? id,
    int? studentsId,
    _i2.Students? students,
    int? subgroupsId,
    _i3.Subgroups? subgroups,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'studentsId': studentsId,
      if (students != null) 'students': students?.toJson(),
      'subgroupsId': subgroupsId,
      if (subgroups != null) 'subgroups': subgroups?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'studentsId': studentsId,
      if (students != null) 'students': students?.toJsonForProtocol(),
      'subgroupsId': subgroupsId,
      if (subgroups != null) 'subgroups': subgroups?.toJsonForProtocol(),
    };
  }

  static StudentSubgroupInclude include({
    _i2.StudentsInclude? students,
    _i3.SubgroupsInclude? subgroups,
  }) {
    return StudentSubgroupInclude._(
      students: students,
      subgroups: subgroups,
    );
  }

  static StudentSubgroupIncludeList includeList({
    _i1.WhereExpressionBuilder<StudentSubgroupTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<StudentSubgroupTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StudentSubgroupTable>? orderByList,
    StudentSubgroupInclude? include,
  }) {
    return StudentSubgroupIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StudentSubgroup.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(StudentSubgroup.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StudentSubgroupImpl extends StudentSubgroup {
  _StudentSubgroupImpl({
    int? id,
    required int studentsId,
    _i2.Students? students,
    required int subgroupsId,
    _i3.Subgroups? subgroups,
  }) : super._(
          id: id,
          studentsId: studentsId,
          students: students,
          subgroupsId: subgroupsId,
          subgroups: subgroups,
        );

  /// Returns a shallow copy of this [StudentSubgroup]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  StudentSubgroup copyWith({
    Object? id = _Undefined,
    int? studentsId,
    Object? students = _Undefined,
    int? subgroupsId,
    Object? subgroups = _Undefined,
  }) {
    return StudentSubgroup(
      id: id is int? ? id : this.id,
      studentsId: studentsId ?? this.studentsId,
      students:
          students is _i2.Students? ? students : this.students?.copyWith(),
      subgroupsId: subgroupsId ?? this.subgroupsId,
      subgroups:
          subgroups is _i3.Subgroups? ? subgroups : this.subgroups?.copyWith(),
    );
  }
}

class StudentSubgroupTable extends _i1.Table<int?> {
  StudentSubgroupTable({super.tableRelation})
      : super(tableName: 'student_subgroups') {
    studentsId = _i1.ColumnInt(
      'studentsId',
      this,
    );
    subgroupsId = _i1.ColumnInt(
      'subgroupsId',
      this,
    );
  }

  late final _i1.ColumnInt studentsId;

  _i2.StudentsTable? _students;

  late final _i1.ColumnInt subgroupsId;

  _i3.SubgroupsTable? _subgroups;

  _i2.StudentsTable get students {
    if (_students != null) return _students!;
    _students = _i1.createRelationTable(
      relationFieldName: 'students',
      field: StudentSubgroup.t.studentsId,
      foreignField: _i2.Students.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.StudentsTable(tableRelation: foreignTableRelation),
    );
    return _students!;
  }

  _i3.SubgroupsTable get subgroups {
    if (_subgroups != null) return _subgroups!;
    _subgroups = _i1.createRelationTable(
      relationFieldName: 'subgroups',
      field: StudentSubgroup.t.subgroupsId,
      foreignField: _i3.Subgroups.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.SubgroupsTable(tableRelation: foreignTableRelation),
    );
    return _subgroups!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        studentsId,
        subgroupsId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'students') {
      return students;
    }
    if (relationField == 'subgroups') {
      return subgroups;
    }
    return null;
  }
}

class StudentSubgroupInclude extends _i1.IncludeObject {
  StudentSubgroupInclude._({
    _i2.StudentsInclude? students,
    _i3.SubgroupsInclude? subgroups,
  }) {
    _students = students;
    _subgroups = subgroups;
  }

  _i2.StudentsInclude? _students;

  _i3.SubgroupsInclude? _subgroups;

  @override
  Map<String, _i1.Include?> get includes => {
        'students': _students,
        'subgroups': _subgroups,
      };

  @override
  _i1.Table<int?> get table => StudentSubgroup.t;
}

class StudentSubgroupIncludeList extends _i1.IncludeList {
  StudentSubgroupIncludeList._({
    _i1.WhereExpressionBuilder<StudentSubgroupTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(StudentSubgroup.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => StudentSubgroup.t;
}

class StudentSubgroupRepository {
  const StudentSubgroupRepository._();

  final attachRow = const StudentSubgroupAttachRowRepository._();

  /// Returns a list of [StudentSubgroup]s matching the given query parameters.
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
  Future<List<StudentSubgroup>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StudentSubgroupTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<StudentSubgroupTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StudentSubgroupTable>? orderByList,
    _i1.Transaction? transaction,
    StudentSubgroupInclude? include,
  }) async {
    return session.db.find<StudentSubgroup>(
      where: where?.call(StudentSubgroup.t),
      orderBy: orderBy?.call(StudentSubgroup.t),
      orderByList: orderByList?.call(StudentSubgroup.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [StudentSubgroup] matching the given query parameters.
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
  Future<StudentSubgroup?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StudentSubgroupTable>? where,
    int? offset,
    _i1.OrderByBuilder<StudentSubgroupTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StudentSubgroupTable>? orderByList,
    _i1.Transaction? transaction,
    StudentSubgroupInclude? include,
  }) async {
    return session.db.findFirstRow<StudentSubgroup>(
      where: where?.call(StudentSubgroup.t),
      orderBy: orderBy?.call(StudentSubgroup.t),
      orderByList: orderByList?.call(StudentSubgroup.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [StudentSubgroup] by its [id] or null if no such row exists.
  Future<StudentSubgroup?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    StudentSubgroupInclude? include,
  }) async {
    return session.db.findById<StudentSubgroup>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [StudentSubgroup]s in the list and returns the inserted rows.
  ///
  /// The returned [StudentSubgroup]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<StudentSubgroup>> insert(
    _i1.Session session,
    List<StudentSubgroup> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<StudentSubgroup>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [StudentSubgroup] and returns the inserted row.
  ///
  /// The returned [StudentSubgroup] will have its `id` field set.
  Future<StudentSubgroup> insertRow(
    _i1.Session session,
    StudentSubgroup row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<StudentSubgroup>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [StudentSubgroup]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<StudentSubgroup>> update(
    _i1.Session session,
    List<StudentSubgroup> rows, {
    _i1.ColumnSelections<StudentSubgroupTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<StudentSubgroup>(
      rows,
      columns: columns?.call(StudentSubgroup.t),
      transaction: transaction,
    );
  }

  /// Updates a single [StudentSubgroup]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<StudentSubgroup> updateRow(
    _i1.Session session,
    StudentSubgroup row, {
    _i1.ColumnSelections<StudentSubgroupTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<StudentSubgroup>(
      row,
      columns: columns?.call(StudentSubgroup.t),
      transaction: transaction,
    );
  }

  /// Deletes all [StudentSubgroup]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<StudentSubgroup>> delete(
    _i1.Session session,
    List<StudentSubgroup> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<StudentSubgroup>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [StudentSubgroup].
  Future<StudentSubgroup> deleteRow(
    _i1.Session session,
    StudentSubgroup row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<StudentSubgroup>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<StudentSubgroup>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<StudentSubgroupTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<StudentSubgroup>(
      where: where(StudentSubgroup.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StudentSubgroupTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<StudentSubgroup>(
      where: where?.call(StudentSubgroup.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class StudentSubgroupAttachRowRepository {
  const StudentSubgroupAttachRowRepository._();

  /// Creates a relation between the given [StudentSubgroup] and [Students]
  /// by setting the [StudentSubgroup]'s foreign key `studentsId` to refer to the [Students].
  Future<void> students(
    _i1.Session session,
    StudentSubgroup studentSubgroup,
    _i2.Students students, {
    _i1.Transaction? transaction,
  }) async {
    if (studentSubgroup.id == null) {
      throw ArgumentError.notNull('studentSubgroup.id');
    }
    if (students.id == null) {
      throw ArgumentError.notNull('students.id');
    }

    var $studentSubgroup = studentSubgroup.copyWith(studentsId: students.id);
    await session.db.updateRow<StudentSubgroup>(
      $studentSubgroup,
      columns: [StudentSubgroup.t.studentsId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [StudentSubgroup] and [Subgroups]
  /// by setting the [StudentSubgroup]'s foreign key `subgroupsId` to refer to the [Subgroups].
  Future<void> subgroups(
    _i1.Session session,
    StudentSubgroup studentSubgroup,
    _i3.Subgroups subgroups, {
    _i1.Transaction? transaction,
  }) async {
    if (studentSubgroup.id == null) {
      throw ArgumentError.notNull('studentSubgroup.id');
    }
    if (subgroups.id == null) {
      throw ArgumentError.notNull('subgroups.id');
    }

    var $studentSubgroup = studentSubgroup.copyWith(subgroupsId: subgroups.id);
    await session.db.updateRow<StudentSubgroup>(
      $studentSubgroup,
      columns: [StudentSubgroup.t.subgroupsId],
      transaction: transaction,
    );
  }
}
