ad_library {
    idea-comments procs test case
    @author: weixiayu@mednet.ucla.edu
    @date: 2021-04-19
}

aa_register_case -cats {api db} \
    -procs { \
        dgit_ideas::entity::idea_comments::new \
        dgit_ideas::entity::idea_comments::edit \
        dgit_ideas::entity::idea_comments::get \
    } idea_comments {
        test idea-comments procedures
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
        
        set comment_id [dgit_ideas::entity::idea_comments::new \
            -idea_id $idea_id \
            -comments "I second the motion! Can I get a blue and gold wristband with ucla logo on it" \
            -creation_user $creation_user]

        aa_true "Call dgit_ideas::entity::idea_comment::new return comment_id: " $comment_id

        set get_success_p [dgit_ideas::entity::idea_comments::get \
            -comment_id $comment_id \
            -column_array "comment_info"]

        aa_true "Call dgit_ideas::entity::idea_comment::get successfully: " $get_success_p

        set get_comments $comment_info(comments)
        aa_log "Call get comment_type from comment_info: $get_comments "

        set get_creation_date $comment_info(creation_date_pretty)
        aa_log "Call get creation_date_pretty from comment_info: $get_creation_date "

    } -teardown_code {
    }
}

