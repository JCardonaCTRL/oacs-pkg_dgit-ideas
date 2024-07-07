ad_library {
    Set of TCL procedures to handle ws-api for dgit_idea_comments table

    @author: weixiayu@mednet.ucla.edu
    @creation-date: 2021-04-26
}

namespace eval dgit_ideas::api::idea_comments {}

ad_proc -public dgit_ideas::api::idea_comments::create {
    -appCode:required
    -ideaId:required
    -comments:required
} {
    Return a json file for creating a new idea_comments record
} {
    set response_code       ""
    set response_message    ""
    set response_body       ""

    ctrl::oauth::check_auth_header
    set user_id     $user_info(user_id)
    set token_str   $user_info(cust_acc_token)

    if {$user_id eq "" || $user_id == 0} {
        set response_code       "INVALID"
        set response_message    "Unauthorized : Undefined user"
        set continue_p 0
    } else {
        set continue_p 1
    }

    if {$continue_p} {
        set comment_id  [dgit_ideas::entity::idea_comments::new \
                            -idea_id        $ideaId \
                            -comments       $comments \
                            -creation_user  $user_id ]

        if { $comment_id > 0 } {
            set response_code       "Ok"
            set response_message    "Idea Comment Created Successfully."
        } else {
            set response_code       "Error"
            set response_message    "Idea Comment Not Created."
        }
    }

    if {$response_body eq ""} {
        set return_data_json [ctrl::restful::api_return -response_code      "$response_code" \
                                                        -response_message   "$response_message" \
                                                        -response_body      ""]
    } else {
        set return_data_json [ctrl::restful::api_return -response_code      "$response_code" \
                                                        -response_message   "$response_message" \
                                                        -response_body      "$response_body" \
                                                        -response_body_value_p f]
    }

    doc_return 200 application/json $return_data_json
    ad_script_abort
}
