<?php
require('../includes/config.inc.php');
require('../lib/database.inc.php');
require('../lib/form_functions.inc.php');
require('lib/voucher_functions.inc.php');
require('../lib/user.inc.php');
require('../' . MYSQL);
require('includes/permission.php');
include('includes/header.html');
?>
<div id="content-wp" class="clearfix">
    <?php
    include('includes/sidebar.html');
    $error_discount = array();
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        if (trim(strlen($_POST['qty'])) == 0) {
            $error_discount['qty'] = 'Please enter code quantity';
        } else {
            if (!filter_var($_POST['qty'], FILTER_VALIDATE_INT, array('min_range' => 1))) {
                $error_discount['qty'] = 'Please enter a valid code quantity';
            }
        }
        if (empty($_POST['mark'])) {
            if (trim(strlen($_POST['length'])) == 0) {
                $error_discount['length'] = 'Please enter code length';
            } else {
                if (!filter_var($_POST['length'], FILTER_VALIDATE_INT, array('min_range' => 1))) {
                    $error_discount['length'] = 'Please enter a valid code length';
                }
            }
        }

        if (empty($_POST['letter']) && empty($_POST['number']) && empty($_POST['symbol']) && empty($_POST['mark'])) {
            $error_discount['formate'] = 'Please select a formate or mark';
        }

        if (empty($_POST['type'])) {
            $error_discount['type'] = 'Please select discount type';
        }
        if (empty($_POST['expiry']) && empty($_POST['expiryNever'])) {
            $error_discount['expiry'] = 'Please select expiration Date';
        }
        if (trim(strlen($_POST['qtyPer'])) == 0) {
            $error_discount['qtyPer'] = 'Please enter quantity per code';
        } else {
            if (!filter_var($_POST['qtyPer'], FILTER_VALIDATE_INT, array('min_range' => 1))) {
                $error_discount['qtyPer'] = 'Please enter a valid quantity per code';
            }
        }
        if (empty($_POST['amount'])) {
            $error_discount['amount'] = 'Please enter amount';
        } else {
            if (!filter_var($_POST['amount'], FILTER_VALIDATE_INT, array('min_range' => 1))) {
                $error_discount['amount'] = 'Please enter a valid amount';
            }
        }
        if (trim(strlen($_POST['minCost'])) == 0) {
            $error_discount['minCost'] = 'Please enter min cost';
        } else {
            if (!filter_var($_POST['minCost'], FILTER_VALIDATE_INT, array('min_range' => 1))) {
                $error_discount['minCost'] = 'Please enter a valid cost';
            }
        }
        if (empty($error_discount)) {
            $options = array(
                'length' => $_POST['length'],
                'prefix' => $_POST['prefix'],
                'suffix' => $_POST['suffix'],
                // 'letters' => isset($_POST['letter']) && $_POST['letter'] == 'upper' ? true : false,
                'numbers' => isset($_POST['number']) ? true : false,
                'symbols' => isset($_POST['symbol']) ? true : false,
                'mixed_case' => isset($_POST['letter']) && $_POST['letter'] == 'mix' ? true : false,
                'mask' => empty($_POST['mark']) ? '' : $_POST['mark'],
                // 'mask' => $_POST['mark'],
            );

            $list_code = generate_coupon($_POST['qty'], $options);

            $active = isset($_POST['active']) ? 1 : 0;
            $min_cost = $_POST['minCost'];
            $operation = $_POST['type'];
            $amount = $_POST['amount'];
            $qty = $_POST['qty'];
            $qty_per = $_POST['qtyPer'];
            $expiry =  isset($_POST['expiryNever']) ? NULL : $_POST['expiry'];
            $count = 0;
            foreach ($list_code  as $code) {
                $count++;
                // echo "code ={$code} - active = {$active} - minCost = {$min_cost} - operate = {$operation} - amount = {$amount} - qty = {$qty} - exp = {$expiry}";
                // add_discount_code($code, $active, $min_cost, $operation, $amount, $qty, $expiry);
                $q = 'INSERT INTO discount_codes (voucher_code, active, min_basket_cost, discount_operation, discount_amount, num_vouchers, expiry)
                VALUES(?, ?, ?, ?, ?, ?, ?)';
                $stmt = mysqli_prepare($dbc, $q);
                mysqli_stmt_bind_param($stmt, 'siisiis', $code, $active, $min_cost, $operation, $amount, $qty_per, $expiry);
                mysqli_stmt_execute($stmt);
                if (mysqli_stmt_affected_rows($stmt) > 0) {
                    $_POST = array();
                }
            }
            $message = "Added $count  discount code successfully";
        }
    }
    ?>
    <div id="content" class="float-right">

        <div class="section add-discount-code">
            <div class="section-head">
                <h3 class="section-title">Add discount code</h3>
                <a class="section-list" href="<?php echo BASE_URL ?>admin/list_discount_code.php">List discount codes</a>
                <?php
                    if(isset( $message)){
                        echo "<div class='alert alert-success' role='alert'>
                        $message
                      </div>";
                    }
                ?>
            </div>
            <div class="section-detail">
                <form action="" method="POST">
                <div class="row form-group">
                        <label for="qty" class="col-md-2">Quantity</label>
                        <div class="col-md-10">
                            <input type="text" name="qty" id="qty" class="form-control" value="<?php if (isset($_POST['qty']))  echo $_POST['qty']; ?>">
                            <?php form_error('qty', $error_discount) ?>
                        </div>
                    </div>
                    <div class="row form-group">
                        <label for="length" class="col-md-2">Code Length</label>
                        <div class="col-md-10">
                            <input type="number" name="length" id="length" class="form-control" value="<?php if (isset($_POST['length']))  echo $_POST['length']; ?>" max="25">
                            <?php form_error('length', $error_discount) ?>
                        </div>
                    </div>


                    <div class="row form-group">
                        <label for="prefix" class="col-md-2">Prefix</label>
                        <div class="col-md-10">
                            <input type="text" name="prefix" id="prefix" class="form-control not-use-mark" value="<?php if (isset($_POST['prefix']))  echo $_POST['prefix']; ?>">
                        </div>
                    </div>
                    <div class="row form-group">
                        <label for="suffix" class="col-md-2">Suffix</label>
                        <div class="col-md-10">
                            <input type="text" name="suffix" id="suffix" class="form-control not-use-mark" value="<?php if (isset($_POST['suffix']))  echo $_POST['suffix']; ?>">
                        </div>
                    </div>
                    <div class="row form-group">
                        <label for="formate" class="col-md-2">Code Formate</label>
                        <div class="col-md-10">
                            <label>
                                Letters
                                <select name="letter" class="formate form-control not-use-mark" id="formate">
                                    <option value="">---Select---</option>
                                    <option value="upper" <?php if (isset($_POST['letter']) && $_POST['letter'] == 'upper') echo 'selected' ?>>Uppercase</option>
                                    <option value="mix" <?php if (isset($_POST['letter']) && $_POST['letter'] == 'mix') echo 'selected' ?>>Mixed case</option>
                                </select>
                            </label>
                            <label><input type="checkbox" name="number" class="formate not-use-mark" <?php if (isset($_POST['number']))  echo 'checked'; ?>> Numbers</label>
                            <label><input type="checkbox" name="symbol" class="formate not-use-mark" <?php if (isset($_POST['symbol']))  echo 'checked'; ?>> Symbols</label>
                        </div>
                    </div>
                    <div class="row form-group">
                        <label for="" class="col-md-2">Use code mark</label>
                        <input type="checkbox" name="userMark" id="use-mark">
                    </div>
                    <div class="row form-group">
                        <label for="mark" class="col-md-2">Code Mark</label>
                        <div class="col-md-10">
                            <input type="text" name="mark" id="mark"  class="form-control" disabled placeholder="XXXABC123XXX" value="<?php if (isset($_POST['mark']))  echo $_POST['mark']; ?>" maxlength="25">
                            <span class="hint">If you using Code Mark then all fields above will be ignored. 'X' will be a random capital letter</span>
                            <?php form_error('formate', $error_discount) ?>
                        </div>
                      
                    </div>
                    <div class="row form-group">
                        <label for="qty-per" class="col-md-2">Quantity per voucher</label>
                        <div class="col-md-10">
                            <input type="number" name="qtyPer" id="qty-per" class="form-control" value="<?php if (isset($_POST['qtyPer']))  echo $_POST['qtyPer']; ?>">
                            <?php form_error('qtyPer', $error_discount) ?>
                        </div>
                    </div>

                    <div class="row form-group">
                        <label for="expiry" class="col-md-2">Expiration Date</label>
                        <div class="col-md-10">
                            <input type="date" name="expiry" id="expiry" class="form-control" value=" <?php if (isset($_POST['expiry']))  echo $_POST['expiry']; ?>">
                            <input type="checkbox" name="expiryNever" id="expiryNever" <?php if (isset($_POST['expiryNever']))  echo 'checked'; ?>>
                            <label for="expiryNever">Never expires</label>
                            <?php form_error('expiry', $error_discount) ?>
                        </div>

                    </div>
                    <div class="row form-group">
                        <label for="type" class="col-md-2">Discount Type</label>
                        <div class="col-md-10">
                            <select name="type" id="type" class="form-control">
                                <option value="">---Select---</option>
                                <option value="%" <?php if (isset($_POST['type']) && $_POST['type'] == '%') echo 'selected' ?>>Percentage</option>
                                <option value="-" <?php if (isset($_POST['type']) && $_POST['type'] == '-') echo 'selected' ?>>Fix amount</option>
                            </select>
                            <?php form_error('type', $error_discount) ?>
                            <input type="number" name="amount" class="form-control" value="<?php if (isset($_POST['amount']))  echo $_POST['amount']; ?>">
                            <?php form_error('amount', $error_discount) ?>
                        </div>
                    </div>
                    <div class="row form-group">
                        <label for="minCost" class="col-md-2">Min Cost</label>
                        <div class="col-md-10">
                            <div class="form-inline">
                                <input type="number" name="minCost" id="minCost" class="form-control" value="<?php if (isset($_POST['minCost']))  echo $_POST['minCost']; ?>">
                                <?php form_error('minCost', $error_discount) ?>
                            </div>
                        </div>
                    </div>
                    <div class="row form-group">
                        <div class="col-md-2">
                            <label for="active">Active</label>
                        </div>

                        <div class="col-md-10">
                            <input type="checkbox" name="active" id="active">
                        </div>
                    </div>
                    <input type="submit" name="createDiscount" value="Add Discount Codes">
                </form>
            </div>
        </div>
    </div>
</div>