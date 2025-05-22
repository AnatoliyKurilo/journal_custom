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
    "isPresent" boolean NOT NULL,
    "comment" text
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
-- MIGRATION VERSION FOR journal_custom
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('journal_custom', '20250521110556931', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250521110556931', "timestamp" = now();

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
