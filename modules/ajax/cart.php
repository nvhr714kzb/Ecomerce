<?php
if (isset($_COOKIE['SESSION']) && (strlen($_COOKIE['SESSION']) === 32)) {
    $cart_id = $_COOKIE['SESSION'];
} else {
    $cart_id = openssl_random_pseudo_bytes(16);
    $cart_id = bin2hex($cart_id);
}
setcookie('SESSION', $cart_id, time() + (60 * 60 * 24 * 30), '/');

if (
    isset($_POST['item_id'], $_POST['qty'])
    && filter_var($_POST['item_id'], FILTER_VALIDATE_INT, array('min_range' => 1))
    && filter_var($_POST['qty'], FILTER_VALIDATE_INT, array('min_range' => 1))
) {
    if (check_item_id_belong_to_cart_id($_POST['item_id'], $cart_id)) {
        shopping_cart_update_product($_POST['item_id'], $_POST['qty']);
        $sub_total = shopping_cart_get_subtotal($_POST['item_id']);
        $total = shopping_cart_get_total_amount($cart_id);
        $shipping_price = get_shipping($total);
        $_SESSION['shipping'] = $shipping_price;

        $message_discount_code = '';
        $_SESSION['discount_price'] = 0;
        if (isset($_SESSION['discount_code'])) {
            $discount_code = get_discount_code($_SESSION['discount_code']);
            if ($discount_code['active'] == 1) {
                if ($discount_code['expired'] == 1) {
                    $_SESSION['discount_price'] = 0;
                    $message_discount_code = 'Sorry, this voucher has expired';
                } else {
                    if ($discount_code['num_vouchers'] != 0) {
                        if ($discount_code['min_basket_cost'] <= $total) { //ADDDDDDDDDDDDDDDDDDDDDDD   NUMBERRRRRRRRRRRRRRR
                            if ($discount_code['discount_operation'] == '%') {
                                // $message_discount_code = "A {$discount_code['discount_amount']} % discount has been applied to your order";
                                $_SESSION['discount_price'] = round(($total * $discount_code['discount_amount']) / 100);
                                // $_SESSION['discount_code'] = $_POST['discountCode'];
                            } elseif ($discount_code['discount_operation'] == '-') {
                                // $message_discount_code = "A discount of $ {$discount_code['discount_amount']} discount has been applied to your order";
                                $_SESSION['discount_price'] = $discount_code['discount_amount'];
                                // $_SESSION['discount_code'] = $_POST['discountCode'];
                            } elseif ($discount_code['discount_operation'] == 's') {
                                // $message_discount_code = "Your order shipping cost has been reduced to $ {$discount_code['discount_amount']}";
                            }
                        } else {
                            $_SESSION['discount_price'] = 0;
                            $message_discount_code = 'Sorry, your order total is not enough for your order to qualify for this discount code';
                        }
                    } else {
                        $_SESSION['discount_price'] = 0;
                        $message_discount_code = 'Sorry, this was a limited edition voucher code, there are no more instances of that code left';
                    }
                }
            } else {
                $_SESSION['discount_price'] = 0;
                $message_discount_code = 'Sorry, the voucher code you entered is no longer active';
            }

            // ==============================
            $total_after = $total - $_SESSION['discount_price'] + $shipping_price;
        } else {
            $total_after = $total + $shipping_price;
        }
        $data = array(
            'is_success' => true,
            'message' => $message_discount_code,
            'sub_total' => currency_format($sub_total),
            'shipping' => currency_format($shipping_price),
            'discount' => currency_format($_SESSION['discount_price']),
            'total' => currency_format($total),
            'total_after' => currency_format($total_after)
        );
        echo json_encode($data);
        exit();
    }
}
$data = array(
    'is_success' => false,
);
echo json_encode($data);
