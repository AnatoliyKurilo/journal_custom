import 'package:journal_custom_server/src/custom_scope.dart';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/user_subgroup_service.dart';
import 'package:collection/collection.dart';


class StudentsEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  // @override
  // Set<Scope> get requiredScopes => {Scope.admin, CustomScope.curator, CustomScope.groupHead, CustomScope.teacher, CustomScope.student, CustomScope.documentSpecialist};

  // Создание студента
  Future<Students> createStudent(
    Session session, {
    required String firstName,
    required String lastName,
    String? patronymic,
    required String email,
    String? phoneNumber,
    required String groupName,
    String? recordBookNumber,
  }) async {
    session.log('StudentsEndpoint: Начало создания студента: $firstName $lastName');

    try {

      var group = await Groups.db.findFirstRow(
        session,
        where: (g) => g.name.equals(groupName),
      );

      if (group == null) {
        throw Exception('Группа с названием "$groupName" не найдена');
      }
      
      if (firstName.isEmpty || lastName.isEmpty || email.isEmpty || groupName.isEmpty) {
        throw Exception('Все поля должны быть заполнены');
      }
      if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email)) {
        throw Exception('Некорректный формат email: $email');
      }
      // var group = Groups.db.findFirstRow(
      //   session,
      //   where: (g) => g.name.equals(groupName),
      // ); 
      // if(group == null) {
      //   throw Exception('Группа с названием "$groupName" не найдена');
      // }

      var existingPerson = await Person.db.findFirstRow(
        session,
        where: (p) => p.email.equals(email),
      );

      if (existingPerson != null) {
        throw Exception('Человек с таким email уже существует');
      }

      

      var person = Person(
        firstName: firstName,
        lastName: lastName,
        patronymic: patronymic,
        email: email,
        phoneNumber: phoneNumber,
      );
      person = await Person.db.insertRow(session, person);

      var student = Students(
        personId: person.id!,
        groupsId: group.id!,
        // recordBookNumber: recordBookNumber,
      );
      student = await Students.db.insertRow(session, student);

      return student;
    } catch (e, stackTrace) {
      session.log(
        'StudentsEndpoint: Ошибка при создании студента: $e',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  // Получение всех студентов
  Future<List<Students>> getAllStudents(Session session) async {
    return await Students.db.find(
      session,
      include: Students.include(
        person: Person.include(),
        groups: Groups.include(),
      ),
    );
  }

  // Обновление студента
  Future<Students> updateStudent(Session session, Students student) async {
    var existingStudent = await Students.db.findById(session, student.id!);
    if (existingStudent == null) {
      throw Exception('Студент с ID ${student.id} не найден');
    }
    await Students.db.updateRow(session, student);
    return student;
  }

  // Получение записей о посещаемости студента
  Future<List<StudentOverallAttendanceRecord>> getStudentOverallAttendanceRecords(
    Session session, 
    int studentId
  ) async {
    final student = await Students.db.findById(session, studentId);
    if (student == null) {
      throw Exception('Студент с ID $studentId не найден');
    }

    final accessibleSubgroupIds = await UserSubgroupService.getUserAccessibleSubgroupIds(session);
    
    if (accessibleSubgroupIds.isEmpty) {
      return [];
    }

    final studentSubgroupLinks = await StudentSubgroup.db.find(
      session,
      where: (ss) => ss.studentsId.equals(studentId) & ss.subgroupsId.inSet(accessibleSubgroupIds.toSet()),
    );

    if (studentSubgroupLinks.isEmpty) {
      return [];
    }

    final subgroupIds = studentSubgroupLinks.map((link) => link.subgroupsId).toSet();

    final classes = await Classes.db.find(
      session,
      where: (c) => c.subgroupsId.inSet(subgroupIds),
      include: Classes.include(
        subjects: Subjects.include(),
        class_types: ClassTypes.include(),
        subgroups: Subgroups.include(),
      ),
      orderBy: (c) => c.date,
      orderDescending: true,
    );

    if (classes.isEmpty) {
      return [];
    }

    final classIds = classes.map((c) => c.id!).toSet();
    final attendanceRecords = await Attendance.db.find(
      session,
      where: (a) => a.studentsId.equals(studentId) & a.classesId.inSet(classIds),
    );

    final List<StudentOverallAttendanceRecord> result = [];
    for (var classItem in classes) {
      final attendance = attendanceRecords.firstWhereOrNull(
        (ar) => ar.classesId == classItem.id,
      );

      result.add(StudentOverallAttendanceRecord(
        subjectName: classItem.subjects?.name ?? 'Неизвестный предмет',
        classTopic: classItem.topic,
        classTypeName: classItem.class_types?.name,
        classDate: classItem.date,
        isPresent: attendance?.isPresent ?? false,
        comment: attendance?.comment,
        subgroupName: classItem.subgroups?.name,
      ));
    }
    return result;
  }
}