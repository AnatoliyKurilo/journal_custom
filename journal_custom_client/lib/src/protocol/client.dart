/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:journal_custom_client/src/protocol/groups_protocol.dart' as _i3;
import 'package:journal_custom_client/src/protocol/teachers_protocol.dart'
    as _i4;
import 'package:journal_custom_client/src/protocol/students_protocol.dart'
    as _i5;
import 'package:journal_custom_client/src/protocol/person.dart' as _i6;
import 'package:journal_custom_client/src/protocol/student_overall_attendance_record.dart'
    as _i7;
import 'package:journal_custom_client/src/protocol/class_types_protocol.dart'
    as _i8;
import 'package:journal_custom_client/src/protocol/classes.dart' as _i9;
import 'package:journal_custom_client/src/protocol/subjects_protocol.dart'
    as _i10;
import 'package:journal_custom_client/src/protocol/student_attendance_info.dart'
    as _i11;
import 'package:journal_custom_client/src/protocol/attendance_protocol.dart'
    as _i12;
import 'package:journal_custom_client/src/protocol/student_class_attendance_flat_record.dart'
    as _i13;
import 'package:journal_custom_client/src/protocol/semesters_protocol.dart'
    as _i14;
import 'package:journal_custom_client/src/protocol/subgroups_protocol.dart'
    as _i15;
import 'package:journal_custom_client/src/protocol/subject_attendance_matrix.dart'
    as _i16;
import 'package:journal_custom_client/src/protocol/greeting.dart' as _i17;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i18;
import 'protocol.dart' as _i19;

/// {@category Endpoint}
class EndpointAdmin extends _i1.EndpointRef {
  EndpointAdmin(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'admin';

  _i2.Future<_i3.Groups> createGroup(
    String name,
    int? curatorId,
  ) =>
      caller.callServerEndpoint<_i3.Groups>(
        'admin',
        'createGroup',
        {
          'name': name,
          'curatorId': curatorId,
        },
      );

  _i2.Future<List<_i3.Groups>> getAllGroups() =>
      caller.callServerEndpoint<List<_i3.Groups>>(
        'admin',
        'getAllGroups',
        {},
      );

  _i2.Future<_i3.Groups?> getGroupByName(String groupName) =>
      caller.callServerEndpoint<_i3.Groups?>(
        'admin',
        'getGroupByName',
        {'groupName': groupName},
      );

  _i2.Future<_i3.Groups> updateGroup(
    _i3.Groups clientProvidedGroup, {
    int? newCuratorId,
    int? newGroupHeadId,
  }) =>
      caller.callServerEndpoint<_i3.Groups>(
        'admin',
        'updateGroup',
        {
          'clientProvidedGroup': clientProvidedGroup,
          'newCuratorId': newCuratorId,
          'newGroupHeadId': newGroupHeadId,
        },
      );

  _i2.Future<_i4.Teachers> createTeacher({
    required String firstName,
    required String lastName,
    String? patronymic,
    required String email,
    String? phoneNumber,
  }) =>
      caller.callServerEndpoint<_i4.Teachers>(
        'admin',
        'createTeacher',
        {
          'firstName': firstName,
          'lastName': lastName,
          'patronymic': patronymic,
          'email': email,
          'phoneNumber': phoneNumber,
        },
      );

  _i2.Future<_i5.Students> createStudent({
    required String firstName,
    required String lastName,
    String? patronymic,
    required String email,
    String? phoneNumber,
    required String groupName,
  }) =>
      caller.callServerEndpoint<_i5.Students>(
        'admin',
        'createStudent',
        {
          'firstName': firstName,
          'lastName': lastName,
          'patronymic': patronymic,
          'email': email,
          'phoneNumber': phoneNumber,
          'groupName': groupName,
        },
      );

  _i2.Future<List<_i4.Teachers>> getAllTeachers() =>
      caller.callServerEndpoint<List<_i4.Teachers>>(
        'admin',
        'getAllTeachers',
        {},
      );

  _i2.Future<List<_i5.Students>> getAllStudents() =>
      caller.callServerEndpoint<List<_i5.Students>>(
        'admin',
        'getAllStudents',
        {},
      );

  _i2.Future<_i6.Person> updatePerson(_i6.Person person) =>
      caller.callServerEndpoint<_i6.Person>(
        'admin',
        'updatePerson',
        {'person': person},
      );

  _i2.Future<List<_i5.Students>> searchStudents({required String query}) =>
      caller.callServerEndpoint<List<_i5.Students>>(
        'admin',
        'searchStudents',
        {'query': query},
      );

  _i2.Future<List<_i3.Groups>> searchGroups({required String query}) =>
      caller.callServerEndpoint<List<_i3.Groups>>(
        'admin',
        'searchGroups',
        {'query': query},
      );

  _i2.Future<_i5.Students> updateStudent(_i5.Students student) =>
      caller.callServerEndpoint<_i5.Students>(
        'admin',
        'updateStudent',
        {'student': student},
      );

  _i2.Future<bool> deleteGroup(int groupId) => caller.callServerEndpoint<bool>(
        'admin',
        'deleteGroup',
        {'groupId': groupId},
      );

  _i2.Future<List<_i7.StudentOverallAttendanceRecord>>
      getStudentOverallAttendanceRecords(int studentId) =>
          caller.callServerEndpoint<List<_i7.StudentOverallAttendanceRecord>>(
            'admin',
            'getStudentOverallAttendanceRecords',
            {'studentId': studentId},
          );
}

/// {@category Endpoint}
class EndpointClassTypes extends _i1.EndpointRef {
  EndpointClassTypes(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'classTypes';

  _i2.Future<List<_i8.ClassTypes>> searchClassTypes({required String query}) =>
      caller.callServerEndpoint<List<_i8.ClassTypes>>(
        'classTypes',
        'searchClassTypes',
        {'query': query},
      );
}

/// {@category Endpoint}
class EndpointClasses extends _i1.EndpointRef {
  EndpointClasses(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'classes';

  _i2.Future<_i9.Classes> createClass({
    required int subjectsId,
    required int classTypesId,
    required int teachersId,
    required int semestersId,
    required int subgroupsId,
    required DateTime date,
    String? topic,
    String? notes,
  }) =>
      caller.callServerEndpoint<_i9.Classes>(
        'classes',
        'createClass',
        {
          'subjectsId': subjectsId,
          'classTypesId': classTypesId,
          'teachersId': teachersId,
          'semestersId': semestersId,
          'subgroupsId': subgroupsId,
          'date': date,
          'topic': topic,
          'notes': notes,
        },
      );

  _i2.Future<List<_i10.Subjects>> getSubjectsWithClasses() =>
      caller.callServerEndpoint<List<_i10.Subjects>>(
        'classes',
        'getSubjectsWithClasses',
        {},
      );

  _i2.Future<List<_i9.Classes>> getClassesBySubject({required int subjectId}) =>
      caller.callServerEndpoint<List<_i9.Classes>>(
        'classes',
        'getClassesBySubject',
        {'subjectId': subjectId},
      );

  _i2.Future<List<_i11.StudentAttendanceInfo>>
      getStudentsForClassWithAttendance({required int classId}) =>
          caller.callServerEndpoint<List<_i11.StudentAttendanceInfo>>(
            'classes',
            'getStudentsForClassWithAttendance',
            {'classId': classId},
          );

  _i2.Future<_i12.Attendance> updateStudentAttendance({
    required int classId,
    required int studentId,
    required bool isPresent,
    String? comment,
  }) =>
      caller.callServerEndpoint<_i12.Attendance>(
        'classes',
        'updateStudentAttendance',
        {
          'classId': classId,
          'studentId': studentId,
          'isPresent': isPresent,
          'comment': comment,
        },
      );

  _i2.Future<List<_i13.StudentClassAttendanceFlatRecord>>
      getSubjectOverallAttendance({required int subjectId}) => caller
              .callServerEndpoint<List<_i13.StudentClassAttendanceFlatRecord>>(
            'classes',
            'getSubjectOverallAttendance',
            {'subjectId': subjectId},
          );
}

/// {@category Endpoint}
class EndpointSemesters extends _i1.EndpointRef {
  EndpointSemesters(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'semesters';

  _i2.Future<List<_i14.Semesters>> searchSemesters({required String query}) =>
      caller.callServerEndpoint<List<_i14.Semesters>>(
        'semesters',
        'searchSemesters',
        {'query': query},
      );
}

/// {@category Endpoint}
class EndpointSubgroups extends _i1.EndpointRef {
  EndpointSubgroups(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'subgroups';

  _i2.Future<_i3.Groups?> getCurrentUserGroup() =>
      caller.callServerEndpoint<_i3.Groups?>(
        'subgroups',
        'getCurrentUserGroup',
        {},
      );

  _i2.Future<_i15.Subgroups> createSubgroup(
    int groupId,
    String name,
    String? description,
  ) =>
      caller.callServerEndpoint<_i15.Subgroups>(
        'subgroups',
        'createSubgroup',
        {
          'groupId': groupId,
          'name': name,
          'description': description,
        },
      );

  _i2.Future<_i15.Subgroups> createFullGroupSubgroup(
    int groupId,
    String name,
    String? description,
  ) =>
      caller.callServerEndpoint<_i15.Subgroups>(
        'subgroups',
        'createFullGroupSubgroup',
        {
          'groupId': groupId,
          'name': name,
          'description': description,
        },
      );

  _i2.Future<List<_i15.Subgroups>> getGroupSubgroups(int groupId) =>
      caller.callServerEndpoint<List<_i15.Subgroups>>(
        'subgroups',
        'getGroupSubgroups',
        {'groupId': groupId},
      );

  _i2.Future<_i15.Subgroups> updateSubgroup(
    int subgroupId,
    String name,
    String? description,
  ) =>
      caller.callServerEndpoint<_i15.Subgroups>(
        'subgroups',
        'updateSubgroup',
        {
          'subgroupId': subgroupId,
          'name': name,
          'description': description,
        },
      );

  _i2.Future<bool> deleteSubgroup(int subgroupId) =>
      caller.callServerEndpoint<bool>(
        'subgroups',
        'deleteSubgroup',
        {'subgroupId': subgroupId},
      );

  _i2.Future<List<_i5.Students>> getSubgroupStudents(int subgroupId) =>
      caller.callServerEndpoint<List<_i5.Students>>(
        'subgroups',
        'getSubgroupStudents',
        {'subgroupId': subgroupId},
      );

  _i2.Future<List<_i5.Students>> getStudentsNotInSubgroup(int subgroupId) =>
      caller.callServerEndpoint<List<_i5.Students>>(
        'subgroups',
        'getStudentsNotInSubgroup',
        {'subgroupId': subgroupId},
      );

  _i2.Future<bool> addStudentToSubgroup(
    int subgroupId,
    int studentId,
  ) =>
      caller.callServerEndpoint<bool>(
        'subgroups',
        'addStudentToSubgroup',
        {
          'subgroupId': subgroupId,
          'studentId': studentId,
        },
      );

  _i2.Future<bool> removeStudentFromSubgroup(
    int subgroupId,
    int studentId,
  ) =>
      caller.callServerEndpoint<bool>(
        'subgroups',
        'removeStudentFromSubgroup',
        {
          'subgroupId': subgroupId,
          'studentId': studentId,
        },
      );

  _i2.Future<List<_i15.Subgroups>> searchSubgroups({required String query}) =>
      caller.callServerEndpoint<List<_i15.Subgroups>>(
        'subgroups',
        'searchSubgroups',
        {'query': query},
      );
}

/// {@category Endpoint}
class EndpointSubjectAttendanceMatrix extends _i1.EndpointRef {
  EndpointSubjectAttendanceMatrix(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'subjectAttendanceMatrix';

  _i2.Future<_i16.SubjectAttendanceMatrix> getSubjectAttendanceMatrix(
          {required int subjectId}) =>
      caller.callServerEndpoint<_i16.SubjectAttendanceMatrix>(
        'subjectAttendanceMatrix',
        'getSubjectAttendanceMatrix',
        {'subjectId': subjectId},
      );
}

/// {@category Endpoint}
class EndpointSubjects extends _i1.EndpointRef {
  EndpointSubjects(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'subjects';

  _i2.Future<List<_i10.Subjects>> searchSubjects({required String query}) =>
      caller.callServerEndpoint<List<_i10.Subjects>>(
        'subjects',
        'searchSubjects',
        {'query': query},
      );
}

/// {@category Endpoint}
class EndpointTeacherSearch extends _i1.EndpointRef {
  EndpointTeacherSearch(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'teacherSearch';

  _i2.Future<List<_i4.Teachers>> searchTeachers({required String query}) =>
      caller.callServerEndpoint<List<_i4.Teachers>>(
        'teacherSearch',
        'searchTeachers',
        {'query': query},
      );
}

/// {@category Endpoint}
class EndpointMakeUserAdmin extends _i1.EndpointRef {
  EndpointMakeUserAdmin(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'makeUserAdmin';

  _i2.Future<bool> setUserScopes(int userId) => caller.callServerEndpoint<bool>(
        'makeUserAdmin',
        'setUserScopes',
        {'userId': userId},
      );
}

/// {@category Endpoint}
class EndpointUserRoles extends _i1.EndpointRef {
  EndpointUserRoles(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'userRoles';

  _i2.Future<List<String>> getUserRoles(int personId) =>
      caller.callServerEndpoint<List<String>>(
        'userRoles',
        'getUserRoles',
        {'personId': personId},
      );

  _i2.Future<bool> assignCuratorRole(int teacherId) =>
      caller.callServerEndpoint<bool>(
        'userRoles',
        'assignCuratorRole',
        {'teacherId': teacherId},
      );

  _i2.Future<bool> assignGroupHeadRole(int studentId) =>
      caller.callServerEndpoint<bool>(
        'userRoles',
        'assignGroupHeadRole',
        {'studentId': studentId},
      );

  _i2.Future<bool> removeRole(
    int personId,
    String role,
  ) =>
      caller.callServerEndpoint<bool>(
        'userRoles',
        'removeRole',
        {
          'personId': personId,
          'role': role,
        },
      );
}

/// This is an example endpoint that returns a greeting message through its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _i1.EndpointRef {
  EndpointGreeting(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _i2.Future<_i17.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i17.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

class Modules {
  Modules(Client client) {
    auth = _i18.Caller(client);
  }

  late final _i18.Caller auth;
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )? onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
          host,
          _i19.Protocol(),
          securityContext: securityContext,
          authenticationKeyManager: authenticationKeyManager,
          streamingConnectionTimeout: streamingConnectionTimeout,
          connectionTimeout: connectionTimeout,
          onFailedCall: onFailedCall,
          onSucceededCall: onSucceededCall,
          disconnectStreamsOnLostInternetConnection:
              disconnectStreamsOnLostInternetConnection,
        ) {
    admin = EndpointAdmin(this);
    classTypes = EndpointClassTypes(this);
    classes = EndpointClasses(this);
    semesters = EndpointSemesters(this);
    subgroups = EndpointSubgroups(this);
    subjectAttendanceMatrix = EndpointSubjectAttendanceMatrix(this);
    subjects = EndpointSubjects(this);
    teacherSearch = EndpointTeacherSearch(this);
    makeUserAdmin = EndpointMakeUserAdmin(this);
    userRoles = EndpointUserRoles(this);
    greeting = EndpointGreeting(this);
    modules = Modules(this);
  }

  late final EndpointAdmin admin;

  late final EndpointClassTypes classTypes;

  late final EndpointClasses classes;

  late final EndpointSemesters semesters;

  late final EndpointSubgroups subgroups;

  late final EndpointSubjectAttendanceMatrix subjectAttendanceMatrix;

  late final EndpointSubjects subjects;

  late final EndpointTeacherSearch teacherSearch;

  late final EndpointMakeUserAdmin makeUserAdmin;

  late final EndpointUserRoles userRoles;

  late final EndpointGreeting greeting;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'admin': admin,
        'classTypes': classTypes,
        'classes': classes,
        'semesters': semesters,
        'subgroups': subgroups,
        'subjectAttendanceMatrix': subjectAttendanceMatrix,
        'subjects': subjects,
        'teacherSearch': teacherSearch,
        'makeUserAdmin': makeUserAdmin,
        'userRoles': userRoles,
        'greeting': greeting,
      };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup =>
      {'auth': modules.auth};
}
