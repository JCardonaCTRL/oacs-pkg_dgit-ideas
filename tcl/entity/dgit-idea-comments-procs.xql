<?xml version="1.0"?>
<queryset>
    <fullquery name="dgit_ideas::entity::idea_comments::new.insert">
        <querytext>
            insert into dgit_idea_comments ( comment_id, idea_id, comments, creation_user, creation_date)
            values (:comment_id, :idea_id, :comments, :creation_user, :creation_date)
        </querytext>
    </fullquery>

    <fullquery name="dgit_ideas::entity::idea_comments::get.select">
        <querytext>
            select *, to_char(creation_date, 'YYYY-MM-DD HH12:MI:SS AM') as creation_date_pretty
            from dgit_idea_comments
            where comment_id = :comment_id
        </querytext>
    </fullquery>

    <fullquery name="dgit_ideas::entity::idea_comments::edit.update">
        <querytext>
            update dgit_idea_comments
                set $sql_update
            where comment_id = :comment_id
        </querytext>
    </fullquery>
</queryset>
