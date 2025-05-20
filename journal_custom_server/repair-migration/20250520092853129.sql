BEGIN;

--
-- ACTION ALTER TABLE
--
DROP INDEX "unique_group_head";
ALTER TABLE "groups" DROP COLUMN "groupHeadId";
--
-- ACTION ALTER TABLE
--
ALTER TABLE "students" ADD COLUMN "isGroupHead" boolean DEFAULT false;
--
-- ACTION ALTER TABLE
--
ALTER TABLE ONLY "teachers"
    ADD CONSTRAINT "teachers_fk_0"
    FOREIGN KEY("personId")
    REFERENCES "person"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- MIGRATION VERSION FOR journal_custom
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('journal_custom', '20250520092044338', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250520092044338', "timestamp" = now();

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

--
-- MIGRATION VERSION FOR _repair
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('_repair', '20250520092853129', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250520092853129', "timestamp" = now();


COMMIT;
