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

abstract class Teachers
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Teachers._({
    this.id,
    required this.personId,
    this.person,
  });

  factory Teachers({
    int? id,
    required int personId,
    _i2.Person? person,
  }) = _TeachersImpl;

  factory Teachers.fromJson(Map<String, dynamic> jsonSerialization) {
    return Teachers(
      id: jsonSerialization['id'] as int?,
      personId: jsonSerialization['personId'] as int,
      person: jsonSerialization['person'] == null
          ? null
          : _i2.Person.fromJson(
              (jsonSerialization['person'] as Map<String, dynamic>)),
    );
  }

  static final t = TeachersTable();

  static const db = TeachersRepository._();

  @override
  int? id;

  int personId;

  _i2.Person? person;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Teachers]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Teachers copyWith({
    int? id,
    int? personId,
    _i2.Person? person,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'personId': personId,
      if (person != null) 'person': person?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'personId': personId,
      if (person != null) 'person': person?.toJsonForProtocol(),
    };
  }

  static TeachersInclude include({_i2.PersonInclude? person}) {
    return TeachersInclude._(person: person);
  }

  static TeachersIncludeList includeList({
    _i1.WhereExpressionBuilder<TeachersTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TeachersTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TeachersTable>? orderByList,
    TeachersInclude? include,
  }) {
    return TeachersIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Teachers.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Teachers.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TeachersImpl extends Teachers {
  _TeachersImpl({
    int? id,
    required int personId,
    _i2.Person? person,
  }) : super._(
          id: id,
          personId: personId,
          person: person,
        );

  /// Returns a shallow copy of this [Teachers]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Teachers copyWith({
    Object? id = _Undefined,
    int? personId,
    Object? person = _Undefined,
  }) {
    return Teachers(
      id: id is int? ? id : this.id,
      personId: personId ?? this.personId,
      person: person is _i2.Person? ? person : this.person?.copyWith(),
    );
  }
}

class TeachersTable extends _i1.Table<int?> {
  TeachersTable({super.tableRelation}) : super(tableName: 'teachers') {
    personId = _i1.ColumnInt(
      'personId',
      this,
    );
  }

  late final _i1.ColumnInt personId;

  _i2.PersonTable? _person;

  _i2.PersonTable get person {
    if (_person != null) return _person!;
    _person = _i1.createRelationTable(
      relationFieldName: 'person',
      field: Teachers.t.personId,
      foreignField: _i2.Person.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.PersonTable(tableRelation: foreignTableRelation),
    );
    return _person!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        personId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'person') {
      return person;
    }
    return null;
  }
}

class TeachersInclude extends _i1.IncludeObject {
  TeachersInclude._({_i2.PersonInclude? person}) {
    _person = person;
  }

  _i2.PersonInclude? _person;

  @override
  Map<String, _i1.Include?> get includes => {'person': _person};

  @override
  _i1.Table<int?> get table => Teachers.t;
}

class TeachersIncludeList extends _i1.IncludeList {
  TeachersIncludeList._({
    _i1.WhereExpressionBuilder<TeachersTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Teachers.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Teachers.t;
}

class TeachersRepository {
  const TeachersRepository._();

  final attachRow = const TeachersAttachRowRepository._();

  /// Returns a list of [Teachers]s matching the given query parameters.
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
  Future<List<Teachers>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TeachersTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TeachersTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TeachersTable>? orderByList,
    _i1.Transaction? transaction,
    TeachersInclude? include,
  }) async {
    return session.db.find<Teachers>(
      where: where?.call(Teachers.t),
      orderBy: orderBy?.call(Teachers.t),
      orderByList: orderByList?.call(Teachers.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [Teachers] matching the given query parameters.
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
  Future<Teachers?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TeachersTable>? where,
    int? offset,
    _i1.OrderByBuilder<TeachersTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TeachersTable>? orderByList,
    _i1.Transaction? transaction,
    TeachersInclude? include,
  }) async {
    return session.db.findFirstRow<Teachers>(
      where: where?.call(Teachers.t),
      orderBy: orderBy?.call(Teachers.t),
      orderByList: orderByList?.call(Teachers.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [Teachers] by its [id] or null if no such row exists.
  Future<Teachers?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    TeachersInclude? include,
  }) async {
    return session.db.findById<Teachers>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [Teachers]s in the list and returns the inserted rows.
  ///
  /// The returned [Teachers]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Teachers>> insert(
    _i1.Session session,
    List<Teachers> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Teachers>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Teachers] and returns the inserted row.
  ///
  /// The returned [Teachers] will have its `id` field set.
  Future<Teachers> insertRow(
    _i1.Session session,
    Teachers row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Teachers>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Teachers]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Teachers>> update(
    _i1.Session session,
    List<Teachers> rows, {
    _i1.ColumnSelections<TeachersTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Teachers>(
      rows,
      columns: columns?.call(Teachers.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Teachers]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Teachers> updateRow(
    _i1.Session session,
    Teachers row, {
    _i1.ColumnSelections<TeachersTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Teachers>(
      row,
      columns: columns?.call(Teachers.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Teachers]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Teachers>> delete(
    _i1.Session session,
    List<Teachers> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Teachers>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Teachers].
  Future<Teachers> deleteRow(
    _i1.Session session,
    Teachers row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Teachers>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Teachers>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TeachersTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Teachers>(
      where: where(Teachers.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TeachersTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Teachers>(
      where: where?.call(Teachers.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class TeachersAttachRowRepository {
  const TeachersAttachRowRepository._();

  /// Creates a relation between the given [Teachers] and [Person]
  /// by setting the [Teachers]'s foreign key `personId` to refer to the [Person].
  Future<void> person(
    _i1.Session session,
    Teachers teachers,
    _i2.Person person, {
    _i1.Transaction? transaction,
  }) async {
    if (teachers.id == null) {
      throw ArgumentError.notNull('teachers.id');
    }
    if (person.id == null) {
      throw ArgumentError.notNull('person.id');
    }

    var $teachers = teachers.copyWith(personId: person.id);
    await session.db.updateRow<Teachers>(
      $teachers,
      columns: [Teachers.t.personId],
      transaction: transaction,
    );
  }
}
