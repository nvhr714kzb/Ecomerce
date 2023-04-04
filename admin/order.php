<?php
require('../includes/config.inc.php');
require('../lib/database.inc.php');
require('../lib/helper.inc.php');
require('lib/order_functions.inc.php');
require('../lib/user.inc.php');
require('../' . MYSQL);
require('includes/permission.php');
include('includes/header.html');
$status_options = array(
       1 => 'placed',
       2 => 'verified',
       3 => 'completed',
       4 => 'canceled',
);
$message = '';
if (isset($_GET['submitByCustomer'])) {
       if (empty($_GET['customerId'])) {
              $message = 'You must select an customer.';
       } else {
              if (filter_var($_GET['customerId'], FILTER_VALIDATE_INT, array('min_range' => 1))) {
                     if (isset($_GET['hasLogin'])) {
                            $list_orders = get_order_by_customer_id(ORDER_LOGIN, $_GET['customerId']);
                     }else{
                            $list_orders = get_order_by_customer_id(ORDER_NOT_LOGIN, $_GET['customerId']);
                     }
                     
              } else {
                     $message = 'Customer is invalid';
              }
       }
}
if (isset($_GET['submitByOrderId'])) {
       if (empty($_GET['orderId'])) {
              $message = 'You must enter an order ID.';
       } else {
              if (filter_var($_GET['orderId'], FILTER_VALIDATE_INT, array('min_range' => 1))) {
                     if (isset($_GET['hasLogin'])) {
                            $list_orders = get_order_by_id(ORDER_LOGIN , $_GET['orderId']);
                     }else{
                            $list_orders = get_order_by_id(ORDER_NOT_LOGIN , $_GET['orderId']);
                     }
              } else {
                     $message = 'Order Id is invalid';
              }
       }
}
if (isset($_GET['submitMostRecent'])) {
       if (empty($_GET['recordCount'])) {
              $message = 'You must select a number.';
       } else {
              if (filter_var($_GET['recordCount'], FILTER_VALIDATE_INT, array('min_range' => 1))) {
                     if (isset($_GET['hasLogin'])) {
                            $list_orders = get_most_recent_orders(ORDER_LOGIN, $_GET['recordCount']);
                     } else {
                            $list_orders = get_most_recent_orders(ORDER_NOT_LOGIN, $_GET['recordCount']);
                     }
              } else {
                     $message = 'Number of orders is invalid';
              }
       }
}
if (isset($_GET['submitBetweenDates'])) {
       if (empty($_GET['startDate'])) {
              $message = 'You must enter a start date. ';
       } else {
              if (strtotime($_GET['startDate']) == FALSE) {
                     $message = 'The start date is invalid. ';
              }
       }
       if (empty($_GET['endDate'])) {
              $message .= 'You must enter a end date. ';
       } else {
              if (strtotime($_GET['endDate']) == FALSE) {
                     $message .= 'The end date is invalid. ';
              }
       }
       if (empty($message) && strtotime($_GET['startDate']) > strtotime($_GET['endDate'])) {
              $message = 'The start date should be more recent than the end date.';
       }
       if (empty($message)) {
              if (isset($_GET['hasLogin'])) {
                     $list_orders = get_order_between_dates(ORDER_LOGIN, $_GET['startDate'], $_GET['endDate']);
              } else {
                     $list_orders = get_order_between_dates(ORDER_NOT_LOGIN, $_GET['startDate'], $_GET['endDate']);
              }
       }
}
if (isset($_GET['submitOrdersByStatus'])) {
       if (empty($_GET['status'])) {
              $message = 'You must select a status.';
       } else {
              if (filter_var($_GET['status'], FILTER_VALIDATE_INT, array('min_range' => 1))) {
                     if (isset($_GET['hasLogin'])) {
                            $list_orders =  get_order_by_status(ORDER_LOGIN, $_GET['status']);
                     } else {
                            $list_orders =  get_order_by_status(ORDER_NOT_LOGIN, $_GET['status']);
                     }
              } else {
                     $message = 'Status is invalid';
              }
       }
}

if (isset($list_orders) && is_array($list_orders) && empty($list_orders)) {
       $message = 'No orders found matching your searching criteria!';
}
$list_users = get_list_customer();

?>
<div id="content-wp" class="clearfix">
       <?php include('includes/sidebar.html') ?>
       <div id="content" class="float-right">
              <div class="section">
                     <div class="section-head">
                            <h3 class="section-title">Admin users' orders:</h3>
                     </div>
                     <div class="section-detail">
                            <form action="" method="GET" class="form-inline">
                                   <?php
                                   if (isset($message)) {
                                          echo "<p>$message</p>";
                                   }
                                   ?>
                                   <div>
                                          <label> <input type="checkbox" name="hasLogin" id="has-login" value="1"> Has Sign in</label>
                                   </div><br>
                                   <div>
                                          <label for="customer-id" class="control-label">Show orders by customer</label>
                                          <select name="customerId" id="customer-id" class="form-control">
                                                 <option value="">Select</option>
                                                 <?php
                                                 foreach ($list_users as $item) {
                                                        // $selected = '';
                                                        // if(isset($days) && $days == $key){
                                                        //        $selected = 'selected';
                                                        // }
                                                 ?>

                                                        <option value="<?php echo $item['id'] ?>"><?php echo $item['name'] ?></option>
                                                 <?php } ?>
                                          </select>
                                          <input type="submit" name="submitByCustomer" value="Go!">
                                   </div><br>
                                   <div>
                                          <label for="order-id" class="control-label">Get by order ID</label>
                                          <input type="number" name="orderId" class="form-control" id="order-id" min=1>
                                          <input type="submit" name="submitByOrderId" value="Go!">
                                   </div><br>
                                   <div>
                                          <label for="record-count" class="control-label">Show the most recent</label>
                                          <input type="number" name="recordCount" id="record-count" class="form-control" min=1>
                                          <label for="record-count" class="control-label">orders</label>
                                          <input type="submit" name="submitMostRecent" value="Go!">
                                   </div><br>
                                   <div>
                                          <label for="start-date" class="control-label">Show all records created between</label>
                                          <input type="date" name="startDate" id="start-date" class="form-control">
                                          <label for="end-date" class="control-label">and </label>
                                          <input type="date" name="endDate" id="end-date" class="form-control">
                                          <input type="submit" name="submitBetweenDates" value="Go!">
                                   </div><br>
                                   <div>
                                          <label for="status" class="control-label">Show orders by status</label>
                                          <select name="status" id="status" class="form-control">
                                                 <option value="">Select</option>
                                                 <?php
                                                 foreach ($status_options as $key => $val) {
                                                        // $selected = '';
                                                        // if(isset($days) && $days == $key){
                                                        //        $selected = 'selected';
                                                        // }
                                                 ?>
                                                        <option value="<?php echo $key ?>"><?php echo $val ?></option>
                                                 <?php } ?>
                                          </select>
                                          <input type="submit" name="submitOrdersByStatus" value="Go!">
                                   </div><br>
                            </form>
                            <?php if (!empty($list_orders)) { ?>
                                   <table>
                                          <thead>
                                                 <th>Order Id</th>
                                                 <th>Customer</th>
                                                 <th>Status</th>
                                                 <th>Num Items</th>
                                                 <th>Date Shipped</th>
                                                 <th>Date Created</th>
                                                 <th>Action</th>
                                          </thead>
                                          <tbody>
                                                 <?php foreach ($list_orders as $item) { ?>
                                                        <tr>
                                                               <td><?php echo $item['order_id'] ?></td>
                                                               <td><?php echo $item['name'] ?></td>
                                                               <td><?php echo $status_options[$item['status']] ?></td>
                                                               <td><?php echo $item['items'] ?></td>
                                                               <td>
                                                                      <?php
                                                                      if (!empty($item['ship_date'])) {
                                                                             echo date_formate($item['ship_date']);
                                                                      }else{
                                                                             echo '-';
                                                                      }
                                                                      ?>
                                                               </td>
                                                               <td><?php echo date_formate($item['order_date']) ?></td>
                                                               <td><a href="order_detail.php?orderId=<?php echo $item['order_id'] ?>">View Details</a></td>
                                                        </tr>
                                                 <?php } ?>

                                          </tbody>
                                   </table>
                            <?php } ?>
                     </div>
              </div>
       </div>
</div>