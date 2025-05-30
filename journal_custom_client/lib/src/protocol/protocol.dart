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
import 'greeting.dart' as _i2;
import 'attendance_protocol.dart' as _i3;
import 'class_types_protocol.dart' as _i4;
import 'classes.dart' as _i5;
import 'groups_protocol.dart' as _i6;
import 'person.dart' as _i7;
import 'role_protocol.dart' as _i8;
import 'semesters_protocol.dart' as _i9;
import 'student_attendance_info.dart' as _i10;
import 'student_class_attendance_flat_record.dart' as _i11;
import 'student_overall_attendance_record.dart' as _i12;
import 'student_subgroups.dart' as _i13;
import 'students_protocol.dart' as _i14;
import 'subgroups_protocol.dart' as _i15;
import 'subject_attendance_matrix.dart' as _i16;
import 'subjects_protocol.dart' as _i17;
import 'teachers_protocol.dart' as _i18;
import 'package:journal_custom_client/src/protocol/groups_protocol.dart'
    as _i19;
import 'package:journal_custom_client/src/protocol/teachers_protocol.dart'
    as _i20;
import 'package:journal_custom_client/src/protocol/students_protocol.dart'
    as _i21;
import 'package:journal_custom_client/src/protocol/student_overall_attendance_record.dart'
    as _i22;
import 'package:journal_custom_client/src/protocol/class_types_protocol.dart'
    as _i23;
import 'package:journal_custom_client/src/protocol/subjects_protocol.dart'
    as _i24;
import 'package:journal_custom_client/src/protocol/classes.dart' as _i25;
import 'package:journal_custom_client/src/protocol/student_attendance_info.dart'
    as _i26;
import 'package:journal_custom_client/src/protocol/student_class_attendance_flat_record.dart'
    as _i27;
import 'package:journal_custom_client/src/protocol/subgroups_protocol.dart'
    as _i28;
import 'package:journal_custom_client/src/protocol/semesters_protocol.dart'
    as _i29;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i30;
export 'greeting.dart';
export 'attendance_protocol.dart';
export 'class_types_protocol.dart';
export 'classes.dart';
export 'groups_protocol.dart';
export 'person.dart';
export 'role_protocol.dart';
export 'semesters_protocol.dart';
export 'student_attendance_info.dart';
export 'student_class_attendance_flat_record.dart';
export 'student_overall_attendance_record.dart';
export 'student_subgroups.dart';
export 'students_protocol.dart';
export 'subgroups_protocol.dart';
export 'subject_attendance_matrix.dart';
export 'subjects_protocol.dart';
export 'teachers_protocol.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i2.Greeting) {
      return _i2.Greeting.fromJson(data) as T;
    }
    if (t == _i3.Attendance) {
      return _i3.Attendance.fromJson(data) as T;
    }
    if (t == _i4.ClassTypes) {
      return _i4.ClassTypes.fromJson(data) as T;
    }
    if (t == _i5.Classes) {
      return _i5.Classes.fromJson(data) as T;
    }
    if (t == _i6.Groups) {
      return _i6.Groups.fromJson(data) as T;
    }
    if (t == _i7.Person) {
      return _i7.Person.fromJson(data) as T;
    }
    if (t == _i8.Roles) {
      return _i8.Roles.fromJson(data) as T;
    }
    if (t == _i9.Semesters) {
      return _i9.Semesters.fromJson(data) as T;
    }
    if (t == _i10.StudentAttendanceInfo) {
      return _i10.StudentAttendanceInfo.fromJson(data) as T;
    }
    if (t == _i11.StudentClassAttendanceFlatRecord) {
      return _i11.StudentClassAttendanceFlatRecord.fromJson(data) as T;
    }
    if (t == _i12.StudentOverallAttendanceRecord) {
      return _i12.StudentOverallAttendanceRecord.fromJson(data) as T;
    }
    if (t == _i13.StudentSubgroup) {
      return _i13.StudentSubgroup.fromJson(data) as T;
    }
    if (t == _i14.Students) {
      return _i14.Students.fromJson(data) as T;
    }
    if (t == _i15.Subgroups) {
      return _i15.Subgroups.fromJson(data) as T;
    }
    if (t == _i16.SubjectAttendanceMatrix) {
      return _i16.SubjectAttendanceMatrix.fromJson(data) as T;
    }
    if (t == _i17.Subjects) {
      return _i17.Subjects.fromJson(data) as T;
    }
    if (t == _i18.Teachers) {
      return _i18.Teachers.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Greeting?>()) {
      return (data != null ? _i2.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.Attendance?>()) {
      return (data != null ? _i3.Attendance.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.ClassTypes?>()) {
      return (data != null ? _i4.ClassTypes.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.Classes?>()) {
      return (data != null ? _i5.Classes.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.Groups?>()) {
      return (data != null ? _i6.Groups.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.Person?>()) {
      return (data != null ? _i7.Person.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.Roles?>()) {
      return (data != null ? _i8.Roles.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.Semesters?>()) {
      return (data != null ? _i9.Semesters.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.StudentAttendanceInfo?>()) {
      return (data != null ? _i10.StudentAttendanceInfo.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i11.StudentClassAttendanceFlatRecord?>()) {
      return (data != null
          ? _i11.StudentClassAttendanceFlatRecord.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i12.StudentOverallAttendanceRecord?>()) {
      return (data != null
          ? _i12.StudentOverallAttendanceRecord.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i13.StudentSubgroup?>()) {
      return (data != null ? _i13.StudentSubgroup.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.Students?>()) {
      return (data != null ? _i14.Students.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.Subgroups?>()) {
      return (data != null ? _i15.Subgroups.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.SubjectAttendanceMatrix?>()) {
      return (data != null ? _i16.SubjectAttendanceMatrix.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i17.Subjects?>()) {
      return (data != null ? _i17.Subjects.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.Teachers?>()) {
      return (data != null ? _i18.Teachers.fromJson(data) : null) as T;
    }
    if (t == List<_i14.Students>) {
      return (data as List).map((e) => deserialize<_i14.Students>(e)).toList()
          as T;
    }
    if (t == List<_i5.Classes>) {
      return (data as List).map((e) => deserialize<_i5.Classes>(e)).toList()
          as T;
    }
    if (t == Map<int, Map<int, bool>>) {
      return Map.fromEntries((data as List).map((e) => MapEntry(
          deserialize<int>(e['k']), deserialize<Map<int, bool>>(e['v'])))) as T;
    }
    if (t == Map<int, bool>) {
      return Map.fromEntries((data as List).map((e) =>
          MapEntry(deserialize<int>(e['k']), deserialize<bool>(e['v'])))) as T;
    }
    if (t == _i1.getType<List<_i6.Groups>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i6.Groups>(e)).toList()
          : null) as T;
    }
    if (t == List<_i19.Groups>) {
      return (data as List).map((e) => deserialize<_i19.Groups>(e)).toList()
          as T;
    }
    if (t == List<_i20.Teachers>) {
      return (data as List).map((e) => deserialize<_i20.Teachers>(e)).toList()
          as T;
    }
    if (t == List<_i21.Students>) {
      return (data as List).map((e) => deserialize<_i21.Students>(e)).toList()
          as T;
    }
    if (t == List<_i22.StudentOverallAttendanceRecord>) {
      return (data as List)
          .map((e) => deserialize<_i22.StudentOverallAttendanceRecord>(e))
          .toList() as T;
    }
    if (t == List<_i23.ClassTypes>) {
      return (data as List).map((e) => deserialize<_i23.ClassTypes>(e)).toList()
          as T;
    }
    if (t == List<_i24.Subjects>) {
      return (data as List).map((e) => deserialize<_i24.Subjects>(e)).toList()
          as T;
    }
    if (t == List<_i25.Classes>) {
      return (data as List).map((e) => deserialize<_i25.Classes>(e)).toList()
          as T;
    }
    if (t == List<_i26.StudentAttendanceInfo>) {
      return (data as List)
          .map((e) => deserialize<_i26.StudentAttendanceInfo>(e))
          .toList() as T;
    }
    if (t == List<_i27.StudentClassAttendanceFlatRecord>) {
      return (data as List)
          .map((e) => deserialize<_i27.StudentClassAttendanceFlatRecord>(e))
          .toList() as T;
    }
    if (t == List<_i28.Subgroups>) {
      return (data as List).map((e) => deserialize<_i28.Subgroups>(e)).toList()
          as T;
    }
    if (t == List<_i29.Semesters>) {
      return (data as List).map((e) => deserialize<_i29.Semesters>(e)).toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    try {
      return _i30.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i2.Greeting) {
      return 'Greeting';
    }
    if (data is _i3.Attendance) {
      return 'Attendance';
    }
    if (data is _i4.ClassTypes) {
      return 'ClassTypes';
    }
    if (data is _i5.Classes) {
      return 'Classes';
    }
    if (data is _i6.Groups) {
      return 'Groups';
    }
    if (data is _i7.Person) {
      return 'Person';
    }
    if (data is _i8.Roles) {
      return 'Roles';
    }
    if (data is _i9.Semesters) {
      return 'Semesters';
    }
    if (data is _i10.StudentAttendanceInfo) {
      return 'StudentAttendanceInfo';
    }
    if (data is _i11.StudentClassAttendanceFlatRecord) {
      return 'StudentClassAttendanceFlatRecord';
    }
    if (data is _i12.StudentOverallAttendanceRecord) {
      return 'StudentOverallAttendanceRecord';
    }
    if (data is _i13.StudentSubgroup) {
      return 'StudentSubgroup';
    }
    if (data is _i14.Students) {
      return 'Students';
    }
    if (data is _i15.Subgroups) {
      return 'Subgroups';
    }
    if (data is _i16.SubjectAttendanceMatrix) {
      return 'SubjectAttendanceMatrix';
    }
    if (data is _i17.Subjects) {
      return 'Subjects';
    }
    if (data is _i18.Teachers) {
      return 'Teachers';
    }
    className = _i30.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i2.Greeting>(data['data']);
    }
    if (dataClassName == 'Attendance') {
      return deserialize<_i3.Attendance>(data['data']);
    }
    if (dataClassName == 'ClassTypes') {
      return deserialize<_i4.ClassTypes>(data['data']);
    }
    if (dataClassName == 'Classes') {
      return deserialize<_i5.Classes>(data['data']);
    }
    if (dataClassName == 'Groups') {
      return deserialize<_i6.Groups>(data['data']);
    }
    if (dataClassName == 'Person') {
      return deserialize<_i7.Person>(data['data']);
    }
    if (dataClassName == 'Roles') {
      return deserialize<_i8.Roles>(data['data']);
    }
    if (dataClassName == 'Semesters') {
      return deserialize<_i9.Semesters>(data['data']);
    }
    if (dataClassName == 'StudentAttendanceInfo') {
      return deserialize<_i10.StudentAttendanceInfo>(data['data']);
    }
    if (dataClassName == 'StudentClassAttendanceFlatRecord') {
      return deserialize<_i11.StudentClassAttendanceFlatRecord>(data['data']);
    }
    if (dataClassName == 'StudentOverallAttendanceRecord') {
      return deserialize<_i12.StudentOverallAttendanceRecord>(data['data']);
    }
    if (dataClassName == 'StudentSubgroup') {
      return deserialize<_i13.StudentSubgroup>(data['data']);
    }
    if (dataClassName == 'Students') {
      return deserialize<_i14.Students>(data['data']);
    }
    if (dataClassName == 'Subgroups') {
      return deserialize<_i15.Subgroups>(data['data']);
    }
    if (dataClassName == 'SubjectAttendanceMatrix') {
      return deserialize<_i16.SubjectAttendanceMatrix>(data['data']);
    }
    if (dataClassName == 'Subjects') {
      return deserialize<_i17.Subjects>(data['data']);
    }
    if (dataClassName == 'Teachers') {
      return deserialize<_i18.Teachers>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i30.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}
