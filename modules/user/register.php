<?php
$page_title = "Register";
get_header();
$reg_errors = array();
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
       //Custom name
       if (empty($_POST['customerName'])) {
              $reg_errors['customerName'] = 'Please enter your name!';
       } else {
              if (is_name($_POST['customerName'])) {
                     $customer_name = escape_data($_POST['customerName'], $dbc);
              } else {
                     $reg_errors['customerName'] = "Please enter a valid your name!";
              }
       }
       if (empty($_POST['username'])) {
              $reg_errors['username'] = 'Please enter user name!';
       } else {
              if (is_username($_POST['username'])) {
                     $username = escape_data($_POST['username'], $dbc);
              } else {
                     $reg_errors['username'] = "Please enter a valid user name!";
              }
       }
       //Email
       if (empty($_POST['email'])) {
              $reg_errors['email'] = 'Please enter your email';
       } else {
              if (is_email($_POST['email'])) {
                     $email = escape_data($_POST['email'], $dbc);
              } else {
                     $reg_errors['email'] = 'Please enter a valid your email!';
              }
       }
       //Password
       if (empty($_POST['password'])) {
              $reg_errors['password'] = 'Please enter your password!';
       } else {
              if (is_password($_POST['password'])) {
                     if ($_POST['password'] === $_POST['passwordCheck']) {
                            $password = $_POST['password'];
                     } else {
                            $reg_errors['passwordCheck'] = 'Your password did not match the confirmed password!';
                     }
              } else {
                     $reg_errors['password'] = 'Please enter a valid password!';
              }
       }
       //Confirm no error
       if (empty($reg_errors)) {
              $q = "SELECT `email`, `username` FROM `users` WHERE `email` = '{$email}' OR `username` = '{$username}'";
              $r = mysqli_query($dbc, $q);
              $rows = mysqli_num_rows($r);
              if ($rows == 0) {
                     $active_token = md5($username . time());
                     //Method 1
                     $q = "INSERT INTO `users` (`name`,  `username`, `email`, `pass`, `active_token`) VALUES (?, ?, ?, ?, ?)";
                     $stmt = mysqli_prepare($dbc, $q);
                     mysqli_stmt_bind_param($stmt, 'sssss', $customer_name, $username, $email, $password, $active_token);
                     $password = password_hash($password, PASSWORD_DEFAULT);
                     mysqli_stmt_execute($stmt);
                     if (!$stmt) {
                            echo mysqli_stmt_error($stmt);
                     }
                     if (mysqli_stmt_affected_rows($stmt) === 1) {
                            $uid = mysqli_stmt_insert_id($stmt);
                            mysqli_stmt_close($stmt);
                            $_SESSION['reg_user_id'] = $uid;
                            // =======================Send email===========================
                            $url_active = "" . BASE_URL . "?mod=user&act=active&activeToken={$active_token}";
                            $content = "<p>Hello $customer_name </p>
                            <p>Please click this link to active your account: $url_active</p>";
                            send_email($email, $customer_name, 'Active your account', $content);
                            // echo "<div><h3>Thanks!</h3><p>Thank you for registering! To complete the
                            //        process, please now click the button below so that you may pay for your
                            //        site access via PayPal. The cost is $10 (US) per year. <strong>Note: When
                            //        you complete your payment at PayPal, please click the button to return to
                            //        this site.</strong></p>";
                            // echo '<form action="https://www.sandbox.paypal.com/cgi-bin/webscr" method="post" target="_top">
                            //        <input type="hidden" name="cmd" value="_s-xclick">
                            //        <input type="hidden" name="hosted_button_id" value="68CHKWMU85KZE">
                            //        <input type="image" src="https://www.sandbox.paypal.com/es_XC/i/btn/btn_subscribeCC_LG.gif" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!">
                            //        <img alt="" border="0" src="https://www.sandbox.paypal.com/es_XC/i/scr/pixel.gif" width="1" height="1">
                            // </form></div>';
                      ?>
                            <div id="content" class="success-reg">
                                   <div>
                                          <i class="fas fa-check-circle"></i>       
                                          <h3>Congratulations!</h3>
                                          <p>You will receive an email. Click the link in that email to active your account in 5 minutes
                                          . Once you have done that, you may then login.</p>
                                   </div>
                            </div>
                     <?php
                            get_footer();
                            exit();
                     } else {
                            trigger_error('You could not be registered due to a system error. We apologize for any inconvenience.');
                     }
                     //Method 2
                     // $q = "INSERT INTO `users` (`u_custom_name`,  `u_username`, `u_email`, `u_pass`, `active_token`, `u_date_expires`)
                     //        VALUES ('{$customer_name}', '{$username}', '$email', '".password_hash($password, PASSWORD_DEFAULT)."', '{$active_token}', ADDDATE(NOW(), INTERVAL 1 MONTH))";
                     // $r = mysqli_query($dbc, $q);
                     // if(mysqli_affected_rows($dbc) === 1){
                     //        $uid = mysqli_insert_id($dbc);
                     //        $_SESSION['reg_user_id'] = $uid;
                     //        echo "<div><h3>Thanks!</h3><p>Thank you for registering! To complete the
                     //               process, please now click the button below so that you may pay for your
                     //               site access via PayPal. The cost is $10 (US) per year. <strong>Note: When
                     //               you complete your payment at PayPal, please click the button to return to
                     //               this site.</strong></p>";
                     //        echo '<form action="https://www.sandbox.paypal.com/cgi-bin/webscr" method="post" target="_top">
                     //               <input type="hidden" name="cmd" value="_s-xclick">
                     //               <input type="hidden" name="hosted_button_id" value="68CHKWMU85KZE">
                     //               <input type="image" src="https://www.sandbox.paypal.com/es_XC/i/btn/btn_subscribeCC_LG.gif" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!">
                     //               <img alt="" border="0" src="https://www.sandbox.paypal.com/es_XC/i/scr/pixel.gif" width="1" height="1">
                     //        </form></div>';

                     //        // SEND EMAILLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL TO THANKS AND ACTIVE
                     //        get_sidebar();
                     //        get_footer();
                     //        exit();
                     // }else{
                     //        trigger_error('You could not be registered due to a system error. We apologize for any inconvenience.');
                     // }
              } else {
                     if ($rows === 2) {

                            $reg_errors['email'] = 'This email address has already been registered. If you have forgotten your password, use the link at left to have your password sent to you.';
                            $reg_errors['username'] = 'This username has already been registered. Please try another.';
                     } elseif ($rows === 1) {
                            $row = mysqli_fetch_array($r, MYSQLI_NUM);
                            // echo $row[1];
                            echo $_POST['username'];
                            if ($row[0] === $_POST['email'] && $row[1] === $_POST['username']) {
                                   $reg_errors['email'] = 'This email address has already been registered';
                                   $reg_errors['username'] = 'This username has already been registered with this email address';
                            } elseif ($row[0] === $_POST['email']) {
                                   $reg_errors['email'] = 'This email address has already been registered';
                            } elseif ($row[1] === $_POST['username']) {
                                   $reg_errors['username'] = 'This username has already been registered. Please try another';
                            }
                     }
              }
       }
}
// load_view('user', 'register', 'reg_errors');
include("view/user/register.php");
get_footer();
