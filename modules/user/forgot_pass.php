<?php
get_header();
$pass_errors = array();
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
       if (empty($_POST['email'])) {
              $pass_errors['email'] = "Please enter your email!";
       } else {
              if (is_email($_POST['email'])) {
                     $email = escape_data($_POST['email'], $dbc);
                     $q = "SELECT `id` FROM `users` WHERE `email` = '{$email}'";
                     $r = mysqli_query($dbc, $q);
                     if (mysqli_num_rows($r) == 1) {
                            list($u_id) = mysqli_fetch_row($r);
                     } else {
                            $pass_errors['email'] = 'The submitted email address does not exist!';
                     }
              } else {
                     $pass_errors['email'] = "Please enter a valid your email!";
              }
       }

       if (empty($pass_errors)) {
              $token = openssl_random_pseudo_bytes(32);
              $token = bin2hex($token);
              $q = "REPLACE INTO `access_tokens` (`user_id`, `token`, `date_expires`)
              VALUES (?, ?, DATE_ADD(NOW(), INTERVAL 15 MINUTE))";
              $stmt = mysqli_prepare($dbc, $q);
              mysqli_stmt_bind_param($stmt, 'is', $u_id, $token);
              mysqli_stmt_execute($stmt);
              if (mysqli_stmt_affected_rows($stmt) > 0) {
                     $url = "" . BASE_URL . "?mod=user&act=reset&t={$token}";
                     $body = "This email is in response to a forgotten password reset
              request. If you did make this request, click the following link to be able to access your account: $url
              For security purposes, you have 15 minutes to do this. If you do
              not click this link within 15 minutes, you’ll need to request a
              password reset again. If you have not forgotten your password, you can safely ignore
              this message and you will still be able to login with your
              existing password. ";
                     send_email($email, '', 'Reset Your Password', $body);
                     // mail($email, 'Password Reset at Knowledge is Power', $body, 'FROM: ' . CONTACT_EMAIL);
                     ?>
                     <div id="content" class="reset-pass">
                            <div>
                                   <i class="fas fa-check-circle"></i>
                                   <h3>Reset Your Password!</h3>
                                   <p>You will receive an access
                                   code via email. Click the link in that email to gain access
                                   to the site. Once you have done that, you may then change your
                                   password.</p>
                            </div>
                     </div>
                     <?php
                     get_footer();
                     exit();
              } else {
                     trigger_error('Your password could not be changed due to a system error. We apologize for any inconvenience.');
              };
       }
}

include("view/user/forgot_pass.php");
get_footer();
