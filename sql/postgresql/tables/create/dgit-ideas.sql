-- -----------------------------------------------------
-- @author: weixiayu@mednet.ucla.edu
-- @creation-date: 2021-04-13

-- @author: jcardona@mednet.ucla.edu
-- @modification-date: 2021-04-27
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS "dgit_ideas" (
    "idea_id"       INTEGER NOT NULL
        CONSTRAINT dgit_ideas_pk
            PRIMARY KEY
        CONSTRAINT dgit_ideas_object_id_fk
            REFERENCES acs_objects(object_id)
            ON DELETE CASCADE,
    "category"      VARCHAR(100) DEFAULT 'idea',
    "subject"       VARCHAR(500) NOT NULL,
    "details"       TEXT,
    "notify_me_p"   BOOL DEFAULT 'FALSE',
    "status"        VARCHAR(100) DEFAULT 'open',
    "active_p"      BOOL DEFAULT 'TRUE'
);
