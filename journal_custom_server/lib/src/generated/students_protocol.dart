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
import 'person.dart' as _i2;
import 'groups_protocol.dart' as _i3;

abstract class Students
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Students._({
    this.id,
    required this.personId,
    this.person,
    required this.groupsId,
    this.groups,
    bool? isGroupHead,
  }) : isGroupHead = isGroupHead ?? false;

  factory Students({
    int? id,
    required int personId,
    _i2.Person? person,
    required int groupsId,
    _i3.Groups? groups,
    bool? isGroupHead,
  }) = _StudentsImpl;

  factory Students.fromJson(Map<String, dynamic> jsonSerialization) {
    return Students(
      id: jsonSerialization['id'] as int?,
      personId: jsonSerialization['personId'] as int,
      person: jsonSerialization['person'] == null
          ? null
          : _i2.Person.fromJson(
              (jsonSerialization['person'] as Map<String, dynamic>)),
      groupsId: jsonSerialization['groupsId'] as int,
      groups: jsonSerialization['groups'] == null
          ? null
          : _i3.Groups.fromJson(
              (jsonSerialization['groups'] as Map<String, dynamic>)),
      isGroupHead: jsonSerialization['isGroupHead'] as bool?,
    );
  }

  static final t = StudentsTable();

  static const db = StudentsRepository._();

  @override
  int? id;

  int personId;

  _i2.Person? person;

  int groupsId;

  _i3.Groups? groups;

  bool? isGroupHead;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Students]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Students copyWith({
    int? id,
    int? personId,
    _i2.Person? person,
    int? groupsId,
    _i3.Groups? groups,
    bool? isGroupHead,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'personId': personId,
      if (person != null) 'person': person?.toJson(),
      'groupsId': groupsId,
      if (groups != null) 'groups': groups?.toJson(),
      if (isGroupHead != null) 'isGroupHead': isGroupHead,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'personId': personId,
      if (person != null) 'person': person?.toJsonForProtocol(),
      'groupsId': groupsId,
      if (groups != null) 'groups': groups?.toJsonForProtocol(),
      if (isGroupHead != null) 'isGroupHead': isGroupHead,
    };
  }

  static StudentsInclude include({
    _i2.PersonInclude? person,
    _i3.GroupsInclude? groups,
  }) {
    return StudentsInclude._(
      person: person,
      groups: groups,
    );
  }

  static StudentsIncludeList includeList({
    _i1.WhereExpressionBuilder<StudentsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<StudentsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StudentsTable>? orderByList,
    StudentsInclude? include,
  }) {
    return StudentsIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Students.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Students.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StudentsImpl extends Students {
  _StudentsImpl({
    int? id,
    required int personId,
    _i2.Person? person,
    required int groupsId,
    _i3.Groups? groups,
    bool? isGroupHead,
  }) : super._(
          id: id,
          personId: personId,
          person: person,
          groupsId: groupsId,
          groups: groups,
          isGroupHead: isGroupHead,
        );

  /// Returns a shallow copy of this [Students]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Students copyWith({
    Object? id = _Undefined,
    int? personId,
    Object? person = _Undefined,
    int? groupsId,
    Object? groups = _Undefined,
    Object? isGroupHead = _Undefined,
  }) {
    return Students(
      id: id is int? ? id : this.id,
      personId: personId ?? this.personId,
      person: person is _i2.Person? ? person : this.person?.copyWith(),
      groupsId: groupsId ?? this.groupsId,
      groups: groups is _i3.Groups? ? groups : this.groups?.copyWith(),
      isGroupHead: isGroupHead is bool? ? isGroupHead : this.isGroupHead,
    );
  }
}

class StudentsTable extends _i1.Table<int?> {
  StudentsTable({super.tableRelation}) : super(tableName: 'students') {
    personId = _i1.ColumnInt(
      'personId',
      this,
    );
    groupsId = _i1.ColumnInt(
      'groupsId',
      this,
    );
    isGroupHead = _i1.ColumnBool(
      'isGroupHead',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnInt personId;

  _i2.PersonTable? _person;

  late final _i1.ColumnInt groupsId;

  _i3.GroupsTable? _groups;

  late final _i1.ColumnBool isGroupHead;

  _i2.PersonTable get person {
    if (_person != null) return _person!;
    _person = _i1.createRelationTable(
      relationFieldName: 'person',
      field: Students.t.personId,
      foreignField: _i2.Person.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.PersonTable(tableRelation: foreignTableRelation),
    );
    return _person!;
  }

  _i3.GroupsTable get groups {
    if (_groups != null) return _groups!;
    _groups = _i1.createRelationTable(
      relationFieldName: 'groups',
      field: Students.t.groupsId,
      foreignField: _i3.Groups.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.GroupsTable(tableRelation: foreignTableRelation),
    );
    return _groups!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        personId,
        groupsId,
        isGroupHead,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'person') {
      return person;
    }
    if (relationField == 'groups') {
      return groups;
    }
    return null;
  }
}

class StudentsInclude extends _i1.IncludeObject {
  StudentsInclude._({
    _i2.PersonInclude? person,
    _i3.GroupsInclude? groups,
  }) {
    _person = person;
    _groups = groups;
  }

  _i2.PersonInclude? _person;

  _i3.GroupsInclude? _groups;

  @override
  Map<String, _i1.Include?> get includes => {
        'person': _person,
        'groups': _groups,
      };

  @override
  _i1.Table<int?> get table => Students.t;
}

class StudentsIncludeList extends _i1.IncludeList {
  StudentsIncludeList._({
    _i1.WhereExpressionBuilder<StudentsTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Students.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Students.t;
}

class StudentsRepository {
  const StudentsRepository._();

  final attachRow = const StudentsAttachRowRepository._();

  /// Returns a list of [Students]s matching the given query parameters.
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
  Future<List<Students>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StudentsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<StudentsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StudentsTable>? orderByList,
    _i1.Transaction? transaction,
    StudentsInclude? include,
  }) async {
    return session.db.find<Students>(
      where: where?.call(Students.t),
      orderBy: orderBy?.call(Students.t),
      orderByList: orderByList?.call(Students.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [Students] matching the given query parameters.
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
  Future<Students?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StudentsTable>? where,
    int? offset,
    _i1.OrderByBuilder<StudentsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StudentsTable>? orderByList,
    _i1.Transaction? transaction,
    StudentsInclude? include,
  }) async {
    return session.db.findFirstRow<Students>(
      where: where?.call(Students.t),
      orderBy: orderBy?.call(Students.t),
      orderByList: orderByList?.call(Students.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [Students] by its [id] or null if no such row exists.
  Future<Students?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    StudentsInclude? include,
  }) async {
    return session.db.findById<Students>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [Students]s in the list and returns the inserted rows.
  ///
  /// The returned [Students]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Students>> insert(
    _i1.Session session,
    List<Students> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Students>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Students] and returns the inserted row.
  ///
  /// The returned [Students] will have its `id` field set.
  Future<Students> insertRow(
    _i1.Session session,
    Students row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Students>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Students]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Students>> update(
    _i1.Session session,
    List<Students> rows, {
    _i1.ColumnSelections<StudentsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Students>(
      rows,
      columns: columns?.call(Students.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Students]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Students> updateRow(
    _i1.Session session,
    Students row, {
    _i1.ColumnSelections<StudentsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Students>(
      row,
      columns: columns?.call(Students.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Students]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Students>> delete(
    _i1.Session session,
    List<Students> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Students>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Students].
  Future<Students> deleteRow(
    _i1.Session session,
    Students row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Students>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Students>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<StudentsTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Students>(
      where: where(Students.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StudentsTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Students>(
      where: where?.call(Students.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class StudentsAttachRowRepository {
  const StudentsAttachRowRepository._();

  /// Creates a relation between the given [Students] and [Person]
  /// by setting the [Students]'s foreign key `personId` to refer to the [Person].
  Future<void> person(
    _i1.Session session,
    Students students,
    _i2.Person person, {
    _i1.Transaction? transaction,
  }) async {
    if (students.id == null) {
      throw ArgumentError.notNull('students.id');
    }
    if (person.id == null) {
      throw ArgumentError.notNull('person.id');
    }

    var $students = students.copyWith(personId: person.id);
    await session.db.updateRow<Students>(
      $students,
      columns: [Students.t.personId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [Students] and [Groups]
  /// by setting the [Students]'s foreign key `groupsId` to refer to the [Groups].
  Future<void> groups(
    _i1.Session session,
    Students students,
    _i3.Groups groups, {
    _i1.Transaction? transaction,
  }) async {
    if (students.id == null) {
      throw ArgumentError.notNull('students.id');
    }
    if (groups.id == null) {
      throw ArgumentError.notNull('groups.id');
    }

    var $students = students.copyWith(groupsId: groups.id);
    await session.db.updateRow<Students>(
      $students,
      columns: [Students.t.groupsId],
      transaction: transaction,
    );
  }
}
