-- -----------------------------------------------------
-- @author: weixiayu@mednet.ucla.edu
-- @creation-date: 2021-04-13

-- @author: jcardona@mednet.ucla.edu
-- @modification-date: 2021-04-27
-- -----------------------------------------------------

CREATE OR REPLACE FUNCTION inline_0 ()
RETURNS INTEGER AS '
begin
    PERFORM acs_object_type__create_type (
        ''dgit_idea'',      -- object_type
        ''DGIT Idea'',      -- pretty_name
        ''DGIT Ideas'',     -- pretty_plural
        ''acs_object'',     -- supertype
        ''dgit_ideas'',     -- table_name
        ''idea_id'',        -- id_column
         null,              -- package_name (default)
        ''f'',              -- abstract_p (default)
        null,               -- type_extension_table (default)
        null                -- name_method (default)
    );

   return 1;
end;' LANGUAGE 'plpgsql';

SELECT inline_0 ();
DROP FUNCTION inline_0 ();

CREATE OR REPLACE FUNCTION dgit_idea__new (
    idea_id         INTEGER,
    category        VARCHAR,
    subject         VARCHAR,
    details         TEXT,
    notify_me_p     BOOL,
    active_p        BOOL,
    status          VARCHAR,
    creation_date   TIMESTAMPTZ DEFAULT now(),
    creation_user   INTEGER DEFAULT NULL,
    context_id      INTEGER DEFAULT NULL,
    package_id      INTEGER DEFAULT NULL
)
RETURNS INTEGER AS
$$
DECLARE
    v_idea_id     INTEGER;
BEGIN
    v_idea_id     := acs_object__new(
                        idea_id,        -- object_id
                        'dgit_idea',    -- object_type
                        creation_date,  -- creation_date
                        creation_user,  -- creation_user
                        null,           -- creation_ip
                        context_id,     -- context_id
                        null,           -- title
                        package_id      -- package_id
                    );
    INSERT INTO dgit_ideas (
        idea_id, category, subject, details, notify_me_p, active_p, status
    ) VALUES (
        v_idea_id, category, subject, details, notify_me_p, active_p, status
    );

    RETURN v_idea_id;
END;
$$
LANGUAGE 'plpgsql' VOLATILE;

CREATE OR REPLACE FUNCTION dgit_idea__delete(INTEGER)
RETURNS VOID AS '
BEGIN
    DELETE FROM dgit_ideas WHERE idea_id = $1;
    PERFORM acs_object__delete($1);
END;
' LANGUAGE 'plpgsql';
