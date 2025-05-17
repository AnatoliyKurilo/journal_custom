BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "classes" DROP CONSTRAINT "classes_fk_5";
ALTER TABLE "classes" DROP CONSTRAINT "classes_fk_1";
ALTER TABLE "classes" DROP CONSTRAINT "classes_fk_2";
ALTER TABLE "classes" DROP CONSTRAINT "classes_fk_3";
ALTER TABLE "classes" DROP CONSTRAINT "classes_fk_4";
ALTER TABLE "classes" DROP COLUMN "groupId";
ALTER TABLE ONLY "classes"
    ADD CONSTRAINT "classes_fk_1"
    FOREIGN KEY("typeId")
    REFERENCES "class_types"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "classes"
    ADD CONSTRAINT "classes_fk_2"
    FOREIGN KEY("teacherId")
    REFERENCES "teachers"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "classes"
    ADD CONSTRAINT "classes_fk_3"
    FOREIGN KEY("semesterId")
    REFERENCES "semesters"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "classes"
    ADD CONSTRAINT "classes_fk_4"
    FOREIGN KEY("subgroupId")
    REFERENCES "subgroups"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- MIGRATION VERSION FOR journal_custom
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('journal_custom', '20250517064631179', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250517064631179', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
