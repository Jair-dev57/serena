BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "exercise" (
    "id" bigserial PRIMARY KEY,
    "exerciseKey" text NOT NULL,
    "title" text NOT NULL,
    "category" text NOT NULL,
    "description" text NOT NULL,
    "steps" json NOT NULL,
    "difficulty" text NOT NULL,
    "durationMinutes" bigint NOT NULL,
    "tags" json NOT NULL,
    "breathingPattern" json
);

-- Indexes
CREATE UNIQUE INDEX "exercise_key_unique" ON "exercise" USING btree ("exerciseKey");


--
-- MIGRATION VERSION FOR serena_poc
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serena_poc', '20260823233319363', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260823233319363', "timestamp" = now();

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
