<?php
$page_title = "Reset password";
get_header();
//Validation token
$reset_error = '';
if (isset($_GET['t']) && (strlen($_GET['t']) === 64)) {
       $token = $_GET['t'];
       $q = "SELECT `user_id` FROM `access_tokens` WHERE `token` = ? AND `date_expires` > NOW()";
       $stmt = mysqli_prepare($dbc, $q);
       mysqli_stmt_bind_param($stmt, 's', $token);
       mysqli_stmt_execute($stmt);
       mysqli_stmt_store_result($stmt);
       if (mysqli_stmt_num_rows($stmt) === 1) {
              mysqli_stmt_bind_result($stmt, $user_id);
              mysqli_stmt_fetch($stmt);

              session_regenerate_id(true);
              $_SESSION['reset_user_id'] = $user_id;

              $q = "DELETE FROM `access_tokens` WHERE `token` = ?";
              $stmt = mysqli_prepare($dbc, $q);
              mysqli_stmt_bind_param($stmt, 's', $token);
              mysqli_stmt_execute($stmt);
       } else {
              $reset_error = 'Either the provided token does not match that on file or your time has expired. Please resubmit the "Forgot your password?" form.';
       }
} else {
       $reset_error = 'This page has been accessed in error.';
}


//Validation form
$pass_errors = array();
if (($_SERVER['REQUEST_METHOD'] === 'POST') && isset($_SESSION['reset_user_id'])) {
       $reset_error = '';
       if (is_password($_POST['pass1'])) {
              if ($_POST['pass1'] == $_POST['pass2']) {
                     $p = $_POST['pass1'];
              } else {
                     $pass_errors['pass2'] = 'Your password did not match the confirmed password!';
              }
       } else {
              $pass_errors['pass1'] = 'Please enter a valid password!';
       }
       if (empty($pass_errors)) {
              $q = "UPDATE `users` SET `pass` = ? WHERE `id` = ? LIMIT 1";
              $stmt = mysqli_prepare($dbc, $q);
              mysqli_stmt_bind_param($stmt, 'si', $pass, $_SESSION['reset_user_id']);
              $pass = password_hash($p, PASSWORD_DEFAULT);
              mysqli_stmt_execute($stmt);
              if (mysqli_stmt_affected_rows($stmt) === 1) {
                     $message = 'Your password has been changed.';
                     $_POST = array();
                     // echo '<h1>Your password has been changed.</h1>';
                     unset($_SESSION['reset_user_id']);
                     // get_footer();
                     // exit();
              } else {
                     trigger_error('Your password could not be changed due to a system error. We apologize for any inconvenience.');
              }
       }
}
//Open form if no error
if (empty($reset_error)) {
       include('view/user/reset.php');
} else {
?>
       <div id="content" class="reset-pass">
              <div>
                     <img src="public/images/icon/failure.jpg" alt="" width="100px">
                     <h3>Reset your password!</h3>
                     <p><?php echo $reset_error ?></p>
              </div>

       </div>

<?php
}

get_footer();
