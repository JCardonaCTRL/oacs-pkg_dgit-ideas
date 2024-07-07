ad_library {
    idea-votes procs test case
    @author: weixiayu@mednet.ucla.edu
    @date: 2021-04-19
}

aa_register_case -cats {api db} \
    -procs { \
        dgit_ideas::entity::idea_votes::new \
        dgit_ideas::entity::idea_votes::edit \
        dgit_ideas::entity::idea_votes::get \
    } idea_votes {
        test idea-votes procedures
} {
    aa_run_with_teardown -rollback -test_code {
        set creation_user [ad_conn user_id]
        set package_id [ad_conn package_id]
        set context_id $package_id
        set category_id "general"

        set idea_id [dgit_ideas::entity::ideas::new \
            -creation_user $creation_user \
            -context_id $context_id \
            -package_id $package_id \
            -category_id $category_id \
            -subject "Apple watches for all ucla staff!" \
            -details "I say we should all get apple watches! who's with me?" \
            -notify_me_p TRUE ]

        aa_log "Call dgit_ideas::entity::ideas::new return idea_id = $idea_id "

        set vote_id [dgit_ideas::entity::idea_votes::new \
            -idea_id $idea_id \
            -vote_type "up" \
            -creation_user $creation_user]

        aa_true "Call dgit_ideas::entity::idea_vote::new return vote_id: " $vote_id

        set get_success_p [dgit_ideas::entity::idea_votes::get \
            -vote_id $vote_id \
            -column_array "vote_info"]

        aa_true "Call dgit_ideas::entity::idea_vote::get successfully: " $get_success_p

        set get_vote_type $vote_info(vote_type)
        aa_log "Call get vote_type from vote_info: $get_vote_type "

        set get_creation_date $vote_info(creation_date_pretty)
        aa_log "Call get creation_date_pretty from vote_info: $get_creation_date "

    } -teardown_code {
    }
}

