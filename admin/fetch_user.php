<?php
require('../includes/config.inc.php');
require('../lib/database.inc.php');
require('lib/chat_functions.inc.php');
require('../' . MYSQL);
require('includes/permission.php');

// ===================FETCH USER=====================
$q = "SELECT id, email, name, avatar FROM users WHERE id != {$_SESSION['user_id']} AND type = 0";
$list_user = db_fetch_array($q);
$output = '';
$output .= '<table>';
$output .= '<thead>';
$output .= '<th>Email</th>';
$output .= '<th>Status</th>';
$output .= '<th>Action</th>';
$output .= '</thead>';
$output .= '<tbody>';
if (!empty($list_user)) {
       foreach ($list_user as $user) {
              $current_timestamp = strtotime(date("Y-m-d H:i:s") . '- 10 second');
              $current_timestamp = date("Y-m-d H:i:s", $current_timestamp);
              $user_last_activity = fetch_user_last_activity($user['id']);
              if ($user_last_activity > $current_timestamp) {
                     $status = 'Online';
              } else {
                     $status = 'Offline';
              }
              $output .= "<tr>";
              $count_unseen_message = count_unseen_message($user['id'], $_SESSION['user_id']);
              // $is_type = fetch_is_type_status($user['id']);
              $output .= "<td>{$user['email']}  $count_unseen_message</td>";
              $output .= "<td>$status</td>";
              $output .= "<td><button class='start-chat' data-touserid='{$user['id']}' data-tousername='{$user['name']}' data-avatar='{$user['avatar']}'>Start Chat</button></td>";
              $output .= "</tr>";
       }
}else{
       $output .= "<tr><td colspan='3'>There is no user!</td></tr>";
}

$output .=  '</tbody>';
$output .=  '</table>';
echo $output;
