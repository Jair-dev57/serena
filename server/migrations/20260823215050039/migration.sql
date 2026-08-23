BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "block_entry" (
    "id" bigserial PRIMARY KEY,
    "dateTime" timestamp without time zone NOT NULL,
    "severity" text NOT NULL,
    "context" text NOT NULL,
    "note" text
);


--
-- MIGRATION VERSION FOR serena_poc
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serena_poc', '20260823215050039', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260823215050039', "timestamp" = now();

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
