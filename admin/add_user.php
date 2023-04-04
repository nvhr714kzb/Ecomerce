<?php
require('../includes/config.inc.php');
require("../lib/user.inc.php");
require('../lib/database.inc.php');
require('../lib/helper.inc.php');
require('../lib/form_functions.inc.php');
require('../' . MYSQL);
require('includes/permission.php');
include('includes/header.html');

?>
<div id="content-wp" class="clearfix">
       <?php
       include('includes/sidebar.html');
       $list_privileges = get_list_privileges();
       $reg_errors = array();
       if ($_SERVER['REQUEST_METHOD'] === 'POST') {
              if (empty($_POST['name'])) {
                     $reg_errors['name'] = 'Please enter your name!';
              } else {
                     if (is_name($_POST['name'])) {
                            $name = escape_data($_POST['name'], $dbc);
                     } else {
                            $reg_errors['name'] = "Please enter a valid your name!";
                     }
              }
              if (empty($_POST['username'])) {
                     $reg_errors['username'] = 'Please enter your username!';
              } else {
                     if (is_username($_POST['username'])) {
                            $username = escape_data($_POST['username'], $dbc);
                     } else {
                            $reg_errors['username'] = "Please enter a valid your username!";
                     }
              }
              if (empty($_POST['email'])) {
                     $reg_errors['email'] = 'Please enter your email';
              } else {
                     if (is_email($_POST['email'])) {
                            $email = escape_data($_POST['email'], $dbc);
                     } else {
                            $reg_errors['email'] = 'Please enter a valid your email!';
                     }
              }
              if (empty($_POST['pass'])) {
                     $reg_errors['pass'] = 'Please enter your password!';
              } else {
                     if (is_password($_POST['pass'])) {
                            if ($_POST['pass'] === $_POST['passCheck']) {
                                   $pass = $_POST['pass'];
                            } else {
                                   $reg_errors['passCheck'] = 'Your password did not match the confirmed password!';
                            }
                     } else {
                            $reg_errors['pass'] = 'Please enter a valid password!';
                     }
              }
              if (empty($_POST['type'])) {
                     $reg_errors['type'] = 'Please select a  privilege!';
              } else {
                     if (is_numeric($_POST['type'])) {
                            $type = $_POST['type'];
                     } else {
                            $reg_errors['type'] = 'Please select a valid privilege!';
                     }
              }
              if (is_uploaded_file($_FILES['avatar']['tmp_name']) && $_FILES['avatar']['error'] === UPLOAD_ERR_OK) {
                     $file = $_FILES['avatar'];
                     $size = ROUND($file['size'] / 1024);
                     if ($size > 500000) {
                            $reg_errors['size'] = 'The uploaded file was too large.';
                     }

                     $allowed_ext =  array('png', 'jpg', 'gif', 'jpeg');
                     $file_ext = pathinfo($file['name'], PATHINFO_EXTENSION);

                     $allowed_mime = array('image/gif', 'image/pjpeg', 'image/jpeg', 'image/JPG', 'image/X-PNG', 'image/PNG', 'image/png', 'image/x-png');
                     $file_info = finfo_open(FILEINFO_MIME_TYPE);
                     $file_type = finfo_file($file_info, $file['tmp_name']);
                     finfo_close($file_info);

                     if (!in_array($file_type, $allowed_mime) || !in_array($file_ext, $allowed_ext)) {
                            $reg_errors['avatar'] = 'The uploaded file was not of the proper type.';
                     }
                     if (!array_key_exists('avatar', $reg_errors)) {
                            $new_name = sha1($file['name'] . uniqid('', true));
                            $new_name .= '.' . $file_ext;
                            $dest = "../public/images/avatar/$new_name";
                            if (move_uploaded_file($file['tmp_name'], $dest)) {
                                   $flag_upload_success = true;
                            } else {
                                   trigger_error('The file could not be moved.');
                                   unlink($file['tmp_name']);
                            }
                     }
              } else {
                     switch ($_FILES['avatar']['error']) {
                            case 1:
                            case 2:
                                   $reg_errors['avatar'] = 'The uploaded file was too large.';
                                   break;
                            case 3:
                                   $reg_errors['avatar'] = 'The file was only partially uploaded.';
                                   break;
                            case 6:
                            case 7:
                            case 8:
                                   $reg_errors['avatar'] = 'The file could not be uploaded due to a system error.';
                                   break;
                            case 4:
                            default:
                                   $reg_errors['avatar'] = 'No file was uploaded.';
                                   break;
                     }
              }
              if (empty($reg_errors)) {
                     $q = "SELECT `email`, `username` FROM `users` WHERE `email` = '{$email}' OR `username` = '{$username}'";
                     $r = mysqli_query($dbc, $q);
                     $rows = mysqli_num_rows($r);
                     if ($rows == 0) {
                            $q = "INSERT INTO `users` (`type`, `name`, `avatar`,  `username`, `email`, `pass`, `is_active`)
                                   VALUES (?, ?, ?, ?, ?, ?, '1')";
                            $stmt = mysqli_prepare($dbc, $q);
                            mysqli_stmt_bind_param($stmt, 'isssss', $type, $name, $new_name, $username, $email, $pass);
                            $pass = password_hash($pass, PASSWORD_DEFAULT);
                            mysqli_stmt_execute($stmt);
                            // if (!$stmt) {
                            //        echo mysqli_stmt_error($stmt);
                            // }
                            if (mysqli_stmt_affected_rows($stmt) === 1) {
                                   mysqli_stmt_close($stmt);
                                   $_POST = array();
                                   $_FILES = array();
                                   unset($file);
                                   $success = true;
                                   // redirect('list_users.php');
                            } else {
                                   trigger_error('A system error has occurred. We apologize for any inconvenience.');
                                   unlink($dest);
                            }
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
                            unlink($dest);
                     }
              } else {
                     if (isset($flag_upload_success)) {
                            unlink($dest);
                     }
              }
       }
       ?>
       <div id="content" class="float-right">
              <div class="section add-user">
                     <div class="section-head">
                            <h3 class="section-title">Add a user</h3>
                            <a class="section-list" href="<?php echo BASE_URL ?>admin/list_users.php">List users</a>
                            <?php
                            if (isset($success)) {
                                   echo '<div class="alert alert-success" role="alert">User has been added!</div>';
                            }
                            ?>
                     </div>
                     <div class="section-detail">
                            <form action="" method="POST" enctype="multipart/form-data" accept-charset="utf8">
                                   <?php
                                   create_form_input('name', 'text', 'Your name', $reg_errors);
                                   create_form_input('username', 'text', 'User Name', $reg_errors);
                                   create_form_input('email', 'text', 'Email', $reg_errors);
                                   create_form_input('pass', 'password', 'Password', $reg_errors);
                                   create_form_input('passCheck', 'password', 'Password confirm', $reg_errors);
                                   ?>
                                   <div class="form-group">
                                          <label for="type">Choose privilege</label>
                                          <select name="type" id="type">
                                                 <option value="">Choose</option>
                                                 <?php foreach ($list_privileges as $item) {
                                                        $selected = '';
                                                        if (isset($_POST['type']) &&  $_POST['type'] == $item['id']) {
                                                               $selected = 'selected';
                                                        }
                                                 ?>
                                                        <option value="<?php echo $item['id'] ?>" <?php echo $selected ?>><?php echo $item['type'] ?></option>
                                                 <?php } ?>
                                          </select>
                                          <?php
                                          form_error('type', $reg_errors);
                                          ?>
                                   </div>

                                   <div class="form-group">
                                          <label for="upload-avatar">Avatar</label>
                                          <input type="file" name="avatar" id="upload-avatar">
                                          <?php
                                          form_error('avatar',  $reg_errors);
                                          ?>
                                          <img src="../public/images/size/100x100.png" alt="" id="preview-avatar" width="100px">
                                   </div>
                                   <div class="form-group text-left">
                                          <input type="submit" name="submitAddUser" value="Add user" class="no-style submit">
                                   </div>
                            </form>
                     </div>
              </div>
       </div>
</div>