BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "attendance" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "attendance" (
    "id" bigserial PRIMARY KEY,
    "classesId" bigint NOT NULL,
    "studentsId" bigint NOT NULL,
    "status" text NOT NULL,
    "comment" text
);

--
-- ACTION DROP TABLE
--
DROP TABLE "classes" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "classes" (
    "id" bigserial PRIMARY KEY,
    "subjectId" bigint NOT NULL,
    "subjectsId" bigint NOT NULL,
    "class_typesId" bigint NOT NULL,
    "teachersId" bigint NOT NULL,
    "semestersId" bigint NOT NULL,
    "subgroupsId" bigint NOT NULL,
    "date" timestamp without time zone NOT NULL
);

--
-- ACTION DROP TABLE
--
DROP TABLE "student_subgroups" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "student_subgroups" (
    "id" bigserial PRIMARY KEY,
    "studentsId" bigint NOT NULL,
    "subgroupsId" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "unique_combination" ON "student_subgroups" USING btree ("studentsId", "subgroupsId");

--
-- ACTION DROP TABLE
--
DROP TABLE "students" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "students" (
    "id" bigserial PRIMARY KEY,
    "personId" bigint NOT NULL,
    "groupsId" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "students_groups_unique_idx" ON "students" USING btree ("groupsId");
CREATE UNIQUE INDEX "students_person_unique_idx" ON "students" USING btree ("personId");

--
-- ACTION DROP TABLE
--
DROP TABLE "subgroups" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "subgroups" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "groupsId" bigint NOT NULL
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "attendance"
    ADD CONSTRAINT "attendance_fk_0"
    FOREIGN KEY("classesId")
    REFERENCES "classes"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "attendance"
    ADD CONSTRAINT "attendance_fk_1"
    FOREIGN KEY("studentsId")
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
    FOREIGN KEY("subjectsId")
    REFERENCES "subjects"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "classes"
    ADD CONSTRAINT "classes_fk_2"
    FOREIGN KEY("class_typesId")
    REFERENCES "class_types"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "classes"
    ADD CONSTRAINT "classes_fk_3"
    FOREIGN KEY("teachersId")
    REFERENCES "teachers"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "classes"
    ADD CONSTRAINT "classes_fk_4"
    FOREIGN KEY("semestersId")
    REFERENCES "semesters"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "classes"
    ADD CONSTRAINT "classes_fk_5"
    FOREIGN KEY("subgroupsId")
    REFERENCES "subgroups"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "student_subgroups"
    ADD CONSTRAINT "student_subgroups_fk_0"
    FOREIGN KEY("studentsId")
    REFERENCES "students"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "student_subgroups"
    ADD CONSTRAINT "student_subgroups_fk_1"
    FOREIGN KEY("subgroupsId")
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
    FOREIGN KEY("groupsId")
    REFERENCES "groups"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "subgroups"
    ADD CONSTRAINT "subgroups_fk_0"
    FOREIGN KEY("groupsId")
    REFERENCES "groups"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR journal_custom
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('journal_custom', '20250519054845673', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250519054845673', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20240520102713718', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240520102713718', "timestamp" = now();


COMMIT;
