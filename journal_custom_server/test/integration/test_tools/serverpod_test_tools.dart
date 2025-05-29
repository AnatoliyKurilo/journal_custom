/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_local_identifiers

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_test/serverpod_test.dart' as _i1;
import 'package:serverpod/serverpod.dart' as _i2;
import 'dart:async' as _i3;
import 'package:journal_custom_server/src/generated/groups_protocol.dart'
    as _i4;
import 'package:journal_custom_server/src/generated/teachers_protocol.dart'
    as _i5;
import 'package:journal_custom_server/src/generated/students_protocol.dart'
    as _i6;
import 'package:journal_custom_server/src/generated/person.dart' as _i7;
import 'package:journal_custom_server/src/generated/student_overall_attendance_record.dart'
    as _i8;
import 'package:journal_custom_server/src/generated/class_types_protocol.dart'
    as _i9;
import 'package:journal_custom_server/src/generated/classes.dart' as _i10;
import 'package:journal_custom_server/src/generated/subjects_protocol.dart'
    as _i11;
import 'package:journal_custom_server/src/generated/student_attendance_info.dart'
    as _i12;
import 'package:journal_custom_server/src/generated/attendance_protocol.dart'
    as _i13;
import 'package:journal_custom_server/src/generated/student_class_attendance_flat_record.dart'
    as _i14;
import 'package:journal_custom_server/src/generated/semesters_protocol.dart'
    as _i15;
import 'package:journal_custom_server/src/generated/subgroups_protocol.dart'
    as _i16;
import 'package:journal_custom_server/src/generated/subject_attendance_matrix.dart'
    as _i17;
import 'package:journal_custom_server/src/generated/greeting.dart' as _i18;
import 'package:journal_custom_server/src/generated/protocol.dart';
import 'package:journal_custom_server/src/generated/endpoints.dart';
export 'package:serverpod_test/serverpod_test_public_exports.dart';

/// Creates a new test group that takes a callback that can be used to write tests.
/// The callback has two parameters: `sessionBuilder` and `endpoints`.
/// `sessionBuilder` is used to build a `Session` object that represents the server state during an endpoint call and is used to set up scenarios.
/// `endpoints` contains all your Serverpod endpoints and lets you call them:
/// ```dart
/// withServerpod('Given Example endpoint', (sessionBuilder, endpoints) {
///   test('when calling `hello` then should return greeting', () async {
///     final greeting = await endpoints.example.hello(sessionBuilder, 'Michael');
///     expect(greeting, 'Hello Michael');
///   });
/// });
/// ```
///
/// **Configuration options**
///
/// [applyMigrations] Whether pending migrations should be applied when starting Serverpod. Defaults to `true`
///
/// [enableSessionLogging] Whether session logging should be enabled. Defaults to `false`
///
/// [rollbackDatabase] Options for when to rollback the database during the test lifecycle.
/// By default `withServerpod` does all database operations inside a transaction that is rolled back after each `test` case.
/// Just like the following enum describes, the behavior of the automatic rollbacks can be configured:
/// ```dart
/// /// Options for when to rollback the database during the test lifecycle.
/// enum RollbackDatabase {
///   /// After each test. This is the default.
///   afterEach,
///
///   /// After all tests.
///   afterAll,
///
///   /// Disable rolling back the database.
///   disabled,
/// }
/// ```
///
/// [runMode] The run mode that Serverpod should be running in. Defaults to `test`.
///
/// [serverpodLoggingMode] The logging mode used when creating Serverpod. Defaults to `ServerpodLoggingMode.normal`
///
/// [serverpodStartTimeout] The timeout to use when starting Serverpod, which connects to the database among other things. Defaults to `Duration(seconds: 30)`.
///
/// [testGroupTagsOverride] By default Serverpod test tools tags the `withServerpod` test group with `"integration"`.
/// This is to provide a simple way to only run unit or integration tests.
/// This property allows this tag to be overridden to something else. Defaults to `['integration']`.
///
/// [experimentalFeatures] Optionally specify experimental features. See [Serverpod] for more information.
@_i1.isTestGroup
void withServerpod(
  String testGroupName,
  _i1.TestClosure<TestEndpoints> testClosure, {
  bool? applyMigrations,
  bool? enableSessionLogging,
  _i2.ExperimentalFeatures? experimentalFeatures,
  _i1.RollbackDatabase? rollbackDatabase,
  String? runMode,
  _i2.ServerpodLoggingMode? serverpodLoggingMode,
  Duration? serverpodStartTimeout,
  List<String>? testGroupTagsOverride,
}) {
  _i1.buildWithServerpod<_InternalTestEndpoints>(
    testGroupName,
    _i1.TestServerpod(
      testEndpoints: _InternalTestEndpoints(),
      endpoints: Endpoints(),
      serializationManager: Protocol(),
      runMode: runMode,
      applyMigrations: applyMigrations,
      isDatabaseEnabled: true,
      serverpodLoggingMode: serverpodLoggingMode,
      experimentalFeatures: experimentalFeatures,
    ),
    maybeRollbackDatabase: rollbackDatabase,
    maybeEnableSessionLogging: enableSessionLogging,
    maybeTestGroupTagsOverride: testGroupTagsOverride,
    maybeServerpodStartTimeout: serverpodStartTimeout,
  )(testClosure);
}

class TestEndpoints {
  late final _AdminEndpoint admin;

  late final _ClassTypesEndpoint classTypes;

  late final _ClassesEndpoint classes;

  late final _SemestersEndpoint semesters;

  late final _SubgroupsEndpoint subgroups;

  late final _SubjectAttendanceMatrixEndpoint subjectAttendanceMatrix;

  late final _SubjectsEndpoint subjects;

  late final _TeacherSearchEndpoint teacherSearch;

  late final _MakeUserAdminEndpoint makeUserAdmin;

  late final _UserRolesEndpoint userRoles;

  late final _GreetingEndpoint greeting;
}

class _InternalTestEndpoints extends TestEndpoints
    implements _i1.InternalTestEndpoints {
  @override
  void initialize(
    _i2.SerializationManager serializationManager,
    _i2.EndpointDispatch endpoints,
  ) {
    admin = _AdminEndpoint(
      endpoints,
      serializationManager,
    );
    classTypes = _ClassTypesEndpoint(
      endpoints,
      serializationManager,
    );
    classes = _ClassesEndpoint(
      endpoints,
      serializationManager,
    );
    semesters = _SemestersEndpoint(
      endpoints,
      serializationManager,
    );
    subgroups = _SubgroupsEndpoint(
      endpoints,
      serializationManager,
    );
    subjectAttendanceMatrix = _SubjectAttendanceMatrixEndpoint(
      endpoints,
      serializationManager,
    );
    subjects = _SubjectsEndpoint(
      endpoints,
      serializationManager,
    );
    teacherSearch = _TeacherSearchEndpoint(
      endpoints,
      serializationManager,
    );
    makeUserAdmin = _MakeUserAdminEndpoint(
      endpoints,
      serializationManager,
    );
    userRoles = _UserRolesEndpoint(
      endpoints,
      serializationManager,
    );
    greeting = _GreetingEndpoint(
      endpoints,
      serializationManager,
    );
  }
}

class _AdminEndpoint {
  _AdminEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<_i4.Groups> createGroup(
    _i1.TestSessionBuilder sessionBuilder,
    String name,
    int? curatorId,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'admin',
        method: 'createGroup',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'admin',
          methodName: 'createGroup',
          parameters: _i1.testObjectToJson({
            'name': name,
            'curatorId': curatorId,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<_i4.Groups>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i4.Groups>> getAllGroups(
      _i1.TestSessionBuilder sessionBuilder) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'admin',
        method: 'getAllGroups',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'admin',
          methodName: 'getAllGroups',
          parameters: _i1.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<List<_i4.Groups>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i4.Groups?> getGroupByName(
    _i1.TestSessionBuilder sessionBuilder,
    String groupName,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'admin',
        method: 'getGroupByName',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'admin',
          methodName: 'getGroupByName',
          parameters: _i1.testObjectToJson({'groupName': groupName}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<_i4.Groups?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i4.Groups> updateGroup(
    _i1.TestSessionBuilder sessionBuilder,
    _i4.Groups clientProvidedGroup, {
    int? newCuratorId,
    int? newGroupHeadId,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'admin',
        method: 'updateGroup',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'admin',
          methodName: 'updateGroup',
          parameters: _i1.testObjectToJson({
            'clientProvidedGroup': clientProvidedGroup,
            'newCuratorId': newCuratorId,
            'newGroupHeadId': newGroupHeadId,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<_i4.Groups>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i5.Teachers> createTeacher(
    _i1.TestSessionBuilder sessionBuilder, {
    required String firstName,
    required String lastName,
    String? patronymic,
    required String email,
    String? phoneNumber,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'admin',
        method: 'createTeacher',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'admin',
          methodName: 'createTeacher',
          parameters: _i1.testObjectToJson({
            'firstName': firstName,
            'lastName': lastName,
            'patronymic': patronymic,
            'email': email,
            'phoneNumber': phoneNumber,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<_i5.Teachers>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i6.Students> createStudent(
    _i1.TestSessionBuilder sessionBuilder, {
    required String firstName,
    required String lastName,
    String? patronymic,
    required String email,
    String? phoneNumber,
    required String groupName,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'admin',
        method: 'createStudent',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'admin',
          methodName: 'createStudent',
          parameters: _i1.testObjectToJson({
            'firstName': firstName,
            'lastName': lastName,
            'patronymic': patronymic,
            'email': email,
            'phoneNumber': phoneNumber,
            'groupName': groupName,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<_i6.Students>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i5.Teachers>> getAllTeachers(
      _i1.TestSessionBuilder sessionBuilder) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'admin',
        method: 'getAllTeachers',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'admin',
          methodName: 'getAllTeachers',
          parameters: _i1.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<List<_i5.Teachers>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i6.Students>> getAllStudents(
      _i1.TestSessionBuilder sessionBuilder) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'admin',
        method: 'getAllStudents',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'admin',
          methodName: 'getAllStudents',
          parameters: _i1.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<List<_i6.Students>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i7.Person> updatePerson(
    _i1.TestSessionBuilder sessionBuilder,
    _i7.Person person,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'admin',
        method: 'updatePerson',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'admin',
          methodName: 'updatePerson',
          parameters: _i1.testObjectToJson({'person': person}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<_i7.Person>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i6.Students>> searchStudents(
    _i1.TestSessionBuilder sessionBuilder, {
    required String query,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'admin',
        method: 'searchStudents',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'admin',
          methodName: 'searchStudents',
          parameters: _i1.testObjectToJson({'query': query}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<List<_i6.Students>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i4.Groups>> searchGroups(
    _i1.TestSessionBuilder sessionBuilder, {
    required String query,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'admin',
        method: 'searchGroups',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'admin',
          methodName: 'searchGroups',
          parameters: _i1.testObjectToJson({'query': query}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<List<_i4.Groups>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i6.Students> updateStudent(
    _i1.TestSessionBuilder sessionBuilder,
    _i6.Students student,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'admin',
        method: 'updateStudent',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'admin',
          methodName: 'updateStudent',
          parameters: _i1.testObjectToJson({'student': student}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<_i6.Students>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> deleteGroup(
    _i1.TestSessionBuilder sessionBuilder,
    int groupId,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'admin',
        method: 'deleteGroup',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'admin',
          methodName: 'deleteGroup',
          parameters: _i1.testObjectToJson({'groupId': groupId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i8.StudentOverallAttendanceRecord>>
      getStudentOverallAttendanceRecords(
    _i1.TestSessionBuilder sessionBuilder,
    int studentId,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'admin',
        method: 'getStudentOverallAttendanceRecords',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'admin',
          methodName: 'getStudentOverallAttendanceRecords',
          parameters: _i1.testObjectToJson({'studentId': studentId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<List<_i8.StudentOverallAttendanceRecord>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _ClassTypesEndpoint {
  _ClassTypesEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<List<_i9.ClassTypes>> searchClassTypes(
    _i1.TestSessionBuilder sessionBuilder, {
    required String query,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'classTypes',
        method: 'searchClassTypes',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'classTypes',
          methodName: 'searchClassTypes',
          parameters: _i1.testObjectToJson({'query': query}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<List<_i9.ClassTypes>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _ClassesEndpoint {
  _ClassesEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<_i10.Classes> createClass(
    _i1.TestSessionBuilder sessionBuilder, {
    required int subjectsId,
    required int classTypesId,
    required int teachersId,
    required int semestersId,
    required int subgroupsId,
    required DateTime date,
    String? topic,
    String? notes,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'classes',
        method: 'createClass',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'classes',
          methodName: 'createClass',
          parameters: _i1.testObjectToJson({
            'subjectsId': subjectsId,
            'classTypesId': classTypesId,
            'teachersId': teachersId,
            'semestersId': semestersId,
            'subgroupsId': subgroupsId,
            'date': date,
            'topic': topic,
            'notes': notes,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<_i10.Classes>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i11.Subjects>> getSubjectsWithClasses(
      _i1.TestSessionBuilder sessionBuilder) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'classes',
        method: 'getSubjectsWithClasses',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'classes',
          methodName: 'getSubjectsWithClasses',
          parameters: _i1.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<List<_i11.Subjects>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i10.Classes>> getClassesBySubject(
    _i1.TestSessionBuilder sessionBuilder, {
    required int subjectId,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'classes',
        method: 'getClassesBySubject',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'classes',
          methodName: 'getClassesBySubject',
          parameters: _i1.testObjectToJson({'subjectId': subjectId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<List<_i10.Classes>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i12.StudentAttendanceInfo>>
      getStudentsForClassWithAttendance(
    _i1.TestSessionBuilder sessionBuilder, {
    required int classId,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'classes',
        method: 'getStudentsForClassWithAttendance',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'classes',
          methodName: 'getStudentsForClassWithAttendance',
          parameters: _i1.testObjectToJson({'classId': classId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<List<_i12.StudentAttendanceInfo>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i13.Attendance> updateStudentAttendance(
    _i1.TestSessionBuilder sessionBuilder, {
    required int classId,
    required int studentId,
    required bool isPresent,
    String? comment,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'classes',
        method: 'updateStudentAttendance',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'classes',
          methodName: 'updateStudentAttendance',
          parameters: _i1.testObjectToJson({
            'classId': classId,
            'studentId': studentId,
            'isPresent': isPresent,
            'comment': comment,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<_i13.Attendance>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i14.StudentClassAttendanceFlatRecord>>
      getSubjectOverallAttendance(
    _i1.TestSessionBuilder sessionBuilder, {
    required int subjectId,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'classes',
        method: 'getSubjectOverallAttendance',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'classes',
          methodName: 'getSubjectOverallAttendance',
          parameters: _i1.testObjectToJson({'subjectId': subjectId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<List<_i14.StudentClassAttendanceFlatRecord>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _SemestersEndpoint {
  _SemestersEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<List<_i15.Semesters>> searchSemesters(
    _i1.TestSessionBuilder sessionBuilder, {
    required String query,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'semesters',
        method: 'searchSemesters',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'semesters',
          methodName: 'searchSemesters',
          parameters: _i1.testObjectToJson({'query': query}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<List<_i15.Semesters>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _SubgroupsEndpoint {
  _SubgroupsEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<_i4.Groups?> getCurrentUserGroup(
      _i1.TestSessionBuilder sessionBuilder) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'subgroups',
        method: 'getCurrentUserGroup',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'subgroups',
          methodName: 'getCurrentUserGroup',
          parameters: _i1.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<_i4.Groups?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i16.Subgroups> createSubgroup(
    _i1.TestSessionBuilder sessionBuilder,
    int groupId,
    String name,
    String? description,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'subgroups',
        method: 'createSubgroup',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'subgroups',
          methodName: 'createSubgroup',
          parameters: _i1.testObjectToJson({
            'groupId': groupId,
            'name': name,
            'description': description,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<_i16.Subgroups>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i16.Subgroups> createFullGroupSubgroup(
    _i1.TestSessionBuilder sessionBuilder,
    int groupId,
    String name,
    String? description,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'subgroups',
        method: 'createFullGroupSubgroup',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'subgroups',
          methodName: 'createFullGroupSubgroup',
          parameters: _i1.testObjectToJson({
            'groupId': groupId,
            'name': name,
            'description': description,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<_i16.Subgroups>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i16.Subgroups>> getGroupSubgroups(
    _i1.TestSessionBuilder sessionBuilder,
    int groupId,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'subgroups',
        method: 'getGroupSubgroups',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'subgroups',
          methodName: 'getGroupSubgroups',
          parameters: _i1.testObjectToJson({'groupId': groupId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<List<_i16.Subgroups>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i16.Subgroups> updateSubgroup(
    _i1.TestSessionBuilder sessionBuilder,
    int subgroupId,
    String name,
    String? description,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'subgroups',
        method: 'updateSubgroup',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'subgroups',
          methodName: 'updateSubgroup',
          parameters: _i1.testObjectToJson({
            'subgroupId': subgroupId,
            'name': name,
            'description': description,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<_i16.Subgroups>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> deleteSubgroup(
    _i1.TestSessionBuilder sessionBuilder,
    int subgroupId,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'subgroups',
        method: 'deleteSubgroup',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'subgroups',
          methodName: 'deleteSubgroup',
          parameters: _i1.testObjectToJson({'subgroupId': subgroupId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i6.Students>> getSubgroupStudents(
    _i1.TestSessionBuilder sessionBuilder,
    int subgroupId,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'subgroups',
        method: 'getSubgroupStudents',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'subgroups',
          methodName: 'getSubgroupStudents',
          parameters: _i1.testObjectToJson({'subgroupId': subgroupId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<List<_i6.Students>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i6.Students>> getStudentsNotInSubgroup(
    _i1.TestSessionBuilder sessionBuilder,
    int subgroupId,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'subgroups',
        method: 'getStudentsNotInSubgroup',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'subgroups',
          methodName: 'getStudentsNotInSubgroup',
          parameters: _i1.testObjectToJson({'subgroupId': subgroupId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<List<_i6.Students>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> addStudentToSubgroup(
    _i1.TestSessionBuilder sessionBuilder,
    int subgroupId,
    int studentId,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'subgroups',
        method: 'addStudentToSubgroup',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'subgroups',
          methodName: 'addStudentToSubgroup',
          parameters: _i1.testObjectToJson({
            'subgroupId': subgroupId,
            'studentId': studentId,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> removeStudentFromSubgroup(
    _i1.TestSessionBuilder sessionBuilder,
    int subgroupId,
    int studentId,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'subgroups',
        method: 'removeStudentFromSubgroup',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'subgroups',
          methodName: 'removeStudentFromSubgroup',
          parameters: _i1.testObjectToJson({
            'subgroupId': subgroupId,
            'studentId': studentId,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i16.Subgroups>> searchSubgroups(
    _i1.TestSessionBuilder sessionBuilder, {
    required String query,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'subgroups',
        method: 'searchSubgroups',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'subgroups',
          methodName: 'searchSubgroups',
          parameters: _i1.testObjectToJson({'query': query}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<List<_i16.Subgroups>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _SubjectAttendanceMatrixEndpoint {
  _SubjectAttendanceMatrixEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<_i17.SubjectAttendanceMatrix> getSubjectAttendanceMatrix(
    _i1.TestSessionBuilder sessionBuilder, {
    required int subjectId,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'subjectAttendanceMatrix',
        method: 'getSubjectAttendanceMatrix',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'subjectAttendanceMatrix',
          methodName: 'getSubjectAttendanceMatrix',
          parameters: _i1.testObjectToJson({'subjectId': subjectId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<_i17.SubjectAttendanceMatrix>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _SubjectsEndpoint {
  _SubjectsEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<List<_i11.Subjects>> searchSubjects(
    _i1.TestSessionBuilder sessionBuilder, {
    required String query,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'subjects',
        method: 'searchSubjects',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'subjects',
          methodName: 'searchSubjects',
          parameters: _i1.testObjectToJson({'query': query}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<List<_i11.Subjects>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _TeacherSearchEndpoint {
  _TeacherSearchEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<List<_i5.Teachers>> searchTeachers(
    _i1.TestSessionBuilder sessionBuilder, {
    required String query,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'teacherSearch',
        method: 'searchTeachers',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'teacherSearch',
          methodName: 'searchTeachers',
          parameters: _i1.testObjectToJson({'query': query}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<List<_i5.Teachers>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _MakeUserAdminEndpoint {
  _MakeUserAdminEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<bool> setUserScopes(
    _i1.TestSessionBuilder sessionBuilder,
    int userId,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'makeUserAdmin',
        method: 'setUserScopes',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'makeUserAdmin',
          methodName: 'setUserScopes',
          parameters: _i1.testObjectToJson({'userId': userId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _UserRolesEndpoint {
  _UserRolesEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<List<String>> getUserRoles(
    _i1.TestSessionBuilder sessionBuilder,
    int personId,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'userRoles',
        method: 'getUserRoles',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'userRoles',
          methodName: 'getUserRoles',
          parameters: _i1.testObjectToJson({'personId': personId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<List<String>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> assignRole(
    _i1.TestSessionBuilder sessionBuilder,
    int personId,
    String roleToAssign,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'userRoles',
        method: 'assignRole',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'userRoles',
          methodName: 'assignRole',
          parameters: _i1.testObjectToJson({
            'personId': personId,
            'roleToAssign': roleToAssign,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> assignCuratorRole(
    _i1.TestSessionBuilder sessionBuilder,
    int teacherId,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'userRoles',
        method: 'assignCuratorRole',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'userRoles',
          methodName: 'assignCuratorRole',
          parameters: _i1.testObjectToJson({'teacherId': teacherId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> assignGroupHeadRole(
    _i1.TestSessionBuilder sessionBuilder,
    int studentId,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'userRoles',
        method: 'assignGroupHeadRole',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'userRoles',
          methodName: 'assignGroupHeadRole',
          parameters: _i1.testObjectToJson({'studentId': studentId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> removeRole(
    _i1.TestSessionBuilder sessionBuilder,
    int personId,
    String roleToRemove,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'userRoles',
        method: 'removeRole',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'userRoles',
          methodName: 'removeRole',
          parameters: _i1.testObjectToJson({
            'personId': personId,
            'roleToRemove': roleToRemove,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _GreetingEndpoint {
  _GreetingEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<_i18.Greeting> hello(
    _i1.TestSessionBuilder sessionBuilder,
    String name,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'greeting',
        method: 'hello',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'greeting',
          methodName: 'hello',
          parameters: _i1.testObjectToJson({'name': name}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<_i18.Greeting>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}
