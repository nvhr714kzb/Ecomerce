$(function() {
    // ====================Emoj======================

    $('textarea[name="commentContent"]').emojioneArea();
    // =========================LOAD COMMENT===================
    function load_comment() {
        $.ajax({
            url: "?mod=ajax&act=load_comment",
            method: "POST",
            data: { post_id: post_id },
            dataType: "text",
            success: function(response) {
                $("#list-comment").html(response);
            },
        });
    }

    // ====================Update seen notify like and comment=====================
    $("#box-message").click(function(e) {
        e.preventDefault();
        $.ajax({
            url: "?mod=ajax&act=seen_notify",
            method: "POST",
            dataType: "text",
            data: { count_unseen: count_unseen },
            success: function(response) {
                $("#count-unseen").remove();
            },
        });
    });
    // ==============================ADD REPLY========================
    $(document).on("click", ".reply", function() {
        if (is_login) {
            var comment_id = $(this).data("index");
            $(".comment-form-child").remove();
            var box_comment =
                '<form method="POST" class="comment-form comment-form-child clearfix"><textarea name="commentContent" rows="5" id="box-comment-child"></textarea> <input type="hidden" name="commentId" value="' +
                comment_id +
                '"><input type="submit" name="addComment" value="Add a comment" class="float-right"></form>';
            $(this).parents(".comment-ask").append(box_comment);
            $('textarea[name="commentContent"]').emojioneArea();
        } else {
            swal("You must login to reply this comment!");
        }
    });
    // ==========================ADD LIKE========================
    $(document).on("click", ".num-like", function() {
        if (is_login) {
            var comment_id = $(this).data("id");
            $.ajax({
                url: "?mod=ajax&act=add_like",
                method: "POST",
                data: { comment_id: comment_id },
                dataType: "text",
                success: function(response) {
                    $(".num-like[data-id=" + comment_id + "]").html(
                        "Like (" + response + ")"
                    );
                    if (response > 0) {
                        // load_comment();
                        $(".num-like[data-id=" + comment_id + "]").css("color", "gray");
                    } else {
                        $(".num-like[data-id=" + comment_id + "]").css("color", "");
                    }
                },
            });
        } else {
            swal("You must login to like this comment!");
        }
    });
    //delete when hover error due to emoj
    $(document).on("focus", "#box-comment", function() {
        $(".comment-form-child").remove();
    });
    // ================ADD COMMENT===================
    $(document).on("submit", ".comment-form", function(event) {
        if (is_login) {
            event.preventDefault();
            var form_data = $(this).serialize();
            $.ajax({
                url: "?mod=ajax&act=add_comment",
                method: "POST",
                data: form_data + "&post_id=" + post_id,
                dataType: "text",
                success: function(response) {
                    swal(response);
                    // $('.comment-form').each(function(){
                    //     $(this).reset();
                    // });
                    // $(".comment-form")[0].reset();
                    // $(".comment-form")[1].reset();
                    var element_parent = $("#box-comment").emojioneArea();
                    element_parent[0].emojioneArea.setText('');
                    var element_child = $("#box-comment-child").emojioneArea();
                    element_child[0].emojioneArea.setText('');
                },
            });
        } else {
            swal("You must login to like this comment");
        }
    });
});