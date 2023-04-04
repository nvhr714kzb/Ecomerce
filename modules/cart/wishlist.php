<?php
if (isset($_COOKIE['SESSION']) && (strlen($_COOKIE['SESSION']) === 32)) {
       $cart_id = $_COOKIE['SESSION'];
} else {
       $cart_id = openssl_random_pseudo_bytes(16);
       $cart_id = bin2hex($uid);
}
setcookie('SESSION', $cart_id, time() + (60 * 60 * 24 * 30), '/');

if (isset($_GET['id'], $_GET['action']) && $_GET['action'] === 'add') {
       // foreach ($_POST as $key => $value) {
       //        if (substr($key, 0, 4) == 'attr') {
       //               $selected_attributes[] = substr($key, strlen('attr'));
       //               $selected_attribute_values[] = $_POST[$key];
       //        }
       // }
       // if (count($selected_attributes) > 0) {
       //        $attributes = implode('/', $selected_attributes) . ':  ' . implode('/', $selected_attribute_values);
       // } else {
       //        $attributes = 'No';
       // }
       // add_to_cart_not_login($cart_id, $_GET['id'], $attributes, 1);
       // redirect("?mod=product&act=detail_product&id={$_GET['id']}");
} elseif (isset($_GET['itemId'], $_GET['action']) && $_GET['action'] === 'remove') {
       $item_id = filter_var($_GET['itemId'], FILTER_VALIDATE_INT, array('min_range' => 1)) ? $_GET['itemId'] : 0;
       if (check_item_id_belong_to_cart_id($item_id, $cart_id)) {
              shopping_cart_remove_product($item_id);
       }
} elseif (isset($_GET['itemId'], $_GET['action']) && $_GET['action'] === 'moveCart') {
       $item_id = filter_var($_GET['itemId'], FILTER_VALIDATE_INT, array('min_range' => 1)) ? $_GET['itemId'] : 0;
       if (check_item_id_belong_to_cart_id($item_id, $cart_id)) {
              shopping_cart_move_product_to_cart($item_id);
       }
} 
$page_title = 'Your wish list';
get_header();
if(is_login()){
       $list_save_items = shopping_cart_get_products(CART_LOGIN, WISHLIST, $cart_id, $_SESSION['user_id']);
}else{
       $list_save_items = shopping_cart_get_products(CART_NOT_LOGIN, WISHLIST, $cart_id, 0);
}
if (!empty($list_save_items)) {
       include('view/cart/wishlist.php');
} else {
       include('view/cart/empty_wishlist.php');
}
get_footer();
