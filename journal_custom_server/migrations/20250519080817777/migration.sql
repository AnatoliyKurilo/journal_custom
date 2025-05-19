BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "classes" DROP CONSTRAINT "classes_fk_5";
ALTER TABLE "classes" DROP CONSTRAINT "classes_fk_0";
ALTER TABLE "classes" DROP CONSTRAINT "classes_fk_1";
ALTER TABLE "classes" DROP CONSTRAINT "classes_fk_2";
ALTER TABLE "classes" DROP CONSTRAINT "classes_fk_3";
ALTER TABLE "classes" DROP CONSTRAINT "classes_fk_4";
ALTER TABLE "classes" DROP COLUMN "subjectId";
ALTER TABLE ONLY "classes"
    ADD CONSTRAINT "classes_fk_0"
    FOREIGN KEY("subjectsId")
    REFERENCES "subjects"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "classes"
    ADD CONSTRAINT "classes_fk_1"
    FOREIGN KEY("class_typesId")
    REFERENCES "class_types"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "classes"
    ADD CONSTRAINT "classes_fk_2"
    FOREIGN KEY("teachersId")
    REFERENCES "teachers"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "classes"
    ADD CONSTRAINT "classes_fk_3"
    FOREIGN KEY("semestersId")
    REFERENCES "semesters"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "classes"
    ADD CONSTRAINT "classes_fk_4"
    FOREIGN KEY("subgroupsId")
    REFERENCES "subgroups"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
--
-- ACTION ALTER TABLE
--
DROP INDEX "students_groups_unique_idx";
CREATE INDEX "students_groups_unique_idx" ON "students" USING btree ("groupsId");

--
-- MIGRATION VERSION FOR journal_custom
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('journal_custom', '20250519080817777', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250519080817777', "timestamp" = now();

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
