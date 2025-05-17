BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "attendance" (
    "id" bigserial PRIMARY KEY,
    "classId" bigint NOT NULL,
    "studentId" bigint NOT NULL,
    "status" text NOT NULL,
    "comment" text
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "class_types" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "classes" (
    "id" bigserial PRIMARY KEY,
    "subjectId" bigint NOT NULL,
    "groupId" bigint NOT NULL,
    "typeId" bigint NOT NULL,
    "teacherId" bigint NOT NULL,
    "semesterId" bigint NOT NULL,
    "subgroupId" bigint,
    "date" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "group_heads" (
    "id" bigserial PRIMARY KEY
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "groups" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "curatorId" bigint NOT NULL,
    "groupHeadId" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "unique_curator" ON "groups" USING btree ("curatorId");
CREATE UNIQUE INDEX "unique_group_head" ON "groups" USING btree ("groupHeadId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "person" (
    "id" bigserial PRIMARY KEY,
    "firstName" text NOT NULL,
    "lastName" text NOT NULL,
    "patronymic" text,
    "email" text NOT NULL,
    "phoneNumber" text
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "roles" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "semesters" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "startDate" timestamp without time zone NOT NULL,
    "endDate" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "student_subgroups" (
    "id" bigserial PRIMARY KEY,
    "studentId" bigint NOT NULL,
    "subgroupId" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "unique_combination" ON "student_subgroups" USING btree ("studentId", "subgroupId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "students" (
    "id" bigserial PRIMARY KEY,
    "personId" bigint NOT NULL,
    "groupId" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "students_groups_unique_idx" ON "students" USING btree ("groupId");
CREATE UNIQUE INDEX "students_person_unique_idx" ON "students" USING btree ("personId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "subgroups" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "groupId" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "subjects" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "description" text,
    "teacherId" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "teachers" (
    "id" bigserial PRIMARY KEY,
    "personId" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "teachers_person_unique_idx" ON "teachers" USING btree ("personId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "users" (
    "id" bigserial PRIMARY KEY,
    "login" text NOT NULL,
    "passwordHash" text NOT NULL,
    "roleId" bigint NOT NULL,
    "personId" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "users_person_unique_idx" ON "users" USING btree ("personId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "attendance"
    ADD CONSTRAINT "attendance_fk_0"
    FOREIGN KEY("classId")
    REFERENCES "classes"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "attendance"
    ADD CONSTRAINT "attendance_fk_1"
    FOREIGN KEY("studentId")
    REFERENCES "students"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "classes"
    ADD CONSTRAINT "classes_fk_0"
    FOREIGN KEY("subjectId")
    REFERENCES "subjects"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "classes"
    ADD CONSTRAINT "classes_fk_1"
    FOREIGN KEY("groupId")
    REFERENCES "groups"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "classes"
    ADD CONSTRAINT "classes_fk_2"
    FOREIGN KEY("typeId")
    REFERENCES "class_types"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "classes"
    ADD CONSTRAINT "classes_fk_3"
    FOREIGN KEY("teacherId")
    REFERENCES "teachers"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "classes"
    ADD CONSTRAINT "classes_fk_4"
    FOREIGN KEY("semesterId")
    REFERENCES "semesters"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "classes"
    ADD CONSTRAINT "classes_fk_5"
    FOREIGN KEY("subgroupId")
    REFERENCES "subgroups"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "groups"
    ADD CONSTRAINT "groups_fk_0"
    FOREIGN KEY("curatorId")
    REFERENCES "teachers"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "groups"
    ADD CONSTRAINT "groups_fk_1"
    FOREIGN KEY("groupHeadId")
    REFERENCES "students"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "student_subgroups"
    ADD CONSTRAINT "student_subgroups_fk_0"
    FOREIGN KEY("studentId")
    REFERENCES "students"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "student_subgroups"
    ADD CONSTRAINT "student_subgroups_fk_1"
    FOREIGN KEY("subgroupId")
    REFERENCES "subgroups"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "students"
    ADD CONSTRAINT "students_fk_0"
    FOREIGN KEY("personId")
    REFERENCES "person"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "students"
    ADD CONSTRAINT "students_fk_1"
    FOREIGN KEY("groupId")
    REFERENCES "groups"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "subgroups"
    ADD CONSTRAINT "subgroups_fk_0"
    FOREIGN KEY("groupId")
    REFERENCES "groups"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "subjects"
    ADD CONSTRAINT "subjects_fk_0"
    FOREIGN KEY("teacherId")
    REFERENCES "teachers"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "teachers"
    ADD CONSTRAINT "teachers_fk_0"
    FOREIGN KEY("personId")
    REFERENCES "person"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "users"
    ADD CONSTRAINT "users_fk_0"
    FOREIGN KEY("roleId")
    REFERENCES "roles"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "users"
    ADD CONSTRAINT "users_fk_1"
    FOREIGN KEY("personId")
    REFERENCES "person"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR journal_custom
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('journal_custom', '20250517060521322', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250517060521322', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
