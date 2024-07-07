#/packages/dgit-ideas/admin/list-ajax/comment-list-ajax.tcl
ad_page_contract {
    Comment List AJAX

    @author: weixiayu@mednet.ucla.edu
    @creation-date:2021-05-03
} {
    {idea_id:integer,notnull}
}

# -------------------------------------------------------------------------------
# Login Validation
# -------------------------------------------------------------------------------
set login_user_id   [auth::require_login]
set package_id      [ad_conn package_id]
set package_url     [ad_conn package_url]
set permission_p    [permission::permission_p -party_id $login_user_id -object_id $package_id -privilege "admin"]
set return_url      "${package_url}/admin/idea-detail?[export_vars {idea_id}]"

ctrl::jquery::datatable::query_param

set sql_order ""
set sql_order_list ""
foreach {col dir} $dt_info(sort_list) {
    lappend sql_order_list "$col $dir"
}

if ![empty_string_p $sql_order_list] {
    set sql_order " order by [join $sql_order_list ","]"
}
# ---------------------------------------------
# Add filter for the numbmer of rows to display
# ----------------------------------------------
array set dt_page_info $dt_info(page_attribute_list)
set sql_filter_row "where rn > $dt_page_info(start) and rn <= [expr $dt_page_info(start)+$dt_page_info(length)]"

# ---------------------------------------------
# Set search up
# ---------------------------------------------
set search_value ""
if ![empty_string_p $dt_info(search_global)] {
    array set search_arr $dt_info(search_global)
    set search_value $search_arr(value)
}

# -----------------------------------------------
# Generate the records to return
# -----------------------------------------------
set sql_search_list  [list]
set sql_search_filter ""
set field_list [list comment_id comments creation_date p.first_names p.last_name]
foreach field_name $field_list {
    if {![empty_string_p $search_value]} {
        if { $field_name eq "comment_id" } {
            lappend sql_search_list "comment_id::text like '%'||lower(:search_value)||'%'"
        } elseif { $field_name eq "creation_date" } {
            lappend sql_search_list "to_char(creation_date, 'YYYY-MM-DD HH12:MI:SS AM') like '%'||lower(:search_value)||'%'"
        } else {
            lappend sql_search_list "lower($field_name) like '%'||lower(:search_value)||'%'"
        }
    }
}

if {[llength $sql_search_list] > 0} {
    set sql_search_filter " and  ([join $sql_search_list " or "])"
}

set data_json_list ""
set field_list [list]

foreach {index column_info} $dt_info(column_info_list) {
    array set column_arr_$index $column_info
    lappend field_list [set column_arr_${index}(data)]
}

set actions ""
db_foreach selected_rows_to_display "" {
    incr row_num
    set field_json [list]
    foreach fs_field $field_list {
        if [empty_string_p $fs_field] {
            continue
        }
        set $fs_field [ctrl::json::filter_special_chars_dt [set $fs_field]]
        set new_value [set $fs_field]
        set new_value [regsub -all "\r" $new_value " "]
        lappend field_json [ctrl::json::construct_record  [list [list $fs_field $new_value]]]
    }
    if $active_p {
        set status "inactive"
        set actions "&nbsp;<button type='button' class='btn btn-danger btn-xs' id='delete-comment-button' data-bs-toggle='modal' data-bs-target='#delete-comment-modal' data-toggle='modal' data-target='#delete-comment-modal' data-id='$comment_id' data-title='Deactivate Comment (ID=$comment_id):' data-status='$status' data-destination='${package_url}/admin/comments/edit-status?[export_vars {comment_id return_url status}]' >Deactivate</button>"
    } else {
         set status "active"
         set actions "&nbsp;<button type='button' class='btn btn-danger btn-xs' id='delete-comment-button' data-bs-toggle='modal' data-bs-target='#delete-comment-modal' data-toggle='modal' data-target='#delete-comment-modal' data-id='$comment_id' data-title='Activate Comment (ID=$comment_id):' data-status='$status' data-destination='${package_url}/admin/comments/edit-status?[export_vars {comment_id return_url status}]' >Activate</button>"
    }
    lappend field_json [ctrl::json::construct_record [list [list "actions" $actions]]]
    lappend data_json_list "{[join $field_json ","]}"
}
set iFilteredTotal [db_string total_selected_rows ""]
set iTotal         [db_string total_rows ""]
set result [ctrl::json::construct_record [list [list draw $dt_page_info(draw) i] [list recordsTotal $iTotal] [list recordsFiltered $iFilteredTotal] [list data [join $data_json_list ","] a-joined]]]
doc_return 200 application/json "{$result}"
