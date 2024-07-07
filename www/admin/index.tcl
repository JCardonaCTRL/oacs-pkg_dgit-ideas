#/packages/dgit-ideas/www/admin/index.tcl
ad_page_contract {
    DGIT Ideas Main Page

    @author: weixiayu@mednet.ucla.edu
    @creation-date: 2021-05-03
} {
    {status:integer,optional}
}

## -------------------------------------------------------------------------------
##   Permission
## -------------------------------------------------------------------------------
set login_user_id   [auth::require_login]
set package_id      [ad_conn package_id]
set package_url     [ad_conn package_url]
set return_url      [ad_return_url]
permission::require_permission -party_id $login_user_id -object_id $package_id  -privilege admin

set status_option_list [list [list "Open" "open"] [list "Close" "close"]]
template::multirow create status_rows name category_id
foreach option_list $status_option_list {
    lassign $option_list name category_id
    template::multirow append status_rows $name $category_id
}

if ![exists_and_not_null status] {
    set status "open"
}

util_get_user_messages -multirow user_messages

set form_action_url "${package_url}/admin/change-status"
set ajax_url        "${package_url}/admin/list-ajax/idea-list-ajax"

template::head::add_css -href "//cdn.datatables.net/2.0.3/css/dataTables.dataTables.min.css" -order 99
template::head::add_javascript -src "//cdn.datatables.net/2.0.3/js/dataTables.min.js" -order 99

security::csp::require script-src cdn.datatables.net
security::csp::require style-src cdn.datatables.net