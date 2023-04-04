<?php
require('../includes/config.inc.php');
require('../lib/user.inc.php');
require('../lib/database.inc.php');
require('../lib/helper.inc.php');
require('../lib/form_functions.inc.php');
require('../' . MYSQL);
require('includes/permission.php');
include('includes/header.html');
?>
<?php if (isset($_GET['userId']) && is_numeric($_GET['userId']) && is_valid_admin($_GET['userId'])) { ?>
       <div id="content-wp" class="clearfix">
              <?php
              include('includes/sidebar.html');
              $user_errors = array();
              if ($_SERVER['REQUEST_METHOD'] === 'POST') {
                     if (empty($_POST['name'])) {
                            $user_errors['name'] = 'Please enter your name!';
                     } else {
                            if (is_name($_POST['name'])) {
                                   $name = escape_data($_POST['name'], $dbc);
                            } else {
                                   $user_errors['name'] = "Please enter a valid your name!";
                            }
                     }
                     if (empty($_POST['pass'])) {
                            $user_errors['pass'] = 'Please enter your password!';
                     } else {
                            if (is_password($_POST['pass'])) {
                                   if ($_POST['pass'] === $_POST['passCheck']) {
                                          $pass = $_POST['pass'];
                                   } else {
                                          $user_errors['passCheck'] = 'Your password did not match the confirmed password!';
                                   }
                            } else {
                                   $user_errors['pass'] = 'Please enter a valid password!';
                            }
                     }
                     if (is_uploaded_file($_FILES['avatar']['tmp_name']) && ($_FILES['avatar']['error'] === UPLOAD_ERR_OK)) {
                            $file = $_FILES['avatar'];
                            $size = ROUND($file['size'] / 1024);
                            if ($size > 512) {
                                   $user_errors['avatar'] = 'The uploaded file was too large.';
                            }
                            $allowed_mime = array('image/gif', 'image/pjpeg', 'image/jpeg', 'image/JPG', 'image/X-PNG', 'image/PNG', 'image/png', 'image/x-png');
                            $allowed_extensions = array('.jpg', '.gif', '.png', 'jpeg');
                            // Check the file:
                            $fileinfo = finfo_open(FILEINFO_MIME_TYPE);
                            $file_type = finfo_file($fileinfo, $file['tmp_name']);
                            finfo_close($fileinfo);
                            $file_ext = substr($file['name'], -4);
                            if (!in_array($file_type, $allowed_mime) || !in_array($file_ext, $allowed_extensions)) {
                                   $user_errors['avatar'] = 'The uploaded file was not of the proper type.';
                            }
                            if (!array_key_exists('avatar', $user_errors)) {
                                   $new_name = sha1($file['name'] . uniqid('', true));
                                   $new_name .= ((substr($file_ext, 0, 1) != '.') ? ".{$file_ext}" : $file_ext);
                                   $dest =  "../public/images/avatar/$new_name";
                                   if (move_uploaded_file($file['tmp_name'], $dest)) {
                                          $flag_upload_success = true;
                                          // echo '<h4>The file has been uploaded!</h4>';
                                   } else {
                                          trigger_error('The file could not be moved.');
                                          unlink($file['tmp_name']);
                                   }
                            }
                     } 
                     if (empty($user_errors)) {
                            if(isset($new_name)){
                                   $q = "UPDATE `users` SET `name` = ?, `pass` = ?, `avatar` = ? WHERE id = {$_GET['userId']}";
                                   $stmt = mysqli_prepare($dbc, $q);
                                   mysqli_stmt_bind_param($stmt, 'sss', $name, $pass, $new_name);
                            }else{
                                   $q = "UPDATE `users` SET `name` = ?, `pass` = ? WHERE id = {$_GET['userId']}";
                                   $stmt = mysqli_prepare($dbc, $q);
                                   mysqli_stmt_bind_param($stmt, 'ss', $name, $pass);
                            }
                           
                            $pass = password_hash($pass, PASSWORD_DEFAULT);
                            mysqli_stmt_execute($stmt);
                            // if (!$stmt) {
                            //        echo mysqli_stmt_error($stmt);
                            // }
                            if (mysqli_stmt_affected_rows($stmt) === 1) {
                                   // redirect('list_users.php');
                                   $message = 'Updated successfully';
                                   $_POST = array();
                                   $_FILES = array();
                                   unset($file);
                            } else {
                                   trigger_error('A system error has occurred. We apologize for any inconvenience.');
                            }
                     }else{
                            if (isset($flag_upload_success)) {
                                   unlink($dest);
                            }
                     }
              }
              if ($_SERVER['REQUEST_METHOD'] != 'POST') {
                     $value = 'DATABASE';
              } else {
                     $value = 'POST';
              }
              ?>
              <div id="content" class="float-right">
                     <div class="section edit-user">
                            <div class="section-head">
                                   <h3 class="section-title">Edit user</h3>
                                   <?php
                                          if(isset($message)){
                                                 echo "<div class='alert alert-success' role='alert'>
                                                 $message
                                               </div>";
                                          }
                                   ?>
                            </div>
                            <div class="section-detail">
                                   <form action="" method="POST" enctype="multipart/form-data" accept-charset="utf8">
                                          <?php
                                          create_form_input('name', 'text', 'Your name', $user_errors, $value);
                                          create_form_input('email', 'text', 'Email', $user_errors, 'DATABASE', ['disabled' => 'disabled']);
                                          ?>
                                          <div class="form-group">
                                                 <label for="avatar">Avatar</label>
                                                 <input type="file" name="avatar" id="upload-avatar"><br>
                                                 <img src="../public/images/avatar/<?php echo  get_info_user((int)$_GET['userId'])['avatar'] ?>" alt="" id="preview-avatar" width="100px">
                                          </div>
                                          <?php
                                          create_form_input('pass', 'password', 'Password', $user_errors);
                                          create_form_input('passCheck', 'password', 'Password confirm', $user_errors);
                                          ?>
                                          <div class="form-group">
                                          </div>
                                          <div class="form-group text-left">
                                                 <input type="submit" name="submitUpdateUser" value="Update user" class="no-style submit">
                                          </div>
                                   </form>
                            </div>
                     </div>
              </div>
       </div>
<?php } else {
       redirect('list_users.php');
}
?>