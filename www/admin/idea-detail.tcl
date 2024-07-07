#/dgit-ideas/www/admin/idea-detail.tcl
ad_page_contract {
    Idea Detail Info

    @author: weixiayu@mednet.ucla.edu
    @creation-date: 2021-05-05
} {
    {idea_id:integer,notnull}
}

## -------------------------------------------------------------------------------
##   Initial settings
## -------------------------------------------------------------------------------
set package_id      [ad_conn package_id]
set login_user_id   [auth::require_login]
set back_url        "[ad_conn package_url]/admin/index"
set ajax_url        "[ad_conn package_url]/admin/list-ajax/comment-list-ajax?[export_vars {idea_id}]"

util_get_user_messages -multirow user_messages

## --------------------------------------------------------------------------------
##  Idea detail settings
## --------------------------------------------------------------------------------
template::multirow create details label value
dgit_ideas::entity::ideas::get -idea_id $idea_id -column_array "idea_info"
template::multirow append details "Category:" [string totitle $idea_info(category_name)]
template::multirow append details "Subject:" $idea_info(subject)
template::multirow append details "Notify?:" $idea_info(notify_me_p_pretty)
template::multirow append details "Details:" $idea_info(details)
template::multirow append details "Vote Up:" $idea_info(vote_up_number)
template::multirow append details "Vote Down:" $idea_info(vote_down_number)
template::multirow append details "Status:" [string totitle $idea_info(status_name)]
template::multirow append details "Creation Date:" $idea_info(creation_date_pretty)
if { $idea_info(last_modified_pretty) > $idea_info(creation_date_pretty) } {
    template::multirow append details "Modifying Date:" $idea_info(last_modified_pretty)
}
template::multirow append details "Creation User:" $idea_info(creation_name)

template::head::add_css -href "//cdn.datatables.net/2.0.3/css/dataTables.dataTables.min.css" -order 99
template::head::add_javascript -src "//cdn.datatables.net/2.0.3/js/dataTables.min.js" -order 99

security::csp::require script-src cdn.datatables.net
security::csp::require style-src cdn.datatables.net