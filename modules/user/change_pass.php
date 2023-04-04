<?php
redirect_invalid_user();
$page_title = "Change password";
get_header();
$pass_errors = array();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
       if (empty($_POST['passwordCurrent'])) {
              $pass_errors['passwordCurrent'] = 'Please enter your current password';
       } else {
              $passwordCurrent = escape_data($_POST['passwordCurrent'], $dbc);
       }

       if (empty($_POST['passwordNew'])) {
              $pass_errors['passwordNew'] = 'Please enter your new password';
       } else {
              if (is_password($_POST['passwordNew'])) {
                     if ($_POST['passwordNew'] == $_POST['passwordCheck']) {
                            $passwordNew  = escape_data($_POST['passwordNew'], $dbc);
                     } else {
                            $pass_errors['passwordCheck'] = 'Your password did not match the confirmed password!';
                     }
              } else {
                     $pass_errors['passwordNew'] = 'Please enter a valid password';
              }
       }
       if (empty($pass_errors)) {
              $q = "SELECT `pass` FROM `users` WHERE  `id` = '{$_SESSION['user_id']}'";
              $r = mysqli_query($dbc, $q);
              list($hash) = mysqli_fetch_array($r, MYSQLI_NUM);
              if (password_verify($passwordCurrent, $hash)) {
                     $q = "UPDATE users SET `pass` = '" . password_hash($passwordNew, PASSWORD_DEFAULT) . "' WHERE `id` = " . $_SESSION['user_id'] . "";
                     if ($r = mysqli_query($dbc, $q)) {
                            $message = 'Your password has been changed';
                            $_POST = array();
                     } else {
                            trigger_error('Your password could not be changed due to a system error. We apologize for any inconvenience.');
                     }
              } else {
                     $pass_errors['passwordCurrent'] = 'Your current password is wrong';
              }
       }
}
include("view/user/change_pass.php");
// load_view('user', 'change_pass', 'pass_errors');
get_footer();
