BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "groups" ADD COLUMN "_teachersGroupsTeachersId" bigint;
ALTER TABLE ONLY "groups"
    ADD CONSTRAINT "groups_fk_1"
    FOREIGN KEY("_teachersGroupsTeachersId")
    REFERENCES "teachers"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "person" ADD COLUMN "studentId" bigint;
ALTER TABLE "person" ADD COLUMN "teacherId" bigint;
ALTER TABLE ONLY "person"
    ADD CONSTRAINT "person_fk_1"
    FOREIGN KEY("studentId")
    REFERENCES "students"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "person"
    ADD CONSTRAINT "person_fk_2"
    FOREIGN KEY("teacherId")
    REFERENCES "teachers"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "students" ADD COLUMN "_groupsStudentsGroupsId" bigint;
ALTER TABLE ONLY "students"
    ADD CONSTRAINT "students_fk_2"
    FOREIGN KEY("_groupsStudentsGroupsId")
    REFERENCES "groups"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- MIGRATION VERSION FOR journal_custom
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('journal_custom', '20250520115519216', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250520115519216', "timestamp" = now();

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
