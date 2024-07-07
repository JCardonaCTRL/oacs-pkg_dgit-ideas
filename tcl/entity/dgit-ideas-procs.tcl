ad_library {
    Set of TCL procedures to handle dgit_ideas table

    @author: weixiayu@mednet.ucla.edu
    @creation-date: 2021-04-14
}

namespace eval dgit_ideas::entity::ideas {}

ad_proc -public dgit_ideas::entity::ideas::new {
    {-creation_user:required}
    {-context_id:required}
    {-package_id:required}
    {-idea_id ""}
    {-category ""}
    {-subject ""}
    {-details ""}
    {-notify_me_p "FALSE"}
    {-active_p "TRUE"}
    {-status ""}
} {
    Create a new ideas record and @return an idea_id
} {
    if ![exists_and_not_null idea_id] {
        set idea_id [db_nextval "acs_object_id_seq"]
    }
    
    db_transaction {
        db_exec_plsql insert ""
    } on_error {
        db_abort_transaction
        error "Core Ideas: An error occured while inserting a record into table ideas: $errmsg"
    }
    return $idea_id
}

ad_proc -public dgit_ideas::entity::ideas::edit {
    {-idea_id:required}
    {-modifying_user:required}
    {-category}
    {-subject}
    {-details}
    {-notify_me_p}
    {-active_p}
    {-status}
} {
    Edit a new ideas record of table ideas and @return a boolean type success_p
} {
    set success_p       0
    set sql_update      [list]
    set varchar_list    [list subject details notify_me_p active_p category status]
    foreach {column_var} $varchar_list {
        if [info exists $column_var] {
            lappend sql_update "$column_var = :$column_var"
        }
    }

    set sql_update [join $sql_update ,]

    if {$sql_update ne ""} {
        db_transaction {
            db_dml update ""

            if [ad_conn isconnected] {
                set modifying_ip    [ad_conn peeraddr]
            } else {
                set modifying_ip    "system"
            }

            ctrl::acs_object::update_object \
                -object_id      $idea_id \
                -modifying_user $modifying_user \
                -modifying_ip   $modifying_ip

            set success_p 1
        }  on_error {
            db_abort_transaction
            error "Core Ideas: An error occured while updating a record of table ideas: $errmsg"
        }
    }
    return $success_p
}

ad_proc -private dgit_ideas::entity::ideas::get {
    {-idea_id:required}
    {-column_array "idea_info"}
    {-all:boolean}
} {
    Get the record information from table ideas and return an array with the elements
} {
    upvar $column_array row

    set sql_and_where   "AND ideas.active_p IS TRUE"
    if {$all_p} {
        set sql_and_where ""
    }
    return [db_0or1row select "" -column_array row]
}

ad_proc -public dgit_ideas::entity::ideas::mark_delete {
    {-idea_id:required}
    {-modifying_user:required}
} {
    Sets as active_p false for the record in table ideas and @return a boolean type success_p
} {
    set success_p [dgit_ideas::entity::ideas::edit \
        -idea_id $idea_id \
        -modifying_user $modifying_user \
        -active_p FALSE]

    return $success_p
}

ad_proc -public dgit_ideas::entity::ideas::delete {
    {-idea_id:required}
} {
    Delete a record from table ideas and @return a boolean type success_p
} {
    set success_p 0
    db_transaction {
        db_exec_plsql delete ""
        set success_p 1
    }  on_error {
        db_abort_transaction
        error "Core Ideas: An error occured while deleting a record from table ideas: $errmsg"
    }
    return $success_p
}
