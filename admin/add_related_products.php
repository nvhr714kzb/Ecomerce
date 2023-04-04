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
        if (empty($_POST['productId'])) {
            $error = 'Please select products by searching';
        } else {
            $length = count($_POST['productId']);
            if ($length > 1) {
                $count = 0;
                for ($i = 0; $i < $length; $i++) {
                    for ($j = 0; $j < $length; $j++) {
                        if ((int)$_POST['productId'][$j] !=  (int)$_POST['productId'][$i]) {
                            $q1 = "SELECT * FROM related_phone WHERE (product_a = " . (int)$_POST['productId'][$i] . " AND product_b =" . (int)$_POST['productId'][$j] . ") OR (product_a = " . (int)$_POST['productId'][$j] . " AND product_b = " . (int)$_POST['productId'][$i] . ")";
                            $num_row = db_num_rows($q1);
                            if ($num_row == 0) {
                                $q2 = "INSERT INTO related_phone (product_a, product_b) VALUES(" . (int)$_POST['productId'][$i] . ", " . (int)$_POST['productId'][$j] . ")";
                                db_query($q2);
                                $count++;
                            }
                        }
                    }
                }
                if ($count == 0) {
                    $error = 'Related products has added. Please try another product!';
                } else {
                    $message = 'Added related products';
                }
            } else {
                $error = 'Please select at least 2 products';
            }
        }
    }
    ?>

    <div id="content" class="float-right">
        <div class="section">
            <div class="section-head">
                <h3 class="section-title">Add related products</h3>
                <a class="section-add" href="<?php echo BASE_URL ?>admin/list_related_products.php">List related products</a>
                <?php
                if (isset($error)) {
                    echo "<div class='alert alert-danger' role='alert'>
                        $error
                      </div>";
                }

                if (isset($message)) {
                    echo "<div class='alert alert-success' role='alert'>
                        $message
                      </div>";
                }
                ?>
            </div>
            <div class="section-detail">
                <form action="" method='POST' id="form-search-related-product">
                    <div id="search-wp">
                        <div class="form-group">
                            <label for="search-product" class="control-label">Choose products</label>
                            <input type="text" name="searchProduct" id="search-product" class="form-control" placeholder="Search product" autocomplete="off">
                            <div id="hint-search"></div>
                        </div>

                    </div>
                    <ul id="list-related-product">
                    </ul>
                    <div class="form-group">
                        <input type="submit" name="subAddRelated" value="Add related products">
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>