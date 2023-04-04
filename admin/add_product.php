<?php
require('../includes/config.inc.php');
require('../lib/database.inc.php');
require('../lib/form_functions.inc.php');
require('lib/product_functions.inc.php');
require('lib/helper_functions.inc.php');
require('../lib/user.inc.php');
require('../' . MYSQL);
require('includes/permission.php');
include('includes/header.html');

?>
<div id="content-wp" class="clearfix">
       <?php
       include('includes/sidebar.html');
       $add_product_errors = array();
       if ($_SERVER['REQUEST_METHOD'] === 'POST') {
              if (isset($_POST['category'])) {
                     foreach ($_POST['category'] as $cate) {
                            if (!filter_var($cate, FILTER_VALIDATE_INT, ['min_range' => 1])) {
                                   $add_product_errors['category'] = 'Please select valid categories!';
                                   break;
                            }
                     }
              } else {
                     $add_product_errors['category'] = 'Please select categories!';
              }

              if (empty($_POST['name'])) {
                     $add_product_errors['name'] = 'Please enter the name!';
              }
              if (empty($_POST['price']) || !filter_var($_POST['price'], FILTER_VALIDATE_FLOAT, array('min_range' >= 1))) {
                     $add_product_errors['price'] = 'Please enter a valid price!';
              }
              if (empty($_POST['stock']) || !filter_var($_POST['stock'], FILTER_VALIDATE_FLOAT, array('min_range' => 1))) {
                     $add_product_errors['stock'] = 'Please enter a valid stock!';
              }
              if (empty($_POST['description'])) {
                     $add_product_errors['description'] = 'Please enter the description!';
              }
              if (empty($_POST['content'])) {
                     $add_product_errors['content'] = 'Please enter the content!';
              }
              if (empty($_POST['attrScreen']) || empty($_POST['attrOs']) || empty($_POST['attrCameraBack']) || empty($_POST['attrCameraFront']) || empty($_POST['attrCpu']) || empty($_POST['attrSim']) || empty($_POST['attrBattery'])) {
                     $add_product_errors['attr'] = 'Please select all attribute!';
              }
              if (empty($_POST['attr'])) {
                     $add_product_errors['attr'] = 'Please enter all attribute!';
              } else {
                     foreach ($_POST['attr'] as $attr) {
                            if (!filter_var($attr, FILTER_VALIDATE_INT, ['min_range' => 1])) {
                                   $add_product_errors['attr'] = 'Please enter all valid attribute!';
                                   break;
                            }
                     }
              }

              //Check for thumb
              $list_images = [];
              $list_dest = [];
              if (is_uploaded_file($_FILES['thumb']['tmp_name']) && $_FILES['thumb']['error'] === UPLOAD_ERR_OK) {
                     $file = $_FILES['thumb'];
                     $size = ROUND($file['size'] / 1024);
                     if ($size > 500000) {
                            $add_product_errors['thumb'] = 'The uploaded file was too large.';
                     }

                     $allowed_ext =  array('png', 'jpg', 'gif', 'jpeg');
                     $file_ext = pathinfo($file['name'], PATHINFO_EXTENSION);
                     // $file_ext = substr($file['anem'], -4);

                     $allowed_mime = array('image/gif', 'image/pjpeg', 'image/jpeg', 'image/JPG', 'image/X-PNG', 'image/PNG', 'image/png', 'image/x-png');
                     $file_info = finfo_open(FILEINFO_MIME_TYPE);
                     $file_type = finfo_file($file_info, $file['tmp_name']);
                     finfo_close($file_info);

                     if (!in_array($file_type, $allowed_mime) || !in_array($file_ext, $allowed_ext)) {
                            $add_product_errors['thumb'] = 'The uploaded file was not of the proper type.';
                     }
                     if (!array_key_exists('thumb', $add_product_errors)) {
                            $new_name_thumb = sha1($file['name'] . uniqid('', true));
                            $new_name_thumb .= '.' . $file_ext;
                            $dest = "../public/images/phone/$new_name_thumb";
                            $list_dest[] = $dest;
                            if (move_uploaded_file($file['tmp_name'], $dest)) {
                                   $flag_upload_success = true;
                                   // $_SESSION['thumb']['new_name'] = $new_name;
                                   // $_SESSION['thumb']['file_name'] = $file['name'];
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
                                   $add_product_errors['thumb'] = 'The uploaded file was too large.';
                                   break;
                            case 3:
                                   $add_product_errors['thumb'] = 'The file was only partially uploaded.';
                                   break;
                            case 6:
                            case 7:
                            case 8:
                                   $add_product_errors['thumb'] = 'The file could not be uploaded due to a system error.';
                                   break;
                            case 4:
                            default:
                                   $add_product_errors['thumb'] = 'No file was uploaded.';
                                   break;
                     }
              }
              //Check list images
              if ($_FILES['listImage']) {
                     $list_file = re_array_files($_FILES['listImage']);
                     foreach ($list_file as $file_item) {
                            if (is_uploaded_file($file_item['tmp_name']) && $file_item['error'] === UPLOAD_ERR_OK) {
                                   $file = $file_item;
                                   $size = ROUND($file['size'] / 1024);
                                   if ($size > 500000) {
                                          $add_product_errors['listImage'] = 'The uploaded file was too large.';
                                   }

                                   $allowed_ext =  array('png', 'jpg', 'gif', 'jpeg');
                                   $file_ext = pathinfo($file['name'], PATHINFO_EXTENSION);
                                   // $file_ext = substr($file['name'], -4);

                                   $allowed_mime = array('image/gif', 'image/pjpeg', 'image/jpeg', 'image/JPG', 'image/X-PNG', 'image/PNG', 'image/png', 'image/x-png');
                                   $file_info = finfo_open(FILEINFO_MIME_TYPE);
                                   $file_type = finfo_file($file_info, $file['tmp_name']);
                                   finfo_close($file_info);

                                   if (!in_array($file_type, $allowed_mime) || !in_array($file_ext, $allowed_ext)) {
                                          $add_product_errors['listImage'] = 'The uploaded file was not of the proper type.';
                                   }
                                   if (!array_key_exists('listImage', $add_product_errors)) {
                                          $new_name = sha1($file['name'] . uniqid('', true));
                                          $new_name .= '.' . $file_ext;
                                          $dest = "../public/images/phone/$new_name";
                                          $list_dest[] = $dest;
                                          if (move_uploaded_file($file['tmp_name'], $dest)) {
                                                 $flag_upload_success = true;
                                                 $list_images[] = $new_name;
                                                 // $_SESSION['listImage'][]['new_name'] = $new_name;
                                                 // $_SESSION['listImage'][]['file_name'] = $file['name'];
                                                 // echo '<h4>The file has been uploaded!</h4>';
                                          } else {
                                                 trigger_error('The file could not be moved.');
                                                 unlink($file['tmp_name']);
                                          }
                                   }
                            } else {
                                   // switch ($_FILES['listImage']['error']) {
                                   //        case 1:
                                   //        case 2:
                                   //               $add_product_errors['listImage'] = 'The uploaded file was too large.';
                                   //               break;
                                   //        case 3:
                                   //               $add_product_errors['listImage'] = 'The file was only partially uploaded.';
                                   //               break;
                                   //        case 6:
                                   //        case 7:
                                   //        case 8:
                                   //               $add_product_errors['listImage'] = 'The file could not be uploaded due to a system error.';
                                   //               break;
                                   //        case 4:
                                   //        default:
                                   //               $add_product_errors['listImage'] = 'No file was uploaded.';
                                   //               break;
                                   // }
                            }
                     }
              }
              if (empty($add_product_errors)) {
                     $q1 = "INSERT INTO `phones` (`name`, `description`, `content`, `thumb`, `price`, `stock`, `screen`, `os`, `camera_back`, `camera_front`, `cpu`, `sim`,`battery`) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                     $q2 = "INSERT INTO `phone_category`(`phone_id`, `category_id`) VALUES(?, ?)";
                     $q3 = "INSERT INTO `product_attribute`(`product_id`, `attribute_value_id`) VALUES(?, ?)";
                     $q4 = "INSERT INTO `img_product`(`product_id`, `image`) VALUES (?, ?)";
                     $stmt1 = mysqli_prepare($dbc, $q1);
                     $stmt2 = mysqli_prepare($dbc, $q2);
                     $stmt3 = mysqli_prepare($dbc, $q3);
                     $stmt4 = mysqli_prepare($dbc, $q4);
                     // if(!$stmt){ for debugging
                     //        echo mysqli_stmt_error($stmt);
                     // }
                     // show_array($_POST);
                     mysqli_stmt_bind_param($stmt1, 'ssssiisssssss', $name, $des, $content,  $new_name_thumb, $_POST['price'], $_POST['stock'], $_POST['attrScreen'], $_POST['attrOs'], $_POST['attrCameraBack'], $_POST['attrCameraFront'], $_POST['attrCpu'], $_POST['attrSim'], $_POST['attrBattery']);
                     mysqli_stmt_bind_param($stmt2, 'ii', $product_id, $item);
                     mysqli_stmt_bind_param($stmt3, 'ii', $product_id, $attr);
                     mysqli_stmt_bind_param($stmt4, 'is', $product_id, $image);
                     $name = strip_tags($_POST['name']);
                     $des = strip_tags($_POST['description']);
                     $allowed = '<div><p><span><br><a><img><h1><h2><h3><h4>
                     <ul><ol><li><blockquote>';
                     $content = strip_tags($_POST['content'], $allowed);
                     mysqli_stmt_execute($stmt1);
                     if (mysqli_stmt_affected_rows($stmt1) === 1) {
                            $product_id = mysqli_stmt_insert_id($stmt1);
                            // ==================CATEGORY==============
                            foreach ($_POST['category'] as $item) {
                                   mysqli_stmt_execute($stmt2);
                            }
                            // ==================ATTR==================

                            foreach ($_POST['attr'] as $attr) {
                                   mysqli_stmt_execute($stmt3);
                            }
                            // =======================LIST IMAGE========
                            foreach ($list_images as $image) {
                                   // $image = $image['new_name'];
                                   mysqli_stmt_execute($stmt4);
                            }
                            // if(!empty($_SESSION['listImage'])){
                            //        foreach($_SESSION['listImage'] as $image){
                            //               $image = $image['new_name'];
                            //               mysqli_stmt_execute($stmt4);
                            //        }
                            // }
                            // echo '<h4>The product has been added!</h4>';
                            $success_add = true;
                            $_POST = array();
                            $_FILES = array();
                            unset($file, $_SESSION['thumb'], $_SESSION['listImage']);
                     } else {
                            trigger_error('The product could not be added due to a system error. We apologize for any inconvenience.');

                            // if(isset($dest)){
                            //        unlink($dest);
                            // }
                            foreach ($list_dest as $dest) {
                                   if (file_exists($dest)) {
                                          unlink($dest);
                                   }
                            }
                     }
              } else {
                     // show_array($list_dest);
                     if (isset($flag_upload_success)) {
                            foreach ($list_dest as $dest) {
                                   if (file_exists($dest)) {
                                          unlink($dest);
                                   }
                            }
                     }
              }
       } else {
              // unset($_SESSION['thumb']);
              // unset($_SESSION['listImage']);
              // if(isset($flag_upload_success)){
              //        foreach($list_dest as $dest){
              //                unlink($dest);
              //        }
              //  }

       }
       ?>
       <div id="content" class="float-right">
              <div class="section add-product">
                     <div class="section-head">
                            <h3 class="section-title">Add a product</h3>
                            <?php
                                   if(isset($success_add)){
                                          echo '<div class="alert alert-success" role="alert">
                                          The product has been added!
                                        </div>';
                                   }
                            ?>
                     </div>
                     <div class="section-detail">
                            <form enctype="multipart/form-data" action="" method="POST" accept-charset="utf8">
                                   <input type="hidden" name="MAX_FILE_SIZE" value="500000">
                                   <fieldset>
                                          <legend>Fill out the form to add a to the catalog. All fields are required.</legend>
                                          <div class="form-group">
                                                 <label class="control-label">Brand</label>
                                                 <select name="category[]" multiple="multiple" size="3" class="form-control" <?php if (array_key_exists('category', $add_product_errors)) echo 'class = "error"' ?>>
                                                        <?php
                                                        $list_categories = get_categories();
                                                        foreach ($list_categories as $key => $val) {
                                                               $selected = '';
                                                               if (isset($_POST['category'])) {
                                                                      foreach ($_POST['category'] as $item) {
                                                                             if ($item == $key) {
                                                                                    $selected = 'selected';
                                                                             }
                                                                      }
                                                               }
                                                               echo "<option value = '{$key}' $selected>" . htmlspecialchars(ucwords($val)) . "</option>";
                                                        }
                                                        ?>
                                                 </select>
                                          </div>
                                          <?php
                                          form_error('category', $add_product_errors);
                                          ?>
                                          <?php create_form_input('name', 'text', 'Name', $add_product_errors) ?>
                                          <?php create_form_input('price', 'text', 'Price', $add_product_errors) ?>
                                          <small>Without the dollar sign.</small>

                                          <?php create_form_input('stock', 'text', 'Initial Quantity in Stock', $add_product_errors) ?>
                                          <div class="row form-group">
                                                 <label for="attr-screen" class="col-md-3">Screen:</label>
                                                 <div class="col-md-9">
                                                        <input type="text" name="attrScreen" id="attr-screen" value="<?php if (!empty($_POST['attrScreen'])) echo $_POST['attrScreen']; ?>" class="form-control">
                                                 </div>
                                          </div>
                                          <div class="row form-group">
                                                 <label for="attr-os" class="col-md-3">Operating system:</label>
                                                 <div class="col-md-9">
                                                        <input type="text" name="attrOs" id="attr-os" value="<?php if (!empty($_POST['attrOs'])) echo $_POST['attrOs']; ?>" class="form-control">
                                                 </div>
                                          </div>

                                          <div class="row form-group">
                                                 <label for="attr-camera-back" class="col-md-3">Back Camera:</label>
                                                 <div class="col-md-9">
                                                        <input type="text" name="attrCameraBack" id="attr-camera-back" value="<?php if (!empty($_POST['attrCameraBack'])) echo $_POST['attrCameraBack']; ?> " class="form-control">
                                                 </div>
                                          </div>


                                          <div class="row form-group">
                                                 <label for="attr-camera-front" class="col-md-3">Front Camera:</label>
                                                 <div class="col-md-9">
                                                        <input type="text" name="attrCameraFront" id="attr-camera-front" value="<?php if (!empty($_POST['attrCameraFront'])) echo $_POST['attrCameraFront']; ?>" class="form-control">
                                                 </div>
                                          </div>
                                          <div class="row form-group">
                                                 <label for="attr-cpu" class="col-md-3">CPU:</label>
                                                 <div class="col-md-9">
                                                        <input type="text" name="attrCpu" id="attr-cpu" value="<?php if (!empty($_POST['attrCpu'])) echo $_POST['attrCpu']; ?>" class="form-control">
                                                 </div>
                                          </div>
                                          <div class="row form-group">
                                                 <label for="attr-sim" class="col-md-3">SIM:</label>
                                                 <div class="col-md-9">
                                                        <input type="text" name="attrSim" id="attr-sim" value="<?php if (!empty($_POST['attrSim'])) echo $_POST['attrSim']; ?>" class="form-control">
                                                 </div>
                                          </div>
                                          <div class="row form-group">
                                                 <label for="attr-battery" class="col-md-3">Battery capacity:</label>
                                                 <div class="col-md-9">
                                                        <input type="text" name="attrBattery" id="attr-battery" value="<?php if (!empty($_POST['attrBattery'])) echo $_POST['attrBattery']; ?>" class="form-control">
                                                 </div>
                                          </div>
                                          <?php
                                          // =====================ATTR============================
                                          $list_all_attr = get_all_attr();
                                          if (!empty($list_all_attr)) {
                                                 $tmp = $list_all_attr[0]['name'];
                                                 echo "<div class='form-group'>";
                                                 echo "<label>" . ucwords($list_all_attr[0]['name']) . "</label>";
                                                 echo "<select name = 'attr[]' multiple='multiple' size='3' class='form-control'>"; //open select
                                                 $i = 0;
                                                 foreach ($list_all_attr as $v) {
                                                        $selected = '';
                                                        if ($v['name'] != $tmp) {
                                                               $i++;
                                                               echo "</select name = 'attr[]'>";
                                                               echo "</div>";
                                                               echo "<div class='form-group'>";
                                                               echo "<label>" . ucwords($v['name']) . "</label>";
                                                               echo "<select name='attr[]' multiple='multiple' size='3' class='form-control'>"; //open select
                                                        }
                                                        if (isset($_POST['attr'])) {
                                                               foreach ($_POST['attr'] as $attr) {
                                                                      if ($attr == $v['attribute_value_id']) {
                                                                             $selected = 'selected';
                                                                      }
                                                               }
                                                        }
                                                        echo "<option value='" . $v['attribute_value_id'] . "' " . $selected . ">{$v['value']}</option>";
                                                        $tmp = $v['name'];
                                                 }
                                                 echo "</select>";
                                                 echo "</div>";
                                          }
                                          form_error('attr', $add_product_errors);
                                          ?>
                                          <?php create_form_input('description', 'textarea', 'Description', $add_product_errors) ?>
                                          <?php create_form_input('content', 'textarea', 'Content', $add_product_errors) ?>
                                          <div class="form-group">
                                                 <label for="upload-thumb" class="control-label" for="upload-thumb">Thumb</label>
                                                 <input type = 'file' name = 'thumb' id='upload-thumb' class='form-control-file'>
                                                 <?php
                                                        form_error('thumb',  $add_product_errors);
                                                 ?>
                                          </div>
                                          <img src="../public/images/size/400x400.png" alt="" id="preview-thumb" width="400px" height="400px"><br>
                                         
                                          <div class="row form-group">
                                                 <div class="col-md-5">
                                                        <div class="form-group">
                                                               <label for="upload-1">Image 1</label>
                                                               <input type="file" name="listImage[]" id="upload-1" class="mb-5">
                                                        </div>
                                                        <img src="../public/images/size/400x460.png" alt="" id="preview-1">
                                                 </div>
                                                 <div class="col-md5">
                                                        <div class="form-group">
                                                               <label for="upload-2">Image 2</label>
                                                               <input type="file" name="listImage[]" id="upload-2">
                                                        </div>
                                                        <img src="../public/images/size/400x460.png" alt="" id="preview-2">
                                                 </div>
                                          </div>
                                          <div class="row form-group">
                                                 <div class="col-md-5">
                                                        <div class="form-group">
                                                               <label for="upload-3">Image 3</label>
                                                               <input type="file" name="listImage[]" id="upload-3">
                                                        </div>
                                                        <img src="../public/images/size/400x460.png" alt="" id="preview-3">
                                                 </div>
                                                 <div class="col-md-5">
                                                        <div class="form-group">
                                                               <label for="upload-4">Image 4</label>
                                                               <input type="file" name="listImage[]" id="upload-4">
                                                        </div>
                                                        <img src="../public/images/size/400x460.png" alt="" id="preview-4">
                                                 </div>
                                          </div>
                                          <?php
                                          // if (array_key_exists('thumb', $add_product_errors)) {
                                          //        echo "
                                          //        <div class = 'error'><i class='fas fa-exclamation-triangle'></i> {$add_product_errors['thumb']}</div>
                                          //        <input type = 'file' name = 'thumb' class = 'error' >
                                          //        ";
                                          // } else {
                                          //        echo "<input type = 'file' name = 'thumb'>";
                                          //        if (isset($_SESSION['thumb'])) {
                                          //               echo "<div>{$_SESSION['thumb']['file_name']}</div>";
                                          //        }
                                          // }
                                          ?>
                                          <div class="form-group">
                                                 <input type="submit" value="Add this product">
                                          </div>
                                   </fieldset>
                            </form>
                     </div>
              </div>
       </div>
</div>