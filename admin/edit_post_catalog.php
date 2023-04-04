<?php
require('../includes/config.inc.php');
require('../lib/database.inc.php');
require('lib/product_functions.inc.php');
require('lib/post_functions.inc.php');
require('../lib/user.inc.php');
require('../lib/helper.inc.php');
require('../' . MYSQL);
require('includes/permission.php');
include('includes/header.html');
$page = isset($_GET['page']) ? $_GET['page'] : 'product';
$error_message = '';
if ($page === 'product') {
       $item_edit  = 0;
       foreach ($_POST as $key => $value) {
              if (substr($key, 0, 6) === 'submit') {
                     $last_hyphen = strrpos($key, '-');
                     $action = substr($key, strlen('submit-'), $last_hyphen - strlen('submit-'));
                     $pid = (int)substr($key, $last_hyphen + 1);
                     if ($action === 'view-posts') {
                            header("Location: edit_post_catalog.php?page=post&pId=$pid");
                     } elseif ($action === 'delete-posts') {
                            delete_post_by_product($pid);
                            $success_delete = true;
                     }
                     break;
              }
       }
       $q = "SELECT p.id, p.name, p.thumb, IFNULL(s.price, p.price) price, po.product_id, COUNT(po.product_id) num_post FROM phones p 
       INNER JOIN posts po ON po.product_id = p.id
       LEFT OUTER JOIN promotion pm ON p.promotion_id = pm.id 
       LEFT OUTER JOIN sales s ON (p.id = s.product_id AND 
       ((NOW() BETWEEN s.start_date AND s.end_date) OR (NOW() > s.start_date AND s.end_date IS NULL)))
       GROUP BY po.product_id ORDER BY p.date_created DESC LIMIT 20";
       $list_post = db_fetch_array($q);
       include('edit_list_post_by_products.php');

} elseif ($page === 'post') {
       if (isset($_GET['pId']) && filter_var($_GET['pId'], FILTER_VALIDATE_INT, array('min_range' => 1)) && is_valid_product($_GET['pId'])) {
              $product_id = $_GET['pId'];
              $phone_info = get_detail_phone($product_id);
              foreach ($_POST as $key => $value) {
                     if (substr($key, 0, 6) === 'submit') {
                            $last_hyphen = strrpos($key, '-');
                            $action = substr($key, strlen('submit-'), $last_hyphen - strlen('submit-'));
                            $id = (int)substr($key, $last_hyphen + 1);
                            if ($action === 'delete') {
                                   delete_post($id);
                                   $success_delete = true;
                            }elseif($action === 'live'){
                                   update_status_post($id, 'live');
                                   $success_live = true;
                            }
                            break;
                     }
              }

              $q = "SELECT po.id, po.status, po.title, po.thumb, po.description, po.date_created, u.name  FROM posts po
              INNER JOIN users u ON po.user_id = u.id
              WHERE po.product_id = $product_id";
              $status = !empty($_GET['status']) ? $_GET['status'] : 'all';
              if ($status === 'live') {
                     $q .= " AND status = 'live'";
              } elseif ($status === 'draft') {
                     $q .= " AND status = 'draft'";
              }

              $page = isset($_GET['p']) && is_numeric($_GET['p'])  && $_GET['p'] > 0 ? $_GET['p'] : 1;

              $start_item = ($page - 1) * NUM_ITEMS_ADMIN;
              $num_page = ceil(count(db_fetch_array($q)) / NUM_ITEMS_ADMIN);
              $q .= " LIMIT $start_item, " . NUM_ITEMS_ADMIN . "";
              $list_post = db_fetch_array($q);

              $count_post = array(
                     'all' =>  db_num_rows("SELECT id FROM posts WHERE product_id = $product_id"),
                     'live' => db_num_rows("SELECT id FROM posts WHERE product_id = $product_id AND status = 'live'"),
                     'draft' => db_num_rows("SELECT id FROM posts WHERE product_id = $product_id AND status = 'draft'")
              );
              include('edit_list_post_by_product.php');
       } else {
              redirect('edit_post_catalog.php?page=product');
       }
}
