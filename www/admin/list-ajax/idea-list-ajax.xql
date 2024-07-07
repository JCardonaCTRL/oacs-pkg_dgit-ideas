<?xml version="1.0"?>
<queryset>
    <fullquery name="selected_rows_to_display">
        <querytext>
         select x1.*
         from (
            select  ROW_NUMBER() OVER () as rn, x2.*
            from (
                select ideas.*,
                    case when notify_me_p is TRUE then 'Yes' else 'No' end as notify_me_p_pretty, 
                    to_char(ao.creation_date, 'YYYY-MM-DD HH12:MI:SS AM') as creation_date_pretty,
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
                    ) as vote_down_number,
                    p.first_names || ' ' || p.last_name as creation_name
                from dgit_ideas ideas
                    join acs_objects ao on ideas.idea_id = ao.object_id
                    join persons p on ao.creation_user = p.person_id
                where ideas.active_p IS TRUE 
                $status_filter
                $sql_search_filter
                $sql_order
            ) x2
        ) x1
        $sql_filter_row
        </querytext>
    </fullquery>

    <fullquery name="total_selected_rows">
        <querytext>
            select  count(*) from (
                select ideas.*,
                    to_char(ao.creation_date, 'YYYY-MM-DD HH12:MI:SS AM') as creation_date_pretty,
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
                    ) as vote_down_number,
                    p.first_names || ' ' || p.last_name as creation_name
                from dgit_ideas ideas
                    join acs_objects ao on ideas.idea_id = ao.object_id
                    join persons p on ao.creation_user = p.person_id
                where ideas.active_p IS TRUE    
                $status_filter
                $sql_search_filter
            ) x2
        </querytext>
    </fullquery>

    <fullquery name="total_rows">
        <querytext>
            select  count(*) from (
                select ideas.*,
                    to_char(ao.creation_date, 'YYYY-MM-DD HH12:MI:SS AM') as creation_date_pretty,
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
                    ) as vote_down_number,
                    p.first_names || ' ' || p.last_name as creation_name
                from dgit_ideas ideas
                    join acs_objects ao on ideas.idea_id = ao.object_id
                    join persons p on ao.creation_user = p.person_id
                where ideas.active_p IS TRUE
                $status_filter
            ) x2
        </querytext>
    </fullquery>

</queryset>

