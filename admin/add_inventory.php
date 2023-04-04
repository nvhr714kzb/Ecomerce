<?php
require('../includes/config.inc.php');
require('../lib/database.inc.php');
require('lib/inventory_functions.inc.php');
require('../lib/product_functions.inc.php');
require('../lib/user.inc.php');
require('../' . MYSQL);
include('includes/header.html');
require('includes/permission.php');
?>
<div id="content-wp" class="clearfix">
       <?php
       include('includes/sidebar.html');
       if (isset($_POST['submitAddStock'])) {
              if (isset($_POST['add']) && is_array($_POST['add'])) {
                     $q = "UPDATE phones SET stock = stock + ? WHERE id = ?  ";
                     $stmt1 = mysqli_prepare($dbc, $q);
                     mysqli_stmt_bind_param($stmt1, 'ii', $qty, $id);
                     $affected = 0;
                     foreach ($_POST['add'] as $id => $qty) {
                            if (filter_var($qty, FILTER_VALIDATE_INT, array('min_range' => 1))) {
                                   $id = filter_var($id, FILTER_VALIDATE_INT, array('min_range' => 1)) ? $id : NULL;
                                   mysqli_stmt_execute($stmt1);
                                   $affected += mysqli_stmt_affected_rows($stmt1);
                            }
                     }
                     // echo "<h4>{$affected} tems(s) Were Updated!</h4>";
              }
       }
       if (isset($_GET['submitOutOfStock'])) {
              $list_inventory = get_list_inventory_from_to(0, 0);
       }
       if (isset($_GET['submitBetweenNum'])) {
              if (trim($_GET['fromNum']) == '') {
                     $message = 'You must enter a start number. ';
              } else {
                     if (filter_var($_GET['fromNum'], FILTER_VALIDATE_INT) === 0 || filter_var($_GET['fromNum'], FILTER_VALIDATE_INT)) {
                            $fromNum = $_GET['fromNum'];
                     } else {
                            $message = 'The start number is invalid. ';
                     }
              }
              if (empty($_GET['toNum'])) {
                     $message .= 'You must enter a end number. ';
              } else {
                     if (!filter_var($_GET['toNum'], FILTER_VALIDATE_INT, array('min_range' => 1))) {
                            $message .= 'The end number is invalid. ';
                     } else {
                            $toNum = $_GET['toNum'];
                     }
              }
              if (empty($message)) {
                     $list_inventory = get_list_inventory_from_to($_GET['fromNum'], $_GET['toNum']);
              }
       }
       if (isset($list_inventory) && is_array($list_inventory) && empty($list_inventory)) {
              $message = 'No items found matching your searching criteria!';
       }
       ?>
       <div id="content" class="float-right">
              <div class="section add-inventory">
                     <div class="section-head">
                            <h3 class="section-title">Add Inventory</h3>
                            <?php
                            if (isset($affected)) {
                                   echo "<div class='alert alert-success' role='alert'>$affected items(s) Were Updated!</div>";
                            }
                            ?>
                            <?php
                            if (isset($message)) {
                                   echo "<div class='alert alert-warning' role='alert'>
                                          $message
                                        </div>";
                            }
                            ?>
                     </div>
                     <div class="section-detail">
                            <form action="" method="GET" class="form-inline">

                                   <div class="criteria">
                                          <span>Show all records out of stock</span>
                                          <input type="submit" name="submitOutOfStock" value="Go!">
                                   </div>
                                   <div class="criteria">
                                          <span>Show all records stock between</span>
                                          <input type="number" name="fromNum" value="<?php if (isset($fromNum)) echo $fromNum ?>" class="form-control" min="0">
                                          <span>and </span>
                                          <input type="number" name="toNum" value="<?php if (isset($toNum)) echo $toNum ?>" class="form-control" min="1">
                                          <input type="submit" name="submitBetweenNum" value="Go!">
                                   </div>

                            </form>
                            <?php
                            if (isset($list_inventory) && is_array($list_inventory)) {
                            ?>
                                   <form action="" method="POST" accept-charset="utf8">
                                          <fieldset>
                                                 <table>
                                                        <legend>Indicate how many additional quantity of each product should be added to the inventory.</legend>
                                                        <thead>
                                                               <th>Product</th>
                                                               <th>Normal Price</th>
                                                               <th>Quantity in Stock</th>
                                                               <th>Add</th>
                                                        </thead>
                                                        <tbody>
                                                               <?php
                                                               if (!empty($list_inventory)) {
                                                                      foreach ($list_inventory as $item) {
                                                               ?>
                                                                             <tr>
                                                                                    <td><?php echo $item['name'] ?></td>
                                                                                    <td><?php echo currency_format($item['price']) ?></td>
                                                                                    <td><?php echo $item['stock'] ?></td>
                                                                                    <td>
                                                                                           <div class="form-group">
                                                                                                  <input type='number' name='add[<?php echo $item['id'] ?>]' class="form-control" min='1'>
                                                                                           </div>
                                                                                    </td>
                                                                             </tr>
                                                               <?php
                                                                      }
                                                               } else {
                                                                      echo '<tr><td colspan=4>There is no record</td></tr>';
                                                               }
                                                               ?>
                                                        </tbody>
                                                 </table>
                                                 <?php
                                                 if (!empty($list_inventory)) {
                                                 ?>
                                                        <div class="field"><input type="submit" name="submitAddStock" value="Add The Inventory" class="button" /></div>
                                                 <?php
                                                 }
                                                 ?>
                                          </fieldset>
                                   </form>
                            <?php
                            }
                            ?>
                     </div>
              </div>
       </div>
</div>