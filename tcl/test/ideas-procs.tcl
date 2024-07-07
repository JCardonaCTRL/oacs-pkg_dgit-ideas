ad_library {
    ideas procs test case
    @author: weixiayu@mednet.ucla.edu
    @date: 2021-04-19
}

aa_register_case -cats {api db} \
    -procs { \
        dgit_ideas::entity::ideas::new \
        dgit_ideas::entity::ideas::edit \
        dgit_ideas::entity::ideas::get \
        dgit_ideas::entity::ideas::mark_delete \
    } ideas {
        test ideas procedures
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
        
        set edit_success_p [dgit_ideas::entity::ideas::edit \
            -idea_id $idea_id \
            -modifying_user $creation_user \
            -category_id $category_id \
            -subject "Apple watches for all ucla staff and students!" \
            -notify_me_p FALSE \
            -active_p TRUE]            

        aa_true "Call dgit_ideas::entity::ideas::edit successfully: " $edit_success_p     

        set get_success_p [dgit_ideas::entity::ideas::get \
            -idea_id $idea_id \
            -column_array idea_info \
            -all]
        
        aa_true "Call dgit_ideas::entity::ideas::get successfully: " $get_success_p

        set get_subject $idea_info(subject)
        aa_log "Call get subject from idea_info: $get_subject "

        set get_notify_me_p $idea_info(notify_me_p)
        aa_log "Call get notify_me_p from idea_info: $get_notify_me_p "

        set get_active_p $idea_info(active_p)
        aa_log "Call get active_p from idea_info: $get_active_p "

        set mark_delete_success_p [dgit_ideas::entity::ideas::mark_delete \
            -idea_id $idea_id \
            -modifying_user $creation_user]
        aa_true "Call dgit_ideas::entity::ideas::mark_delete successfully: " $mark_delete_success_p

        set get_success_p [dgit_ideas::entity::ideas::get \
            -idea_id $idea_id \
            -column_array new_idea_info \
            -all]
        set get_new_active_p $new_idea_info(active_p)
        aa_log "Call get active_p after mark_delete from idea_info: $get_new_active_p "

        set delete_success_p [dgit_ideas::entity::ideas::delete -idea_id $idea_id]
        aa_true "Call dgit_ideas::entity::ideas::delete successfully: " $delete_success_p

    } -teardown_code {
    }
}
