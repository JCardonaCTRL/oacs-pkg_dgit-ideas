-- -----------------------------------------------------
-- @author: weixiayu@mednet.ucla.edu
-- @creation-date: 2021-04-13

-- @author: jcardona@mednet.ucla.edu
-- @modification-date: 2021-04-27
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS "dgit_idea_comments" (
    "comment_id"    INTEGER NOT NULL
        CONSTRAINT dgit_idea_comments_pk
            PRIMARY KEY,
    "idea_id"   INTEGER NOT NULL
        CONSTRAINT dgit_idea_comments_idea_id_fk
            REFERENCES dgit_ideas(idea_id)
            ON DELETE CASCADE,
    "comments"  TEXT,
    "creation_user"  INTEGER NOT NULL
        CONSTRAINT dgit_idea_comments_creation_user_fk
            REFERENCES users(user_id)
            ON DELETE SET NULL,
    "creation_date"  TIMESTAMP DEFAULT now(),
    "active_p" BOOL DEFAULT 'TRUE'
);
