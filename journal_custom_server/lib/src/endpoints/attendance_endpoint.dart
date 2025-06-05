import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/user_subgroup_service.dart';

class AttendanceEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  // Получение студентов занятия с посещаемостью
  Future<List<StudentAttendanceInfo>> getStudentsForClassWithAttendance(
    Session session, {
    required int classId
  }) async {
    final classInfo = await Classes.db.findById(
      session,
      classId,
      include: Classes.include(subgroups: Subgroups.include()),
    );

    if (classInfo == null) {
      throw Exception('Занятие с ID $classId не найдено.');
    }

    if (!await UserSubgroupService.hasAccessToSubgroup(session, classInfo.subgroupsId!)) {
      throw Exception('Доступ запрещен: нет прав на просмотр этого занятия.');
    }

    final studentLinks = await StudentSubgroup.db.find(
      session,
      where: (ss) => ss.subgroupsId.equals(classInfo.subgroupsId!),
      include: StudentSubgroup.include(
        students: Students.include(person: Person.include()),
      ),
    );

    final students = studentLinks.map((link) => link.students!).toList();
    if (students.isEmpty) {
      return [];
    }

    final studentIds = students.map((s) => s.id!).toList();
    final attendanceRecords = await Attendance.db.find(
      session,
      where: (a) => a.classesId.equals(classId) & a.studentsId.inSet(studentIds.toSet()),
    );

    List<StudentAttendanceInfo> studentAttendanceList = [];
    for (var student in students) {
      final attendance = attendanceRecords.firstWhere(
        (ar) => ar.studentsId == student.id,
        orElse: () => Attendance(classesId: classId, studentsId: student.id!, isPresent: false),
      );
      studentAttendanceList.add(StudentAttendanceInfo(
        student: student,
        isPresent: attendance.isPresent,
        comment: attendance.comment,
        attendanceId: attendance.id,
      ));
    }
    return studentAttendanceList;
  }

  // Обновление посещаемости студента
  Future<Attendance> updateStudentAttendance(Session session, {
    required int classId,
    required int studentId,
    required bool isPresent,
    String? comment,
  }) async {

  // Проверяем существование занятия
  final classInfo = await Classes.db.findById(session, classId);
  if (classInfo == null) {
    throw Exception('Занятие с ID $classId не найдено.');
  }

  // Проверяем существование студента
  final studentInfo = await Students.db.findById(session, studentId);
  if (studentInfo == null) {
    throw Exception('Студент с ID $studentId не найден.');
  }

    var attendanceRecord = await Attendance.db.findFirstRow(
      session,
      where: (a) => a.classesId.equals(classId) & a.studentsId.equals(studentId),
    );
    if (attendanceRecord == null) {
      attendanceRecord = Attendance(
        classesId: classId,
        studentsId: studentId,
        isPresent: isPresent,
        comment: comment,
      );
      return await Attendance.db.insertRow(session, attendanceRecord);
    } else {
      attendanceRecord.isPresent = isPresent;
      attendanceRecord.comment = comment;
      return await Attendance.db.updateRow(session, attendanceRecord);
    }
  }

  // Получение общей посещаемости по предмету
  Future<List<StudentClassAttendanceFlatRecord>> getSubjectOverallAttendance(
    Session session, {
    required int subjectId,
  }) async {

    if (subjectId <= 0) {
      throw Exception('Предмет с ID $subjectId не найден.');
    }
    // Перенести логику из ClassesEndpoint
    final List<StudentClassAttendanceFlatRecord> flatRecords = [];

    final classesForSubject = await Classes.db.find(
      session,
      where: (c) => c.subjectsId.equals(subjectId),
      include: Classes.include(
        subjects: Subjects.include(),
        class_types: ClassTypes.include(),
        subgroups: Subgroups.include(),
      ),
      orderBy: (c) => c.date,
    );

    if (classesForSubject.isEmpty) {
      return [];
    }

    final subgroupIds = classesForSubject
        .where((c) => c.subgroupsId != null)
        .map((c) => c.subgroupsId!)
        .toSet();

    if (subgroupIds.isEmpty) {
      return [];
    }

    final studentLinks = await StudentSubgroup.db.find(
      session,
      where: (ss) => ss.subgroupsId.inSet(subgroupIds),
      include: StudentSubgroup.include(
        students: Students.include(person: Person.include()),
      ),
    );

    final allStudentsInvolved = studentLinks.map((link) => link.students!).toList();
    if (allStudentsInvolved.isEmpty) {
      return [];
    }

    final allStudentIdsInvolved = allStudentsInvolved.map((s) => s.id!).toSet();
    final classIdsForSubject = classesForSubject.map((c) => c.id!).toSet();
    
    final attendanceRecords = await Attendance.db.find(
      session,
      where: (a) => a.classesId.inSet(classIdsForSubject) & a.studentsId.inSet(allStudentIdsInvolved),
    );

    for (var classItem in classesForSubject) {
      final studentsForThisClass = allStudentsInvolved
          .where((student) => studentLinks.any((link) => link.studentsId == student.id && link.subgroupsId == classItem.subgroupsId))
          .toList();

      for (var student in studentsForThisClass) {
        final attendance = attendanceRecords.firstWhere(
          (ar) => ar.classesId == classItem.id && ar.studentsId == student.id,
          orElse: () => Attendance(
            classesId: classItem.id!,
            studentsId: student.id!,
            isPresent: false,
          ),
        );
        flatRecords.add(StudentClassAttendanceFlatRecord(
          student: student,
          classInfo: classItem,
          isPresent: attendance.isPresent,
          comment: attendance.comment,
        ));
      }
    }
    return flatRecords;
  }

  // Получение матрицы посещаемости по предмету
  Future<SubjectAttendanceMatrix> getSubjectAttendanceMatrix(
    Session session, {
    required int subjectId,
  }) async {
    // Перенести логику из SubjectAttendanceMatrixEndpoint
    final accessibleSubgroupIds = await UserSubgroupService.getUserAccessibleSubgroupIds(session);
    
    final subject = await Subjects.db.findById(session, subjectId);
    if (subject == null) {
      throw Exception('Предмет с ID $subjectId не найден.');
    }

    if (accessibleSubgroupIds.isEmpty) {
      return SubjectAttendanceMatrix(students: [], classes: [], attendanceData: {});
    }

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

    final Map<int, Students> uniqueStudentsMap = {};
    for (var link in studentLinks) {
      if (link.students != null && link.students!.id != null) {
        uniqueStudentsMap[link.students!.id!] = link.students!;
      }
    }
    final allUniqueStudents = uniqueStudentsMap.values.toList();
    
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