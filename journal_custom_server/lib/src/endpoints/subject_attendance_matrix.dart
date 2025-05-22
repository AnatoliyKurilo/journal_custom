import 'package:journal_custom_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class SubjectAttendanceMatrixEndpoint extends Endpoint {
  @override
  bool get requireAuth => true;

  @override
  Set<String> get requiredRoles => {'serverpod.admin', 'curator','groupHead'};


  Future<SubjectAttendanceMatrix> getSubjectAttendanceMatrix(
    Session session, {
    required int subjectId,
  }) async {
    // 1. Найти все занятия (Classes) по этому предмету
    final classesForSubject = await Classes.db.find(
      session,
      where: (c) => c.subjectsId.equals(subjectId),
      include: Classes.include( // Включаем нужные данные для отображения
        // subjects: Subjects.include(), // Уже есть subjectId
        class_types: ClassTypes.include(), // Для возможного отображения типа в заголовке
        subgroups: Subgroups.include(),
      ),
      orderBy: (c) => c.date, // Сортируем по дате занятия
    );

    if (classesForSubject.isEmpty) {
      return SubjectAttendanceMatrix(students: [], classes: [], attendanceData: {});
    }

    // Собираем ID всех подгрупп, связанных с этими занятиями
    final subgroupIds = classesForSubject
        .where((c) => c.subgroupsId != null)
        .map((c) => c.subgroupsId!)
        .toSet();

    if (subgroupIds.isEmpty) {
      return SubjectAttendanceMatrix(students: [], classes: classesForSubject, attendanceData: {});
    }

    // 2. Найти всех уникальных студентов (Students) в этих подгруппах
    final studentLinks = await StudentSubgroup.db.find(
      session,
      where: (ss) => ss.subgroupsId.inSet(subgroupIds),
      include: StudentSubgroup.include(
        students: Students.include(
          person: Person.include(),
        ),
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

    // 3. Найти все записи о посещаемости (Attendance) для этих студентов и этих занятий
    final classIdsForSubject = classesForSubject.map((c) => c.id!).toSet();
    final attendanceRecords = await Attendance.db.find(
      session,
      where: (a) => a.classesId.inSet(classIdsForSubject) & a.studentsId.inSet(allStudentIdsInvolved),
    );

    // 4. Формируем attendanceData: Map<studentId, Map<classId, bool>>
    final Map<int, Map<int, bool>> attendanceData = {};
    for (var student in allUniqueStudents) {
      final studentId = student.id!;
      attendanceData[studentId] = {};
      for (var classItem in classesForSubject) {
        final classId = classItem.id!;
        // Проверяем, относится ли студент к подгруппе этого занятия
        bool studentBelongsToThisClassSubgroup = studentLinks.any(
            (link) => link.studentsId == studentId && link.subgroupsId == classItem.subgroupsId);

        if (studentBelongsToThisClassSubgroup) {
            final record = attendanceRecords.firstWhere(
              (ar) => ar.classesId == classId && ar.studentsId == studentId,
              orElse: () => Attendance(classesId: classId, studentsId: studentId, isPresent: false), // По умолчанию не был
            );
            attendanceData[studentId]![classId] = record.isPresent;
        } else {
            // Если студент не из подгруппы этого занятия, у него не может быть отметки
            // Можно оставить пустым или использовать специальное значение, если нужно явно показать "не относится"
            // Для bool просто не добавляем запись, или false, если все ячейки должны быть заполнены.
            // В данном случае, если студент не в подгруппе, он не должен иметь отметки для этого занятия.
            // Для простоты, если студент не в подгруппе, ячейка будет пустой (не будет ключа classId).
        }
      }
    }

    return SubjectAttendanceMatrix(
      students: allUniqueStudents,
      classes: classesForSubject, // Уже отсортированы по дате
      attendanceData: attendanceData,
    );
  }

}