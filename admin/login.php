<?php
require('../includes/config.inc.php');
require('../lib/database.inc.php');
require('../lib/form_functions.inc.php');
require('../lib/product_functions.inc.php');
require('../' . MYSQL);
include('includes/header_not_login.html');
$login_errors = array();
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
       if (empty($_POST['email'])) {
              $login_errors['email'] = "Please enter your email address!";
       } else {
              if (is_email($_POST['email'])) {
                     $email = $_POST['email'];
              } else {
                     $login_errors['email'] = "Please enter a valid email address!";
              }
       }
       if (empty($_POST['password'])) {
              $login_errors['password'] = "Please enter your password!";
       } else {
              $password = $_POST['password'];
       }
       if (empty($login_errors)) {
              $q = "SELECT `id`, `username`, `type`, `pass` FROM users WHERE `email` = ? AND `is_active` = '1' AND `trashed` = 0";
              $stmt = mysqli_prepare($dbc, $q);
              mysqli_stmt_bind_param($stmt, 's', $email);
              mysqli_stmt_execute($stmt);
              mysqli_stmt_store_result($stmt);
              if (mysqli_stmt_num_rows($stmt) === 1) {
                     mysqli_stmt_bind_result($stmt, $id, $username, $type, $pass);
                     mysqli_stmt_fetch($stmt);
                     mysqli_stmt_close($stmt);
                     if (password_verify($password, $pass)) {
                            session_regenerate_id(true);
                            $_SESSION['user_id'] = $id;
                            $_SESSION['username'] = $username;
                            $_SESSION['check'] = hash('ripemd128', $_SERVER['REMOTE_ADDR'] . $_SERVER['HTTP_USER_AGENT']);
                            //For two user types
                            // if ($u_type === 'admin') {
                            //        $_SESSION['user_admin'] = true;
                            // }
                            //For multi user types
                            $_SESSION['user_type'] = $type;
                            if (isset($_COOKIE['SESSION']) && (strlen($_COOKIE['SESSION']) === 32)) {
                                   transfer_cart_to_user($id, $_COOKIE['SESSION']);
                            }
                            // ===============FOR CHAT===========================
                            $table = 'login_details';
                            $data = array(
                                   'user_id' => $id
                            );
                            $_SESSION['login_details_id'] = db_insert($table, $data);
                            db_query($q);
                            if (!headers_sent()) {
                                   header("Location: index.php");
                                   exit();
                            } else {
                                   trigger_error('A system error occurred. We apologize for the inconvenience');
                            }
                     } else {
                            $login_errors['login'] = "Username or password is incorrect, please check again";
                     }
              } else {
                     $login_errors['login'] = "Username or password is incorrect, please check again";
              }
       }
}
?>
<div class="login admin">
       <form action="?mod=user&act=login" method="POST" accept-charset="utf8">
              <h1 class="login-title">Sign-In</h1>
              <?php create_form_input('email', 'text', 'Email', $login_errors, 'POST', array('autocomplete' => 'off', 'value' => 'nvhr714kzb@gmail.com')) ?>
              <?php create_form_input('password', 'password', 'Password', $login_errors, 'POST', array('autocomplete' => 'off', 'value' => 'Aa0799500203')) ?>
              <input type="submit" value="Login">
              <?php form_error('login', $login_errors) ?>
              <a href="<?php echo BASE_URL ?>" class="text-center">Back to home</a>
       </form>
</div>