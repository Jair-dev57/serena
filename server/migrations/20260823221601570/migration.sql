BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "exercise_progress" (
    "id" bigserial PRIMARY KEY,
    "exerciseId" text NOT NULL,
    "timesCompleted" bigint NOT NULL,
    "lastCompletedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "exercise_progress_exercise_id_unique" ON "exercise_progress" USING btree ("exerciseId");


--
-- MIGRATION VERSION FOR serena_poc
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serena_poc', '20260823221601570', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260823221601570', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260129180959368', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129180959368', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260213194423028', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260213194423028', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260129181112269', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181112269', "timestamp" = now();


COMMIT;
