<?php
if (isset($_COOKIE['SESSION']) && (strlen($_COOKIE['SESSION']) === 32)) {
    $cart_id = $_COOKIE['SESSION'];
} else {
    $cart_id = openssl_random_pseudo_bytes(16);
    $cart_id = bin2hex($cart_id);
}
setcookie('SESSION', $cart_id, time() + (60 * 60 * 24 * 30), '/');

foreach ($_POST as $key => $value) {
    if (substr($key, 0, 4) == 'attr') {
        $selected_attributes[] = substr($key, strlen('attr'));
        $selected_attribute_values[] = $_POST[$key];
    }
}
if (isset($selected_attributes) && count($selected_attributes) > 0) {
    $attributes = implode('/', $selected_attributes) . ':  ' . implode('/', $selected_attribute_values);
} else {
    $attributes = 'No';
}
$num_cart = filter_var($_POST['num-cart'], FILTER_VALIDATE_INT, ['min_range' => 1]) ? $_POST['num-cart'] : 1;
if (is_login()) {
    shopping_cart_add_product(CART_LOGIN, CART, $cart_id, $_SESSION['user_id'], (int)$_POST['id'], $attributes,  $num_cart);
    $message = 'You added '.$num_cart.' products into cart';
} else {    
    shopping_cart_add_product(CART_NOT_LOGIN, CART, $cart_id, 0, (int)$_POST['id'], $attributes,  $num_cart);
    $message = 'You added '.$num_cart.' products into cart';
}
$data = array(
    'message' => $message,
    'num_cart' => shopping_cart_get_count()
);
echo json_encode($data);
