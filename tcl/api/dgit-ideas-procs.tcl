ad_library {
    Set of TCL procedures to handle ws-api for dgit_ideas table

    @author: weixiayu@mednet.ucla.edu
    @creation-date: 2021-04-21
}

namespace eval dgit_ideas::api::ideas {}

ad_proc -public dgit_ideas::api::ideas::get_categories {
} {
    @return a json file for idea categories list
} {
    set response_code       ""
    set response_message    ""
    set response_body       ""

    set category_list [list [list "Idea" "idea"] [list "General" "general"]]

    set list_json [list]
    foreach row $category_list {
        lassign $row name category_id
        set category_list       [list]
        lappend category_list   [list "name" $name ""]
        lappend category_list   [list "categoryId" $category_id ""]
        lappend list_json       [list [ctrl::json::construct_record $category_list]]
    }
    set body [ctrl::json::construct_record [list [list "categoryList" $list_json "a"]]]
    set response_body $body

    if { [llength $category_list] > 0 } {
        set response_code       "Ok"
        set response_message    "Idea Categories Return Successfully."
    } else {
        set response_code       "Error"
        set response_message    "No Idea Categories Return."
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

ad_proc -public dgit_ideas::api::ideas::create {
    -appCode:required
    -categoryId:required
    {-subject ""}
    {-details ""}
    {-notifyMeP "FALSE"}
} {
    @return a json file for creating a new ideas record
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
        set package_id  [ad_conn package_id]
        set idea_id     [dgit_ideas::entity::ideas::new \
                            -creation_user  $user_id \
                            -context_id     $package_id \
                            -package_id     $package_id \
                            -category       $categoryId \
                            -subject        $subject  \
                            -details        $details \
                            -notify_me_p    $notifyMeP \
                            -status         "open"]

        if { $idea_id > 0 } {
            set response_code       "Ok"
            set response_message    "Idea Created Successfully."
            set response_body       [ctrl::json::construct_record  [list [list "ideaId" "$idea_id"]]]
        } else {
            set response_code       "Error"
            set response_message    "Idea Not Created."
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

ad_proc -public dgit_ideas::api::ideas::update {
    -appCode:required
    -ideaId:required
    {-categoryId:required}
    {-subject ""}
    {-details ""}
    {-notifyMeP "FALSE"}
} {
    @return a json file for updating a new ideas record
} {
    set response_code       ""
    set response_message    ""
    set response_body       ""
    set package_id [ad_conn package_id]

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
        set success_p   [dgit_ideas::entity::ideas::edit \
                            -idea_id        $ideaId \
                            -modifying_user $user_id \
                            -category       $categoryId \
                            -subject        $subject  \
                            -details        $details  \
                            -notify_me_p    $notifyMeP]

        if {$success_p}  {
            set response_code       "Ok"
            set response_message    "Idea Updated Successfully."
            set response_body       [ctrl::json::construct_record  [list [list "ideaId" "$ideaId"]]]
        } else {
            set response_code       "Error"
            set response_message    "Idea Not Updated."
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

ad_proc -public dgit_ideas::api::ideas::get_list {
} {
    @return a json file for getting idea list
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
        set list_json [list]
        db_foreach get "" {
            set idea_list [list]
            lappend idea_list [list "ideaId"        $idea_id ""]
            lappend idea_list [list "categoryId"    $category ""]
            lappend idea_list [list "categoryName"  [string totitle $category] ""]
            lappend idea_list [list "subject"       $subject ""]
            lappend idea_list [list "voteUpNumber"  $vote_up_number ""]
            lappend idea_list [list "voteDownNumber" $vote_down_number ""]
            lappend idea_list [list "myVote"        "$my_vote" ""]
            lappend idea_list [list "creationDate"  $creation_date_pretty ""]
            lappend list_json [list [ctrl::json::construct_record $idea_list]]

        }
        set body [ctrl::json::construct_record   [list [list "ideaList" "$list_json" "a"]]]
        set response_code       "Ok"
        set response_message    "Idea list."
        set response_body       $body
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

ad_proc -public dgit_ideas::api::ideas::get_details {
    {-ideaId:required}
} {
    @return a json file for getting the idea details
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
        set list_json       [list]
        set comments_json   [list]

        db_foreach get_comments "" {
            set comment_list [list]
            lappend comment_list [list "commentId"      $comment_id ""]
            lappend comment_list [list "comments"       $comments ""]
            lappend comment_list [list "creationName"   $creation_name ""]
            lappend comment_list [list "creationDate"   $creation_date ""]
            lappend comments_json [list [ctrl::json::construct_record $comment_list]]
        }

        dgit_ideas::entity::ideas::get -idea_id $ideaId -column_array "idea_info"

        set idea_details_list       [list]
        lappend idea_details_list   [list "categoryId"  $idea_info(category)]
        lappend idea_details_list   [list "subject"     $idea_info(subject)]
        lappend idea_details_list   [list "details"     $idea_info(details)]

        set vote_up_number          [db_string get_number_of_vote_up "" -default 0]
        set vote_down_number        [db_string get_number_of_vote_down "" -default 0]
        set my_vote                 [db_string get_my_vote "" -default ""]
        lappend idea_details_list   [list "voteUpNumber"    $vote_up_number ""]
        lappend idea_details_list   [list "voteDownNumber"  $vote_down_number ""]
        lappend idea_details_list   [list "myVote"          $my_vote ""]

        lappend idea_details_list   [list "creationDate" $idea_info(creation_date_pretty) ""]
        lappend idea_details_list   [list "creationName" $idea_info(creation_name) ""]

        lappend idea_details_list   [list "commentsList" $comments_json "a"]

        set list_json [list [ctrl::json::construct_record $idea_details_list]]

        set body [ctrl::json::construct_record   [list [list "ideaDetails" "$list_json" "a-p"]]]

        set response_code       "Ok"
        set response_message    "Idea details."
        set response_body       $body
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
