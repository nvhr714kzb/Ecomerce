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
       if ($_SERVER['REQUEST_METHOD'] === 'POST') {
              if (isset($_POST['sale_price'], $_POST['start_date'], $_POST['end_date'])) {
                     // Prepare the query to be run:
                     $q = 'INSERT INTO sales (product_id, price, start_date, end_date) VALUES (?, ?, ?, ?)';
                     $stmt = mysqli_prepare($dbc, $q);
                     mysqli_stmt_bind_param($stmt, 'iiss', $id, $price, $start_date, $end_date);

                     $affected = 0;

                     foreach ($_POST['sale_price'] as $id => $price) {
                            if (filter_var($price, FILTER_VALIDATE_FLOAT) && $price > 0 && filter_var($id, FILTER_VALIDATE_INT) && $id >= 0 && !empty($_POST['start_date'][$id]) && (preg_match('/^(202)[0-9]\-[0-1]\d\-[0-3]\d$/', $_POST['start_date'][$id]))) {
                                   $start_date = $_POST['start_date'][$id];
                                   $end_date = (!empty($_POST['end_date'][$id]) && preg_match('/^(202)[0-9]\-[0-1]\d\-[0-3]\d$/', $_POST['end_date'][$id])) ? $_POST['end_date'][$id] : NULL;
                                   mysqli_stmt_execute($stmt);
                                   $affected += mysqli_stmt_affected_rows($stmt);
                            }
                     }
                     // echo "<h4>$affected Sales Were Created!</h4>";
              }
       }
       ?>
       <div id="content" class="float-right">
              <div class="section">
                     <div class="section-head">
                            <h3 class="section-title">Create sales</h3>
                            <a class="section-list" href="<?php echo BASE_URL ?>admin/list_sale.php">List sales</a>
                            <?php
                            if (isset($affected)) {
                                   echo "<div class='alert alert-success' role='alert'>$affected Sales Were Created!</div>";
                            }
                            ?>
                     </div>
                     <div class="section-detail">
                            <form action="" method="POST" accept-charset="utf8" class="form-inline">
                                   <fieldset>
                                          <legend>To mark an item as being on sale, indicate the sale price, the date the sale starts, and the date the sale ends. All dates must be in the format YYYY-MM-DD. You may leave the end date blank, thereby creating an open-ended sale. Only the currently stocked products are listed below!</legend>
                                          <table>
                                                 <thead>
                                                        <th>Item</th>
                                                        <th>Price</th>
                                                        <th>Quantity</th>
                                                        <th>Sale Price</th>
                                                        <th>Start Date</th>
                                                        <th>End Date</th>
                                                 </thead>

                                                 <tbody>
                                                        <?php
                                                        $list_product_not_sale = get_list_product_not_sale();
                                                        if (!empty($list_product_not_sale)) {
                                                               foreach ($list_product_not_sale as $item) {
                                                        ?>
                                                                      <tr>
                                                                             <td><?php echo $item['name'] ?></td>
                                                                             <td><?php echo currency_format($item['price']) ?></td>
                                                                             <td><?php echo $item['stock'] ?></td>
                                                                             <td><input type="number" name='sale_price[<?php echo $item['id'] ?>]' class="form-control"></td>
                                                                             <td><input type="date" name='start_date[<?php echo $item['id'] ?>]' class='form-control'></td>
                                                                             <td><input type="date" name='end_date[<?php echo $item['id'] ?>]' class='form-control'></td>
                                                                      </tr>
                                                               <?php
                                                               }
                                                        } else {
                                                               ?>
                                                               <tr>
                                                                      <td colspan="6">There is no product</td>
                                                               </tr>
                                                        <?php
                                                        }
                                                        ?>
                                                 </tbody>
                                          </table>
                                          <div class="field"><input type="submit" value="Add These Sales" class="button" /></div>
                                   </fieldset>
                            </form>
                     </div>
              </div>
       </div>
</div>