<?php
$page_title = "Login";
get_header();
$login_errors = array();
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
       if (empty($_POST['emailLogin'])) {
              $login_errors['emailLogin'] = "Please enter your email address!";
       } else {
              if (is_email($_POST['emailLogin'])) {
                     $email = $_POST['emailLogin'];
              } else {
                     $login_errors['emailLogin'] = "Please enter a valid email address!";
              }
       }
       if (empty($_POST['passwordLogin'])) {
              $login_errors['passwordLogin'] = "Please enter your password!";
       } else {
              $password = $_POST['passwordLogin'];
       }
       if (empty($login_errors)) {
              $q = "SELECT `id`, `username`, `name`, `type`, `pass` FROM users WHERE `email` = ? AND `is_active` = '1' AND `trashed` = 0";
              $stmt = mysqli_prepare($dbc, $q);
              mysqli_stmt_bind_param($stmt, 's', $email);
              mysqli_stmt_execute($stmt);
              mysqli_stmt_store_result($stmt);
              if (mysqli_stmt_num_rows($stmt) === 1) {
                     mysqli_stmt_bind_result($stmt, $id, $username, $name, $type, $pass);
                     mysqli_stmt_fetch($stmt);
                     mysqli_stmt_close($stmt);
                     if (password_verify($password, $pass)) {
                            session_regenerate_id(true);
                            $_SESSION['user_id'] = $id;
                            $_SESSION['username'] = $username;
                            $_SESSION['name'] = $name;
                            $_SESSION['check'] = hash('ripemd128', $_SERVER['REMOTE_ADDR'] . $_SERVER['HTTP_USER_AGENT']);
                            // ===================Remember me=============================
                            if(!empty($_POST['rememberMe'])){
                                   setcookie('email_login', $email, time() + (7*24*3600));
                                   setcookie('pass_login', $password, time() + (7*24*3600));
                            }else{
                                   if(isset($_COOKIE['email_login'])){
                                          setcookie('email_login','', time() - 3600);
                                   }
                                   if(isset($_COOKIE['pass_login'])){
                                          setcookie('pass_login','', time() - 3600);
                                   }
                            }

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
                            redirect();
                     } else {
                            $login_errors['login'] = "Email or password is incorrect, please check again";
                     }
              } else {
                     $login_errors['login'] = "Email or password is incorrect, please check again";
              }
       }
}
include("view/user/login.php");
get_footer();

