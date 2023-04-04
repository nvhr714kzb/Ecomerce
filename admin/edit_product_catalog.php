<?php
require('../includes/config.inc.php');
require('../lib/database.inc.php');
require('lib/product_functions.inc.php');
require('../lib/form_functions.inc.php');
require('../lib/user.inc.php');
require('../' . MYSQL);
require('includes/permission.php');
include('includes/header.html');
$page = isset($_GET['page']) ? $_GET['page'] : 'categories';
// =====================Category======================
if ($page === 'categories') {
       // if ($_SERVER['REQUEST_METHOD'] === 'GET') {
       //        unset($_SESSION['image']);
       // }
       $item_edit  = 0;
       foreach ($_POST as $key => $value) {
              if (substr($key, 0, 6) === 'submit') {
                     $last_hyphen = strrpos($key, '-');
                     $action = substr($key, strlen('submit-'), $last_hyphen - strlen('submit-'));
                     $cat_id = (int)substr($key, $last_hyphen + 1);
                     if ($action === 'edit-product') {
                            header("Location: edit_product_catalog.php?page=product&catId=$cat_id");
                     } elseif ($action === 'edit-cat') {
                            $item_edit = $cat_id;
                     } elseif ($action === 'update-cat') {
                            $cat = strip_tags($_POST['category']);
                            $description = strip_tags($_POST['description']);
                            $img = ''; //ADDDDDDDDDDDDDDDDDDDDd
                            if (!empty($cat && $description)) {
                                   update_category($cat_id, $cat, $description, $img);
                                   $message = ' Brand has been updated';
                            } else {
                                   $error_message = 'Category name or description required';
                            }
                     } elseif ($action === 'delete-cat') {
                            $status = delete_category($cat_id);
                            if ($status < 0) {
                                   $error_message = "Category not empty";
                            } else {
                                   $message = ' Brand has been deleted';
                            }
                     } elseif ($action === 'add-cat') {
                            $add_cat_errors = array();
                            if (empty($_POST['catName'])) {
                                   $add_cat_errors['name'] = 'Category required';
                            } else {
                                   if (strlen($_POST['catName']) > 40) {
                                          $add_cat_errors['name'] = 'Category must be less than or equal 40 characters ';
                                   }
                            }
                            if (empty($_POST['catDes'])) {
                                   $add_cat_errors['des'] = 'Description required';
                            } else {
                                   if (strlen($_POST['catDes']) > 500) {
                                          $add_cat_errors['des'] = 'Description must be less than or equal 500 characters ';
                                   }
                            }
                            // if(empty($_POST['nameImg'])){
                            //        $add_category_errors['des'] = 'Description required';
                            // }
                            if (is_uploaded_file($_FILES['image']['tmp_name']) && ($_FILES['image']['error'] === UPLOAD_ERR_OK)) {
                                   $file = $_FILES['image'];
                                   $size = ROUND($file['size'] / 1024);
                                   if ($size > 512) {
                                          $add_category_errors['image'] = 'The uploaded file was too large.';
                                   }
                                   $allowed_mime = array('image/gif', 'image/pjpeg', 'image/jpeg', 'image/JPG', 'image/X-PNG', 'image/PNG', 'image/png', 'image/x-png');
                                   $allowed_extensions = array('.jpg', '.gif', '.png', 'jpeg');
                                   // Check the file:
                                   $fileinfo = finfo_open(FILEINFO_MIME_TYPE);
                                   $file_type = finfo_file($fileinfo, $file['tmp_name']);
                                   finfo_close($fileinfo);
                                   $file_ext = substr($file['name'], -4);
                                   if (!in_array($file_type, $allowed_mime) || !in_array($file_ext, $allowed_extensions)) {
                                          $add_cat_errors['image'] = 'The uploaded file was not of the proper type.';
                                   }
                                   if (!array_key_exists('image', $add_cat_errors)) {
                                          $new_name = sha1($file['name'] . uniqid('', true));
                                          $new_name .= ((substr($file_ext, 0, 1) != '.') ? ".{$file_ext}" : $file_ext);
                                          $dest =  "../public/images/phone/$new_name";
                                          if (move_uploaded_file($file['tmp_name'], $dest)) {
                                                 $flag_upload_success = true;
                                                 // echo '<h4>The file has been uploaded!</h4>';
                                          } else {
                                                 trigger_error('The file could not be moved.');
                                                 unlink($file['tmp_name']);
                                          }
                                   }
                            } else {
                                   switch ($_FILES['image']['error']) {
                                          case 1:
                                          case 2:
                                                 $add_cat_errors['image'] = 'The uploaded file was too large.';
                                                 break;
                                          case 3:
                                                 $add_cat_errors['image'] = 'The file was only partially uploaded.';
                                                 break;
                                          case 6:
                                          case 7:
                                          case 8:
                                                 $add_cat_errors['image'] = 'The file could not be uploaded due to a system error.';
                                                 break;
                                          case 4:
                                          default:
                                                 $add_cat_errors['image'] = 'No file was uploaded.';
                                                 break;
                                   }
                            }
                            if (empty($add_cat_errors)) {
                                   add_category(strip_tags($_POST['catName']), strip_tags($_POST['catDes']), $new_name);
                                   $message = ' Brand has been added';
                                   $_POST = array();
                                   $_FILES = array();
                                   unset($file);
                            } else {
                                   if (isset($flag_upload_success)) {
                                          unlink($dest);
                                   }
                            }
                     }
                     break;
              }
       }
       $list_cats = get_list_categories();
       include('edit_list_cats_product.php');

       // =====================Product======================
} elseif ($page === 'product') {
       if (isset($_GET['catId']) && filter_var($_GET['catId'], FILTER_VALIDATE_INT, array('min_range' => 1)) && is_valid_category($_GET['catId'])) {
              $cat_id = $_GET['catId'];
              foreach ($_POST as $key => $value) {
                     if (substr($key, 0, 6) === 'submit') {
                            $last_hyphen = strrpos($key, '-');
                            $action = substr($key, strlen('submit-'), $last_hyphen - strlen('submit-'));
                            $id = (int)substr($key, $last_hyphen + 1);
                            if ($action === 'edit-pro') {
                                   header("Location: edit_product_catalog.php?page=productDetail&productId=$id&catId=$cat_id");
                                   exit();
                            }
                            break;
                     }
              }
              $list_products = get_products_by_cat($cat_id, 0, NUM_ITEMS_ADMIN);
              include('edit_list_products.php');
       } else {
              redirect('admin/edit_product_catalog.php?page=categories');
       }

       // =====================Product detail======================
} elseif ($page === 'productDetail') {
       if (isset($_GET['catId'], $_GET['productId']) && filter_var($_GET['catId'], FILTER_VALIDATE_INT, array('min_range' => 1)) && filter_var($_GET['productId'], FILTER_VALIDATE_INT, array('min_range' => 1)) && is_valid_product_in_category($_GET['productId'], $_GET['catId'])) {
              $product_id = (int)$_GET['productId'];
              $cat_id = (int)$_GET['catId'];
              $update_product_errors = array();
              if (isset($_POST['updateInfo'])) {
                     if (empty($_POST['name'])) {
                            $update_product_errors['name'] = 'Please enter the name!';
                     }
                     if (empty($_POST['description'])) {
                            $update_product_errors['description'] = 'Please enter the description!';
                     }
                     if (empty($_POST['price'])) {
                            $update_product_errors['price'] = 'Please enter the price!';
                     } elseif (!is_numeric($_POST['price']) || $_POST['price'] <= 0) {
                            $update_product_errors['price'] = 'Please enter a valid price!';
                     }
                     if (is_uploaded_file($_FILES['thumb']['tmp_name']) && ($_FILES['thumb']['error'] === UPLOAD_ERR_OK)) {
                            $file = $_FILES['thumb'];
                            $size = ROUND($file['size'] / 1024);
                            if ($size > 512) {
                                   $update_product_errors['thumb'] = 'The uploaded file was too large.';
                            }
                            $allowed_mime = array('image/gif', 'image/pjpeg', 'image/jpeg', 'image/JPG', 'image/X-PNG', 'image/PNG', 'image/png', 'image/x-png');
                            $allowed_extensions = array('.jpg', '.gif', '.png', 'jpeg');
                            // Check the file:
                            $fileinfo = finfo_open(FILEINFO_MIME_TYPE);
                            $file_type = finfo_file($fileinfo, $file['tmp_name']);
                            finfo_close($fileinfo);
                            $file_ext = substr($file['name'], -4);
                            if (!in_array($file_type, $allowed_mime) || !in_array($file_ext, $allowed_extensions)) {
                                   $update_product_errors['thumb'] = 'The uploaded file was not of the proper type.';
                            }
                            if (!array_key_exists('thumb', $update_product_errors)) {
                                   $new_name = sha1($file['name'] . uniqid('', true));
                                   $new_name .= ((substr($file_ext, 0, 1) != '.') ? ".{$file_ext}" : $file_ext);
                                   $dest =  "../public/images/phone/$new_name";
                                   if (move_uploaded_file($file['tmp_name'], $dest)) {
                                          $flag_upload_success = true;
                                          // echo '<h4>The file has been uploaded!</h4>';
                                   } else {
                                          trigger_error('The file could not be moved.');
                                          unlink($file['tmp_name']);
                                   }
                            }
                     } else {
                            // switch ($_FILES['thumb']['error']) {
                            //        case 1:
                            //        case 2:
                            //               $update_product_errors['thumb'] = 'The uploaded file was too large.';
                            //               break;
                            //        case 3:
                            //               $update_product_errors['thumb'] = 'The file was only partially uploaded.';
                            //               break;
                            //        case 6:
                            //        case 7:
                            //        case 8:
                            //               $update_product_errors['thumb'] = 'The file could not be uploaded due to a system error.';
                            //               break;
                            //        case 4:
                            //        default:
                            //               $update_product_errors['thumb'] = 'No file was uploaded.';
                            //               break;
                            // }
                     }
                     if (empty($update_product_errors)) {
                            if (isset($new_name)) {//has thumb
                                   update_product($product_id, addslashes(strip_tags($_POST['name'])), addslashes(strip_tags($_POST['description'])), $_POST['price'], $new_name);
                            }else{//no thumb
                                   $q = "UPDATE phones SET name = '".strip_tags($_POST['name'])."', description  = '".strip_tags($_POST['description'])."', price = ".$_POST['price']." WHERE id = $product_id";
                                   db_query($q);
                            }
                            $success_add = true;
                     } else {
                            if (isset($flag_upload_success)) {
                                   unlink($dest);
                            }
                     }
                     // ==========================FILE===========================
              } elseif (isset($_POST['removeCat'])) {
                     if (isset($_POST['targetCatRemove']) && filter_var($_POST['targetCatRemove'], FILTER_VALIDATE_INT, array('min_range' => 1))) {
                            $status = remove_product_from_category($product_id, $_POST['targetCatRemove']);
                            if ($cat_id == $_POST['targetCatRemove']) {
                                   redirect("admin/edit_product_catalog.php?page=product&catId={$cat_id}");
                            }
                     }
              } elseif (isset($_POST['assignCat'])) {
                     if (isset($_POST['targetCatAssign']) && filter_var($_POST['targetCatAssign'], FILTER_VALIDATE_INT, array('min_range' => 1))) {
                            assign_product_category($product_id, $_POST['targetCatAssign']);
                     }
              } elseif (isset($_POST['moveCat'])) {
                     if (isset($_POST['targetCatMove'], $_POST['sourceCatMove']) && is_numeric($_POST['targetCatMove'])) {
                            move_product_to_category($product_id, $_POST['sourceCatMove'], $_POST['targetCatMove']);
                            if ($_POST['sourceCatMove'] ==  $cat_id) {
                                   redirect("admin/edit_product_catalog.php?page=productDetail&productId=$product_id&catId={$_POST['targetCatMove']}");
                            }
                     }
              } elseif (isset($_POST['removeCatalog'])) {
                     delete_product($product_id);
                     redirect("admin/edit_product_catalog.php?page=product&catId={$cat_id}");
              } elseif (isset($_POST['removeAttr'])) {
                     if (isset($_POST['targetAttrRemove']) && filter_var($_POST['targetAttrRemove'], FILTER_VALIDATE_INT, array('min_range' => 1))) {
                            remove_product_attribute_value($product_id, $_POST['targetAttrRemove']);
                     }
              } elseif (isset($_POST['assignAttr'])) {
                     if (isset($_POST['targetAttrAssign']) && filter_var($_POST['targetAttrAssign'], FILTER_VALIDATE_INT, array('min_range' => 1))) {
                            assign_attribute_to_product($product_id, $_POST['targetAttrAssign']);
                     }
              }
              $num_cat = count_categories_of_product($product_id);
              $list_categories_for_product = get_categories_for_product($product_id);
              $list_categories = get_categories();
              $list_categories_not_assign = array_diff($list_categories, $list_categories_for_product);
              $product_attrs = get_product_attributes($product_id);
              $list_product_attrs_not_assign = get_attributes_not_assign_to_product($product_id);

              $detail_product = get_product_info($product_id);
              if ($_SERVER['REQUEST_METHOD'] == 'POST') {
                     $name = $_POST['name'];
                     $description = $_POST['description'];
                     $price = $_POST['price'];
              } else {
                     $name = $detail_product['name'];
                     $description = $detail_product['description'];
                     $price = $detail_product['price'];
              }
              include("edit_product_detail.php");
       } else {
              redirect("admin/edit_product_catalog.php?page=product&catId={$cat_id}");
       }
       // =====================Attribute======================
} elseif ($page === 'attributes') {
       $item_edit = 0;
       foreach ($_POST as $key => $value) {
              if (substr($key, 0, 6) === 'submit') {
                     $last_hyphen = strrpos($key, '-');
                     $action = substr($key, strlen('submit-'), $last_hyphen - strlen('submit-'));
                     $attr_id = (int)substr($key, $last_hyphen + 1);
                     if ($action === 'edit-attr-val') {
                            header("Location: edit_product_catalog.php?page=attributeValues&attrId=$attr_id");
                     } elseif ($action === 'edit') {
                            $item_edit = $attr_id;
                     } elseif ($action === 'delete') {
                            $status = delete_attribute($attr_id);
                            if ($status < 0) {
                                   $error_message = "Attribute has one or more values and cannot be deleted!";
                            } else {
                                   $message = ' Attribute name has been deleted';
                            }
                     } elseif ($action === 'update') {
                            $attr_name = $_POST['name'];
                            if (!empty($attr_name)) {
                                   if (strlen($_POST['name']) <= 20) {
                                          update_attribute($attr_id, strip_tags($attr_name));
                                          $message = ' Attribute name has been updated';
                                   } else {
                                          $error_message = 'Attribute name must be less than or equal 20 characters';
                                   }
                            } else {
                                   $error_message = 'Attribute name required';
                            }
                     } elseif ($action === 'add-attr') {
                            $attr_name = $_POST['name-attr'];
                            if (!empty($attr_name)) {
                                   if (strlen($_POST['name-attr']) <= 20) {
                                          add_attribute(strip_tags($attr_name));
                                          $message = 'Attribute name has been added';
                                   } else {
                                          $error_message = 'Attribute name must be less than or equal 20 characters';
                                   }
                            } else {
                                   $error_message = 'Attribute name required!';
                            }
                     }
                     break;
              }
       }
       $list_attrs = get_attributes();
       include('list_attributes.php');

       // =====================Attribute Values======================
} elseif ($page === 'attributeValues') {
       if (isset($_GET['attrId']) && filter_var($_GET['attrId'], FILTER_VALIDATE_INT, array('min_range' => 1)) && is_valid_attr($_GET['attrId'])) {
              $item_edit = 0;
              $attr_id = $_GET['attrId'];
              foreach ($_POST as $key => $value) {
                     if (substr($key, 0, 6) === 'submit') {
                            $last_hyphen = strrpos($key, '-');
                            $action = substr($key, strlen('submit-'), $last_hyphen - strlen('submit-'));
                            $attr_val_id = (int)substr($key, $last_hyphen + 1);
                            if ($action === 'edit') {
                                   $item_edit = $attr_val_id;
                            }
                            if ($action === 'update') {
                                   $value = $_POST['value'];
                                   if (!empty($value) && strlen($value) <= 20) {
                                          update_attr_value($attr_val_id, strip_tags($value));
                                          $message = ' Attribute value has been updated';
                                   } else {
                                          $error_message = 'Attribute value required!';
                                   }
                            }
                            if ($action === 'delete') {
                                   $status = delete_attr_value($attr_val_id);
                                   if ($status < 0) {
                                          $error_message = 'Cannot delete this attribute value. One or more products using it!';
                                   } else {
                                          $message = ' Attribute value has been deleted';
                                   }
                            }
                            if ($action === 'add-val') {
                                   $value = $_POST['attribute-value'];
                                   if (!empty($value)) {
                                          if (strlen($value) <= 20) {
                                                 add_attr_value($attr_id, $value);
                                                 $message = ' Attribute value has been added';
                                          } else {
                                                 $error_message = 'Attribute value must be less than or equal 20 characters';;
                                          }
                                   } else {
                                          $error_message = 'Attribute value required';
                                   }
                            }
                            break;
                     }
              }
              $list_attr_values = get_attr_values($attr_id);
              include('list_attribute_values.php');
       } else {
              redirect('admin/edit_product_catalog.php?page=attributes');
       }
       // =========================CART=========================
} elseif ($page === 'carts') {
       $day_options = array(
              0 => 'All shopping carts',
              1 => 'One day old',
              10 => 'Ten days old',
              20 => 'Twenty days old',
              30 => 'Thirty days old',
              90 => 'Ninety days old'
       );
       foreach ($_POST as $key => $val) {
              if (substr($key, 0, 6) == 'submit') {
                     $action = substr($key, strlen('submit-'), strlen($key));
                     $days = isset($_POST['days']) ? (int)$_POST['days'] : 0;
                     if ($action == 'count') {
                            $count_old_cart = get_count_old_cart($days);
                            if ($count_old_cart == 0) {
                                   $count_old_cart = 'no';
                            }
                            $message = "There are $count_old_cart old shopping carts (selected option: {$day_options[$days]}).";
                     }
                     if ($action == 'delete') {
                            delete_old_carts($days);
                            $message = "The old shopping carts were removed from the database (selected option: {$day_options[$days]}).";
                     }
                     break;
              }
       }
       include('delete_old_cart.php');
} else {
       redirect('admin/edit_product_catalog.php?page=categories');
}
