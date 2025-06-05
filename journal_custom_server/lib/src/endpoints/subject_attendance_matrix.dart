import 'package:journal_custom_server/src/custom_scope.dart';
import 'package:journal_custom_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import '../services/user_subgroup_service.dart';

class SubjectAttendanceMatrixEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {Scope.admin, CustomScope.curator, CustomScope.groupHead, CustomScope.teacher, CustomScope.student, CustomScope.documentSpecialist};

  Future<SubjectAttendanceMatrix> getSubjectAttendanceMatrix(
    Session session, {
    required int subjectId,
  }) async {
    final accessibleSubgroupIds = await UserSubgroupService.getUserAccessibleSubgroupIds(session);
    if (accessibleSubgroupIds.isEmpty) {
      return SubjectAttendanceMatrix(students: [], classes: [], attendanceData: {});
    }
    // Найти занятия по предмету только для доступных подгрупп
    final classesForSubject = await Classes.db.find(
      session,
      where: (c) => c.subjectsId.equals(subjectId) & c.subgroupsId.inSet(accessibleSubgroupIds.toSet()),
      include: Classes.include(
        class_types: ClassTypes.include(),
        subgroups: Subgroups.include(),
      ),
      orderBy: (c) => c.date,
    );
    if (classesForSubject.isEmpty) {
      return SubjectAttendanceMatrix(students: [], classes: [], attendanceData: {});
    }
    // Остальная логика остается прежней, но теперь работает только с доступными подгруппами
    final subgroupIds = classesForSubject
        .where((c) => c.subgroupsId != null)
        .map((c) => c.subgroupsId!)
        .toSet();
    final studentLinks = await StudentSubgroup.db.find(
      session,
      where: (ss) => ss.subgroupsId.inSet(subgroupIds),
      include: StudentSubgroup.include(
        students: Students.include(person: Person.include()),
      ),
    );
    // Получаем уникальный список студентов
    final Map<int, Students> uniqueStudentsMap = {};
    for (var link in studentLinks) {
      if (link.students != null && link.students!.id != null) {
        uniqueStudentsMap[link.students!.id!] = link.students!;
      }
    }
    final allUniqueStudents = uniqueStudentsMap.values.toList();
    // Сортируем студентов по ФИО
    allUniqueStudents.sort((a, b) {
        final lastNameA = a.person?.lastName?.toLowerCase() ?? '';
        final lastNameB = b.person?.lastName?.toLowerCase() ?? '';
        int comp = lastNameA.compareTo(lastNameB);
        if (comp != 0) return comp;
        final firstNameA = a.person?.firstName?.toLowerCase() ?? '';
        final firstNameB = b.person?.firstName?.toLowerCase() ?? '';
        return firstNameA.compareTo(firstNameB);
    });
    if (allUniqueStudents.isEmpty) {
      return SubjectAttendanceMatrix(students: [], classes: classesForSubject, attendanceData: {});
    }
    final allStudentIdsInvolved = allUniqueStudents.map((s) => s.id!).toSet();
    final classIdsForSubject = classesForSubject.map((c) => c.id!).toSet();
    final attendanceRecords = await Attendance.db.find(
      session,
      where: (a) => a.classesId.inSet(classIdsForSubject) & a.studentsId.inSet(allStudentIdsInvolved),
    );
    final Map<int, Map<int, bool>> attendanceData = {};
    for (var student in allUniqueStudents) {
      final studentId = student.id!;
      attendanceData[studentId] = {};
      for (var classItem in classesForSubject) {
        final classId = classItem.id!;
        bool studentBelongsToThisClassSubgroup = studentLinks.any(
            (link) => link.studentsId == studentId && link.subgroupsId == classItem.subgroupsId);
        if (studentBelongsToThisClassSubgroup) {
          final record = attendanceRecords.firstWhere(
            (ar) => ar.classesId == classId && ar.studentsId == studentId,
            orElse: () => Attendance(classesId: classId, studentsId: studentId, isPresent: false),
          );
          attendanceData[studentId]![classId] = record.isPresent;
        }
      }
    }
    return SubjectAttendanceMatrix(
      students: allUniqueStudents,
      classes: classesForSubject,
      attendanceData: attendanceData,
    );
  }

}