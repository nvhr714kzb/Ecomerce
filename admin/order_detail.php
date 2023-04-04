<?php
require('../includes/config.inc.php');
require('../lib/database.inc.php');
require('../lib/user.inc.php');
require('../lib/helper.inc.php');
require('../lib/discount_code_functions.inc.php');
require('lib/product_functions.inc.php');
require('lib/order_functions.inc.php');
require('includes/permission.php');
require('../' . MYSQL);
?>
<div id="content-wp" class="clearfix">
       <?php
       if (isset($_GET['orderId'])) {
              list($has_login, $order_id) = parse_order_id($_GET['orderId']);
              if (isset($_POST['submitUpdate'])) {
                     $status = (int)$_POST['status'];
                     $comment = escape_data(strip_tags($_POST['comment']), $dbc);
                     if ($has_login == 'Login') {
                            $q = "SELECT status  FROM orders WHERE order_id = $order_id";
                            $current_status = db_fetch_row($q)['status'];
                            if ($status != $current_status && ($status = 0 || $status = 1)) {
                                   $q = "UPDATE orders SET ship_date = NULL WHERE order_id = $order_id";
                                   $r = mysqli_query($dbc, $q);
                            } elseif ($status != $current_status && $status == 2) {
                                   $is_ship = true;
                            }
                            $q = "UPDATE orders SET status  = $status, comments = $comment WHERE order_id = $order_id";
                            $r = mysqli_query($dbc, $q);
                     } elseif ($has_login == 'No Login') {
                            $q = "SELECT status  FROM orders_not_login WHERE order_id = $order_id";
                            $current_status = db_fetch_row($q)['status'];
                            if ($status != $current_status && ($status == 0 || $status == 1)) {
                                   $q = "UPDATE orders_not_login SET ship_date = NULL WHERE order_id = $order_id";
                                   $r = mysqli_query($dbc, $q);
                            } elseif ($status != $current_status && $status == 2) {
                                   $is_ship = true;
                            }
                            $q = "UPDATE orders_not_login SET status  = $status, comments = '$comment' WHERE order_id = $order_id";
                            $r = mysqli_query($dbc, $q);
                     }
              }
              if (isset($is_ship)) {
                     if ($has_login == 'Login') {
                            $q = "SELECT o.customer_id, o.total, c.charge_id, o.discount_code FROM orders o JOIN charges c ON(o.order_id = c.order_id  AND c.type = 'auth_only') WHERE o.order_id = $order_id";
                            $r = mysqli_query($dbc, $q);
                     } elseif ($has_login == 'No Login') {
                            $q = "SELECT o.customer_id, o.total, c.charge_id, o.discount_code FROM orders_not_login o JOIN charges_not_login c ON(o.order_id = c.order_id  AND c.type = 'auth_only') WHERE o.order_id = $order_id";
                            $r = mysqli_query($dbc, $q);
                     }

                     if (mysqli_num_rows($r) === 1) {
                            list($customer_id, $order_total, $charge_id, $discount_code) = mysqli_fetch_array($r, MYSQLI_NUM);
                            if ($order_total > 0) {
                                   try {
                                          require_once '../includes/vendor/autoload.php';
                                          \Stripe\Stripe::setApiKey('sk_test_51HcMVfERGNfztik59f5CdZD7s50FzQo828mAIgCdI1rXiZRmcpgghwVgjuqhvCPSnCSWbyu34t0frP2ZbS7NxbV300DTJu8Emv');
                                          $charge = \Stripe\Charge::retrieve($charge_id);
                                          $charge->capture();
                                          if ($charge->paid == 1) {
                                                 $message = 'The payment has been made. You may now ship the order.';
                                                 if ($has_login == 'Login') {
                                                        $q = "UPDATE orders SET ship_date = NOW() WHERE order_id = $order_id";
                                                        $r = mysqli_query($dbc, $q);
                                                        $q = "UPDATE phones p, order_contents oc SET p.stock = p.stock -  oc.quantity WHERE p.id = oc.product_id  AND oc.order_id = $order_id";
                                                        $r = mysqli_query($dbc, $q);
                                                 } elseif ($has_login == 'No Login') {
                                                        $q = "UPDATE orders_not_login SET ship_date = NOW() WHERE order_id = $order_id";
                                                        $r = mysqli_query($dbc, $q);
                                                        $q = "UPDATE phones p, order_contents_not_login oc SET p.stock = p.stock -  oc.quantity WHERE p.id = oc.product_id  AND oc.order_id = $order_id";
                                                        $r = mysqli_query($dbc, $q);
                                                 }
                                                 //decrease quantity discount code
                                                 if (!empty($discount_code)) {
                                                        $discount_code_info = get_discount_code($discount_code);
                                                        if ($discount_code_info['expired'] == 1) {
                                                        } else {
                                                               if ($discount_code_info['num_vouchers'] > 0) {
                                                                      $q = "UPDATE discount_codes SET num_vouchers = num_vouchers - 1 WHERE voucher_code = '$discount_code'";
                                                                      $r = mysqli_query($dbc, $q);
                                                               } else {
                                                               }
                                                        }
                                                 }
                                          } else {
                                                 $error = 'The payment could not be processed because: ' .  $charge->response_reason_text;
                                          }
                                   } catch (Exception $e) {
                                          trigger_error(print_r($e, 1));
                                   }
                            } else {
                                   $error = "The order total (\$$order_total) is invalid.";
                            }
                     } else {
                            $error = 'No matching order could be found.';
                     }
              }
              if (!empty($order_id)) {
                     if ($has_login == 'Login') {
                            $order_info = get_order_info(ORDER_LOGIN, $order_id);
                            if (!empty($order_info)) {
                                   $status_options = array(
                                          1 => 'placed',
                                          2 => 'verified',
                                          3 => 'completed',
                                          4 => 'canceled',
                                   );
                                   $order_content = get_orders_content(ORDER_LOGIN, $order_id);
                                   $edit_enable = isset($_POST['submitEdit']) ? true : false;
                                   include('includes/header.html');
                                   include('includes/sidebar.html');
                            } else {
                                   redirect('order.php');
                            }
                     } elseif ($has_login == 'No Login') {
                            $order_info = get_order_info(ORDER_NOT_LOGIN, $order_id);
                            if (!empty($order_info)) {
                                   $status_options = array(
                                          0 => 'placed',
                                          1 => 'verified',
                                          2 => 'completed',
                                          3 => 'canceled',
                                   );
                                   $order_content = get_orders_content(ORDER_NOT_LOGIN, $order_id);
                                   $edit_enable = isset($_POST['submitEdit']) ? true : false;
                                   include('includes/header.html');
                                   include('includes/sidebar.html');
                            } else {
                                   redirect('order.php');
                            }
                     } else {
                            redirect('order.php');
                     }
              } else {
                     redirect('order.php');
              }
       } else {
              redirect('order.php');
       }

       ?>

       <div id="content" class="float-right">
              <div class="section">
                     <div class="section-head">
                            <h3 class="section-title">Order detail</h3>
                            <?php
                            if (isset($message)) echo "<div class='alert alert-success' role='alert'>
                            $message
                          </div>";

                            if (isset($error)) echo "<div class='alert alert-success' role='alert'>
                            $error
                          </div>";
                            ?>
                     </div>
                     <div class="section-detail">
                            <form action="" method="POST">
                                   <input type="hidden" name="orderId" value="<?php echo $order_info['order_id'] ?>">
                                   <div class="row">
                                          <div class="col-md-6">
                                                 <p>Order Id:</p>
                                          </div>
                                          <div class="col-md-6">
                                                 <p><?php echo substr($order_info['order_id'], -1) ?></p>
                                          </div>
                                   </div>
                                   <div class="row">
                                          <div class="col-md-6">
                                                 <p>Total Amount:</p>
                                          </div>
                                          <div class="col-md-6">
                                                 <p><?php echo currency_format($order_info['total']) ?></p>
                                          </div>
                                   </div>
                                   <div class="row">
                                          <div class="col-md-6">
                                                 <p>Discount:</p>
                                          </div>
                                          <div class="col-md-6">
                                                 <p><?php echo currency_format($order_info['discount_price']) ?></p>
                                          </div>
                                   </div>
                                   <div class="row">
                                          <div class="col-md-6">
                                                 <p>Shipping:</p>
                                          </div>
                                          <div class="col-md-6">
                                                 <p><?php echo currency_format($order_info['shipping']) ?></p>
                                          </div>
                                   </div>
                                   <div class="row">
                                          <div class="col-md-6">
                                                 <p>Date Created:</p>
                                          </div>
                                          <div class="col-md-6">
                                                 <p><?php echo date_formate($order_info['order_date']) ?></p>
                                          </div>
                                   </div>
                                   <div class="row">
                                          <div class="col-md-6">
                                                 <p>Status:</p>
                                          </div>
                                          <div class="col-md-6">
                                                 <div class="form-group">
                                                        <select name="status" id="" class="form-control" <?php if (!$edit_enable) echo 'disabled' ?>>
                                                               <?php
                                                               foreach ($status_options as $key => $value) {
                                                                      $selected = '';
                                                                      if ($key == $order_info['status']) {
                                                                             $selected = 'selected';
                                                                      }
                                                               ?>
                                                                      <option value="<?php echo $key ?>" <?php echo $selected ?>><?php echo $value ?></option>
                                                               <?php } ?>
                                                        </select>
                                                 </div>
                                          </div>
                                   </div>
                                   <div class="row">
                                          <div class="col-md-6">
                                                 <p>Comments:</p>
                                          </div>
                                          <div class="col-md-6">
                                                 <div class="form-group">
                                                        <input type="text" class="form-control" name="comment" value="<?php echo $order_info['comments'] ?>" <?php if (!$edit_enable) echo 'disabled' ?>>
                                                 </div>
                                          </div>
                                   </div>
                                   <div class="row">
                                          <div class="col-md-6">
                                                 <p>Customer Name:</p>
                                          </div>
                                          <div class="col-md-6">
                                                 <p><?php echo $order_info['name'] ?></p>
                                          </div>
                                   </div>
                                   <div class="row">
                                          <div class="col-md-6">
                                                 <p>Shipping Address:</p>
                                          </div>
                                          <div class="col-md-6">
                                                 <p><?php echo $order_info['address'] ?></p>
                                          </div>
                                   </div>
                                   <div class="row">
                                          <div class="col-md-6">
                                                 <p>Customer Email:</p>
                                          </div>
                                          <div class="col-md-6">
                                                 <p><?php echo $order_info['email'] ?></p>
                                          </div>
                                   </div>
                                   <div class="row">
                                          <div class="col-md-6">
                                                 <p>Customer Phone:</p>
                                          </div>
                                          <div class="col-md-6">
                                                 <p><?php echo $order_info['phone'] ?></p>
                                          </div>
                                   </div>
                                   <div class="row">
                                          <div class="col-md-6">
                                                 <p>Credit Card Number Used:</p>
                                          </div>
                                          <div class="col-md-6">
                                                 <p><?php echo $order_info['credit_card_number'] ?></p>
                                          </div>
                                   </div>
                                   <div>
                                          <input type="submit" name="submitEdit" value="Edit" <?php if ($edit_enable) echo 'disabled' ?>>
                                          <input type="submit" name="submitUpdate" value="Update" <?php if (!$edit_enable) echo 'disabled' ?>>
                                          <input type="submit" name="submitCancel" value="Cancel" <?php if (!$edit_enable) echo 'disabled' ?>>
                                   </div>
                                   <h3>Order contains these products:</h3>
                                   <table>
                                          <thead>
                                                 <th>Product ID</th>
                                                 <th>Product Name</th>
                                                 <th>Quantity</th>
                                                 <th>Unit Cost</th>
                                                 <th>Subtotal</th>
                                          </thead>
                                          <tbody>
                                                 <?php foreach ($order_content as $item) { ?>
                                                        <tr>
                                                               <td><?php echo $item['product_id'] ?></td>
                                                               <td>
                                                                      <?php echo $item['product_name'] ?>:
                                                                      <?php
                                                                      if ($item['attributes'] != 'No') {
                                                                             echo " ({$item['attributes']})";
                                                                      }
                                                                      ?>
                                                               </td>
                                                               <td><?php echo $item['quantity'] ?></td>
                                                               <td><?php echo number_format($item['price']) ?> đ</td>
                                                               <td><?php echo number_format($item['subtotal']) ?> đ</td>
                                                        </tr>
                                                 <?php } ?>

                                          </tbody>
                                   </table>
                            </form>
                     </div>
              </div>
       </div>
</div>
<?php
