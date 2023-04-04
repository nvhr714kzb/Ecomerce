<?php
require('../includes/config.inc.php');
require('../lib/helper.inc.php');
require('../lib/database.inc.php');
require('lib/product_functions.inc.php');
require('../lib/user.inc.php');
require('../' . MYSQL);
require('includes/permission.php');
include('includes/header.html');
?>

<div id="content-wp" class="clearfix">
    <?php include('includes/sidebar.html') ?>
    <div id="content" class="float-right">
        <?php
        $item_edit  = 0;
        foreach ($_POST as $key => $value) {
            if (substr($key, 0, 6) === 'submit') {
                $last_hyphen = strrpos($key, '-');
                $action = substr($key, strlen('submit-'), $last_hyphen - strlen('submit_'));
                $product_id = (int)substr($key, $last_hyphen + 1);
                if ($action === 'edit-sale') {
                    $item_edit = $product_id;
                }
                if ($action === 'update-sale') {
                    $sale_price = (int)$_POST['salePrice'];
                    $start_date = $_POST['startDate'];
                    $end_date = $_POST['endDate'];
                    if (!empty($start_date) && (preg_match('/^(202)[0-9]\-[0-1]\d\-[0-3]\d$/', $start_date)) && $sale_price > 0 && $sale_price <= 99999999) {
                        $end_date = (!empty($end_date) && preg_match('/^(202)[0-9]\-[0-1]\d\-[0-3]\d$/', $end_date)) ? $end_date : NULL;
                        $q = "UPDATE sales SET price = ?, start_date = ?, end_date = ? WHERE product_id = ?";
                        $stmt = mysqli_prepare($dbc, $q);
                        mysqli_stmt_bind_param($stmt, 'issi', $sale_price, $start_date, $end_date, $product_id);
                        mysqli_stmt_execute($stmt);
                        if (mysqli_stmt_affected_rows($stmt) > 0) {
                            $message = 'Update successfully';
                        }
                    } else {
                        //do something
                    }
                }

                if ($action === 'delete-sale') {
                    delete_sale_product($product_id);
                    $message = 'Delete successfully';
                }
                break;
            }
        }
        $list_sale_products = get_list_product_sale(1000);
        ?>
        <div class="section list-sale">
            <div class="section-head">
                <h3 class="section-title">List sales</h3>
                <a class="section-add" href="<?php echo BASE_URL ?>admin/add_sales.php">Create sales</a>
                <?php
                if (isset($message)) {
                    echo "<div class='alert alert-success' role='alert'>
                        $message
                      </div>";
                }
                ?>
            </div>
            <div class="section-detail">
                <form action="" method="POST" enctype="multipart/form-data" class="form-inline">
                    <table cellpadding="12">
                        <thead>
                            <tr>
                                <th width='20%'>Name</th>
                                <th width='5%'>image</th>
                                <th width='10%'>Price</th>
                                <th width='10%'>Sale price</th>
                                <th width='10%'>Start date</th>
                                <th width='10%'>End date</th>
                                <th width='15%'>Out of date</th>
                                <th width='20%'>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php
                            if (!empty($list_sale_products) > 0) {
                                foreach ($list_sale_products as $item) {
                                    if ($item['end_date'] == NULL || $item['now'] < $item['end_date']) {
                                        $is_out_date = 'No';
                                    } else {
                                        $is_out_date = 'Yes';
                                    }
                            ?>
                                    <tr>
                                        <td><?php echo $item['name'] ?></td>
                                        <td><img src="../public/images/phone/<?php echo $item['thumb'] ?>" alt=""></td>
                                        <td><?php echo currency_format($item['price']) ?></td>
                                        <?php
                                            if ($item_edit == $item['product_id']) {
                                        ?>
                                            <td><input type="number" name="salePrice" maxlength="9" value="<?php echo $item['sale_price'] ?>" class="form-control"></td>
                                            <td><input type="date" name="startDate" value="<?php echo date_formate($item['start_date']) ?>" class="form-control"></td>
                                            <td><input type="date" name="endDate" value="<?php echo $item['end_date'] ?>" class="form-control"></td>
                                            <td><?php echo $is_out_date ?></td>
                                            <td>
                                                <input type="submit" name="submit-update-sale-<?php echo $item['product_id'] ?>" value="Update">
                                                <input type="submit" name="cancel" value="Cancel">
                                            </td>
                                        <?php
                                        } else {
                                        ?>
                                            <td><?php echo currency_format($item['sale_price']) ?></td>
                                            <td><?php echo date_formate($item['start_date']) ?></td>
                                            <td>
                                                <?php
                                                if (!empty($item['end_date'])) {
                                                    echo date_formate($item['end_date']);
                                                }
                                                ?>

                                            </td>
                                            <td><?php echo $is_out_date ?></td>
                                            <td>
                                                <input type="submit" name="submit-edit-sale-<?php echo $item['product_id'] ?>" value="Edit">
                                                <input type="submit" name="submit-delete-sale-<?php echo $item['product_id'] ?>" value="Delete" onclick="return confirm('Are you sure you delete it?!')">
                                            </td>
                                        <?php } ?>
                                    </tr>
                                <?php }
                            } else {
                                ?>
                                <tr>
                                    <td colspan="8">
                                        There is no product!
                                    </td>
                                </tr>
                            <?php } ?>
                        </tbody>
                    </table>
                </form>
            </div>
        </div>
    </div>
</div>
