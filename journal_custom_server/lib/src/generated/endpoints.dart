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
import '../endpoints/admin_endpoint.dart' as _i2;
import '../endpoints/class_types_endpoint.dart' as _i3;
import '../endpoints/classes_endpoint.dart' as _i4;
import '../endpoints/semesters_endpoint.dart' as _i5;
import '../endpoints/subgroups_endpoint.dart' as _i6;
import '../endpoints/subject_attendance_matrix.dart' as _i7;
import '../endpoints/subjects_endpoint.dart' as _i8;
import '../endpoints/teachers_search_endpoint.dart' as _i9;
import '../endpoints/user_endpoint.dart' as _i10;
import '../endpoints/user_roles_endpoint.dart' as _i11;
import '../greeting_endpoint.dart' as _i12;
import 'package:journal_custom_server/src/generated/groups_protocol.dart'
    as _i13;
import 'package:journal_custom_server/src/generated/person.dart' as _i14;
import 'package:journal_custom_server/src/generated/students_protocol.dart'
    as _i15;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i16;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'admin': _i2.AdminEndpoint()
        ..initialize(
          server,
          'admin',
          null,
        ),
      'classTypes': _i3.ClassTypesEndpoint()
        ..initialize(
          server,
          'classTypes',
          null,
        ),
      'classes': _i4.ClassesEndpoint()
        ..initialize(
          server,
          'classes',
          null,
        ),
      'semesters': _i5.SemestersEndpoint()
        ..initialize(
          server,
          'semesters',
          null,
        ),
      'subgroups': _i6.SubgroupsEndpoint()
        ..initialize(
          server,
          'subgroups',
          null,
        ),
      'subjectAttendanceMatrix': _i7.SubjectAttendanceMatrixEndpoint()
        ..initialize(
          server,
          'subjectAttendanceMatrix',
          null,
        ),
      'subjects': _i8.SubjectsEndpoint()
        ..initialize(
          server,
          'subjects',
          null,
        ),
      'teacherSearch': _i9.TeacherSearchEndpoint()
        ..initialize(
          server,
          'teacherSearch',
          null,
        ),
      'makeUserAdmin': _i10.MakeUserAdminEndpoint()
        ..initialize(
          server,
          'makeUserAdmin',
          null,
        ),
      'userRoles': _i11.UserRolesEndpoint()
        ..initialize(
          server,
          'userRoles',
          null,
        ),
      'greeting': _i12.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
    connectors['admin'] = _i1.EndpointConnector(
      name: 'admin',
      endpoint: endpoints['admin']!,
      methodConnectors: {
        'createGroup': _i1.MethodConnector(
          name: 'createGroup',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'curatorId': _i1.ParameterDescription(
              name: 'curatorId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).createGroup(
            session,
            params['name'],
            params['curatorId'],
          ),
        ),
        'getAllGroups': _i1.MethodConnector(
          name: 'getAllGroups',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).getAllGroups(session),
        ),
        'getGroupByName': _i1.MethodConnector(
          name: 'getGroupByName',
          params: {
            'groupName': _i1.ParameterDescription(
              name: 'groupName',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).getGroupByName(
            session,
            params['groupName'],
          ),
        ),
        'updateGroup': _i1.MethodConnector(
          name: 'updateGroup',
          params: {
            'clientProvidedGroup': _i1.ParameterDescription(
              name: 'clientProvidedGroup',
              type: _i1.getType<_i13.Groups>(),
              nullable: false,
            ),
            'newCuratorId': _i1.ParameterDescription(
              name: 'newCuratorId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'newGroupHeadId': _i1.ParameterDescription(
              name: 'newGroupHeadId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).updateGroup(
            session,
            params['clientProvidedGroup'],
            newCuratorId: params['newCuratorId'],
            newGroupHeadId: params['newGroupHeadId'],
          ),
        ),
        'createTeacher': _i1.MethodConnector(
          name: 'createTeacher',
          params: {
            'firstName': _i1.ParameterDescription(
              name: 'firstName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'lastName': _i1.ParameterDescription(
              name: 'lastName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'patronymic': _i1.ParameterDescription(
              name: 'patronymic',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'phoneNumber': _i1.ParameterDescription(
              name: 'phoneNumber',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).createTeacher(
            session,
            firstName: params['firstName'],
            lastName: params['lastName'],
            patronymic: params['patronymic'],
            email: params['email'],
            phoneNumber: params['phoneNumber'],
          ),
        ),
        'createStudent': _i1.MethodConnector(
          name: 'createStudent',
          params: {
            'firstName': _i1.ParameterDescription(
              name: 'firstName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'lastName': _i1.ParameterDescription(
              name: 'lastName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'patronymic': _i1.ParameterDescription(
              name: 'patronymic',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'phoneNumber': _i1.ParameterDescription(
              name: 'phoneNumber',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'groupName': _i1.ParameterDescription(
              name: 'groupName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).createStudent(
            session,
            firstName: params['firstName'],
            lastName: params['lastName'],
            patronymic: params['patronymic'],
            email: params['email'],
            phoneNumber: params['phoneNumber'],
            groupName: params['groupName'],
          ),
        ),
        'getAllTeachers': _i1.MethodConnector(
          name: 'getAllTeachers',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).getAllTeachers(session),
        ),
        'getAllStudents': _i1.MethodConnector(
          name: 'getAllStudents',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).getAllStudents(session),
        ),
        'updatePerson': _i1.MethodConnector(
          name: 'updatePerson',
          params: {
            'person': _i1.ParameterDescription(
              name: 'person',
              type: _i1.getType<_i14.Person>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).updatePerson(
            session,
            params['person'],
          ),
        ),
        'searchStudents': _i1.MethodConnector(
          name: 'searchStudents',
          params: {
            'query': _i1.ParameterDescription(
              name: 'query',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).searchStudents(
            session,
            query: params['query'],
          ),
        ),
        'searchGroups': _i1.MethodConnector(
          name: 'searchGroups',
          params: {
            'query': _i1.ParameterDescription(
              name: 'query',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).searchGroups(
            session,
            query: params['query'],
          ),
        ),
        'updateStudent': _i1.MethodConnector(
          name: 'updateStudent',
          params: {
            'student': _i1.ParameterDescription(
              name: 'student',
              type: _i1.getType<_i15.Students>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).updateStudent(
            session,
            params['student'],
          ),
        ),
        'deleteGroup': _i1.MethodConnector(
          name: 'deleteGroup',
          params: {
            'groupId': _i1.ParameterDescription(
              name: 'groupId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).deleteGroup(
            session,
            params['groupId'],
          ),
        ),
        'getStudentOverallAttendanceRecords': _i1.MethodConnector(
          name: 'getStudentOverallAttendanceRecords',
          params: {
            'studentId': _i1.ParameterDescription(
              name: 'studentId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint)
                  .getStudentOverallAttendanceRecords(
            session,
            params['studentId'],
          ),
        ),
      },
    );
    connectors['classTypes'] = _i1.EndpointConnector(
      name: 'classTypes',
      endpoint: endpoints['classTypes']!,
      methodConnectors: {
        'searchClassTypes': _i1.MethodConnector(
          name: 'searchClassTypes',
          params: {
            'query': _i1.ParameterDescription(
              name: 'query',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['classTypes'] as _i3.ClassTypesEndpoint)
                  .searchClassTypes(
            session,
            query: params['query'],
          ),
        )
      },
    );
    connectors['classes'] = _i1.EndpointConnector(
      name: 'classes',
      endpoint: endpoints['classes']!,
      methodConnectors: {
        'createClass': _i1.MethodConnector(
          name: 'createClass',
          params: {
            'subjectsId': _i1.ParameterDescription(
              name: 'subjectsId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'classTypesId': _i1.ParameterDescription(
              name: 'classTypesId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'teachersId': _i1.ParameterDescription(
              name: 'teachersId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'semestersId': _i1.ParameterDescription(
              name: 'semestersId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'subgroupsId': _i1.ParameterDescription(
              name: 'subgroupsId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'date': _i1.ParameterDescription(
              name: 'date',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'topic': _i1.ParameterDescription(
              name: 'topic',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'notes': _i1.ParameterDescription(
              name: 'notes',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['classes'] as _i4.ClassesEndpoint).createClass(
            session,
            subjectsId: params['subjectsId'],
            classTypesId: params['classTypesId'],
            teachersId: params['teachersId'],
            semestersId: params['semestersId'],
            subgroupsId: params['subgroupsId'],
            date: params['date'],
            topic: params['topic'],
            notes: params['notes'],
          ),
        ),
        'getSubjectsWithClasses': _i1.MethodConnector(
          name: 'getSubjectsWithClasses',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['classes'] as _i4.ClassesEndpoint)
                  .getSubjectsWithClasses(session),
        ),
        'getClassesBySubject': _i1.MethodConnector(
          name: 'getClassesBySubject',
          params: {
            'subjectId': _i1.ParameterDescription(
              name: 'subjectId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['classes'] as _i4.ClassesEndpoint).getClassesBySubject(
            session,
            subjectId: params['subjectId'],
          ),
        ),
        'getStudentsForClassWithAttendance': _i1.MethodConnector(
          name: 'getStudentsForClassWithAttendance',
          params: {
            'classId': _i1.ParameterDescription(
              name: 'classId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['classes'] as _i4.ClassesEndpoint)
                  .getStudentsForClassWithAttendance(
            session,
            classId: params['classId'],
          ),
        ),
        'updateStudentAttendance': _i1.MethodConnector(
          name: 'updateStudentAttendance',
          params: {
            'classId': _i1.ParameterDescription(
              name: 'classId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'studentId': _i1.ParameterDescription(
              name: 'studentId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'isPresent': _i1.ParameterDescription(
              name: 'isPresent',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'comment': _i1.ParameterDescription(
              name: 'comment',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['classes'] as _i4.ClassesEndpoint)
                  .updateStudentAttendance(
            session,
            classId: params['classId'],
            studentId: params['studentId'],
            isPresent: params['isPresent'],
            comment: params['comment'],
          ),
        ),
        'getSubjectOverallAttendance': _i1.MethodConnector(
          name: 'getSubjectOverallAttendance',
          params: {
            'subjectId': _i1.ParameterDescription(
              name: 'subjectId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['classes'] as _i4.ClassesEndpoint)
                  .getSubjectOverallAttendance(
            session,
            subjectId: params['subjectId'],
          ),
        ),
      },
    );
    connectors['semesters'] = _i1.EndpointConnector(
      name: 'semesters',
      endpoint: endpoints['semesters']!,
      methodConnectors: {
        'searchSemesters': _i1.MethodConnector(
          name: 'searchSemesters',
          params: {
            'query': _i1.ParameterDescription(
              name: 'query',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['semesters'] as _i5.SemestersEndpoint).searchSemesters(
            session,
            query: params['query'],
          ),
        )
      },
    );
    connectors['subgroups'] = _i1.EndpointConnector(
      name: 'subgroups',
      endpoint: endpoints['subgroups']!,
      methodConnectors: {
        'getCurrentUserGroup': _i1.MethodConnector(
          name: 'getCurrentUserGroup',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['subgroups'] as _i6.SubgroupsEndpoint)
                  .getCurrentUserGroup(session),
        ),
        'createSubgroup': _i1.MethodConnector(
          name: 'createSubgroup',
          params: {
            'groupId': _i1.ParameterDescription(
              name: 'groupId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['subgroups'] as _i6.SubgroupsEndpoint).createSubgroup(
            session,
            params['groupId'],
            params['name'],
            params['description'],
          ),
        ),
        'createFullGroupSubgroup': _i1.MethodConnector(
          name: 'createFullGroupSubgroup',
          params: {
            'groupId': _i1.ParameterDescription(
              name: 'groupId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['subgroups'] as _i6.SubgroupsEndpoint)
                  .createFullGroupSubgroup(
            session,
            params['groupId'],
            params['name'],
            params['description'],
          ),
        ),
        'getGroupSubgroups': _i1.MethodConnector(
          name: 'getGroupSubgroups',
          params: {
            'groupId': _i1.ParameterDescription(
              name: 'groupId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['subgroups'] as _i6.SubgroupsEndpoint)
                  .getGroupSubgroups(
            session,
            params['groupId'],
          ),
        ),
        'updateSubgroup': _i1.MethodConnector(
          name: 'updateSubgroup',
          params: {
            'subgroupId': _i1.ParameterDescription(
              name: 'subgroupId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['subgroups'] as _i6.SubgroupsEndpoint).updateSubgroup(
            session,
            params['subgroupId'],
            params['name'],
            params['description'],
          ),
        ),
        'deleteSubgroup': _i1.MethodConnector(
          name: 'deleteSubgroup',
          params: {
            'subgroupId': _i1.ParameterDescription(
              name: 'subgroupId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['subgroups'] as _i6.SubgroupsEndpoint).deleteSubgroup(
            session,
            params['subgroupId'],
          ),
        ),
        'getSubgroupStudents': _i1.MethodConnector(
          name: 'getSubgroupStudents',
          params: {
            'subgroupId': _i1.ParameterDescription(
              name: 'subgroupId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['subgroups'] as _i6.SubgroupsEndpoint)
                  .getSubgroupStudents(
            session,
            params['subgroupId'],
          ),
        ),
        'getStudentsNotInSubgroup': _i1.MethodConnector(
          name: 'getStudentsNotInSubgroup',
          params: {
            'subgroupId': _i1.ParameterDescription(
              name: 'subgroupId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['subgroups'] as _i6.SubgroupsEndpoint)
                  .getStudentsNotInSubgroup(
            session,
            params['subgroupId'],
          ),
        ),
        'addStudentToSubgroup': _i1.MethodConnector(
          name: 'addStudentToSubgroup',
          params: {
            'subgroupId': _i1.ParameterDescription(
              name: 'subgroupId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'studentId': _i1.ParameterDescription(
              name: 'studentId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['subgroups'] as _i6.SubgroupsEndpoint)
                  .addStudentToSubgroup(
            session,
            params['subgroupId'],
            params['studentId'],
          ),
        ),
        'removeStudentFromSubgroup': _i1.MethodConnector(
          name: 'removeStudentFromSubgroup',
          params: {
            'subgroupId': _i1.ParameterDescription(
              name: 'subgroupId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'studentId': _i1.ParameterDescription(
              name: 'studentId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['subgroups'] as _i6.SubgroupsEndpoint)
                  .removeStudentFromSubgroup(
            session,
            params['subgroupId'],
            params['studentId'],
          ),
        ),
        'searchSubgroups': _i1.MethodConnector(
          name: 'searchSubgroups',
          params: {
            'query': _i1.ParameterDescription(
              name: 'query',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['subgroups'] as _i6.SubgroupsEndpoint).searchSubgroups(
            session,
            query: params['query'],
          ),
        ),
      },
    );
    connectors['subjectAttendanceMatrix'] = _i1.EndpointConnector(
      name: 'subjectAttendanceMatrix',
      endpoint: endpoints['subjectAttendanceMatrix']!,
      methodConnectors: {
        'getSubjectAttendanceMatrix': _i1.MethodConnector(
          name: 'getSubjectAttendanceMatrix',
          params: {
            'subjectId': _i1.ParameterDescription(
              name: 'subjectId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['subjectAttendanceMatrix']
                      as _i7.SubjectAttendanceMatrixEndpoint)
                  .getSubjectAttendanceMatrix(
            session,
            subjectId: params['subjectId'],
          ),
        )
      },
    );
    connectors['subjects'] = _i1.EndpointConnector(
      name: 'subjects',
      endpoint: endpoints['subjects']!,
      methodConnectors: {
        'searchSubjects': _i1.MethodConnector(
          name: 'searchSubjects',
          params: {
            'query': _i1.ParameterDescription(
              name: 'query',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['subjects'] as _i8.SubjectsEndpoint).searchSubjects(
            session,
            query: params['query'],
          ),
        )
      },
    );
    connectors['teacherSearch'] = _i1.EndpointConnector(
      name: 'teacherSearch',
      endpoint: endpoints['teacherSearch']!,
      methodConnectors: {
        'searchTeachers': _i1.MethodConnector(
          name: 'searchTeachers',
          params: {
            'query': _i1.ParameterDescription(
              name: 'query',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['teacherSearch'] as _i9.TeacherSearchEndpoint)
                  .searchTeachers(
            session,
            query: params['query'],
          ),
        )
      },
    );
    connectors['makeUserAdmin'] = _i1.EndpointConnector(
      name: 'makeUserAdmin',
      endpoint: endpoints['makeUserAdmin']!,
      methodConnectors: {
        'setUserScopes': _i1.MethodConnector(
          name: 'setUserScopes',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['makeUserAdmin'] as _i10.MakeUserAdminEndpoint)
                  .setUserScopes(
            session,
            params['userId'],
          ),
        )
      },
    );
    connectors['userRoles'] = _i1.EndpointConnector(
      name: 'userRoles',
      endpoint: endpoints['userRoles']!,
      methodConnectors: {
        'getUserRoles': _i1.MethodConnector(
          name: 'getUserRoles',
          params: {
            'personId': _i1.ParameterDescription(
              name: 'personId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['userRoles'] as _i11.UserRolesEndpoint).getUserRoles(
            session,
            params['personId'],
          ),
        ),
        'assignRole': _i1.MethodConnector(
          name: 'assignRole',
          params: {
            'personId': _i1.ParameterDescription(
              name: 'personId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'roleToAssign': _i1.ParameterDescription(
              name: 'roleToAssign',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['userRoles'] as _i11.UserRolesEndpoint).assignRole(
            session,
            params['personId'],
            params['roleToAssign'],
          ),
        ),
        'assignCuratorRole': _i1.MethodConnector(
          name: 'assignCuratorRole',
          params: {
            'teacherId': _i1.ParameterDescription(
              name: 'teacherId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['userRoles'] as _i11.UserRolesEndpoint)
                  .assignCuratorRole(
            session,
            params['teacherId'],
          ),
        ),
        'assignGroupHeadRole': _i1.MethodConnector(
          name: 'assignGroupHeadRole',
          params: {
            'studentId': _i1.ParameterDescription(
              name: 'studentId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['userRoles'] as _i11.UserRolesEndpoint)
                  .assignGroupHeadRole(
            session,
            params['studentId'],
          ),
        ),
        'removeRole': _i1.MethodConnector(
          name: 'removeRole',
          params: {
            'personId': _i1.ParameterDescription(
              name: 'personId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'roleToRemove': _i1.ParameterDescription(
              name: 'roleToRemove',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['userRoles'] as _i11.UserRolesEndpoint).removeRole(
            session,
            params['personId'],
            params['roleToRemove'],
          ),
        ),
      },
    );
    connectors['greeting'] = _i1.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['greeting'] as _i12.GreetingEndpoint).hello(
            session,
            params['name'],
          ),
        )
      },
    );
    modules['serverpod_auth'] = _i16.Endpoints()..initializeEndpoints(server);
  }
}
