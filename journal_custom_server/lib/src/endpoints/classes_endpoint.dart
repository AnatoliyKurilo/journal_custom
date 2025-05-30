import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/user_subgroup_service.dart';

class ClassesEndpoint extends Endpoint {
  @override
  bool get requireAuth => true;

  // Обновленный метод для получения предметов с занятиями
  Future<List<Subjects>> getSubjectsWithClasses(Session session) async {
    try {
      return await UserSubgroupService.getUserAccessibleSubjectsWithClasses(session);
    } catch (e, stackTrace) {
      session.log(
        'Ошибка в getSubjectsWithClasses: $e',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  // Обновленный метод для получения занятий по предмету
  Future<List<Classes>> getClassesBySubject(Session session, {required int subjectId}) async {
    try {
      final accessibleSubgroupIds = await UserSubgroupService.getUserAccessibleSubgroupIds(session);
      
      if (accessibleSubgroupIds.isEmpty) {
        return [];
      }

      return await Classes.db.find(
        session,
        where: (c) => c.subjectsId.equals(subjectId) & c.subgroupsId.inSet(accessibleSubgroupIds.toSet()),
        include: Classes.include(
          subjects: Subjects.include(),
          class_types: ClassTypes.include(),
          teachers: Teachers.include(person: Person.include()),
          semesters: Semesters.include(),
          subgroups: Subgroups.include(),
        ),
        orderBy: (c) => c.date,
        orderDescending: true,
      );
    } catch (e, stackTrace) {
      session.log(
        'Ошибка в getClassesBySubject: $e',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  // Обновленный метод создания занятий с проверкой доступа
  Future<Classes> createClass(
    Session session, {
    required int subjectsId,
    required int classTypesId,
    required int teachersId,
    required int semestersId,
    required int subgroupsId,
    required DateTime date,
    String? topic,
    String? notes,
  }) async {
    // Проверяем доступ к подгруппе
    if (!await UserSubgroupService.hasAccessToSubgroup(session, subgroupsId)) {
      throw Exception('Доступ запрещен: нет прав на создание занятий для этой подгруппы.');
    }

    // Проверяем существование связанных объектов
    final existingSubject = await Subjects.db.findById(session, subjectsId);
    if (existingSubject == null) {
      throw Exception('Предмет с ID "$subjectsId" не найден.');
    }

    final existingClassType = await ClassTypes.db.findById(session, classTypesId);
    if (existingClassType == null) {
      throw Exception('Тип занятия с ID "$classTypesId" не найден.');
    }

    final existingTeacher = await Teachers.db.findById(session, teachersId);
    if (existingTeacher == null) {
      throw Exception('Преподаватель с ID "$teachersId" не найден.');
    }

    final existingSemester = await Semesters.db.findById(session, semestersId);
    if (existingSemester == null) {
      throw Exception('Семестр с ID "$semestersId" не найден.');
    }

    final existingSubgroup = await Subgroups.db.findById(session, subgroupsId);
    if (existingSubgroup == null) {
      throw Exception('Подгруппа с ID "$subgroupsId" не найдена.');
    }

    final newClass = Classes(
      subjectsId: subjectsId,
      class_typesId: classTypesId,
      teachersId: teachersId,
      semestersId: semestersId,
      subgroupsId: subgroupsId,
      date: date,
      topic: topic,
      notes: notes,
    );

    return await Classes.db.insertRow(session, newClass);
  }

  // Обновленный метод для получения студентов занятия
  // Future<List<StudentAttendanceInfo>> getStudentsForClassWithAttendance(Session session, {required int classId}) async {
  //   // Получаем информацию о занятии
  //   final classInfo = await Classes.db.findById(
  //     session,
  //     classId,
  //     include: Classes.include(subgroups: Subgroups.include()),
  //   );
  //   if (classInfo == null) {
  //     throw Exception('Занятие с ID $classId не найдено.');
  //   }
  //   // Проверяем доступ к подгруппе этого занятия
  //   if (!await UserSubgroupService.hasAccessToSubgroup(session, classInfo.subgroupsId!)) {
  //     throw Exception('Доступ запрещен: нет прав на просмотр этого занятия.');
  //   }
  //   // Получаем студентов из подгруппы
  //   final studentLinks = await StudentSubgroup.db.find(
  //     session,
  //     where: (ss) => ss.subgroupsId.equals(classInfo.subgroupsId!),
  //     include: StudentSubgroup.include(
  //       students: Students.include(person: Person.include()),
  //     ),
  //   );
  //   final students = studentLinks.map((link) => link.students!).toList();
  //   if (students.isEmpty) {
  //     return [];
  //   }
  //   final studentIds = students.map((s) => s.id!).toList();
  //   // Получаем записи о посещаемости
  //   final attendanceRecords = await Attendance.db.find(
  //     session,
  //     where: (a) => a.classesId.equals(classId) & a.studentsId.inSet(studentIds.toSet()),
  //   );
  //   // Собираем информацию
  //   List<StudentAttendanceInfo> studentAttendanceList = [];
  //   for (var student in students) {
  //     final attendance = attendanceRecords.firstWhere(
  //       (ar) => ar.studentsId == student.id,
  //       orElse: () => Attendance(classesId: classId, studentsId: student.id!, isPresent: false),
  //     );
  //     studentAttendanceList.add(StudentAttendanceInfo(
  //       student: student,
  //       isPresent: attendance.isPresent,
  //       comment: attendance.comment,
  //       attendanceId: attendance.id,
  //     ));
  //   }
  //   return studentAttendanceList;
  // }

  // Обновление/создание записи о посещаемости
  // Future<Attendance> updateStudentAttendance(Session session, {
  //   required int classId,
  //   required int studentId,
  //   required bool isPresent,
  //   String? comment,
  // }) async {
  //   // Проверяем права доступа (например, куратор группы этого занятия или преподаватель)
  //   // Для упрощения пока опустим детальную проверку прав, но в продакшене она обязательна
  //   // ... (код проверки прав) ...
  //   var attendanceRecord = await Attendance.db.findFirstRow(
  //     session,
  //     where: (a) => a.classesId.equals(classId) & a.studentsId.equals(studentId),
  //   );
  //   if (attendanceRecord == null) {
  //     // Создаем новую запись
  //     attendanceRecord = Attendance(
  //       classesId: classId,
  //       studentsId: studentId,
  //       isPresent: isPresent,
  //       comment: comment,
  //     );
  //     return await Attendance.db.insertRow(session, attendanceRecord);
  //   } else {
  //     // Обновляем существующую запись
  //     attendanceRecord.isPresent = isPresent;
  //     attendanceRecord.comment = comment;
  //     return await Attendance.db.updateRow(session, attendanceRecord);
  //   }
  // }

  // Новый метод для получения сводной посещаемости по предмету
  // Future<List<StudentClassAttendanceFlatRecord>> getSubjectOverallAttendance(
  //   Session session, {
  //   required int subjectId,
  // }) async {
  //   final List<StudentClassAttendanceFlatRecord> flatRecords = [];
  //   // 1. Найти все занятия (Classes) по этому предмету
  //   final classesForSubject = await Classes.db.find(
  //     session,
  //     where: (c) => c.subjectsId.equals(subjectId),
  //     include: Classes.include(
  //       // Включаем нужные данные для отображения
  //       subjects: Subjects.include(),
  //       class_types: ClassTypes.include(),
  //       subgroups: Subgroups.include(), // Нужно для получения студентов
  //     ),
  //     orderBy: (c) => c.date, // Сортируем по дате занятия
  //   );
  //   if (classesForSubject.isEmpty) {
  //     return [];
  //   }
  //   // Собираем ID всех подгрупп, связанных с этими занятиями
  //   final subgroupIds = classesForSubject
  //       .where((c) => c.subgroupsId != null)
  //       .map((c) => c.subgroupsId!)
  //       .toSet();
  //   if (subgroupIds.isEmpty) {
  //     return []; // Нет подгрупп, значит нет студентов для отчета
  //   }
  //   // 2. Найти всех студентов (Students) в этих подгруппах
  //   final studentLinks = await StudentSubgroup.db.find(
  //     session,
  //     where: (ss) => ss.subgroupsId.inSet(subgroupIds),
  //     include: StudentSubgroup.include(
  //       students: Students.include(
  //         person: Person.include(),
  //       ),
  //     ),
  //   );
  //   final allStudentsInvolved = studentLinks.map((link) => link.students!).toList();
  //   if (allStudentsInvolved.isEmpty) {
  //     return [];
  //   }
  //   final allStudentIdsInvolved = allStudentsInvolved.map((s) => s.id!).toSet();
  //   // 3. Найти все записи о посещаемости (Attendance) для этих студентов и этих занятий
  //   final classIdsForSubject = classesForSubject.map((c) => c.id!).toSet();
  //   final attendanceRecords = await Attendance.db.find(
  //     session,
  //     where: (a) => a.classesId.inSet(classIdsForSubject) & a.studentsId.inSet(allStudentIdsInvolved),
  //   );
  //   // 4. Формируем плоский список
  //   for (var classItem in classesForSubject) {
  //     // Определяем студентов, которые должны были быть на этом конкретном занятии (из его подгруппы)
  //     final studentsForThisClass = allStudentsInvolved
  //         .where((student) => studentLinks.any((link) => link.studentsId == student.id && link.subgroupsId == classItem.subgroupsId))
  //         .toList();
  //     for (var student in studentsForThisClass) {
  //       final attendance = attendanceRecords.firstWhere(
  //         (ar) => ar.classesId == classItem.id && ar.studentsId == student.id,
  //         orElse: () => Attendance(
  //           classesId: classItem.id!,
  //           studentsId: student.id!,
  //           isPresent: false, // По умолчанию не был, если записи нет
  //         ),
  //       );
  //       flatRecords.add(StudentClassAttendanceFlatRecord(
  //         student: student,
  //         classInfo: classItem, // Передаем весь объект Classes
  //         isPresent: attendance.isPresent,
  //         comment: attendance.comment,
  //       ));
  //     }
  //   }
  //   return flatRecords;
  // }
  
}