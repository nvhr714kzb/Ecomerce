<?php
require('../includes/config.inc.php');
require('../lib/database.inc.php');
require('../lib/form_functions.inc.php');
require('lib/voucher_functions.inc.php');
require('../lib/user.inc.php');
require('../lib/helper.inc.php');
require('../lib/product_functions.inc.php');
require('../' . MYSQL);
require('includes/permission.php');
include('includes/header.html');

?>
<div id="content-wp" class="clearfix">
    <?php
    include('includes/sidebar.html');
    $item_edit = '';
    foreach ($_POST as $key => $value) {
        if (substr($key, 0, 6) == 'submit') {
            $last_hyphen = strrpos($key, '-');
            $action = substr($key, strlen('submit-'), $last_hyphen - strlen('submit-'));
            $code = substr($key, $last_hyphen + 1);
            if ($action === 'delete') {
                delete_discount_code($code);
                $message = 'This code has been delete';
            } elseif ($action === 'disable') {
                change_status_discount_code($code, 0);
                $message = 'This code has been disable';
            } elseif ($action === 'enable') {
                change_status_discount_code($code, 1);
                $message = 'This code has been enable';
            }
        }
    }
    $q = "SELECT voucher_code, active, min_basket_cost, discount_operation, discount_amount, num_vouchers, expiry FROM discount_codes";
    // --------------------Pagging----------------------
    $page = isset($_GET['page']) && is_numeric($_GET['page'])  && $_GET['page'] > 0 ? $_GET['page'] : 1;
    $start_item = ($page - 1) * NUM_ITEMS_ADMIN;
    $num_page = ceil(count(db_fetch_array($q)) / NUM_ITEMS_ADMIN);
    // -----------------------End pagging------------------
    $q .=    " LIMIT $start_item, " . NUM_ITEMS_ADMIN . "";

    $list_discount_code = db_fetch_array($q);


    ?>
    <div id="content" class="float-right">
        <div class="section">
            <div class="section-head">
                <h3 class="section-title">List Discount Code</h3>
                <a href="add_discount_code.php" class="section-add">Add discount code</a>
                <?php
                if (isset($message)) {
                    echo "<div class='alert alert-success' role='alert'>
                        $message
                      </div>";
                }
                ?>
            </div>
            <div class="section-detail">
                <form action="" method="post">
                    <div id="action-wp" class="clearfix">
                        <div id="pagging" class="float-right">
                            <?php
                            if ($page > 5) {
                                $p = $page - 5;
                                $back_5 = "href='" . BASE_URL . "admin/list_discount_code.php?page=$p'";
                            } else {
                                $back_5 = '';
                            }
                            if ($page > 1) {
                                $p = $page - 1;
                                $back_1 = "href='" . BASE_URL . "admin/list_discount_code.php?page=$p'";
                            } else {
                                $back_1 = '';
                            }
                            if ($page < $num_page) {
                                $p = $page + 1;
                                $next_1 = "href='" . BASE_URL . "admin/list_discount_code.php?page=$p'";
                            } else {
                                $next_1 = '';
                            }
                            if ($page < $num_page - 4) {
                                $p = $page + 5;
                                $next_5 = "href='" . BASE_URL . "admin/list_discount_code.php?page=$p'";
                            } else {
                                $next_5 = '';
                            } ?>
                            <a <?php echo $back_5 ?>><i class="fas fa-chevron-double-left"></i></a>
                            <a <?php echo $back_1 ?>><i class="far fa-chevron-left"></i></a>
                            <span><?php echo $page ?> / <?php echo $num_page ?></span>
                            <a <?php echo $next_1 ?>><i class="far fa-chevron-right"></i></a>
                            <a <?php echo $next_5 ?>><i class="fas fa-chevron-double-right"></i></a>
                        </div>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th width="15%">Code</th>
                                <th width="5%">Active</th>
                                <th width="15%">Min cost</th>
                                <th width="10%">Type</th>
                                <th width="15%">Amount</th>
                                <th width="10%">Quantity</th>
                                <th width="10%">Expiry</th>
                                <th width="25%">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php
                            if (!empty($list_discount_code)) {
                                foreach ($list_discount_code as $item) {
                            ?>
                                    <tr>
                                        <td><?php echo $item['voucher_code'] ?></td>
                                        <td>
                                            <?php 
                                                if($item['active'] == 1){
                                                    echo 'Yes';
                                                }else{
                                                    echo 'No';
                                                }
                                            ?>
                                        </td>
                                        <td><?php echo currency_format($item['min_basket_cost']) ?></td>
                                        <td>
                                            <?php
                                            if ($item['discount_operation'] == '-') {
                                                echo 'Fixed';
                                            } elseif ($item['discount_operation'] == '%') {
                                                echo 'Percentage';
                                            }
                                            ?>
                                        </td>
                                        <td>
                                            <?php
                                            if ($item['discount_operation'] == '-') {
                                                echo currency_format($item['discount_amount']);
                                            } elseif ($item['discount_operation'] == '%') {
                                                echo $item['discount_amount'] . '%';
                                            }

                                            ?>
                                        </td>
                                        <td><?php echo $item['num_vouchers'] ?></td>
                                        <td>
                                            <?php
                                            if (!empty($item['expiry'])) {
                                                echo date_formate($item['expiry']);
                                            } else {
                                                echo '-';
                                            }
                                            ?>
                                        </td>

                                        <td>
                                            <?php
                                            if (strtotime($item['expiry']) < time()) {
                                            ?>
                                                <input type="submit" name="submit-delete-<?php echo $item['voucher_code'] ?>" value="Delete">
                                            <?php
                                            }
                                            ?>

                                            <?php
                                            if ($item['active'] == 1) {
                                            ?>
                                                <input type="submit" name="submit-disable-<?php echo $item['voucher_code'] ?>" value="Disable">
                                            <?php
                                            } else {
                                            ?>
                                                <input type="submit" name="submit-enable-<?php echo $item['voucher_code'] ?>" value="Enable">
                                            <?php
                                            }
                                            ?>
                                        </td>
                                    </tr>
                                <?php
                                }
                            } else {
                                ?>
                                <tr>
                                    <td colspan="8">There is no record!</td>
                                </tr>
                            <?php
                            }
                            ?>

                        </tbody>
                    </table>
                </form>
            </div>
        </div>
    </div>
</div>