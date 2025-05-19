import 'package:serverpod/serverpod.dart';

class CustomScope extends Scope {
  const CustomScope(String super.name);

  static const userRead  = CustomScope('userRead');
  static const userWrite = CustomScope('userWrite');
  static const student = CustomScope('student');
  static const groupHead = CustomScope('groupHead');
  static const teacher = CustomScope('teacher');
  static const curator = CustomScope('curator');
  static const documentSpecialist = CustomScope('documentSpecialist');
  // static const admin = CustomScope('admin');
}