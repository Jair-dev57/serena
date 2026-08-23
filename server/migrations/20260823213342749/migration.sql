BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "difficult_word" (
    "id" bigserial PRIMARY KEY,
    "word" text NOT NULL,
    "dateAdded" timestamp without time zone NOT NULL,
    "note" text
);


--
-- MIGRATION VERSION FOR serena_poc
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serena_poc', '20260823213342749', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260823213342749', "timestamp" = now();

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
