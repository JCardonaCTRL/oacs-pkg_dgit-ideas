<?xml version="1.0"?>
<queryset>
    <fullquery name="dgit_ideas::entity::idea_votes::new.insert">
        <querytext>
            insert into dgit_idea_votes ( vote_id, idea_id, vote_type, creation_user, creation_date)
            values (:vote_id, :idea_id, :vote_type, :creation_user, :creation_date)
        </querytext>
    </fullquery>

    <fullquery name="dgit_ideas::entity::idea_votes::edit_vote_type.update">
        <querytext>
            update dgit_idea_votes
            set vote_type = :vote_type,
                creation_date = now()
            where vote_id = :vote_id
        </querytext>
    </fullquery>

    <fullquery name="dgit_ideas::entity::idea_votes::get.select">
        <querytext>
            select *, to_char(creation_date, 'YYYY-MM-DD HH12:MI:SS AM') as creation_date_pretty
            from dgit_idea_votes
            where vote_id = :vote_id
        </querytext>
    </fullquery>

    <fullquery name="dgit_ideas::entity::idea_votes::vote_id_by_user_and_idea.get">
        <querytext>
            select vote_id
            from dgit_idea_votes
            where idea_id = :idea_id
                and creation_user = :creation_user
        </querytext>
    </fullquery>
</queryset>
