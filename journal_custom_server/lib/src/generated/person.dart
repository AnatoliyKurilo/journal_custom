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
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i2;

abstract class Person implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Person._({
    this.id,
    required this.firstName,
    required this.lastName,
    this.patronymic,
    required this.email,
    this.phoneNumber,
    this.userInfoId,
    this.userInfo,
  });

  factory Person({
    int? id,
    required String firstName,
    required String lastName,
    String? patronymic,
    required String email,
    String? phoneNumber,
    int? userInfoId,
    _i2.UserInfo? userInfo,
  }) = _PersonImpl;

  factory Person.fromJson(Map<String, dynamic> jsonSerialization) {
    return Person(
      id: jsonSerialization['id'] as int?,
      firstName: jsonSerialization['firstName'] as String,
      lastName: jsonSerialization['lastName'] as String,
      patronymic: jsonSerialization['patronymic'] as String?,
      email: jsonSerialization['email'] as String,
      phoneNumber: jsonSerialization['phoneNumber'] as String?,
      userInfoId: jsonSerialization['userInfoId'] as int?,
      userInfo: jsonSerialization['userInfo'] == null
          ? null
          : _i2.UserInfo.fromJson(
              (jsonSerialization['userInfo'] as Map<String, dynamic>)),
    );
  }

  static final t = PersonTable();

  static const db = PersonRepository._();

  @override
  int? id;

  String firstName;

  String lastName;

  String? patronymic;

  String email;

  String? phoneNumber;

  int? userInfoId;

  _i2.UserInfo? userInfo;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Person]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Person copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? patronymic,
    String? email,
    String? phoneNumber,
    int? userInfoId,
    _i2.UserInfo? userInfo,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'firstName': firstName,
      'lastName': lastName,
      if (patronymic != null) 'patronymic': patronymic,
      'email': email,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (userInfoId != null) 'userInfoId': userInfoId,
      if (userInfo != null) 'userInfo': userInfo?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'firstName': firstName,
      'lastName': lastName,
      if (patronymic != null) 'patronymic': patronymic,
      'email': email,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (userInfoId != null) 'userInfoId': userInfoId,
      if (userInfo != null) 'userInfo': userInfo?.toJsonForProtocol(),
    };
  }

  static PersonInclude include({_i2.UserInfoInclude? userInfo}) {
    return PersonInclude._(userInfo: userInfo);
  }

  static PersonIncludeList includeList({
    _i1.WhereExpressionBuilder<PersonTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PersonTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PersonTable>? orderByList,
    PersonInclude? include,
  }) {
    return PersonIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Person.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Person.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PersonImpl extends Person {
  _PersonImpl({
    int? id,
    required String firstName,
    required String lastName,
    String? patronymic,
    required String email,
    String? phoneNumber,
    int? userInfoId,
    _i2.UserInfo? userInfo,
  }) : super._(
          id: id,
          firstName: firstName,
          lastName: lastName,
          patronymic: patronymic,
          email: email,
          phoneNumber: phoneNumber,
          userInfoId: userInfoId,
          userInfo: userInfo,
        );

  /// Returns a shallow copy of this [Person]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Person copyWith({
    Object? id = _Undefined,
    String? firstName,
    String? lastName,
    Object? patronymic = _Undefined,
    String? email,
    Object? phoneNumber = _Undefined,
    Object? userInfoId = _Undefined,
    Object? userInfo = _Undefined,
  }) {
    return Person(
      id: id is int? ? id : this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      patronymic: patronymic is String? ? patronymic : this.patronymic,
      email: email ?? this.email,
      phoneNumber: phoneNumber is String? ? phoneNumber : this.phoneNumber,
      userInfoId: userInfoId is int? ? userInfoId : this.userInfoId,
      userInfo:
          userInfo is _i2.UserInfo? ? userInfo : this.userInfo?.copyWith(),
    );
  }
}

class PersonTable extends _i1.Table<int?> {
  PersonTable({super.tableRelation}) : super(tableName: 'person') {
    firstName = _i1.ColumnString(
      'firstName',
      this,
    );
    lastName = _i1.ColumnString(
      'lastName',
      this,
    );
    patronymic = _i1.ColumnString(
      'patronymic',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    phoneNumber = _i1.ColumnString(
      'phoneNumber',
      this,
    );
    userInfoId = _i1.ColumnInt(
      'userInfoId',
      this,
    );
  }

  late final _i1.ColumnString firstName;

  late final _i1.ColumnString lastName;

  late final _i1.ColumnString patronymic;

  late final _i1.ColumnString email;

  late final _i1.ColumnString phoneNumber;

  late final _i1.ColumnInt userInfoId;

  _i2.UserInfoTable? _userInfo;

  _i2.UserInfoTable get userInfo {
    if (_userInfo != null) return _userInfo!;
    _userInfo = _i1.createRelationTable(
      relationFieldName: 'userInfo',
      field: Person.t.userInfoId,
      foreignField: _i2.UserInfo.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.UserInfoTable(tableRelation: foreignTableRelation),
    );
    return _userInfo!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        firstName,
        lastName,
        patronymic,
        email,
        phoneNumber,
        userInfoId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'userInfo') {
      return userInfo;
    }
    return null;
  }
}

class PersonInclude extends _i1.IncludeObject {
  PersonInclude._({_i2.UserInfoInclude? userInfo}) {
    _userInfo = userInfo;
  }

  _i2.UserInfoInclude? _userInfo;

  @override
  Map<String, _i1.Include?> get includes => {'userInfo': _userInfo};

  @override
  _i1.Table<int?> get table => Person.t;
}

class PersonIncludeList extends _i1.IncludeList {
  PersonIncludeList._({
    _i1.WhereExpressionBuilder<PersonTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Person.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Person.t;
}

class PersonRepository {
  const PersonRepository._();

  final attachRow = const PersonAttachRowRepository._();

  final detachRow = const PersonDetachRowRepository._();

  /// Returns a list of [Person]s matching the given query parameters.
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
  Future<List<Person>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PersonTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PersonTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PersonTable>? orderByList,
    _i1.Transaction? transaction,
    PersonInclude? include,
  }) async {
    return session.db.find<Person>(
      where: where?.call(Person.t),
      orderBy: orderBy?.call(Person.t),
      orderByList: orderByList?.call(Person.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [Person] matching the given query parameters.
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
  Future<Person?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PersonTable>? where,
    int? offset,
    _i1.OrderByBuilder<PersonTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PersonTable>? orderByList,
    _i1.Transaction? transaction,
    PersonInclude? include,
  }) async {
    return session.db.findFirstRow<Person>(
      where: where?.call(Person.t),
      orderBy: orderBy?.call(Person.t),
      orderByList: orderByList?.call(Person.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [Person] by its [id] or null if no such row exists.
  Future<Person?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    PersonInclude? include,
  }) async {
    return session.db.findById<Person>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [Person]s in the list and returns the inserted rows.
  ///
  /// The returned [Person]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Person>> insert(
    _i1.Session session,
    List<Person> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Person>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Person] and returns the inserted row.
  ///
  /// The returned [Person] will have its `id` field set.
  Future<Person> insertRow(
    _i1.Session session,
    Person row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Person>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Person]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Person>> update(
    _i1.Session session,
    List<Person> rows, {
    _i1.ColumnSelections<PersonTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Person>(
      rows,
      columns: columns?.call(Person.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Person]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Person> updateRow(
    _i1.Session session,
    Person row, {
    _i1.ColumnSelections<PersonTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Person>(
      row,
      columns: columns?.call(Person.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Person]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Person>> delete(
    _i1.Session session,
    List<Person> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Person>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Person].
  Future<Person> deleteRow(
    _i1.Session session,
    Person row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Person>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Person>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PersonTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Person>(
      where: where(Person.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PersonTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Person>(
      where: where?.call(Person.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class PersonAttachRowRepository {
  const PersonAttachRowRepository._();

  /// Creates a relation between the given [Person] and [UserInfo]
  /// by setting the [Person]'s foreign key `userInfoId` to refer to the [UserInfo].
  Future<void> userInfo(
    _i1.Session session,
    Person person,
    _i2.UserInfo userInfo, {
    _i1.Transaction? transaction,
  }) async {
    if (person.id == null) {
      throw ArgumentError.notNull('person.id');
    }
    if (userInfo.id == null) {
      throw ArgumentError.notNull('userInfo.id');
    }

    var $person = person.copyWith(userInfoId: userInfo.id);
    await session.db.updateRow<Person>(
      $person,
      columns: [Person.t.userInfoId],
      transaction: transaction,
    );
  }
}

class PersonDetachRowRepository {
  const PersonDetachRowRepository._();

  /// Detaches the relation between this [Person] and the [UserInfo] set in `userInfo`
  /// by setting the [Person]'s foreign key `userInfoId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> userInfo(
    _i1.Session session,
    Person person, {
    _i1.Transaction? transaction,
  }) async {
    if (person.id == null) {
      throw ArgumentError.notNull('person.id');
    }

    var $person = person.copyWith(userInfoId: null);
    await session.db.updateRow<Person>(
      $person,
      columns: [Person.t.userInfoId],
      transaction: transaction,
    );
  }
}
