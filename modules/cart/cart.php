<?php
if (isset($_COOKIE['SESSION']) && (strlen($_COOKIE['SESSION']) === 32)) {
       $cart_id = $_COOKIE['SESSION'];
} else {
       $cart_id = openssl_random_pseudo_bytes(16);
       $cart_id = bin2hex($cart_id);
}
setcookie('SESSION', $cart_id, time() + (60 * 60 * 24 * 30), '/');

// if(isset($_GET['sku'])){
//        list($type, $id) = parse_sku($_GET['sku']);
// }
if (isset($_GET['id'], $_GET['action']) && $_GET['action'] === 'add') {
       foreach ($_POST as $key => $value) {
              if (substr($key, 0, 4) == 'attr') {
                     $selected_attributes[] = substr($key, strlen('attr'));
                     $selected_attribute_values[] = $_POST[$key];
              }
       }
       if (isset( $selected_attributes) && count($selected_attributes) > 0) {
              $attributes = implode('/', $selected_attributes) . ':  ' . implode('/', $selected_attribute_values);
       } else {
              $attributes = 'No';
       }
       // if (isset($_POST['addCart'])) {
       if (isset($_POST['addCart'])) {
              $num_cart = filter_var($_POST['num-cart'], FILTER_VALIDATE_INT, ['min_range' => 1]) ? $_POST['num-cart'] : 1;
              if (is_login()) {
                     shopping_cart_add_product(CART_LOGIN, CART, $cart_id, $_SESSION['user_id'], $_GET['id'], $attributes,  $num_cart);
              } else {
                     shopping_cart_add_product(CART_NOT_LOGIN, CART, $cart_id, 0, $_GET['id'], $attributes,  $num_cart);
              }
       } elseif (isset($_POST['addWishlist'])) {
              $num_cart = filter_var($_POST['num-cart'], FILTER_VALIDATE_INT, ['min_range' => 1]) ? $_POST['num-cart'] : 1;
              if (is_login()) {
                     shopping_cart_add_product(CART_LOGIN, WISHLIST, $cart_id, $_SESSION['user_id'], $_GET['id'], $attributes,  $num_cart);
              } else {
                     shopping_cart_add_product(CART_NOT_LOGIN, WISHLIST, $cart_id, 0, $_GET['id'], $attributes,  $num_cart);
              }
       }
       redirect("?mod=product&act=detail_product&id={$_GET['id']}");
} elseif (isset($_GET['itemId'], $_GET['action']) && $_GET['action'] === 'remove') {
       $item_id = filter_var($_GET['itemId'], FILTER_VALIDATE_INT, array('min_range' => 1)) ? $_GET['itemId'] : 0;
       if (check_item_id_belong_to_cart_id($item_id, $cart_id)) {
              shopping_cart_remove_product($item_id);
       }
} elseif (isset($_GET['itemId'], $_GET['action']) && $_GET['action'] === 'moveSave') {
       $item_id = filter_var($_GET['itemId'], FILTER_VALIDATE_INT, array('min_range' => 1)) ? $_GET['itemId'] : 0;
       if (check_item_id_belong_to_cart_id($item_id, $cart_id)) {
              shopping_cart_save_product_for_later($item_id);
       }
} elseif (isset($_POST['updateQty'])) {
       foreach ($_POST['quantity'] as $item_id => $qty) {
              if (check_item_id_belong_to_cart_id($item_id, $cart_id)) {
                     $qty = filter_var($qty, FILTER_VALIDATE_INT, array('min_range' => 1)) ? $qty : 1;
                     shopping_cart_update_product($item_id, $qty);
              }
       }
} elseif (isset($_POST['subDiscount'])) {
       if (empty($_POST['discountCode'])) {
              $error_discount_code = 'Please enter the voucher code';
       } else {
              $discount_code = get_discount_code($_POST['discountCode']);
              // show_array($discount_code);
              if (empty($discount_code)) {
                     $error_discount_code = 'Sorry, the voucher code you entered is invalid';
              } else {
                     if ($discount_code['active'] == 1) {
                            if ($discount_code['expired'] == 1) {
                                   $error_discount_code = 'Sorry, this voucher has expired';
                            } else {
                                   if ($discount_code['num_vouchers'] != 0) {
                                          if ($discount_code['min_basket_cost'] <=  shopping_cart_get_total_amount($cart_id)) { //ADDDDDDDDDDDDDDDDDDDDDDD   NUMBERRRRRRRRRRRRRRR
                                                 if ($discount_code['discount_operation'] == '%') {
                                                        $message_discount_code = "A {$discount_code['discount_amount']}% discount has been applied to your order";
                                                        $discount_price = round(((int)shopping_cart_get_total_amount($cart_id) * $discount_code['discount_amount']) / 100);
                                                        $_SESSION['discount_price'] = $discount_price;
                                                        $_SESSION['discount_code'] = $_POST['discountCode'];
                                                 } elseif ($discount_code['discount_operation'] == '-') {
                                                        $message_discount_code = "A discount of ".currency_format($discount_code['discount_amount'])." discount has been applied to your order";
                                                        $discount_price = $discount_code['discount_amount'];
                                                        $_SESSION['discount_price'] = $discount_price;
                                                        $_SESSION['discount_code'] = $_POST['discountCode'];
                                                 } elseif ($discount_code['discount_operation'] == 's') {
                                                        $message_discount_code = "Your order shipping cost has been reduced to $ {$discount_code['discount_amount']}";
                                                 }
                                          } else {
                                                 $error_discount_code = 'Sorry, your order total is not enough for your order to qualify for this discount code';
                                          }
                                   } else {
                                          $error_discount_code = 'Sorry, this was a limited edition voucher code, there are no more instances of that code left';
                                   }
                            }
                     } else {
                            $error_discount_code = 'Sorry, the voucher code you entered is no longer active';
                     }
              }
       }
}elseif(isset($_POST['deleteDiscount'])){
       unset($_SESSION['discount_code']);
       unset($_SESSION['discount_price']);

}
$page_title = 'Your shopping cart';
get_header();
if (is_login()) {
       $list_cart_items = shopping_cart_get_products(CART_LOGIN, CART, $cart_id, $_SESSION['user_id']);
} else {
       $list_cart_items = shopping_cart_get_products(CART_NOT_LOGIN, CART, $cart_id, 0);
}
if (!empty($list_cart_items)) {
       include('view/cart/cart.php');
} else {
       include('view/cart/empty_cart.php');
}
get_footer();
