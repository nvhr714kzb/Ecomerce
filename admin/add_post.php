<?php
require('../includes/config.inc.php');
require('../lib/database.inc.php');
require('../lib/form_functions.inc.php');
require('lib/product_functions.inc.php');
require('../lib/user.inc.php');
require('../' . MYSQL);
require('includes/permission.php');
include('includes/header.html');
?>
<div id="content-wp" class="clearfix">
       <?php
       include('includes/sidebar.html');
       $add_page_errors = array();
       if ($_SERVER['REQUEST_METHOD'] === 'POST') {
              if (!empty($_POST['status'])) {
                     $s =  escape_data(strip_tags($_POST['status']), $dbc);
              } else {
                     $add_page_errors['status'] = 'Please select the status!';
              }
              if (empty($_POST['productId']) || !filter_var($_POST['productId'], FILTER_VALIDATE_FLOAT, array('min_range' >= 1))) {
                     $add_page_errors['productId'] = 'Please select a product!';
              }
              if (!empty($_POST['title'])) {
                     $t = escape_data(strip_tags($_POST['title']), $dbc);
              } else {
                     $add_page_errors['title'] = 'Please enter the title!';
              }
              if (!empty($_POST['description'])) {
                     $d = escape_data(strip_tags($_POST['description']), $dbc);
              } else {
                     $add_page_errors['description'] = 'Please enter the description!';
              }
              if (!empty($_POST['content'])) {
                     $allowed = '<div><p><span><br><a><img><h1><h2><h3><h4><ul><ol><li><blockquote>';
                     $c = escape_data(strip_tags($_POST['content'], $allowed), $dbc);
              } else {
                     $add_page_errors['content'] = 'Please enter the content!';
              }
              //Check for image
              if (is_uploaded_file($_FILES['thumb']['tmp_name']) && $_FILES['thumb']['error'] === UPLOAD_ERR_OK) {
                     $file = $_FILES['thumb'];
                     $size = ROUND($file['size'] / 1024);
                     if ($size > 500000) {
                            $add_page_errors['size'] = 'The uploaded file was too large.';
                     }

                     $allowed_ext =  array('png', 'jpg', 'gif', 'jpeg');
                     $file_ext = pathinfo($file['name'], PATHINFO_EXTENSION);

                     $allowed_mime = array('image/gif', 'image/pjpeg', 'image/jpeg', 'image/JPG', 'image/X-PNG', 'image/PNG', 'image/png', 'image/x-png');
                     $file_info = finfo_open(FILEINFO_MIME_TYPE);
                     $file_type = finfo_file($file_info, $file['tmp_name']);
                     finfo_close($file_info);

                     if (!in_array($file_type, $allowed_mime) || !in_array($file_ext, $allowed_ext)) {
                            $add_page_errors['thumb'] = 'The uploaded file was not of the proper type.';
                     }
                     if (!array_key_exists('thumb', $add_page_errors)) {
                            $new_name = sha1($file['name'] . uniqid('', true));
                            $new_name .= '.' . $file_ext;
                            $dest = "../public/images/post/$new_name";
                            if (move_uploaded_file($file['tmp_name'], $dest)) {
                                   $flag_upload_success = true;
                                   // echo '<h4>The file has been uploaded!</h4>';
                            } else {
                                   trigger_error('The file could not be moved.');
                                   unlink($file['tmp_name']);
                            }
                     }
              } else {
                     switch ($_FILES['thumb']['error']) {
                            case 1:
                            case 2:
                                   $add_page_errors['thumb'] = 'The uploaded file was too large.';
                                   break;
                            case 3:
                                   $add_page_errors['thumb'] = 'The file was only partially uploaded.';
                                   break;
                            case 6:
                            case 7:
                            case 8:
                                   $add_page_errors['thumb'] = 'The file could not be uploaded due to a system error.';
                                   break;
                            case 4:
                            default:
                                   $add_page_errors['thumb'] = 'No file was uploaded.';
                                   break;
                     }
              }
              if (empty($add_page_errors)) {
                     $q = "INSERT INTO posts (title, thumb, description, content, status, user_id, product_id) VALUES ('$t', '$new_name', '$d', '$c', '$s', {$_SESSION['user_id']}, {$_POST['productId']})";
                     $r = mysqli_query($dbc, $q);
                     if (mysqli_affected_rows($dbc) === 1) {
                            $success = true;
                            // echo '<div class="alert alert-success"><h3>The page has been added!</h3></div>';
                            $_POST = array();
                            $_FILES = array();
                            unset($file);
                            // Send an email to the administrator to let them know new content was added?
                     } else {
                            trigger_error('The page could not be added due to a system error. We apologize for any inconvenience.');
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
              <div class="section add-post">
                     <?php
                     if (isset($success)) {
                            echo "<div class='alert alert-success' role='alert'>The page has been added!</div>";
                     }
                     ?>
                     <div class="section-head">
                            <h3 class="section-title">Add a Site Content Post</h3>
                     </div>
                     <div class="section-detail">
                            <form action="" method="post" enctype="multipart/form-data" accept-charset="utf-8">
                                   <fieldset>
                                          <legend>Fill out the form to add a page of content:</legend>
                                          <div class="form-group">
                                                 <label for="status" class="control-label">Status</label>
                                                 <select name="status" class="form-control" id="status">
                                                        <option value="draft">Draft</option>
                                                        <option value="live">Live</option>
                                                 </select>
                                          </div>
                                          <div id="search-wp">
                                                 <form action="" method='POST' id="form-search">
                                                        <div class="form-group">
                                                               <label for="search-product" class="control-label">Choose a product</label>
                                                               <input type="text" name="searchProduct" id="search-product" class="form-control" placeholder="Search product" autocomplete="off">
                                                               <?php
                                                               form_error('productId', $add_page_errors);
                                                               ?>
                                                               <div id="hint-search"></div>
                                                               <img src="" alt="" id="preview-product" width="200px">
                                                               <h4 id="name-product"></h4>
                                                               <input type="hidden" name="productId" id="product-id" value="">

                                                        </div>
                                                 </form>
                                          </div>

                                          <?php
                                          create_form_input('title', 'text', 'Title', $add_page_errors, 'POST', ['maxlength' => '200']);
                                          create_form_input('description', 'textarea', 'Description', $add_page_errors);
                                          create_form_input('content', 'textarea', 'Content', $add_page_errors);
                                          ?>

                                          <div class="form-group">
                                                 <label for="upload-thumb">Thumb</label>
                                                 <input type="file" name="thumb" id="upload-thumb">
                                                 <?php
                                                 form_error('thumb',  $add_page_errors);
                                                 ?>
                                                 <img src="../public/images/size/300x200.png" alt="" id="preview-thumb">
                                          </div>
                                          <input type="submit" name="submit_button" value="Add This Page" id="submit_button" />
                                   </fieldset>
                            </form>
                     </div>
              </div>
       </div>
</div>