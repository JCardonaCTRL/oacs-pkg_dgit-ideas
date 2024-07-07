<?xml version="1.0"?>
<queryset>

    <fullquery name="dgit_ideas::api::ideas::get_list.get">
        <querytext>
            SELECT
                ideas.*,
                to_char(ao.creation_date, 'YYYY-MM-DD HH12:MI:SS AM') as creation_date_pretty,
                (
                    SELECT count(*)
                    FROM dgit_idea_votes iv
                    WHERE iv.idea_id = ideas.idea_id
                        AND lower(iv.vote_type) = 'up'
                        AND iv.active_p IS TRUE
                ) as vote_up_number,
                (
                    SELECT count(*)
                    FROM dgit_idea_votes iv
                    WHERE iv.idea_id = ideas.idea_id
                        AND lower(iv.vote_type) = 'down'
                        AND iv.active_p IS TRUE
                ) as vote_down_number,
                (
                    SELECT lower(iv.vote_type)
                    FROM dgit_idea_votes iv
                    WHERE iv.idea_id = ideas.idea_id
                        AND iv.active_p IS TRUE
                        AND iv.creation_user = :user_id
                ) as my_vote
            FROM dgit_ideas ideas
                JOIN acs_objects ao on ideas.idea_id = ao.object_id
            WHERE ideas.active_p IS TRUE
                AND ideas.status = 'open'
            ORDER BY creation_date_pretty desc
        </querytext>
    </fullquery>

    <fullquery name="dgit_ideas::api::ideas::get_details.get_number_of_vote_up">
        <querytext>
            SELECT count(vote_id) as vote_up_number
            FROM dgit_idea_votes
            WHERE idea_id = :ideaId
                AND lower(vote_type) = 'up'
                AND active_p IS TRUE
        </querytext>
    </fullquery>

    <fullquery name="dgit_ideas::api::ideas::get_details.get_number_of_vote_down">
        <querytext>
            SELECT count(vote_id) as vote_up_number
            FROM dgit_idea_votes
            WHERE idea_id = :ideaId
                AND lower(vote_type) = 'down'
                AND active_p IS TRUE
        </querytext>
    </fullquery>

    <fullquery name="dgit_ideas::api::ideas::get_details.get_my_vote">
        <querytext>
            SELECT lower(iv.vote_type)
            FROM dgit_idea_votes iv
            WHERE iv.idea_id = :ideaId
                AND iv.active_p IS TRUE
                AND iv.creation_user = :user_id
        </querytext>
    </fullquery>

    <fullquery name="dgit_ideas::api::ideas::get_details.get_comments">
        <querytext>
            SELECT
                ic.*,
                p.first_names || ' ' || p.last_name as creation_name
            FROM dgit_idea_comments ic
            JOIN persons p on ic.creation_user = p.person_id
            WHERE ic.idea_id = :ideaId
                AND ic.active_p IS TRUE
        </querytext>
    </fullquery>
</queryset>
