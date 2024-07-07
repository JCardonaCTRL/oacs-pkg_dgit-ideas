<?xml version="1.0"?>
<queryset>
    <fullquery name="dgit_ideas::entity::ideas::new.insert">
        <querytext>
            SELECT dgit_idea__new(
                :idea_id::integer,
                :category::varchar,
                :subject::varchar,
                :details::varchar,
                :notify_me_p,
                :active_p,
                :status::varchar,
                now(),
                :creation_user::integer,
                :context_id::integer,
                :package_id::integer
            )
        </querytext>
    </fullquery>

    <fullquery name="dgit_ideas::entity::ideas::delete.delete">
        <querytext>
            SELECT dgit_idea__delete(:idea_id::integer)
        </querytext>
    </fullquery>

</queryset>
         SELECT dgit_idea__new(
         '1536'::integer,
         'idea'::varchar
         'Test'::varchar,
         'Testing community ideas'::varchar,
         'false',
         'TRUE',
         'open'::varchar,
         now(),
         '1319'::integer,
         '1291'::integer,
         '1291'::integer)"
