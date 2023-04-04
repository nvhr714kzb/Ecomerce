$(function() {
    // ===================Start chat==================
    $(document).on("click", ".start-chat", function() {
        $to_user_id = $(this).data("touserid");
        $to_user_name = $(this).data("tousername");
        $avatar = $(this).data("avatar");
        make_chat_dialog_box($to_user_id, $to_user_name, $avatar); //create box dialog
        // fetch_user_chat_history();
        // $("#chat-box").fadeIn();//open box dialog
        fetch_user_chat_history($to_user_id); //fetch message
        // $(this).fadeOut();
        $('.chat-message').emojioneArea();
        count_unseen_message();
    });

    //   ======================CLOSE DIALOG===============
    $(document).on("click", "#chat-box .close", function() {
        $("#box").remove();
    });

    // =============================Interval===========================
    setInterval(function() {
        update_last_activity();
        // fetch_user();
        count_unseen_message();
        update_chat_history_data();
    }, 3000);

    $(document).on("click", ".send-chat", function() {
        var to_user_id = $(this).attr("id");
        var chat_message = $("#chat-message-" + to_user_id + "").val();
        if (chat_message.trim().length != 0 && chat_message.trim().length < 200) {
            $.ajax({
                url: "?mod=ajax&act=add_message",
                method: "POST",
                dataType: "text",
                data: { to_user_id: to_user_id, chat_message: chat_message },
                success: function(response) {
                    // $("#chat-message-" + to_user_id).val();
                    var element = $("#chat-message-" + to_user_id).emojioneArea();
                    element[0].emojioneArea.setText('');
                    $("#chat-history-" + to_user_id + "").html(response);
                },
            });
        } else if (chat_message.trim().length == 0) {
            swal("Please enter your message!");
        }

    });
    // ===================Open dialog==================
    function make_chat_dialog_box($toUserId, $toUserName, $avatar) {
        var modal_content = "<div id='box'>";
        modal_content += '<button class="close"><i class="fas fa-times"></i></button>';
        modal_content += '<div class="contact d-flex">';
        modal_content +=
            '<div class="pic" style="width:50px"><img src="public/images/avatar/' +
            $avatar +
            '" alt="" ></div>';

        modal_content += '<p class="name">' + $toUserName + "</p>";
        modal_content += "</div>";
        modal_content += '<div class="messages">';
        modal_content += '<div id="chat-history-' + $toUserId + '" class="chat-history"  data-touserid="' + $toUserId + '">';
        modal_content += "</div>";
        modal_content += "</div>";
        modal_content += '<div class="input">';
        modal_content +=
            '<textarea name=""  style="resize: none" class="chat-message" id="chat-message-' +
            $toUserId +
            '" maxlength="200"></textarea>';
        modal_content +=
            '<button class="send-chat" id="' + $toUserId + '">Send</button>';
        modal_content += "</div>";
        modal_content += "</div>";

        modal_content += "</div>";
        $("#chat-box").html(modal_content);
    }

    // function fetch_user() {
    //     $.ajax({
    //         url: "?mod=ajax&act=fetch_user.php",
    //         method: "POST",
    //         success: function(response) {
    //             $("#list_user_for_chat").html(response);
    //         },
    //     });
    // }
    function count_unseen_message() {
        $.ajax({
            url: "?mod=ajax&act=count_unseen_message",
            method: "POST",
            success: function(response) {
                if (response != 0) {
                    $("#count-unseen-message").text(response);
                    $("#count-unseen-message").css("background-color", "#ec0101");
                } else {
                    $("#count-unseen-message").text('');
                    $("#count-unseen-message").css("background-color", "transparent");
                }

            },
        });
    }

    function update_last_activity() {
        $.ajax({
            url: "?mod=ajax&act=update_last_activity",
            success: function() {},
        });
    }

    function fetch_user_chat_history(toUserId) {
        $.ajax({
            url: "?mod=ajax&act=fetch_user_chat_history",
            method: "POST",
            data: { to_user_id: toUserId },
            success: function(response) {
                $("#chat-history-" + toUserId + "").html(response);
            },
        });
    }

    function update_chat_history_data() {
        //   $('.chat_history').each(function(){
        //         var to_user_id = $(this).data('touserid');
        //         fetch_user_chat_history(to_user_id);
        //   });
        if ($(".chat-history").length) {
            var to_user_id = $(".chat-history").data("touserid");
            fetch_user_chat_history(to_user_id);
        }
    }

    // ====================Remove chat======================
    $(document).on('click', '.remove-chat', function() {
        var chat_message_id = $(this).attr('id');
        if (confirm('Are you sure you want to remove this message?')) {
            $.ajax({
                url: '?mod=ajax&act=remove_chat',
                method: 'POST',
                data: { chat_message_id: chat_message_id },
                success: function() {
                    update_chat_history_data();
                }
            })
        }
    });
});
// ===================Typing======================
// $(document).on('focus', '.chat-message', function () {
//   console.log("Blur");
//   var is_type = 'yes';
//   $.ajax({
//     url: 'update_is_type_status.php',
//     method: 'POST',
//     data: { is_type: is_type },
//     success: function () {
//     }
//   })
// });
// $(document).on('blur', '.chat-message', function () {
//   console.log("Blur");
//   var is_type = 'no';
//   $.ajax({
//     url: 'update_is_type_status.php',
//     method: 'POST',
//     data: { is_type: is_type },
//     success: function () {

//     }
//   })
// });