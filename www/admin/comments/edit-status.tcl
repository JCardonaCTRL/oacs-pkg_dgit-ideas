#/packages/dgit-ideas/www/admin/comments/edit-status.tcl
ad_page_contract {
    DGIT Idea Comments Edit Status

    @author: weixiayu@mednet.ucla.edu
    @creation-date: 2021-05-04
} {
    {comment_id:integer,notnull}
    {status:notnull}
    {return_url:notnull}
} 

set login_user_id [auth::require_login]
set package_id    [ad_conn package_id]
if { $status eq "inactive" } {
    set active_p "FALSE"
} else {
    set active_p "TRUE"
}

permission::require_permission -party_id $login_user_id -object_id $package_id  -privilege admin

db_transaction {    
    dgit_ideas::entity::idea_comments::edit -comment_id $comment_id -creation_user $login_user_id -active_p $active_p
} on_error {
    set display_message "There is an error occured during status changing for the comment."
}

set display_message "The status of the comment has been changed."
ad_returnredirect -message $display_message $return_url


