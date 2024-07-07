<master>
<style>
   .btn-default {color:black ;}
   .dataTables_filter {text-align: right;}
   .panel.panel-default {position:absolute;right:4em;left:4em;}
   .table-responsive {overflow-x:inherit !important;}
    
</style>
<div class="container">
    <if @user_messages:rowcount@ gt 0>
        <br>
        <div id="alert-message">
            <multiple name="user_messages">
                <div class="alert alert-success" role="alert">
                    <strong>@user_messages.message;noquote@</strong>
                </div>
            </multiple>
        </div>
    </if>
    
    <div class="row">
        <div class="col-sm-12"><h1>Ideas</h1></div>
        <div class="col-sm-12">
            <label>Status Filter:&nbsp;&nbsp;</label>
            <multiple name="status_rows">
                <input type="radio" name="status" value=@status_rows.category_id@>&nbsp;@status_rows.name@ &nbsp;&nbsp;
            </multiple>
            <input type="radio" name="status" value="" checked>&nbsp;All&nbsp;&nbsp;
        </div>
    </div>
    
    <div class="table-responsive">
        <form method="post" id="form_change_status" action=@form_action_url@>
            <br> 
            <table cellpadding="0" cellspacing="0" border="0" class="table table-condensed table-striped" id="idea_list" width="100%"> 
            </table>
            <p class="text-primary">Change status of selected ideas to: 
                <select id="idea_status_to" name="idea_status_to" >
                    <option value="" selected> &nbsp;-- Select status --&nbsp; </option>
                    <multiple name="status_rows">
                        <option value=@status_rows.category_id@>&nbsp;@status_rows.name@ &nbsp;&nbsp</option>
                    </multiple>
                </select> 
            </p>
            <div class="alert alert-danger idea-alert" role="alert">Please select an idea!!!</div>
        </form>
    </div>
</div>

<!-- update status modal -->
<div class="modal fade" id="update-status-modal" tabindex="-1" role="dialog" aria-labelledby="updateStatusLabel">
   <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header resume-edit-model-header">
        <button type="button" class="close" data-dismiss="modal" data-bs-dismiss="modal" id="aa_cancel_x" aria-label="Close">
            <span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title resume_form_title" id="update_status_header">Update Status of Ideas:</h4>
      </div>
      <div id="updateBox" class="modal-body">
            Are you sure you want to update status of selected ideas?
      </div>
      <div class="modal-footer">
        <button id="update-status" type="button" class="btn btn-info">Update Status</button>
        <button type="button" id="update-cancel" class="btn btn-default" data-dismiss="modal" data-bs-dismiss="modal">Cancel</button>
      </div>
    </div>
   </div>
</div>

<script type="text/javascript" <if @::__csp_nonce@ not nil> nonce="@::__csp_nonce;literal@"</if>>
    // -- update-status-modal --
    $("#update-status-modal").on('show.bs.modal', function (event) {
        var modal = $(this);
        var status_label = $("#idea_status_to option:selected").text().trim();
        modal.find('.modal-body').text("Are you sure you want to update status of selected ideas to " + status_label + "?");
        $("#update-status").click(function() {
            $("#form_change_status").submit();
        });
        
        $("#update-cancel").click(function() {
            $("#idea_status_to").val("");
            $("#form_change_status input[name=n_ideas]").prop("checked", false);
        });
    });

    $("#idea_status_to").change(function() {
        var n_ideas_checked = $("#form_change_status input[name=n_ideas]:checked");
        if ( n_ideas_checked.length > 0 ) {
            $("#update-status-modal").modal('show');
        } else {
            $(".idea-alert").show();
            $(".idea-alert").fadeTo(2000, 500).slideUp(500, function() {
                $(".idea-alert").slideUp(500);
            });
            $("#idea_status_to").val("");
        }
    });
    
    $(document).ready(function() {
        $(".idea-alert").hide();
        var ideasDatatable = $('#idea_list').DataTable ({
            "destroy":true,
            "columns": [
                {"data":"select", "title": "Select", "orderable": false, "className":"text-center", "width":"40px"},
                {"data":"idea_id", "title": "ID", "orderable": true, "width":"50px"},
                {"data":"category_name", "title": "Category", "orderable": true},
                {"data":"subject", "title":"Subject", "orderable": true},
                {"data":"notify_me_p_pretty", "title":"Notify?", "orderable":true},
                {"data":"details", "title":"Details", "orderable": true},
                {"data":"vote_up_number", "title":"Vote Up", "orderable": true},
                {"data":"vote_down_number", "title":"Vote Down", "orderable": true},
                {"data":"status_name", "title":"Status", "orderable":true},
                {"data":"creation_date_pretty", "title":"Creation Date", "orderable":true},
                {"data":"creation_name", "title":"Creation User", "orderable":true}
            ],
           "processing": true,
           "serverSide": true,
           "searching":  true,
           "paging":     true,
           "pageLength": 25,
           "stateSave":  true,
           "bSort": true,
           "ajax": {
                "url":"@ajax_url;noquote@",
                "method": "get"
            },
            "order": [["9","desc"]]
        });

        $("#alert-message").fadeTo(2000, 500).slideUp(500, function() {
            $("#alert-message").slideUp(500);
        });
       
        $("input[type=radio][name=status]").change(function() {
            var status = $("input[name=status]:checked").val();
            var json_url = "@ajax_url;literal@?";
            json_url += "status=" + status ;
            ideasDatatable.ajax.url(json_url).load();
        });
    });
</script>


