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
import '../endpoints/attendance_endpoint.dart' as _i3;
import '../endpoints/class_types_endpoint.dart' as _i4;
import '../endpoints/classes_endpoint.dart' as _i5;
import '../endpoints/groups_endpoint.dart' as _i6;
import '../endpoints/person_endpoint.dart' as _i7;
import '../endpoints/rasp_endpoint.dart' as _i8;
import '../endpoints/search_endpoint.dart' as _i9;
import '../endpoints/semesters_endpoint.dart' as _i10;
import '../endpoints/students_endpoint.dart' as _i11;
import '../endpoints/subgroups_endpoint.dart' as _i12;
import '../endpoints/subject_attendance_matrix.dart' as _i13;
import '../endpoints/subjects_endpoint.dart' as _i14;
import '../endpoints/teachers_endpoint.dart' as _i15;
import '../endpoints/teachers_search_endpoint.dart' as _i16;
import '../endpoints/user_endpoint.dart' as _i17;
import '../endpoints/user_roles_endpoint.dart' as _i18;
import '../greeting_endpoint.dart' as _i19;
import 'package:journal_custom_server/src/generated/groups_protocol.dart'
    as _i20;
import 'package:journal_custom_server/src/generated/person.dart' as _i21;
import 'package:journal_custom_server/src/generated/students_protocol.dart'
    as _i22;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i23;

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
      'attendance': _i3.AttendanceEndpoint()
        ..initialize(
          server,
          'attendance',
          null,
        ),
      'classTypes': _i4.ClassTypesEndpoint()
        ..initialize(
          server,
          'classTypes',
          null,
        ),
      'classes': _i5.ClassesEndpoint()
        ..initialize(
          server,
          'classes',
          null,
        ),
      'groups': _i6.GroupsEndpoint()
        ..initialize(
          server,
          'groups',
          null,
        ),
      'person': _i7.PersonEndpoint()
        ..initialize(
          server,
          'person',
          null,
        ),
      'rasp': _i8.RaspEndpoint()
        ..initialize(
          server,
          'rasp',
          null,
        ),
      'search': _i9.SearchEndpoint()
        ..initialize(
          server,
          'search',
          null,
        ),
      'semesters': _i10.SemestersEndpoint()
        ..initialize(
          server,
          'semesters',
          null,
        ),
      'students': _i11.StudentsEndpoint()
        ..initialize(
          server,
          'students',
          null,
        ),
      'subgroups': _i12.SubgroupsEndpoint()
        ..initialize(
          server,
          'subgroups',
          null,
        ),
      'subjectAttendanceMatrix': _i13.SubjectAttendanceMatrixEndpoint()
        ..initialize(
          server,
          'subjectAttendanceMatrix',
          null,
        ),
      'subjects': _i14.SubjectsEndpoint()
        ..initialize(
          server,
          'subjects',
          null,
        ),
      'teachers': _i15.TeachersEndpoint()
        ..initialize(
          server,
          'teachers',
          null,
        ),
      'teacherSearch': _i16.TeacherSearchEndpoint()
        ..initialize(
          server,
          'teacherSearch',
          null,
        ),
      'makeUserAdmin': _i17.MakeUserAdminEndpoint()
        ..initialize(
          server,
          'makeUserAdmin',
          null,
        ),
      'userRoles': _i18.UserRolesEndpoint()
        ..initialize(
          server,
          'userRoles',
          null,
        ),
      'greeting': _i19.GreetingEndpoint()
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
      },
    );
    connectors['attendance'] = _i1.EndpointConnector(
      name: 'attendance',
      endpoint: endpoints['attendance']!,
      methodConnectors: {
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
              (endpoints['attendance'] as _i3.AttendanceEndpoint)
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
              (endpoints['attendance'] as _i3.AttendanceEndpoint)
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
              (endpoints['attendance'] as _i3.AttendanceEndpoint)
                  .getSubjectOverallAttendance(
            session,
            subjectId: params['subjectId'],
          ),
        ),
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
              (endpoints['attendance'] as _i3.AttendanceEndpoint)
                  .getSubjectAttendanceMatrix(
            session,
            subjectId: params['subjectId'],
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
              (endpoints['classTypes'] as _i4.ClassTypesEndpoint)
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
        'getSubjectsWithClasses': _i1.MethodConnector(
          name: 'getSubjectsWithClasses',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['classes'] as _i5.ClassesEndpoint)
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
              (endpoints['classes'] as _i5.ClassesEndpoint).getClassesBySubject(
            session,
            subjectId: params['subjectId'],
          ),
        ),
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
              (endpoints['classes'] as _i5.ClassesEndpoint).createClass(
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
        'getSubjectsForGroup': _i1.MethodConnector(
          name: 'getSubjectsForGroup',
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
              (endpoints['classes'] as _i5.ClassesEndpoint).getSubjectsForGroup(
            session,
            params['groupId'],
          ),
        ),
        'importClassesFromScheduleForGroup': _i1.MethodConnector(
          name: 'importClassesFromScheduleForGroup',
          params: {
            'groupId': _i1.ParameterDescription(
              name: 'groupId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'year': _i1.ParameterDescription(
              name: 'year',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'startDate': _i1.ParameterDescription(
              name: 'startDate',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'endDate': _i1.ParameterDescription(
              name: 'endDate',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['classes'] as _i5.ClassesEndpoint)
                  .importClassesFromScheduleForGroup(
            session,
            params['groupId'],
            params['year'],
            startDate: params['startDate'],
            endDate: params['endDate'],
          ),
        ),
        'updateClass': _i1.MethodConnector(
          name: 'updateClass',
          params: {
            'classId': _i1.ParameterDescription(
              name: 'classId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'subjectsId': _i1.ParameterDescription(
              name: 'subjectsId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'classTypesId': _i1.ParameterDescription(
              name: 'classTypesId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'teachersId': _i1.ParameterDescription(
              name: 'teachersId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'semestersId': _i1.ParameterDescription(
              name: 'semestersId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'subgroupsId': _i1.ParameterDescription(
              name: 'subgroupsId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'date': _i1.ParameterDescription(
              name: 'date',
              type: _i1.getType<DateTime?>(),
              nullable: true,
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
              (endpoints['classes'] as _i5.ClassesEndpoint).updateClass(
            session,
            classId: params['classId'],
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
        'deleteClass': _i1.MethodConnector(
          name: 'deleteClass',
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
              (endpoints['classes'] as _i5.ClassesEndpoint).deleteClass(
            session,
            params['classId'],
          ),
        ),
      },
    );
    connectors['groups'] = _i1.EndpointConnector(
      name: 'groups',
      endpoint: endpoints['groups']!,
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
              (endpoints['groups'] as _i6.GroupsEndpoint).createGroup(
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
              (endpoints['groups'] as _i6.GroupsEndpoint).getAllGroups(session),
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
              (endpoints['groups'] as _i6.GroupsEndpoint).getGroupByName(
            session,
            params['groupName'],
          ),
        ),
        'updateGroup': _i1.MethodConnector(
          name: 'updateGroup',
          params: {
            'clientProvidedGroup': _i1.ParameterDescription(
              name: 'clientProvidedGroup',
              type: _i1.getType<_i20.Groups>(),
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
              (endpoints['groups'] as _i6.GroupsEndpoint).updateGroup(
            session,
            params['clientProvidedGroup'],
            newCuratorId: params['newCuratorId'],
            newGroupHeadId: params['newGroupHeadId'],
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
              (endpoints['groups'] as _i6.GroupsEndpoint).deleteGroup(
            session,
            params['groupId'],
          ),
        ),
        'importGroupsFromSchedule': _i1.MethodConnector(
          name: 'importGroupsFromSchedule',
          params: {
            'year': _i1.ParameterDescription(
              name: 'year',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['groups'] as _i6.GroupsEndpoint)
                  .importGroupsFromSchedule(
            session,
            params['year'],
          ),
        ),
        'synchronizeGroupIdsWithSchedule': _i1.MethodConnector(
          name: 'synchronizeGroupIdsWithSchedule',
          params: {
            'year': _i1.ParameterDescription(
              name: 'year',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['groups'] as _i6.GroupsEndpoint)
                  .synchronizeGroupIdsWithSchedule(
            session,
            params['year'],
          ),
        ),
      },
    );
    connectors['person'] = _i1.EndpointConnector(
      name: 'person',
      endpoint: endpoints['person']!,
      methodConnectors: {
        'createPerson': _i1.MethodConnector(
          name: 'createPerson',
          params: {
            'person': _i1.ParameterDescription(
              name: 'person',
              type: _i1.getType<_i21.Person>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['person'] as _i7.PersonEndpoint).createPerson(
            session,
            params['person'],
          ),
        ),
        'getPerson': _i1.MethodConnector(
          name: 'getPerson',
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
              (endpoints['person'] as _i7.PersonEndpoint).getPerson(
            session,
            params['personId'],
          ),
        ),
        'updatePerson': _i1.MethodConnector(
          name: 'updatePerson',
          params: {
            'person': _i1.ParameterDescription(
              name: 'person',
              type: _i1.getType<_i21.Person>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['person'] as _i7.PersonEndpoint).updatePerson(
            session,
            params['person'],
          ),
        ),
        'deletePerson': _i1.MethodConnector(
          name: 'deletePerson',
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
              (endpoints['person'] as _i7.PersonEndpoint).deletePerson(
            session,
            params['personId'],
          ),
        ),
        'getAllPersons': _i1.MethodConnector(
          name: 'getAllPersons',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['person'] as _i7.PersonEndpoint)
                  .getAllPersons(session),
        ),
      },
    );
    connectors['rasp'] = _i1.EndpointConnector(
      name: 'rasp',
      endpoint: endpoints['rasp']!,
      methodConnectors: {
        'getAvailableYears': _i1.MethodConnector(
          name: 'getAvailableYears',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['rasp'] as _i8.RaspEndpoint)
                  .getAvailableYears(session),
        ),
        'getGroupsList': _i1.MethodConnector(
          name: 'getGroupsList',
          params: {
            'year': _i1.ParameterDescription(
              name: 'year',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['rasp'] as _i8.RaspEndpoint).getGroupsList(
            session,
            params['year'],
          ),
        ),
        'getGroupsByFaculty': _i1.MethodConnector(
          name: 'getGroupsByFaculty',
          params: {
            'year': _i1.ParameterDescription(
              name: 'year',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'faculty': _i1.ParameterDescription(
              name: 'faculty',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['rasp'] as _i8.RaspEndpoint).getGroupsByFaculty(
            session,
            params['year'],
            params['faculty'],
          ),
        ),
        'getGroupsByCourse': _i1.MethodConnector(
          name: 'getGroupsByCourse',
          params: {
            'year': _i1.ParameterDescription(
              name: 'year',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'course': _i1.ParameterDescription(
              name: 'course',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['rasp'] as _i8.RaspEndpoint).getGroupsByCourse(
            session,
            params['year'],
            params['course'],
          ),
        ),
        'getGroupById': _i1.MethodConnector(
          name: 'getGroupById',
          params: {
            'year': _i1.ParameterDescription(
              name: 'year',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'groupId': _i1.ParameterDescription(
              name: 'groupId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['rasp'] as _i8.RaspEndpoint).getGroupById(
            session,
            params['year'],
            params['groupId'],
          ),
        ),
        'getFaculties': _i1.MethodConnector(
          name: 'getFaculties',
          params: {
            'year': _i1.ParameterDescription(
              name: 'year',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['rasp'] as _i8.RaspEndpoint).getFaculties(
            session,
            params['year'],
          ),
        ),
        'getTeachersList': _i1.MethodConnector(
          name: 'getTeachersList',
          params: {
            'year': _i1.ParameterDescription(
              name: 'year',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['rasp'] as _i8.RaspEndpoint).getTeachersList(
            session,
            params['year'],
          ),
        ),
        'getTeacherById': _i1.MethodConnector(
          name: 'getTeacherById',
          params: {
            'year': _i1.ParameterDescription(
              name: 'year',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'teacherId': _i1.ParameterDescription(
              name: 'teacherId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['rasp'] as _i8.RaspEndpoint).getTeacherById(
            session,
            params['year'],
            params['teacherId'],
          ),
        ),
        'searchTeachersByName': _i1.MethodConnector(
          name: 'searchTeachersByName',
          params: {
            'year': _i1.ParameterDescription(
              name: 'year',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'searchQuery': _i1.ParameterDescription(
              name: 'searchQuery',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['rasp'] as _i8.RaspEndpoint).searchTeachersByName(
            session,
            params['year'],
            params['searchQuery'],
          ),
        ),
        'getTeachersByDepartment': _i1.MethodConnector(
          name: 'getTeachersByDepartment',
          params: {
            'year': _i1.ParameterDescription(
              name: 'year',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'department': _i1.ParameterDescription(
              name: 'department',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['rasp'] as _i8.RaspEndpoint).getTeachersByDepartment(
            session,
            params['year'],
            params['department'],
          ),
        ),
        'getDepartments': _i1.MethodConnector(
          name: 'getDepartments',
          params: {
            'year': _i1.ParameterDescription(
              name: 'year',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['rasp'] as _i8.RaspEndpoint).getDepartments(
            session,
            params['year'],
          ),
        ),
        'getScheduleForGroup': _i1.MethodConnector(
          name: 'getScheduleForGroup',
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
              (endpoints['rasp'] as _i8.RaspEndpoint).getScheduleForGroup(
            session,
            params['groupId'],
          ),
        ),
        'checkApiAvailability': _i1.MethodConnector(
          name: 'checkApiAvailability',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['rasp'] as _i8.RaspEndpoint)
                  .checkApiAvailability(session),
        ),
        'checkGroupExists': _i1.MethodConnector(
          name: 'checkGroupExists',
          params: {
            'groupId': _i1.ParameterDescription(
              name: 'groupId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'year': _i1.ParameterDescription(
              name: 'year',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['rasp'] as _i8.RaspEndpoint).checkGroupExists(
            session,
            params['groupId'],
            params['year'],
          ),
        ),
        'getClassesForGroup': _i1.MethodConnector(
          name: 'getClassesForGroup',
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
              (endpoints['rasp'] as _i8.RaspEndpoint).getClassesForGroup(
            session,
            params['groupId'],
          ),
        ),
        'getScheduleForTeacher': _i1.MethodConnector(
          name: 'getScheduleForTeacher',
          params: {
            'teacherId': _i1.ParameterDescription(
              name: 'teacherId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'year': _i1.ParameterDescription(
              name: 'year',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['rasp'] as _i8.RaspEndpoint).getScheduleForTeacher(
            session,
            params['teacherId'],
            params['year'],
          ),
        ),
        'getClassesForTeacher': _i1.MethodConnector(
          name: 'getClassesForTeacher',
          params: {
            'teacherId': _i1.ParameterDescription(
              name: 'teacherId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'year': _i1.ParameterDescription(
              name: 'year',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['rasp'] as _i8.RaspEndpoint).getClassesForTeacher(
            session,
            params['teacherId'],
            params['year'],
          ),
        ),
        'getSubjectsForGroup': _i1.MethodConnector(
          name: 'getSubjectsForGroup',
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
              (endpoints['rasp'] as _i8.RaspEndpoint).getSubjectsForGroup(
            session,
            params['groupId'],
          ),
        ),
        'getTeachersForGroup': _i1.MethodConnector(
          name: 'getTeachersForGroup',
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
              (endpoints['rasp'] as _i8.RaspEndpoint).getTeachersForGroup(
            session,
            params['groupId'],
          ),
        ),
        'getWeekSchedule': _i1.MethodConnector(
          name: 'getWeekSchedule',
          params: {
            'groupId': _i1.ParameterDescription(
              name: 'groupId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'weekStart': _i1.ParameterDescription(
              name: 'weekStart',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['rasp'] as _i8.RaspEndpoint).getWeekSchedule(
            session,
            params['groupId'],
            params['weekStart'],
          ),
        ),
        'getScheduleForDate': _i1.MethodConnector(
          name: 'getScheduleForDate',
          params: {
            'groupId': _i1.ParameterDescription(
              name: 'groupId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'date': _i1.ParameterDescription(
              name: 'date',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['rasp'] as _i8.RaspEndpoint).getScheduleForDate(
            session,
            params['groupId'],
            params['date'],
          ),
        ),
        'getWeekScheduleDetailed': _i1.MethodConnector(
          name: 'getWeekScheduleDetailed',
          params: {
            'groupId': _i1.ParameterDescription(
              name: 'groupId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'weekStart': _i1.ParameterDescription(
              name: 'weekStart',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['rasp'] as _i8.RaspEndpoint).getWeekScheduleDetailed(
            session,
            params['groupId'],
            params['weekStart'],
          ),
        ),
      },
    );
    connectors['search'] = _i1.EndpointConnector(
      name: 'search',
      endpoint: endpoints['search']!,
      methodConnectors: {
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
              (endpoints['search'] as _i9.SearchEndpoint).searchStudents(
            session,
            query: params['query'],
          ),
        ),
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
              (endpoints['search'] as _i9.SearchEndpoint).searchTeachers(
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
              (endpoints['search'] as _i9.SearchEndpoint).searchGroups(
            session,
            query: params['query'],
          ),
        ),
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
              (endpoints['search'] as _i9.SearchEndpoint).searchSubjects(
            session,
            query: params['query'],
          ),
        ),
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
              (endpoints['search'] as _i9.SearchEndpoint).searchClassTypes(
            session,
            query: params['query'],
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
              (endpoints['search'] as _i9.SearchEndpoint).searchSubgroups(
            session,
            query: params['query'],
          ),
        ),
        'getAllStudentsForAdmin': _i1.MethodConnector(
          name: 'getAllStudentsForAdmin',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['search'] as _i9.SearchEndpoint)
                  .getAllStudentsForAdmin(session),
        ),
        'getStudentsForCurator': _i1.MethodConnector(
          name: 'getStudentsForCurator',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['search'] as _i9.SearchEndpoint)
                  .getStudentsForCurator(session),
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
              (endpoints['semesters'] as _i10.SemestersEndpoint)
                  .searchSemesters(
            session,
            query: params['query'],
          ),
        )
      },
    );
    connectors['students'] = _i1.EndpointConnector(
      name: 'students',
      endpoint: endpoints['students']!,
      methodConnectors: {
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
            'recordBookNumber': _i1.ParameterDescription(
              name: 'recordBookNumber',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['students'] as _i11.StudentsEndpoint).createStudent(
            session,
            firstName: params['firstName'],
            lastName: params['lastName'],
            patronymic: params['patronymic'],
            email: params['email'],
            phoneNumber: params['phoneNumber'],
            groupName: params['groupName'],
            recordBookNumber: params['recordBookNumber'],
          ),
        ),
        'getAllStudents': _i1.MethodConnector(
          name: 'getAllStudents',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['students'] as _i11.StudentsEndpoint)
                  .getAllStudents(session),
        ),
        'updateStudent': _i1.MethodConnector(
          name: 'updateStudent',
          params: {
            'student': _i1.ParameterDescription(
              name: 'student',
              type: _i1.getType<_i22.Students>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['students'] as _i11.StudentsEndpoint).updateStudent(
            session,
            params['student'],
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
              (endpoints['students'] as _i11.StudentsEndpoint)
                  .getStudentOverallAttendanceRecords(
            session,
            params['studentId'],
          ),
        ),
        'getStudentsByGroup': _i1.MethodConnector(
          name: 'getStudentsByGroup',
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
              (endpoints['students'] as _i11.StudentsEndpoint)
                  .getStudentsByGroup(
            session,
            params['groupName'],
          ),
        ),
        'getStudentsByGroupId': _i1.MethodConnector(
          name: 'getStudentsByGroupId',
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
              (endpoints['students'] as _i11.StudentsEndpoint)
                  .getStudentsByGroupId(
            session,
            params['groupId'],
          ),
        ),
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
              (endpoints['subgroups'] as _i12.SubgroupsEndpoint)
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
              (endpoints['subgroups'] as _i12.SubgroupsEndpoint).createSubgroup(
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
              (endpoints['subgroups'] as _i12.SubgroupsEndpoint)
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
              (endpoints['subgroups'] as _i12.SubgroupsEndpoint)
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
              (endpoints['subgroups'] as _i12.SubgroupsEndpoint).updateSubgroup(
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
              (endpoints['subgroups'] as _i12.SubgroupsEndpoint).deleteSubgroup(
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
              (endpoints['subgroups'] as _i12.SubgroupsEndpoint)
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
              (endpoints['subgroups'] as _i12.SubgroupsEndpoint)
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
              (endpoints['subgroups'] as _i12.SubgroupsEndpoint)
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
              (endpoints['subgroups'] as _i12.SubgroupsEndpoint)
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
              (endpoints['subgroups'] as _i12.SubgroupsEndpoint)
                  .searchSubgroups(
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
                      as _i13.SubjectAttendanceMatrixEndpoint)
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
              (endpoints['subjects'] as _i14.SubjectsEndpoint).searchSubjects(
            session,
            query: params['query'],
          ),
        )
      },
    );
    connectors['teachers'] = _i1.EndpointConnector(
      name: 'teachers',
      endpoint: endpoints['teachers']!,
      methodConnectors: {
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
              (endpoints['teachers'] as _i15.TeachersEndpoint).createTeacher(
            session,
            firstName: params['firstName'],
            lastName: params['lastName'],
            patronymic: params['patronymic'],
            email: params['email'],
            phoneNumber: params['phoneNumber'],
          ),
        ),
        'getAllTeachers': _i1.MethodConnector(
          name: 'getAllTeachers',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['teachers'] as _i15.TeachersEndpoint)
                  .getAllTeachers(session),
        ),
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
              (endpoints['teacherSearch'] as _i16.TeacherSearchEndpoint)
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
              (endpoints['makeUserAdmin'] as _i17.MakeUserAdminEndpoint)
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
              (endpoints['userRoles'] as _i18.UserRolesEndpoint).getUserRoles(
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
              (endpoints['userRoles'] as _i18.UserRolesEndpoint).assignRole(
            session,
            params['personId'],
            params['roleToAssign'],
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
              (endpoints['userRoles'] as _i18.UserRolesEndpoint).removeRole(
            session,
            params['personId'],
            params['roleToRemove'],
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
              (endpoints['userRoles'] as _i18.UserRolesEndpoint)
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
              (endpoints['userRoles'] as _i18.UserRolesEndpoint)
                  .assignGroupHeadRole(
            session,
            params['studentId'],
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
              (endpoints['greeting'] as _i19.GreetingEndpoint).hello(
            session,
            params['name'],
          ),
        )
      },
    );
    modules['serverpod_auth'] = _i23.Endpoints()..initializeEndpoints(server);
  }
}
