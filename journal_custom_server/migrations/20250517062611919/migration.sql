BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "group_heads" CASCADE;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "subjects" DROP CONSTRAINT "subjects_fk_0";
ALTER TABLE "subjects" DROP COLUMN "teacherId";

--
-- MIGRATION VERSION FOR journal_custom
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('journal_custom', '20250517062611919', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250517062611919', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
