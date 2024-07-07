#/packages/dgit-ideas/admin/list-ajax/idea-list-ajax.tcl
ad_page_contract {
    Ideas List AJAX

    @author: weixiayu@mednet.ucla.edu
    @creation-date:2021-05-03
} {
    {status ""}
}

# -------------------------------------------------------------------------------
# Login Validation
# -------------------------------------------------------------------------------
set login_user_id   [auth::require_login]
set package_id [ad_conn package_id]
set permission_p [permission::permission_p -party_id $login_user_id -object_id $package_id -privilege "admin"]

## ------------------------------------------------------------------------------
## Initial settings
## ------------------------------------------------------------------------------
if { $status ne "" } {
    set status_filter " and status = :status "
} else {
    set status_filter ""
}

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
set field_list [list idea_id c.name subject details cc.name creation_date p.first_names p.last_name]
foreach field_name $field_list {
    if {![empty_string_p $search_value]} {
        if { $field_name eq "idea_id" } {
            lappend sql_search_list "idea_id::text like '%'||lower(:search_value)||'%'"
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

set select ""
db_foreach selected_rows_to_display "" {
    incr row_num
    set field_json [list]
    foreach fs_field $field_list {
        if [empty_string_p $fs_field] {
            continue
        }
        if {$fs_field eq "idea_id"} {
            set new_value "<a href='idea-detail?[export_vars {idea_id}]'>$idea_id</a>"
        } else {
            set $fs_field [ctrl::json::filter_special_chars_dt [set $fs_field]]
            set new_value [set $fs_field]
            set new_value [regsub -all "\r" $new_value " "]
        } 
        lappend field_json [ctrl::json::construct_record  [list [list $fs_field $new_value]]]
    }
    set select "<input type='checkbox' name='n_ideas'  value='$idea_id'>"
    
    lappend field_json [ctrl::json::construct_record [list [list "select" $select]]]
    lappend data_json_list "{[join $field_json ","]}"
}
set iFilteredTotal [db_string total_selected_rows ""]
set iTotal         [db_string total_rows ""]
set result [ctrl::json::construct_record [list [list draw $dt_page_info(draw) i] [list recordsTotal $iTotal] [list recordsFiltered $iFilteredTotal] [list data [join $data_json_list ","] a-joined]]]
doc_return 200 application/json "{$result}"

