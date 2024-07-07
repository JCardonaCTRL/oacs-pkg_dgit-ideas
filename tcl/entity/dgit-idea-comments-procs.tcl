ad_library {
    Set of TCL procedures to handle dgit_idea_comments table

    @author: weixiayu@mednet.ucla.edu
    @creation-date: 2021-04-19
}

namespace eval dgit_ideas::entity::idea_comments {}

ad_proc -public dgit_ideas::entity::idea_comments::new {
    {-comment_id ""}
    {-idea_id:required}
    {-comments ""}
    {-creation_user:required}
    {-creation_date now()}
} {
    Create a new idea_comments record and @return an comment_id
} {
    if ![exists_and_not_null comment_id] {
        set comment_id [db_nextval "dgit_idea_id_seq"]
    }
    set comments [dgit_ideas::entity::aux::filter_str_for_json -str $comments]

    db_transaction {
        db_dml insert ""
    } on_error {
        db_abort_transaction
        error "Database: An error occured while inserting a record into idea_comments table: $errmsg"
    }
    return $comment_id
}

ad_proc -public dgit_ideas::entity::idea_comments::edit {
    {-comment_id:required}
    {-idea_id}
    {-comments}
    {-creation_user:required}
    {-creation_date}
    {-active_p}
} {
    Edit a new idea_comments record and @return a boolean type success_p
} {
    set success_p       0
    set sql_update      [list]
    set varchar_list    [list idea_id comments creation_user creation_date active_p]
    foreach {column_var} $varchar_list {
        if [info exists $column_var] {
            lappend sql_update "$column_var = :$column_var"
        }
    }

    set sql_update [join $sql_update ,]
    if [exists_and_not_null sql_update] {
        db_transaction {
            db_dml update ""
            set success_p 1
        } on_error {
            db_abort_transaction
            error "Idea Comment: An error occured while updating a record of table dgit_idea_comments: $errmsg"
        }
    }
    
    return $success_p
}

ad_proc -public dgit_ideas::entity::idea_comments::get {
    {-comment_id:required}
    {-column_array "comment_info"}
} {
    @return a boolean type exist_p. If the record exists, the record array is gotten also.
} {
    upvar $column_array row
    set exist_p [db_0or1row select "" -column_array row]
    return $exist_p
}
