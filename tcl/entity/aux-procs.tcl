ad_library {
    Set of auxiliary TCL procedures

    @author: shhong
    @creation-date: 2022-09-12
}

namespace eval dgit_ideas::entity::aux {}

ad_proc -public dgit_ideas::entity::aux::filter_str_for_json {
    {-str:required}
} {
    Filter string for json
} {
    regsub -all {\\} $str {\\\\} str
    regsub -all {"} $str {\\\\"} str
    return $str
}
