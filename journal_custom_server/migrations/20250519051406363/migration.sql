BEGIN;

--
-- ACTION ALTER TABLE
--
DROP INDEX "unique_curator";
DROP INDEX "unique_group_head";

--
-- MIGRATION VERSION FOR journal_custom
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('journal_custom', '20250519051406363', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250519051406363', "timestamp" = now();

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
