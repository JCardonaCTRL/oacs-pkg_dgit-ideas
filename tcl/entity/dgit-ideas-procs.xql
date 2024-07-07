<?xml version="1.0"?>
<queryset>
    <fullquery name="dgit_ideas::entity::ideas::edit.update">
        <querytext>
            UPDATE dgit_ideas
                SET $sql_update
            WHERE idea_id = :idea_id
        </querytext>
    </fullquery>

    <fullquery name="dgit_ideas::entity::ideas::get.select">
        <querytext>
            SELECT
                ideas.*,
                case when notify_me_p is TRUE then 'Yes' else 'No' end as notify_me_p_pretty,
                objects.creation_date,
                objects.last_modified,
                objects.creation_user,
                objects.modifying_user,
                to_char(objects.creation_date, 'YYYY-MM-DD HH12:MI:SS AM') as creation_date_pretty,
                to_char(objects.last_modified, 'YYYY-MM-DD HH12:MI:SS AM') as last_modified_pretty,
                persons.first_names || ' ' || persons.last_name as creation_name,
                u.screen_name as uid,
                category as category_name,
                status as status_name,
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
                ) as vote_down_number
            FROM dgit_ideas ideas
                JOIN acs_objects    objects
                    ON objects.object_id    = ideas.idea_id
                JOIN persons        persons
                    ON objects.creation_user = persons.person_id
                JOIN users          u
                    ON u.user_id         = persons.person_id
            WHERE ideas.idea_id = :idea_id
            $sql_and_where
        </querytext>
    </fullquery>

</queryset>
