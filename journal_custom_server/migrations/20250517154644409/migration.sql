BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "users" CASCADE;

--
-- ACTION DROP TABLE
--
DROP TABLE "person" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "person" (
    "id" bigserial PRIMARY KEY,
    "firstName" text NOT NULL,
    "lastName" text NOT NULL,
    "patronymic" text,
    "email" text NOT NULL,
    "phoneNumber" text,
    "userInfoId" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "user_info_unique" ON "person" USING btree ("userInfoId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "person"
    ADD CONSTRAINT "person_fk_0"
    FOREIGN KEY("userInfoId")
    REFERENCES "serverpod_user_info"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR journal_custom
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('journal_custom', '20250517154644409', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250517154644409', "timestamp" = now();

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
