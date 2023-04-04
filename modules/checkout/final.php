<?php
if (!is_login()) {
    redirect('?mod=cart&act=cart');
}elseif(!isset($_SESSION['response_code']) || $_SESSION['response_code'] != 1){
    redirect('?mod=checkout&act=billing');
}
if (isset($_COOKIE['SESSION']) && (strlen($_COOKIE['SESSION']) === 32)) {
    $cart_id = $_COOKIE['SESSION'];
    $list_cart_items = shopping_cart_get_products(CART_LOGIN, CART, $cart_id, $_SESSION['user_id']);
    if (empty($list_cart_items)) {
           redirect('?mod=cart&act=cart');
    }
} else {
    redirect('?mod=cart&act=cart');
}
$page_title = 'Your Billing Information';
// ================Send email=====================
$email = $_SESSION['email'];
$customer_name = $_SESSION['name'];
$content = confirm_order_email_content($customer_name, $list_cart_items);
send_email($email, $customer_name, 'Confirm your order', $content);
// ====================End send email=================
$r = mysqli_query($dbc, "CALL shopping_cart_clear('$cart_id')");
get_header();
include('view/checkout/final.php');


unset($_SESSION['response_code']);

unset($_SESSION['shipping']);
unset($_SESSION['email']);
unset($_SESSION['order_id']);
unset($_SESSION['order_total']);
unset($_SESSION['discount_price']);
unset($_SESSION['discount_code']);

unset($_SESSION['shipping_for_billing']);
unset($_SESSION['cc_first_name']);
unset($_SESSION['cc_last_name']);
unset($_SESSION['cc_address']);
unset($_SESSION['cc_city']);
unset($_SESSION['cc_state']);
unset($_SESSION['cc_zip']);
// destroy_session_and_data();
get_footer();