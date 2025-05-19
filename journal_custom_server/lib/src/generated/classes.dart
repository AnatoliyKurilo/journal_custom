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
import 'subjects_protocol.dart' as _i2;
import 'class_types_protocol.dart' as _i3;
import 'teachers_protocol.dart' as _i4;
import 'semesters_protocol.dart' as _i5;
import 'subgroups_protocol.dart' as _i6;

abstract class Classes
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Classes._({
    this.id,
    required this.subjectId,
    required this.subjectsId,
    this.subjects,
    required this.class_typesId,
    this.class_types,
    required this.teachersId,
    this.teachers,
    required this.semestersId,
    this.semesters,
    required this.subgroupsId,
    this.subgroups,
    required this.date,
  });

  factory Classes({
    int? id,
    required int subjectId,
    required int subjectsId,
    _i2.Subjects? subjects,
    required int class_typesId,
    _i3.ClassTypes? class_types,
    required int teachersId,
    _i4.Teachers? teachers,
    required int semestersId,
    _i5.Semesters? semesters,
    required int subgroupsId,
    _i6.Subgroups? subgroups,
    required DateTime date,
  }) = _ClassesImpl;

  factory Classes.fromJson(Map<String, dynamic> jsonSerialization) {
    return Classes(
      id: jsonSerialization['id'] as int?,
      subjectId: jsonSerialization['subjectId'] as int,
      subjectsId: jsonSerialization['subjectsId'] as int,
      subjects: jsonSerialization['subjects'] == null
          ? null
          : _i2.Subjects.fromJson(
              (jsonSerialization['subjects'] as Map<String, dynamic>)),
      class_typesId: jsonSerialization['class_typesId'] as int,
      class_types: jsonSerialization['class_types'] == null
          ? null
          : _i3.ClassTypes.fromJson(
              (jsonSerialization['class_types'] as Map<String, dynamic>)),
      teachersId: jsonSerialization['teachersId'] as int,
      teachers: jsonSerialization['teachers'] == null
          ? null
          : _i4.Teachers.fromJson(
              (jsonSerialization['teachers'] as Map<String, dynamic>)),
      semestersId: jsonSerialization['semestersId'] as int,
      semesters: jsonSerialization['semesters'] == null
          ? null
          : _i5.Semesters.fromJson(
              (jsonSerialization['semesters'] as Map<String, dynamic>)),
      subgroupsId: jsonSerialization['subgroupsId'] as int,
      subgroups: jsonSerialization['subgroups'] == null
          ? null
          : _i6.Subgroups.fromJson(
              (jsonSerialization['subgroups'] as Map<String, dynamic>)),
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
    );
  }

  static final t = ClassesTable();

  static const db = ClassesRepository._();

  @override
  int? id;

  int subjectId;

  int subjectsId;

  _i2.Subjects? subjects;

  int class_typesId;

  _i3.ClassTypes? class_types;

  int teachersId;

  _i4.Teachers? teachers;

  int semestersId;

  _i5.Semesters? semesters;

  int subgroupsId;

  _i6.Subgroups? subgroups;

  DateTime date;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Classes]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Classes copyWith({
    int? id,
    int? subjectId,
    int? subjectsId,
    _i2.Subjects? subjects,
    int? class_typesId,
    _i3.ClassTypes? class_types,
    int? teachersId,
    _i4.Teachers? teachers,
    int? semestersId,
    _i5.Semesters? semesters,
    int? subgroupsId,
    _i6.Subgroups? subgroups,
    DateTime? date,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'subjectId': subjectId,
      'subjectsId': subjectsId,
      if (subjects != null) 'subjects': subjects?.toJson(),
      'class_typesId': class_typesId,
      if (class_types != null) 'class_types': class_types?.toJson(),
      'teachersId': teachersId,
      if (teachers != null) 'teachers': teachers?.toJson(),
      'semestersId': semestersId,
      if (semesters != null) 'semesters': semesters?.toJson(),
      'subgroupsId': subgroupsId,
      if (subgroups != null) 'subgroups': subgroups?.toJson(),
      'date': date.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'subjectId': subjectId,
      'subjectsId': subjectsId,
      if (subjects != null) 'subjects': subjects?.toJsonForProtocol(),
      'class_typesId': class_typesId,
      if (class_types != null) 'class_types': class_types?.toJsonForProtocol(),
      'teachersId': teachersId,
      if (teachers != null) 'teachers': teachers?.toJsonForProtocol(),
      'semestersId': semestersId,
      if (semesters != null) 'semesters': semesters?.toJsonForProtocol(),
      'subgroupsId': subgroupsId,
      if (subgroups != null) 'subgroups': subgroups?.toJsonForProtocol(),
      'date': date.toJson(),
    };
  }

  static ClassesInclude include({
    _i2.SubjectsInclude? subjects,
    _i3.ClassTypesInclude? class_types,
    _i4.TeachersInclude? teachers,
    _i5.SemestersInclude? semesters,
    _i6.SubgroupsInclude? subgroups,
  }) {
    return ClassesInclude._(
      subjects: subjects,
      class_types: class_types,
      teachers: teachers,
      semesters: semesters,
      subgroups: subgroups,
    );
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
    required int subjectsId,
    _i2.Subjects? subjects,
    required int class_typesId,
    _i3.ClassTypes? class_types,
    required int teachersId,
    _i4.Teachers? teachers,
    required int semestersId,
    _i5.Semesters? semesters,
    required int subgroupsId,
    _i6.Subgroups? subgroups,
    required DateTime date,
  }) : super._(
          id: id,
          subjectId: subjectId,
          subjectsId: subjectsId,
          subjects: subjects,
          class_typesId: class_typesId,
          class_types: class_types,
          teachersId: teachersId,
          teachers: teachers,
          semestersId: semestersId,
          semesters: semesters,
          subgroupsId: subgroupsId,
          subgroups: subgroups,
          date: date,
        );

  /// Returns a shallow copy of this [Classes]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Classes copyWith({
    Object? id = _Undefined,
    int? subjectId,
    int? subjectsId,
    Object? subjects = _Undefined,
    int? class_typesId,
    Object? class_types = _Undefined,
    int? teachersId,
    Object? teachers = _Undefined,
    int? semestersId,
    Object? semesters = _Undefined,
    int? subgroupsId,
    Object? subgroups = _Undefined,
    DateTime? date,
  }) {
    return Classes(
      id: id is int? ? id : this.id,
      subjectId: subjectId ?? this.subjectId,
      subjectsId: subjectsId ?? this.subjectsId,
      subjects:
          subjects is _i2.Subjects? ? subjects : this.subjects?.copyWith(),
      class_typesId: class_typesId ?? this.class_typesId,
      class_types: class_types is _i3.ClassTypes?
          ? class_types
          : this.class_types?.copyWith(),
      teachersId: teachersId ?? this.teachersId,
      teachers:
          teachers is _i4.Teachers? ? teachers : this.teachers?.copyWith(),
      semestersId: semestersId ?? this.semestersId,
      semesters:
          semesters is _i5.Semesters? ? semesters : this.semesters?.copyWith(),
      subgroupsId: subgroupsId ?? this.subgroupsId,
      subgroups:
          subgroups is _i6.Subgroups? ? subgroups : this.subgroups?.copyWith(),
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
    subjectsId = _i1.ColumnInt(
      'subjectsId',
      this,
    );
    class_typesId = _i1.ColumnInt(
      'class_typesId',
      this,
    );
    teachersId = _i1.ColumnInt(
      'teachersId',
      this,
    );
    semestersId = _i1.ColumnInt(
      'semestersId',
      this,
    );
    subgroupsId = _i1.ColumnInt(
      'subgroupsId',
      this,
    );
    date = _i1.ColumnDateTime(
      'date',
      this,
    );
  }

  late final _i1.ColumnInt subjectId;

  late final _i1.ColumnInt subjectsId;

  _i2.SubjectsTable? _subjects;

  late final _i1.ColumnInt class_typesId;

  _i3.ClassTypesTable? _class_types;

  late final _i1.ColumnInt teachersId;

  _i4.TeachersTable? _teachers;

  late final _i1.ColumnInt semestersId;

  _i5.SemestersTable? _semesters;

  late final _i1.ColumnInt subgroupsId;

  _i6.SubgroupsTable? _subgroups;

  late final _i1.ColumnDateTime date;

  _i2.SubjectsTable get subjects {
    if (_subjects != null) return _subjects!;
    _subjects = _i1.createRelationTable(
      relationFieldName: 'subjects',
      field: Classes.t.subjectsId,
      foreignField: _i2.Subjects.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.SubjectsTable(tableRelation: foreignTableRelation),
    );
    return _subjects!;
  }

  _i3.ClassTypesTable get class_types {
    if (_class_types != null) return _class_types!;
    _class_types = _i1.createRelationTable(
      relationFieldName: 'class_types',
      field: Classes.t.class_typesId,
      foreignField: _i3.ClassTypes.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.ClassTypesTable(tableRelation: foreignTableRelation),
    );
    return _class_types!;
  }

  _i4.TeachersTable get teachers {
    if (_teachers != null) return _teachers!;
    _teachers = _i1.createRelationTable(
      relationFieldName: 'teachers',
      field: Classes.t.teachersId,
      foreignField: _i4.Teachers.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4.TeachersTable(tableRelation: foreignTableRelation),
    );
    return _teachers!;
  }

  _i5.SemestersTable get semesters {
    if (_semesters != null) return _semesters!;
    _semesters = _i1.createRelationTable(
      relationFieldName: 'semesters',
      field: Classes.t.semestersId,
      foreignField: _i5.Semesters.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i5.SemestersTable(tableRelation: foreignTableRelation),
    );
    return _semesters!;
  }

  _i6.SubgroupsTable get subgroups {
    if (_subgroups != null) return _subgroups!;
    _subgroups = _i1.createRelationTable(
      relationFieldName: 'subgroups',
      field: Classes.t.subgroupsId,
      foreignField: _i6.Subgroups.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i6.SubgroupsTable(tableRelation: foreignTableRelation),
    );
    return _subgroups!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        subjectId,
        subjectsId,
        class_typesId,
        teachersId,
        semestersId,
        subgroupsId,
        date,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'subjects') {
      return subjects;
    }
    if (relationField == 'class_types') {
      return class_types;
    }
    if (relationField == 'teachers') {
      return teachers;
    }
    if (relationField == 'semesters') {
      return semesters;
    }
    if (relationField == 'subgroups') {
      return subgroups;
    }
    return null;
  }
}

class ClassesInclude extends _i1.IncludeObject {
  ClassesInclude._({
    _i2.SubjectsInclude? subjects,
    _i3.ClassTypesInclude? class_types,
    _i4.TeachersInclude? teachers,
    _i5.SemestersInclude? semesters,
    _i6.SubgroupsInclude? subgroups,
  }) {
    _subjects = subjects;
    _class_types = class_types;
    _teachers = teachers;
    _semesters = semesters;
    _subgroups = subgroups;
  }

  _i2.SubjectsInclude? _subjects;

  _i3.ClassTypesInclude? _class_types;

  _i4.TeachersInclude? _teachers;

  _i5.SemestersInclude? _semesters;

  _i6.SubgroupsInclude? _subgroups;

  @override
  Map<String, _i1.Include?> get includes => {
        'subjects': _subjects,
        'class_types': _class_types,
        'teachers': _teachers,
        'semesters': _semesters,
        'subgroups': _subgroups,
      };

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

  final attachRow = const ClassesAttachRowRepository._();

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
    ClassesInclude? include,
  }) async {
    return session.db.find<Classes>(
      where: where?.call(Classes.t),
      orderBy: orderBy?.call(Classes.t),
      orderByList: orderByList?.call(Classes.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
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
    ClassesInclude? include,
  }) async {
    return session.db.findFirstRow<Classes>(
      where: where?.call(Classes.t),
      orderBy: orderBy?.call(Classes.t),
      orderByList: orderByList?.call(Classes.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [Classes] by its [id] or null if no such row exists.
  Future<Classes?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    ClassesInclude? include,
  }) async {
    return session.db.findById<Classes>(
      id,
      transaction: transaction,
      include: include,
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

class ClassesAttachRowRepository {
  const ClassesAttachRowRepository._();

  /// Creates a relation between the given [Classes] and [Subjects]
  /// by setting the [Classes]'s foreign key `subjectsId` to refer to the [Subjects].
  Future<void> subjects(
    _i1.Session session,
    Classes classes,
    _i2.Subjects subjects, {
    _i1.Transaction? transaction,
  }) async {
    if (classes.id == null) {
      throw ArgumentError.notNull('classes.id');
    }
    if (subjects.id == null) {
      throw ArgumentError.notNull('subjects.id');
    }

    var $classes = classes.copyWith(subjectsId: subjects.id);
    await session.db.updateRow<Classes>(
      $classes,
      columns: [Classes.t.subjectsId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [Classes] and [ClassTypes]
  /// by setting the [Classes]'s foreign key `class_typesId` to refer to the [ClassTypes].
  Future<void> class_types(
    _i1.Session session,
    Classes classes,
    _i3.ClassTypes class_types, {
    _i1.Transaction? transaction,
  }) async {
    if (classes.id == null) {
      throw ArgumentError.notNull('classes.id');
    }
    if (class_types.id == null) {
      throw ArgumentError.notNull('class_types.id');
    }

    var $classes = classes.copyWith(class_typesId: class_types.id);
    await session.db.updateRow<Classes>(
      $classes,
      columns: [Classes.t.class_typesId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [Classes] and [Teachers]
  /// by setting the [Classes]'s foreign key `teachersId` to refer to the [Teachers].
  Future<void> teachers(
    _i1.Session session,
    Classes classes,
    _i4.Teachers teachers, {
    _i1.Transaction? transaction,
  }) async {
    if (classes.id == null) {
      throw ArgumentError.notNull('classes.id');
    }
    if (teachers.id == null) {
      throw ArgumentError.notNull('teachers.id');
    }

    var $classes = classes.copyWith(teachersId: teachers.id);
    await session.db.updateRow<Classes>(
      $classes,
      columns: [Classes.t.teachersId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [Classes] and [Semesters]
  /// by setting the [Classes]'s foreign key `semestersId` to refer to the [Semesters].
  Future<void> semesters(
    _i1.Session session,
    Classes classes,
    _i5.Semesters semesters, {
    _i1.Transaction? transaction,
  }) async {
    if (classes.id == null) {
      throw ArgumentError.notNull('classes.id');
    }
    if (semesters.id == null) {
      throw ArgumentError.notNull('semesters.id');
    }

    var $classes = classes.copyWith(semestersId: semesters.id);
    await session.db.updateRow<Classes>(
      $classes,
      columns: [Classes.t.semestersId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [Classes] and [Subgroups]
  /// by setting the [Classes]'s foreign key `subgroupsId` to refer to the [Subgroups].
  Future<void> subgroups(
    _i1.Session session,
    Classes classes,
    _i6.Subgroups subgroups, {
    _i1.Transaction? transaction,
  }) async {
    if (classes.id == null) {
      throw ArgumentError.notNull('classes.id');
    }
    if (subgroups.id == null) {
      throw ArgumentError.notNull('subgroups.id');
    }

    var $classes = classes.copyWith(subgroupsId: subgroups.id);
    await session.db.updateRow<Classes>(
      $classes,
      columns: [Classes.t.subgroupsId],
      transaction: transaction,
    );
  }
}
