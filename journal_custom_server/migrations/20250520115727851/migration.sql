BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "person" DROP CONSTRAINT "person_fk_1";
ALTER TABLE "person" DROP CONSTRAINT "person_fk_2";
ALTER TABLE "person" DROP COLUMN "studentId";
ALTER TABLE "person" DROP COLUMN "teacherId";
--
-- ACTION ALTER TABLE
--
ALTER TABLE "students" DROP CONSTRAINT "students_fk_2";
ALTER TABLE "students" DROP COLUMN "_groupsStudentsGroupsId";

--
-- MIGRATION VERSION FOR journal_custom
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('journal_custom', '20250520115727851', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250520115727851', "timestamp" = now();

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
