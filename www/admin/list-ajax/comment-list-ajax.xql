<?xml version="1.0"?>
<queryset>
    <fullquery name="selected_rows_to_display">
        <querytext>
            select x1.*
            from (
                select ROW_NUMBER() OVER () as rn, x2.*
                from (
                    select dic.*, 
                        to_char(dic.creation_date, 'YYYY-MM-DD HH12:MI:SS AM') as creation_date_pretty,
                        p.first_names || ' ' || p.last_name as creation_name,
                        case when dic.active_p is TRUE then 'Active' else 'Inactive' end as active_p_pretty
                    from dgit_idea_comments dic join persons p
                        on dic.creation_user = p.person_id
                    where dic.idea_id = :idea_id
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
                select dic.*,
                    to_char(dic.creation_date, 'YYYY-MM-DD HH12:MI:SS AM') as creation_date_pretty,
                    p.first_names || ' ' || p.last_name as creation_name,
                    case when dic.active_p is TRUE then 'Active' else 'Inactive' end as active_p_pretty
                from dgit_idea_comments dic join persons p
                    on dic.creation_user = p.person_id
                where dic.idea_id = :idea_id
                $sql_search_filter
            ) x2
        </querytext>
    </fullquery>

    <fullquery name="total_rows">
        <querytext>
            select  count(*) from (
                select dic.*,
                    to_char(dic.creation_date, 'YYYY-MM-DD HH12:MI:SS AM') as creation_date_pretty,
                    p.first_names || ' ' || p.last_name as creation_name,
                    case when dic.active_p is TRUE then 'Active' else 'Inactive' end as active_p_pretty
                from dgit_idea_comments dic join persons p
                    on dic.creation_user = p.person_id
                where dic.idea_id = :idea_id
            ) x2
        </querytext>
    </fullquery>

</queryset>

