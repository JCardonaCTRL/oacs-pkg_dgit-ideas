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
        <div class="col-sm-5"><h1>IDEA DETAILS </h1></div>
        <div class="col-sm-7 text-right"><h1><a href="@back_url;literal@" class="button" title="Go Back" >Go Back</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</h1></div>
    </div>

    <div class="margin-form">
        <multiple name="details">
            <div class="form-item-wrapper">
                <div class="form-label" style="font-weight:bold;">@details.label;noquote@</div>
                <div class="form-widget">&nbsp;@details.value;noquote@</div>
            </div>
        </multiple>
    </div>
    <hr>
    <div class="table-responsive">
        <table cellpadding="0" cellspacing="0" border="0" class="table table-condensed table-striped" id="comment_list" width="100%">
        </table>
    </div>
</div>

<!-- delete-modal -->
<div class="modal fade" id="delete-comment-modal" tabindex="-1" role="dialog" aria-labelledby="deleteCommentLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header resume-delete-model-header">
        <button type="button" class="close" data-dismiss="modal" data-bs-dismiss="modal" id="aa_cancel_x" aria-label="Close">
            <span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title resume_form_title" id="delete_header"></h4>
      </div>
      <div id="deleteBox" class="modal-body">
            Are you sure you want to delete the comment?
      </div>
      <div class="modal-footer">
        <button id="delete-comment" type="button" class="btn btn-danger">Delete Comment</button>
        <button type="button" class="btn btn-default" data-dismiss="modal" data-bs-dismiss="modal">Cancel</button>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript" <if @::__csp_nonce@ not nil> nonce="@::__csp_nonce;literal@"</if>>
    // delete-modal
    $("#delete-comment-modal").on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget); // Button that triggered the modal
        var title = button.data('title'); // Extract info from data-* attributes
        var status = button.data('status');
        var destination = button.data('destination');
        console.log("title=" + title + " and destination=" + destination);
        var modal = $(this);

        modal.find('.modal-title').text(title);
        if ( status == "inactive") {
            modal.find('.modal-body').text("Are you sure you want to deactivate the comment?");
            modal.find('#delete-comment').html("Deactivate Comment");
        } else {
            modal.find('.modal-body').text("Are you sure you want to activate the comment?");
            modal.find('#delete-comment').html("Activate Comment");
        }
        $("#delete-comment").click(function() {
            location.href = destination;
        });
    });

    $(document).ready(function() {
        var ideasDatatable = $('#comment_list').DataTable ({
            "destroy":true,
            "columns": [
                {"data":"comment_id", "title": "ID", "orderable": true, "width":"50px"},
                {"data":"comments", "title":"Comments", "orderable": true, "class": "left"},
                {"data":"creation_date_pretty", "title":"Creation Date", "orderable":true, "class":"left"},
                {"data":"creation_name", "title":"Creation User", "orderable":true, "class":"left"},
                {"data":"active_p_pretty", "title":"Status", "orderable":true, "class":"left"},
                {"data":"actions", "title":"Actions", "orderable": false, "class":"left"}
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
            "order": [["2","desc"]]
        });

        $("#alert-message").fadeTo(2000, 500).slideUp(500, function() {
            $("#alert-message").slideUp(500);
        });        
    });
</script>
