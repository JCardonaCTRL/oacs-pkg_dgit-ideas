ad_library {
    Set of TCL procedures to handle dgit_idea_votes table

    @author: weixiayu@mednet.ucla.edu
    @creation-date: 2021-04-19
}

namespace eval dgit_ideas::entity::idea_votes {}

ad_proc -public dgit_ideas::entity::idea_votes::new {
    {-vote_id ""}
    -idea_id:required
    -vote_type:required
    -creation_user:required
    {-creation_date now()}
} {
    Create a new idea_votes record and @return a votes_id
} {
    if ![exists_and_not_null vote_id] {
        set vote_id [db_nextval "dgit_idea_id_seq"]
    }

    db_transaction {
        db_dml insert ""
    } on_error {
        db_abort_transaction
        error "Database: An error occured while inserting a record into idea_votes table: $errmsg"
    }
    return $vote_id
}

ad_proc -public dgit_ideas::entity::idea_votes::edit_vote_type {
    -vote_id:required
    -vote_type:required
} {
    Updates the idea_votes record and @return 1 if success or 0 if error
} {
    set success_p 0
    db_transaction {
        db_dml update ""
        set success_p 1
    } on_error {
        db_abort_transaction
        error "Database: An error occured while updating a record into idea_votes table: $errmsg"
    }
    return $success_p
}

ad_proc -public dgit_ideas::entity::idea_votes::get {
    -vote_id:required
    {-column_array "vote_info"}
} {
    @return a boolean type exist_p. If the record exists, the record array is gotten also.
} {
    upvar $column_array row
    set exist_p [db_0or1row select "" -column_array row]
    return $exist_p
}

ad_proc -public dgit_ideas::entity::idea_votes::vote_id_by_user_and_idea {
    -idea_id:required
    -creation_user:required
} {
    This proc is used to validate the existence of a vote on an specific idea and a user
    so we don't duplicate the records

    @return vote_id based on the parameters
} {
    set vote_id [db_string get "" -default ""]
    return $vote_id
}
