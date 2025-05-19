BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "teachers" DROP CONSTRAINT "teachers_fk_1";
ALTER TABLE "teachers" ALTER COLUMN "personId" DROP NOT NULL;

--
-- MIGRATION VERSION FOR journal_custom
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('journal_custom', '20250519052521298', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250519052521298', "timestamp" = now();

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
