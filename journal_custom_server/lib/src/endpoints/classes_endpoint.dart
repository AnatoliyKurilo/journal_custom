import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class ClassesEndpoint extends Endpoint {
  @override
  bool get requireAuth => true;

  @override
  Set<String> get requiredRoles => {'serverpod.admin', 'curator','groupHead'};

  // Метод для создания занятия
  Future<Classes> createClass(
    Session session, {
    required int subjectsId,
    required int classTypesId,
    required int teachersId,
    required int semestersId,
    required int subgroupsId,
    required DateTime date,
    String? topic, // Новое поле
    String? notes, // Новое поле
  }) async {
    // Проверяем, существует ли дисциплина
    final existingSubject = await Subjects.db.findById(session, subjectsId);
    if (existingSubject == null) {
      throw Exception('Дисциплина с ID "$subjectsId" не найдена.');
    }

    // Проверяем, существует ли тип занятия
    final existingClassType = await ClassTypes.db.findById(session, classTypesId);
    if (existingClassType == null) {
      throw Exception('Тип занятия с ID "$classTypesId" не найден.');
    }

    // Проверяем, существует ли преподаватель
    final existingTeacher = await Teachers.db.findById(session, teachersId);
    if (existingTeacher == null) {
      throw Exception('Преподаватель с ID "$teachersId" не найден.');
    }

    // Проверяем, существует ли семестр
    final existingSemester = await Semesters.db.findById(session, semestersId);
    if (existingSemester == null) {
      throw Exception('Семестр с ID "$semestersId" не найден.');
    }

    // Проверяем, существует ли подгруппа
    final existingSubgroup = await Subgroups.db.findById(session, subgroupsId);
    if (existingSubgroup == null) {
      throw Exception('Подгруппа с ID "$subgroupsId" не найдена.');
    }

    // Создаем запись о занятии
    final newClass = Classes(
      subjectsId: subjectsId,
      class_typesId: classTypesId,
      teachersId: teachersId,
      semestersId: semestersId,
      subgroupsId: subgroupsId,
      date: date,
      topic: topic, // Добавляем новое поле
      notes: notes, // Добавляем новое поле
    );

    return await Classes.db.insertRow(session, newClass);
  }

  Future<List<Subjects>> getSubjectsWithClasses(Session session) async {
    try {
      // Получаем все записи из таблицы Classes
      final classEntries = await Classes.db.find(session);

      // Преобразуем результат в список идентификаторов и убираем повторения
      final subjectIds = classEntries.map((entry) => entry.subjectsId!).toSet().toList();

      // Если предметов нет, возвращаем пустой список
      if (subjectIds.isEmpty) {
        return [];
      }

      // Построение выражения для фильтрации
      Expression<dynamic>? whereExpression;
      for (var id in subjectIds) {
        var condition = Subjects.t.id.equals(id);
        whereExpression = (whereExpression == null) ? condition : (whereExpression | condition);
      }

      // Получаем список предметов по построенному выражению
      return await Subjects.db.find(
        session,
        where: (s) => whereExpression!,
        orderBy: (t) => t.name, // Сортировка по названию
        orderDescending: false,
      );
    } catch (e, stackTrace) {
      session.log(
        'Ошибка в getSubjectsWithClasses: $e',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      // В случае ошибки возвращаем пустой список
      return [];
    }
  }

  Future<List<Classes>> getClassesBySubject(Session session, {required int subjectId}) async {
    try {
      return await Classes.db.find(
        session,
        where: (c) => c.subjectsId.equals(subjectId),
        // Вы можете добавить orderBy, например, по дате
        orderBy: (c) => c.date,
        orderDescending: true, // Сначала новые занятия
        // Если вам нужна информация о типе занятия, преподавателе и т.д. сразу,
        // используйте include:
        include: Classes.include(
          class_types: ClassTypes.include(),
          teachers: Teachers.include(
            person: Person.include(),
          ),
          semesters: Semesters.include(),
          subgroups: Subgroups.include(),
        ),
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
  // Получение студентов для занятия и их статуса посещаемости
  Future<List<StudentAttendanceInfo>> getStudentsForClassWithAttendance(Session session, {required int classId}) async {
    // 1. Получаем информацию о занятии, включая подгруппу
    final classInfo = await Classes.db.findById(
      session,
      classId,
      include: Classes.include(
        subgroups: Subgroups.include(), // Нам нужна подгруппа этого занятия
      ),
    );

    if (classInfo == null) {
      throw Exception('Занятие с ID $classId не найдено.');
    }
    if (classInfo.subgroupsId == null) {
      // Этого не должно быть, если логика создания занятия корректна
      throw Exception('Для занятия с ID $classId не определена подгруппа.');
    }

    // 2. Получаем студентов из подгруппы этого занятия
    final studentLinks = await StudentSubgroup.db.find(
      session,
      where: (ss) => ss.subgroupsId.equals(classInfo.subgroupsId!),
      include: StudentSubgroup.include(
        students: Students.include(
          person: Person.include(), // Включаем данные Person для отображения ФИО
        ),
      ),
    );

    final students = studentLinks.map((link) => link.students!).toList();
    if (students.isEmpty) {
      return []; // Нет студентов в подгруппе
    }

    final studentIds = students.map((s) => s.id!).toList();

    // 3. Получаем записи о посещаемости для этих студентов на этом занятии
    final attendanceRecords = await Attendance.db.find(
      session,
      where: (a) => a.classesId.equals(classId) & a.studentsId.inSet(studentIds.toSet()),
    );

    // 4. Собираем информацию в один список
    List<StudentAttendanceInfo> studentAttendanceList = [];
    for (var student in students) {
      final attendance = attendanceRecords.firstWhere(
        (ar) => ar.studentsId == student.id,
        orElse: () => Attendance(classesId: classId, studentsId: student.id!, isPresent: false), // По умолчанию не присутствовал
      );
      studentAttendanceList.add(StudentAttendanceInfo(
        student: student,
        isPresent: attendance.isPresent,
        comment: attendance.comment,
        attendanceId: attendance.id, // ID записи о посещаемости, если она есть
      ));
    }
    return studentAttendanceList;
  }

  // Обновление/создание записи о посещаемости
  Future<Attendance> updateStudentAttendance(Session session, {
    required int classId,
    required int studentId,
    required bool isPresent,
    String? comment,
  }) async {
    // Проверяем права доступа (например, куратор группы этого занятия или преподаватель)
    // Для упрощения пока опустим детальную проверку прав, но в продакшене она обязательна
    // ... (код проверки прав) ...

    var attendanceRecord = await Attendance.db.findFirstRow(
      session,
      where: (a) => a.classesId.equals(classId) & a.studentsId.equals(studentId),
    );

    if (attendanceRecord == null) {
      // Создаем новую запись
      attendanceRecord = Attendance(
        classesId: classId,
        studentsId: studentId,
        isPresent: isPresent,
        comment: comment,
      );
      return await Attendance.db.insertRow(session, attendanceRecord);
    } else {
      // Обновляем существующую запись
      attendanceRecord.isPresent = isPresent;
      attendanceRecord.comment = comment;
      return await Attendance.db.updateRow(session, attendanceRecord);
    }
  }

  // Новый метод для получения сводной посещаемости по предмету
  Future<List<StudentClassAttendanceFlatRecord>> getSubjectOverallAttendance(
    Session session, {
    required int subjectId,
  }) async {
    final List<StudentClassAttendanceFlatRecord> flatRecords = [];

    // 1. Найти все занятия (Classes) по этому предмету
    final classesForSubject = await Classes.db.find(
      session,
      where: (c) => c.subjectsId.equals(subjectId),
      include: Classes.include(
        // Включаем нужные данные для отображения
        subjects: Subjects.include(),
        class_types: ClassTypes.include(),
        subgroups: Subgroups.include(), // Нужно для получения студентов
      ),
      orderBy: (c) => c.date, // Сортируем по дате занятия
    );

    if (classesForSubject.isEmpty) {
      return [];
    }

    // Собираем ID всех подгрупп, связанных с этими занятиями
    final subgroupIds = classesForSubject
        .where((c) => c.subgroupsId != null)
        .map((c) => c.subgroupsId!)
        .toSet();

    if (subgroupIds.isEmpty) {
      return []; // Нет подгрупп, значит нет студентов для отчета
    }

    // 2. Найти всех студентов (Students) в этих подгруппах
    final studentLinks = await StudentSubgroup.db.find(
      session,
      where: (ss) => ss.subgroupsId.inSet(subgroupIds),
      include: StudentSubgroup.include(
        students: Students.include(
          person: Person.include(),
        ),
      ),
    );
    final allStudentsInvolved = studentLinks.map((link) => link.students!).toList();
    if (allStudentsInvolved.isEmpty) {
      return [];
    }
    final allStudentIdsInvolved = allStudentsInvolved.map((s) => s.id!).toSet();


    // 3. Найти все записи о посещаемости (Attendance) для этих студентов и этих занятий
    final classIdsForSubject = classesForSubject.map((c) => c.id!).toSet();
    final attendanceRecords = await Attendance.db.find(
      session,
      where: (a) => a.classesId.inSet(classIdsForSubject) & a.studentsId.inSet(allStudentIdsInvolved),
    );

    // 4. Формируем плоский список
    for (var classItem in classesForSubject) {
      // Определяем студентов, которые должны были быть на этом конкретном занятии (из его подгруппы)
      final studentsForThisClass = allStudentsInvolved
          .where((student) => studentLinks.any((link) => link.studentsId == student.id && link.subgroupsId == classItem.subgroupsId))
          .toList();

      for (var student in studentsForThisClass) {
        final attendance = attendanceRecords.firstWhere(
          (ar) => ar.classesId == classItem.id && ar.studentsId == student.id,
          orElse: () => Attendance(
            classesId: classItem.id!,
            studentsId: student.id!,
            isPresent: false, // По умолчанию не был, если записи нет
          ),
        );
        flatRecords.add(StudentClassAttendanceFlatRecord(
          student: student,
          classInfo: classItem, // Передаем весь объект Classes
          isPresent: attendance.isPresent,
          comment: attendance.comment,
        ));
      }
    }
    return flatRecords;
  }
}