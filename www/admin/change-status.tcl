#/packages/dgit-ideas/www/admin/change-status.tcl
ad_page_contract {
    DGIT Ideas Change Status

    @author: weixiayu@mednet.ucla.edu
    @creation-date: 2021-05-04
} {
    {n_ideas:multiple,notnull}
    {idea_status_to ""}
}


set login_user_id [auth::require_login]
set package_id    [ad_conn package_id]
set return_url "index"
permission::require_permission -party_id $login_user_id -object_id $package_id  -privilege admin

db_transaction {
    if {[llength $n_ideas] > 0 && $idea_status_to ne ""} {
        foreach idea_id $n_ideas {
            dgit_ideas::entity::ideas::edit -idea_id $idea_id -modifying_user $login_user_id -status $idea_status_to    
        }
        set display_message "The status of ideas have been changed."
    } else {
        set display_message "Please select an idea or a correct status."
    }
} on_error {
    set display_message "There is an error occured during status changing for ideas."
} 

set display_message "The status of ideas have been changed."
ad_returnredirect -message $display_message $return_url

