<?php
require('../includes/config.inc.php');
require('../lib/database.inc.php');
require('../lib/form_functions.inc.php');
require('../lib/user.inc.php');
require('../' . MYSQL);
require('includes/permission.php');
include('includes/header.html');
?>
<div id="content-wp" class="clearfix">
    <?php include('includes/sidebar.html') ?>
    <div id="content" class="float-right">
        <?php
        if (isset($_GET['productId'])) {
        ?>
            <div class="section notify-stock">
                <div class="section-head">
                    <h3 class="section-title">Send notify out of stock</h3>
                </div>
                <div class="section-detail">
                    <?php
                    // $list_notify_stock = get_list_notify_stock();
                    $q = "SELECT id, name, email, product_id FROM product_stock_notification WHERE product_id = " . (int)$_GET['productId'] . " AND processed = 0";
                    $list_notify_stock = db_fetch_array($q);
                    $q2 = "SELECT name, thumb FROM phones WHERE id = " . (int)$_GET['productId'] . "";
                    $product_info = db_fetch_row($q2);

                    $error = array();
                    create_form_input('subjectEmail', 'text', $label = 'Email subject', $error);
                    ?>
                    <div class="form-group">
                        <label for="">Email content</label>
                        <textarea name="contentEmail" id="contentEmail" cols="30" rows="10" class="form-control"></textarea>
                    </div>
                    <?php
                    // create_form_input('contentEmail', 'textarea', $label = 'Email content', $error);

                    $product_id = $_GET['productId'];
                    ?>
                    <div>
                        <h4><?php echo $product_info['name'] ?></h4>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th width="10%">
                                    <input type="checkbox" name="checkAll" id="checkAll">
                                </th>
                                <th width="30%">Name</th>
                                <th width="30%">Email</th>
                                <th width="30%">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php
                            $count = 0;

                            foreach ($list_notify_stock as $item) {
                                $count++;
                            ?>
                                <tr>
                                    <td><input type="checkbox" name="checkItem[]" class="single-select checkItem" data-name="<?php echo $item['name'] ?>" data-email="<?php echo $item['email'] ?>"></td>
                                    <td><?php echo $item['name'] ?></td>
                                    <td><?php echo $item['email'] ?></td>
                                    <td><button type="button" class="email-button" id="<?php echo $count ?>" data-action="single" data-name="<?php echo $item['name'] ?>" data-email="<?php echo $item['email'] ?>">Send single</button></td>
                                </tr>
                            <?php
                            }
                            ?>
                            <tr>
                                <td colspan="3"></td>
                                <td><button type="button" class="email-button" id="bulk-email" data-action="bulk" data-name="<?php echo $item['name'] ?>" data-email="<?php echo $item['email'] ?>">Send bulk</button></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        <?php
        } else {
            $q = "SELECT DISTINCT n.product_id,  p.name, p.thumb, p.stock FROM product_stock_notification n INNER JOIN phones p ON n.product_id = p.id WHERE  n.processed = 0";
            $list_product_notify = db_fetch_array($q);
        ?>
            <div class="section">
                <div class="section-head">
                    <h3 class="section-title">Send email</h3>
                </div>
                <div class="section-detail">
                    <table>
                        <thead>
                            <tr>
                                <th width="30%">Name</th>
                                <th width="10%">Image</th>
                                <th width="30%">Stock</th>
                                <th width="30%">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php
                            foreach ($list_product_notify as $item) {
                            ?>
                                <tr>
                                    <td><?php echo $item['name'] ?></td>
                                    <td><img src="../public/images/phone/<?php echo $item['thumb'] ?>" alt=""></td>
                                    <td><?php echo $item['stock'] ?></td>
                                    <td><a href="notify_stock.php?productId=<?php echo $item['product_id'] ?>">Send email for this product</a></td>
                                </tr>
                            <?php
                            }
                            ?>
                        </tbody>
                    </table>
                </div>
            </div>
        <?php
        }
        ?>
    </div>
</div>
<?php
