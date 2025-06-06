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
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i3;
import 'greeting.dart' as _i4;
import 'attendance_protocol.dart' as _i5;
import 'class_types_protocol.dart' as _i6;
import 'classes.dart' as _i7;
import 'groups_protocol.dart' as _i8;
import 'person.dart' as _i9;
import 'role_protocol.dart' as _i10;
import 'semesters_protocol.dart' as _i11;
import 'student_attendance_info.dart' as _i12;
import 'student_class_attendance_flat_record.dart' as _i13;
import 'student_overall_attendance_record.dart' as _i14;
import 'student_subgroups.dart' as _i15;
import 'students_protocol.dart' as _i16;
import 'subgroups_protocol.dart' as _i17;
import 'subject_attendance_matrix.dart' as _i18;
import 'subjects_protocol.dart' as _i19;
import 'teachers_protocol.dart' as _i20;
import 'package:journal_custom_server/src/generated/groups_protocol.dart'
    as _i21;
import 'package:journal_custom_server/src/generated/teachers_protocol.dart'
    as _i22;
import 'package:journal_custom_server/src/generated/students_protocol.dart'
    as _i23;
import 'package:journal_custom_server/src/generated/student_overall_attendance_record.dart'
    as _i24;
import 'package:journal_custom_server/src/generated/class_types_protocol.dart'
    as _i25;
import 'package:journal_custom_server/src/generated/subjects_protocol.dart'
    as _i26;
import 'package:journal_custom_server/src/generated/classes.dart' as _i27;
import 'package:journal_custom_server/src/generated/student_attendance_info.dart'
    as _i28;
import 'package:journal_custom_server/src/generated/student_class_attendance_flat_record.dart'
    as _i29;
import 'package:journal_custom_server/src/generated/semesters_protocol.dart'
    as _i30;
import 'package:journal_custom_server/src/generated/subgroups_protocol.dart'
    as _i31;
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

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'attendance',
      dartName: 'Attendance',
      schema: 'public',
      module: 'journal_custom',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'attendance_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'classesId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'studentsId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'isPresent',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'comment',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'attendance_fk_0',
          columns: ['classesId'],
          referenceTable: 'classes',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'attendance_fk_1',
          columns: ['studentsId'],
          referenceTable: 'students',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'attendance_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'class_types',
      dartName: 'ClassTypes',
      schema: 'public',
      module: 'journal_custom',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'class_types_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'class_types_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'classes',
      dartName: 'Classes',
      schema: 'public',
      module: 'journal_custom',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'classes_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'subjectsId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'class_typesId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'teachersId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'semestersId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'subgroupsId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'date',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'topic',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'notes',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'classes_fk_0',
          columns: ['subjectsId'],
          referenceTable: 'subjects',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'classes_fk_1',
          columns: ['class_typesId'],
          referenceTable: 'class_types',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'classes_fk_2',
          columns: ['teachersId'],
          referenceTable: 'teachers',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'classes_fk_3',
          columns: ['semestersId'],
          referenceTable: 'semesters',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'classes_fk_4',
          columns: ['subgroupsId'],
          referenceTable: 'subgroups',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'classes_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'groups',
      dartName: 'Groups',
      schema: 'public',
      module: 'journal_custom',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'groups_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'curatorId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: '_teachersGroupsTeachersId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'groups_fk_0',
          columns: ['curatorId'],
          referenceTable: 'teachers',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'groups_fk_1',
          columns: ['_teachersGroupsTeachersId'],
          referenceTable: 'teachers',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'groups_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'unique_curator',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'curatorId',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'person',
      dartName: 'Person',
      schema: 'public',
      module: 'journal_custom',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'person_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'firstName',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'lastName',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'patronymic',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'phoneNumber',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'userInfoId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'person_fk_0',
          columns: ['userInfoId'],
          referenceTable: 'serverpod_user_info',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'person_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'user_info_unique',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userInfoId',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'roles',
      dartName: 'Roles',
      schema: 'public',
      module: 'journal_custom',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'roles_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'roles_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'semesters',
      dartName: 'Semesters',
      schema: 'public',
      module: 'journal_custom',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'semesters_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'startDate',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'endDate',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'year',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'semesters_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'student_subgroups',
      dartName: 'StudentSubgroup',
      schema: 'public',
      module: 'journal_custom',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'student_subgroups_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'studentsId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'subgroupsId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'student_subgroups_fk_0',
          columns: ['studentsId'],
          referenceTable: 'students',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'student_subgroups_fk_1',
          columns: ['subgroupsId'],
          referenceTable: 'subgroups',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'student_subgroups_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'unique_combination',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'studentsId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'subgroupsId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'students',
      dartName: 'Students',
      schema: 'public',
      module: 'journal_custom',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'students_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'personId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'groupsId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'isGroupHead',
          columnType: _i2.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
          columnDefault: 'false',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'students_fk_0',
          columns: ['personId'],
          referenceTable: 'person',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'students_fk_1',
          columns: ['groupsId'],
          referenceTable: 'groups',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'students_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'students_person_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'personId',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'subgroups',
      dartName: 'Subgroups',
      schema: 'public',
      module: 'journal_custom',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'subgroups_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'groupsId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'subgroups_fk_0',
          columns: ['groupsId'],
          referenceTable: 'groups',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'subgroups_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'subjects',
      dartName: 'Subjects',
      schema: 'public',
      module: 'journal_custom',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'subjects_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'subjects_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'teachers',
      dartName: 'Teachers',
      schema: 'public',
      module: 'journal_custom',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'teachers_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'personId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'teachers_fk_0',
          columns: ['personId'],
          referenceTable: 'person',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'teachers_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'teachers_person_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'personId',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._i3.Protocol.targetTableDefinitions,
    ..._i2.Protocol.targetTableDefinitions,
  ];

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i4.Greeting) {
      return _i4.Greeting.fromJson(data) as T;
    }
    if (t == _i5.Attendance) {
      return _i5.Attendance.fromJson(data) as T;
    }
    if (t == _i6.ClassTypes) {
      return _i6.ClassTypes.fromJson(data) as T;
    }
    if (t == _i7.Classes) {
      return _i7.Classes.fromJson(data) as T;
    }
    if (t == _i8.Groups) {
      return _i8.Groups.fromJson(data) as T;
    }
    if (t == _i9.Person) {
      return _i9.Person.fromJson(data) as T;
    }
    if (t == _i10.Roles) {
      return _i10.Roles.fromJson(data) as T;
    }
    if (t == _i11.Semesters) {
      return _i11.Semesters.fromJson(data) as T;
    }
    if (t == _i12.StudentAttendanceInfo) {
      return _i12.StudentAttendanceInfo.fromJson(data) as T;
    }
    if (t == _i13.StudentClassAttendanceFlatRecord) {
      return _i13.StudentClassAttendanceFlatRecord.fromJson(data) as T;
    }
    if (t == _i14.StudentOverallAttendanceRecord) {
      return _i14.StudentOverallAttendanceRecord.fromJson(data) as T;
    }
    if (t == _i15.StudentSubgroup) {
      return _i15.StudentSubgroup.fromJson(data) as T;
    }
    if (t == _i16.Students) {
      return _i16.Students.fromJson(data) as T;
    }
    if (t == _i17.Subgroups) {
      return _i17.Subgroups.fromJson(data) as T;
    }
    if (t == _i18.SubjectAttendanceMatrix) {
      return _i18.SubjectAttendanceMatrix.fromJson(data) as T;
    }
    if (t == _i19.Subjects) {
      return _i19.Subjects.fromJson(data) as T;
    }
    if (t == _i20.Teachers) {
      return _i20.Teachers.fromJson(data) as T;
    }
    if (t == _i1.getType<_i4.Greeting?>()) {
      return (data != null ? _i4.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.Attendance?>()) {
      return (data != null ? _i5.Attendance.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.ClassTypes?>()) {
      return (data != null ? _i6.ClassTypes.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.Classes?>()) {
      return (data != null ? _i7.Classes.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.Groups?>()) {
      return (data != null ? _i8.Groups.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.Person?>()) {
      return (data != null ? _i9.Person.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.Roles?>()) {
      return (data != null ? _i10.Roles.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.Semesters?>()) {
      return (data != null ? _i11.Semesters.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.StudentAttendanceInfo?>()) {
      return (data != null ? _i12.StudentAttendanceInfo.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i13.StudentClassAttendanceFlatRecord?>()) {
      return (data != null
          ? _i13.StudentClassAttendanceFlatRecord.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i14.StudentOverallAttendanceRecord?>()) {
      return (data != null
          ? _i14.StudentOverallAttendanceRecord.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i15.StudentSubgroup?>()) {
      return (data != null ? _i15.StudentSubgroup.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.Students?>()) {
      return (data != null ? _i16.Students.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.Subgroups?>()) {
      return (data != null ? _i17.Subgroups.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.SubjectAttendanceMatrix?>()) {
      return (data != null ? _i18.SubjectAttendanceMatrix.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i19.Subjects?>()) {
      return (data != null ? _i19.Subjects.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.Teachers?>()) {
      return (data != null ? _i20.Teachers.fromJson(data) : null) as T;
    }
    if (t == List<_i16.Students>) {
      return (data as List).map((e) => deserialize<_i16.Students>(e)).toList()
          as T;
    }
    if (t == List<_i7.Classes>) {
      return (data as List).map((e) => deserialize<_i7.Classes>(e)).toList()
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
    if (t == _i1.getType<List<_i8.Groups>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i8.Groups>(e)).toList()
          : null) as T;
    }
    if (t == List<_i21.Groups>) {
      return (data as List).map((e) => deserialize<_i21.Groups>(e)).toList()
          as T;
    }
    if (t == List<_i22.Teachers>) {
      return (data as List).map((e) => deserialize<_i22.Teachers>(e)).toList()
          as T;
    }
    if (t == List<_i23.Students>) {
      return (data as List).map((e) => deserialize<_i23.Students>(e)).toList()
          as T;
    }
    if (t == List<_i24.StudentOverallAttendanceRecord>) {
      return (data as List)
          .map((e) => deserialize<_i24.StudentOverallAttendanceRecord>(e))
          .toList() as T;
    }
    if (t == List<_i25.ClassTypes>) {
      return (data as List).map((e) => deserialize<_i25.ClassTypes>(e)).toList()
          as T;
    }
    if (t == List<_i26.Subjects>) {
      return (data as List).map((e) => deserialize<_i26.Subjects>(e)).toList()
          as T;
    }
    if (t == List<_i27.Classes>) {
      return (data as List).map((e) => deserialize<_i27.Classes>(e)).toList()
          as T;
    }
    if (t == List<_i28.StudentAttendanceInfo>) {
      return (data as List)
          .map((e) => deserialize<_i28.StudentAttendanceInfo>(e))
          .toList() as T;
    }
    if (t == List<_i29.StudentClassAttendanceFlatRecord>) {
      return (data as List)
          .map((e) => deserialize<_i29.StudentClassAttendanceFlatRecord>(e))
          .toList() as T;
    }
    if (t == List<_i30.Semesters>) {
      return (data as List).map((e) => deserialize<_i30.Semesters>(e)).toList()
          as T;
    }
    if (t == List<_i31.Subgroups>) {
      return (data as List).map((e) => deserialize<_i31.Subgroups>(e)).toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i4.Greeting) {
      return 'Greeting';
    }
    if (data is _i5.Attendance) {
      return 'Attendance';
    }
    if (data is _i6.ClassTypes) {
      return 'ClassTypes';
    }
    if (data is _i7.Classes) {
      return 'Classes';
    }
    if (data is _i8.Groups) {
      return 'Groups';
    }
    if (data is _i9.Person) {
      return 'Person';
    }
    if (data is _i10.Roles) {
      return 'Roles';
    }
    if (data is _i11.Semesters) {
      return 'Semesters';
    }
    if (data is _i12.StudentAttendanceInfo) {
      return 'StudentAttendanceInfo';
    }
    if (data is _i13.StudentClassAttendanceFlatRecord) {
      return 'StudentClassAttendanceFlatRecord';
    }
    if (data is _i14.StudentOverallAttendanceRecord) {
      return 'StudentOverallAttendanceRecord';
    }
    if (data is _i15.StudentSubgroup) {
      return 'StudentSubgroup';
    }
    if (data is _i16.Students) {
      return 'Students';
    }
    if (data is _i17.Subgroups) {
      return 'Subgroups';
    }
    if (data is _i18.SubjectAttendanceMatrix) {
      return 'SubjectAttendanceMatrix';
    }
    if (data is _i19.Subjects) {
      return 'Subjects';
    }
    if (data is _i20.Teachers) {
      return 'Teachers';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
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
      return deserialize<_i4.Greeting>(data['data']);
    }
    if (dataClassName == 'Attendance') {
      return deserialize<_i5.Attendance>(data['data']);
    }
    if (dataClassName == 'ClassTypes') {
      return deserialize<_i6.ClassTypes>(data['data']);
    }
    if (dataClassName == 'Classes') {
      return deserialize<_i7.Classes>(data['data']);
    }
    if (dataClassName == 'Groups') {
      return deserialize<_i8.Groups>(data['data']);
    }
    if (dataClassName == 'Person') {
      return deserialize<_i9.Person>(data['data']);
    }
    if (dataClassName == 'Roles') {
      return deserialize<_i10.Roles>(data['data']);
    }
    if (dataClassName == 'Semesters') {
      return deserialize<_i11.Semesters>(data['data']);
    }
    if (dataClassName == 'StudentAttendanceInfo') {
      return deserialize<_i12.StudentAttendanceInfo>(data['data']);
    }
    if (dataClassName == 'StudentClassAttendanceFlatRecord') {
      return deserialize<_i13.StudentClassAttendanceFlatRecord>(data['data']);
    }
    if (dataClassName == 'StudentOverallAttendanceRecord') {
      return deserialize<_i14.StudentOverallAttendanceRecord>(data['data']);
    }
    if (dataClassName == 'StudentSubgroup') {
      return deserialize<_i15.StudentSubgroup>(data['data']);
    }
    if (dataClassName == 'Students') {
      return deserialize<_i16.Students>(data['data']);
    }
    if (dataClassName == 'Subgroups') {
      return deserialize<_i17.Subgroups>(data['data']);
    }
    if (dataClassName == 'SubjectAttendanceMatrix') {
      return deserialize<_i18.SubjectAttendanceMatrix>(data['data']);
    }
    if (dataClassName == 'Subjects') {
      return deserialize<_i19.Subjects>(data['data']);
    }
    if (dataClassName == 'Teachers') {
      return deserialize<_i20.Teachers>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i3.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i3.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i5.Attendance:
        return _i5.Attendance.t;
      case _i6.ClassTypes:
        return _i6.ClassTypes.t;
      case _i7.Classes:
        return _i7.Classes.t;
      case _i8.Groups:
        return _i8.Groups.t;
      case _i9.Person:
        return _i9.Person.t;
      case _i10.Roles:
        return _i10.Roles.t;
      case _i11.Semesters:
        return _i11.Semesters.t;
      case _i15.StudentSubgroup:
        return _i15.StudentSubgroup.t;
      case _i16.Students:
        return _i16.Students.t;
      case _i17.Subgroups:
        return _i17.Subgroups.t;
      case _i19.Subjects:
        return _i19.Subjects.t;
      case _i20.Teachers:
        return _i20.Teachers.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'journal_custom';
}
