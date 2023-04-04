<?php
function get_user($uerId)
{
    $q = "CALL get_info_user($uerId)";
    return db_fetch_row($q);
}
function get_list_message($fromUserId, $toUserId)
{
    $q = "CALL get_list_message($fromUserId, $toUserId)";
    return db_fetch_array($q);
}
function fetch_user_chat_history($from_user_id, $to_user_id)
{
    $list_message = get_list_message($from_user_id, $to_user_id);
    $output = '';
    foreach ($list_message as $message) {
        if ($message["from_user_id"] == $from_user_id) {
            if($message['status'] == 2){
                $chat_message = 'This message has been removed';
                $button = '';
            }else{
                $chat_message = htmlspecialchars($message["chat_message"]);
                // $button = '<button class="remove-chat" id ="'.$message['chat_message_id'].'">x</button>';
                $button = '<button class="remove-chat" id ="'.$message['chat_message_id'].'"><i class="far fa-trash-alt"></i></button>';
            }
            $output .= '<div class="message parker">
                            <div class="message-info">
                                <span class="message-name">You</span>
                                <span class="message-date">'.date('d/m/Y', strtotime($message['date_created'])).''.$button.'</span>
                            </div>
                            <div class="message-content">
                                '.$chat_message.'
                            </div>
                         </div>';
        } else {
            if($message['status'] == 2){
                $chat_message = 'This message has been removed';
            }else{
                $chat_message = htmlspecialchars($message["chat_message"]);
            }
            $name = get_user($message['from_user_id'])['name'];
            $output .= '<div class="message stark">
                            <div class="message-info">
                                <span  class="message-name">'.$name.'</span>
                                <span>'.date('d/m/Y', strtotime($message['date_created'])).'</span>
                            </div>
                            <div class="message-content">
                                '.$chat_message.'
                            </div>
                        </div>
            ';
        }
    }
    update_seen_message($to_user_id, $from_user_id);//seen message
    return $output;
}
function add_message($toUserId, $fromUserId, $message){
    $q = "CALL add_message($toUserId, $fromUserId, '$message')";
    db_query($q);
}
function update_seen_message($fromUserId, $toUserId){
    $q = "CALL update_seen_message($fromUserId, $toUserId)";
    db_query($q);
}
function fetch_user_last_activity($userId)
{
       $q = "CALL fetch_user_last_activity($userId)";
       list($last_activity) = db_fetch_row($q);
       return $last_activity;
}
// ====================COUNT UNSENN MESSAGE====================
function count_unseen_message($fromUserId, $toUserId)
{
       $q = "CALL count_unseen_message($fromUserId, $toUserId)";
       list($count) = db_fetch_row($q);
       $output = '';
       if ($count > 0) {
              $output = '<span class="label label-success">' . $count . '</span>';
       }
       return $output;
}
function update_is_type_status($userId, $is_type){
    $q = "CALL update_is_type_status($userId, '$is_type')";
    db_query($q);
}
// function fetch_is_type_status($userId){
//     $q = "CALL fetch_is_type_status($userId)";
//     list($is_type) = db_fetch_row($q);
//     $output = '';
//     if($is_type == 'yes'){
//         $output = ' - <span>Typing....</span>';
//     }
//     return $output;
// }
function remove_message($messageId){
    $q = "CALL remove_message($messageId)";
    db_query($q);
}

