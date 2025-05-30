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
import 'package:journal_custom_client/src/protocol/students_protocol.dart'
    as _i3;
import 'package:journal_custom_client/src/protocol/groups_protocol.dart' as _i4;
import 'package:journal_custom_client/src/protocol/student_attendance_info.dart'
    as _i5;
import 'package:journal_custom_client/src/protocol/attendance_protocol.dart'
    as _i6;
import 'package:journal_custom_client/src/protocol/student_class_attendance_flat_record.dart'
    as _i7;
import 'package:journal_custom_client/src/protocol/subject_attendance_matrix.dart'
    as _i8;
import 'package:journal_custom_client/src/protocol/class_types_protocol.dart'
    as _i9;
import 'package:journal_custom_client/src/protocol/subjects_protocol.dart'
    as _i10;
import 'package:journal_custom_client/src/protocol/classes.dart' as _i11;
import 'package:journal_custom_client/src/protocol/person.dart' as _i12;
import 'package:journal_custom_client/src/protocol/teachers_protocol.dart'
    as _i13;
import 'package:journal_custom_client/src/protocol/subgroups_protocol.dart'
    as _i14;
import 'package:journal_custom_client/src/protocol/semesters_protocol.dart'
    as _i15;
import 'package:journal_custom_client/src/protocol/student_overall_attendance_record.dart'
    as _i16;
import 'package:journal_custom_client/src/protocol/greeting.dart' as _i17;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i18;
import 'protocol.dart' as _i19;

/// {@category Endpoint}
class EndpointAdmin extends _i1.EndpointRef {
  EndpointAdmin(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'admin';

  _i2.Future<List<_i3.Students>> searchStudents({required String query}) =>
      caller.callServerEndpoint<List<_i3.Students>>(
        'admin',
        'searchStudents',
        {'query': query},
      );

  _i2.Future<List<_i4.Groups>> searchGroups({required String query}) =>
      caller.callServerEndpoint<List<_i4.Groups>>(
        'admin',
        'searchGroups',
        {'query': query},
      );
}

/// {@category Endpoint}
class EndpointAttendance extends _i1.EndpointRef {
  EndpointAttendance(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'attendance';

  _i2.Future<List<_i5.StudentAttendanceInfo>> getStudentsForClassWithAttendance(
          {required int classId}) =>
      caller.callServerEndpoint<List<_i5.StudentAttendanceInfo>>(
        'attendance',
        'getStudentsForClassWithAttendance',
        {'classId': classId},
      );

  _i2.Future<_i6.Attendance> updateStudentAttendance({
    required int classId,
    required int studentId,
    required bool isPresent,
    String? comment,
  }) =>
      caller.callServerEndpoint<_i6.Attendance>(
        'attendance',
        'updateStudentAttendance',
        {
          'classId': classId,
          'studentId': studentId,
          'isPresent': isPresent,
          'comment': comment,
        },
      );

  _i2.Future<List<_i7.StudentClassAttendanceFlatRecord>>
      getSubjectOverallAttendance({required int subjectId}) =>
          caller.callServerEndpoint<List<_i7.StudentClassAttendanceFlatRecord>>(
            'attendance',
            'getSubjectOverallAttendance',
            {'subjectId': subjectId},
          );

  _i2.Future<_i8.SubjectAttendanceMatrix> getSubjectAttendanceMatrix(
          {required int subjectId}) =>
      caller.callServerEndpoint<_i8.SubjectAttendanceMatrix>(
        'attendance',
        'getSubjectAttendanceMatrix',
        {'subjectId': subjectId},
      );
}

/// {@category Endpoint}
class EndpointClassTypes extends _i1.EndpointRef {
  EndpointClassTypes(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'classTypes';

  _i2.Future<List<_i9.ClassTypes>> searchClassTypes({required String query}) =>
      caller.callServerEndpoint<List<_i9.ClassTypes>>(
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

  _i2.Future<List<_i10.Subjects>> getSubjectsWithClasses() =>
      caller.callServerEndpoint<List<_i10.Subjects>>(
        'classes',
        'getSubjectsWithClasses',
        {},
      );

  _i2.Future<List<_i11.Classes>> getClassesBySubject(
          {required int subjectId}) =>
      caller.callServerEndpoint<List<_i11.Classes>>(
        'classes',
        'getClassesBySubject',
        {'subjectId': subjectId},
      );

  _i2.Future<_i11.Classes> createClass({
    required int subjectsId,
    required int classTypesId,
    required int teachersId,
    required int semestersId,
    required int subgroupsId,
    required DateTime date,
    String? topic,
    String? notes,
  }) =>
      caller.callServerEndpoint<_i11.Classes>(
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
}

/// {@category Endpoint}
class EndpointGroups extends _i1.EndpointRef {
  EndpointGroups(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'groups';

  _i2.Future<_i4.Groups> createGroup(
    String name,
    int? curatorId,
  ) =>
      caller.callServerEndpoint<_i4.Groups>(
        'groups',
        'createGroup',
        {
          'name': name,
          'curatorId': curatorId,
        },
      );

  _i2.Future<List<_i4.Groups>> getAllGroups() =>
      caller.callServerEndpoint<List<_i4.Groups>>(
        'groups',
        'getAllGroups',
        {},
      );

  _i2.Future<_i4.Groups?> getGroupByName(String groupName) =>
      caller.callServerEndpoint<_i4.Groups?>(
        'groups',
        'getGroupByName',
        {'groupName': groupName},
      );

  _i2.Future<_i4.Groups> updateGroup(
    _i4.Groups clientProvidedGroup, {
    int? newCuratorId,
    int? newGroupHeadId,
  }) =>
      caller.callServerEndpoint<_i4.Groups>(
        'groups',
        'updateGroup',
        {
          'clientProvidedGroup': clientProvidedGroup,
          'newCuratorId': newCuratorId,
          'newGroupHeadId': newGroupHeadId,
        },
      );

  _i2.Future<bool> deleteGroup(int groupId) => caller.callServerEndpoint<bool>(
        'groups',
        'deleteGroup',
        {'groupId': groupId},
      );
}

/// {@category Endpoint}
class EndpointPerson extends _i1.EndpointRef {
  EndpointPerson(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'person';

  _i2.Future<_i12.Person> updatePerson(_i12.Person person) =>
      caller.callServerEndpoint<_i12.Person>(
        'person',
        'updatePerson',
        {'person': person},
      );
}

/// {@category Endpoint}
class EndpointSearch extends _i1.EndpointRef {
  EndpointSearch(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'search';

  _i2.Future<List<_i3.Students>> searchStudents({required String query}) =>
      caller.callServerEndpoint<List<_i3.Students>>(
        'search',
        'searchStudents',
        {'query': query},
      );

  _i2.Future<List<_i13.Teachers>> searchTeachers({required String query}) =>
      caller.callServerEndpoint<List<_i13.Teachers>>(
        'search',
        'searchTeachers',
        {'query': query},
      );

  _i2.Future<List<_i4.Groups>> searchGroups({required String query}) =>
      caller.callServerEndpoint<List<_i4.Groups>>(
        'search',
        'searchGroups',
        {'query': query},
      );

  _i2.Future<List<_i10.Subjects>> searchSubjects({required String query}) =>
      caller.callServerEndpoint<List<_i10.Subjects>>(
        'search',
        'searchSubjects',
        {'query': query},
      );

  _i2.Future<List<_i9.ClassTypes>> searchClassTypes({required String query}) =>
      caller.callServerEndpoint<List<_i9.ClassTypes>>(
        'search',
        'searchClassTypes',
        {'query': query},
      );

  _i2.Future<List<_i14.Subgroups>> searchSubgroups({required String query}) =>
      caller.callServerEndpoint<List<_i14.Subgroups>>(
        'search',
        'searchSubgroups',
        {'query': query},
      );
}

/// {@category Endpoint}
class EndpointSemesters extends _i1.EndpointRef {
  EndpointSemesters(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'semesters';

  _i2.Future<List<_i15.Semesters>> searchSemesters({required String query}) =>
      caller.callServerEndpoint<List<_i15.Semesters>>(
        'semesters',
        'searchSemesters',
        {'query': query},
      );
}

/// {@category Endpoint}
class EndpointStudents extends _i1.EndpointRef {
  EndpointStudents(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'students';

  _i2.Future<_i3.Students> createStudent({
    required String firstName,
    required String lastName,
    String? patronymic,
    required String email,
    String? phoneNumber,
    required String groupName,
    String? recordBookNumber,
  }) =>
      caller.callServerEndpoint<_i3.Students>(
        'students',
        'createStudent',
        {
          'firstName': firstName,
          'lastName': lastName,
          'patronymic': patronymic,
          'email': email,
          'phoneNumber': phoneNumber,
          'groupName': groupName,
          'recordBookNumber': recordBookNumber,
        },
      );

  _i2.Future<List<_i3.Students>> getAllStudents() =>
      caller.callServerEndpoint<List<_i3.Students>>(
        'students',
        'getAllStudents',
        {},
      );

  _i2.Future<_i3.Students> updateStudent(_i3.Students student) =>
      caller.callServerEndpoint<_i3.Students>(
        'students',
        'updateStudent',
        {'student': student},
      );

  _i2.Future<List<_i16.StudentOverallAttendanceRecord>>
      getStudentOverallAttendanceRecords(int studentId) =>
          caller.callServerEndpoint<List<_i16.StudentOverallAttendanceRecord>>(
            'students',
            'getStudentOverallAttendanceRecords',
            {'studentId': studentId},
          );
}

/// {@category Endpoint}
class EndpointSubgroups extends _i1.EndpointRef {
  EndpointSubgroups(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'subgroups';

  _i2.Future<_i4.Groups?> getCurrentUserGroup() =>
      caller.callServerEndpoint<_i4.Groups?>(
        'subgroups',
        'getCurrentUserGroup',
        {},
      );

  _i2.Future<_i14.Subgroups> createSubgroup(
    int groupId,
    String name,
    String? description,
  ) =>
      caller.callServerEndpoint<_i14.Subgroups>(
        'subgroups',
        'createSubgroup',
        {
          'groupId': groupId,
          'name': name,
          'description': description,
        },
      );

  _i2.Future<_i14.Subgroups> createFullGroupSubgroup(
    int groupId,
    String name,
    String? description,
  ) =>
      caller.callServerEndpoint<_i14.Subgroups>(
        'subgroups',
        'createFullGroupSubgroup',
        {
          'groupId': groupId,
          'name': name,
          'description': description,
        },
      );

  _i2.Future<List<_i14.Subgroups>> getGroupSubgroups(int groupId) =>
      caller.callServerEndpoint<List<_i14.Subgroups>>(
        'subgroups',
        'getGroupSubgroups',
        {'groupId': groupId},
      );

  _i2.Future<_i14.Subgroups> updateSubgroup(
    int subgroupId,
    String name,
    String? description,
  ) =>
      caller.callServerEndpoint<_i14.Subgroups>(
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

  _i2.Future<List<_i3.Students>> getSubgroupStudents(int subgroupId) =>
      caller.callServerEndpoint<List<_i3.Students>>(
        'subgroups',
        'getSubgroupStudents',
        {'subgroupId': subgroupId},
      );

  _i2.Future<List<_i3.Students>> getStudentsNotInSubgroup(int subgroupId) =>
      caller.callServerEndpoint<List<_i3.Students>>(
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

  _i2.Future<List<_i14.Subgroups>> searchSubgroups({required String query}) =>
      caller.callServerEndpoint<List<_i14.Subgroups>>(
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

  _i2.Future<_i8.SubjectAttendanceMatrix> getSubjectAttendanceMatrix(
          {required int subjectId}) =>
      caller.callServerEndpoint<_i8.SubjectAttendanceMatrix>(
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
class EndpointTeachers extends _i1.EndpointRef {
  EndpointTeachers(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'teachers';

  _i2.Future<_i13.Teachers> createTeacher({
    required String firstName,
    required String lastName,
    String? patronymic,
    required String email,
    String? phoneNumber,
  }) =>
      caller.callServerEndpoint<_i13.Teachers>(
        'teachers',
        'createTeacher',
        {
          'firstName': firstName,
          'lastName': lastName,
          'patronymic': patronymic,
          'email': email,
          'phoneNumber': phoneNumber,
        },
      );

  _i2.Future<List<_i13.Teachers>> getAllTeachers() =>
      caller.callServerEndpoint<List<_i13.Teachers>>(
        'teachers',
        'getAllTeachers',
        {},
      );
}

/// {@category Endpoint}
class EndpointTeacherSearch extends _i1.EndpointRef {
  EndpointTeacherSearch(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'teacherSearch';

  _i2.Future<List<_i13.Teachers>> searchTeachers({required String query}) =>
      caller.callServerEndpoint<List<_i13.Teachers>>(
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

  _i2.Future<bool> assignRole(
    int personId,
    String roleToAssign,
  ) =>
      caller.callServerEndpoint<bool>(
        'userRoles',
        'assignRole',
        {
          'personId': personId,
          'roleToAssign': roleToAssign,
        },
      );

  _i2.Future<bool> removeRole(
    int personId,
    String roleToRemove,
  ) =>
      caller.callServerEndpoint<bool>(
        'userRoles',
        'removeRole',
        {
          'personId': personId,
          'roleToRemove': roleToRemove,
        },
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
    attendance = EndpointAttendance(this);
    classTypes = EndpointClassTypes(this);
    classes = EndpointClasses(this);
    groups = EndpointGroups(this);
    person = EndpointPerson(this);
    search = EndpointSearch(this);
    semesters = EndpointSemesters(this);
    students = EndpointStudents(this);
    subgroups = EndpointSubgroups(this);
    subjectAttendanceMatrix = EndpointSubjectAttendanceMatrix(this);
    subjects = EndpointSubjects(this);
    teachers = EndpointTeachers(this);
    teacherSearch = EndpointTeacherSearch(this);
    makeUserAdmin = EndpointMakeUserAdmin(this);
    userRoles = EndpointUserRoles(this);
    greeting = EndpointGreeting(this);
    modules = Modules(this);
  }

  late final EndpointAdmin admin;

  late final EndpointAttendance attendance;

  late final EndpointClassTypes classTypes;

  late final EndpointClasses classes;

  late final EndpointGroups groups;

  late final EndpointPerson person;

  late final EndpointSearch search;

  late final EndpointSemesters semesters;

  late final EndpointStudents students;

  late final EndpointSubgroups subgroups;

  late final EndpointSubjectAttendanceMatrix subjectAttendanceMatrix;

  late final EndpointSubjects subjects;

  late final EndpointTeachers teachers;

  late final EndpointTeacherSearch teacherSearch;

  late final EndpointMakeUserAdmin makeUserAdmin;

  late final EndpointUserRoles userRoles;

  late final EndpointGreeting greeting;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'admin': admin,
        'attendance': attendance,
        'classTypes': classTypes,
        'classes': classes,
        'groups': groups,
        'person': person,
        'search': search,
        'semesters': semesters,
        'students': students,
        'subgroups': subgroups,
        'subjectAttendanceMatrix': subjectAttendanceMatrix,
        'subjects': subjects,
        'teachers': teachers,
        'teacherSearch': teacherSearch,
        'makeUserAdmin': makeUserAdmin,
        'userRoles': userRoles,
        'greeting': greeting,
      };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup =>
      {'auth': modules.auth};
}
