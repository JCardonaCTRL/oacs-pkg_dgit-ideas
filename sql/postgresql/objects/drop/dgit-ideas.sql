-- -----------------------------------------------------
-- @author: weixiayu@mednet.ucla.edu
-- @creation-date: 2021-04-13

-- @author: jcardona@mednet.ucla.edu
-- @modification-date: 2021-04-27
-- -----------------------------------------------------

drop function if exists dgit_idea__new(
    idea_id         INTEGER,
    category        VARCHAR,
    subject         VARCHAR,
    details         TEXT,
    notify_me_p     BOOL,
    active_p        BOOL,
    status          VARCHAR,
    creation_date   TIMESTAMPTZ,
    creation_user   INTEGER ,
    context_id      INTEGER ,
    package_id      INTEGER
);

drop function if exists dgit_idea__delete(integer);

delete from acs_objects where object_type = 'dgit_idea';

select content_type__drop_type (
       'dgit_idea',    -- content_type
       't',             -- drop_children_p
       'f'              -- drop_table_p
);

select drop_package('dgit_idea');
