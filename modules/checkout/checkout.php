<?php
get_header();
if (!is_login()) {
       redirect('?mod=cart&act=cart');
}
if (isset($_COOKIE['SESSION']) && (strlen($_COOKIE['SESSION']) === 32)) {
       $cart_id = $_COOKIE['SESSION'];
} else {
       redirect('?mod=cart&act=cart');
}
$list_cart_items = shopping_cart_get_products(CART_LOGIN, CART, $cart_id, $_SESSION['user_id']);
if (empty($list_cart_items)) {
       redirect('?mod=cart&act=cart');
}
// ============Submit for use and delete====================
if($_SERVER['REQUEST_METHOD'] === 'POST'){
       foreach($_POST as $key => $value){
              if(substr($key, 0, 6) == 'submit'){
                     $last_hyphen = strrpos($key, '-');
                     $action = substr($key ,strlen('submit-'), $last_hyphen - strlen('submit-'));
                     $address_id = (int)substr($key, $last_hyphen + 1);
                     if($action == 'delete'){
                            delete_shipping_address($address_id, $_SESSION['user_id']);
                     }elseif($action == 'use'){
                            if(isset($_POST['addressId']) && is_numeric($_POST['addressId']) && $_POST['addressId'] > 0){
                                   $_SESSION['address_id'] = $_POST['addressId'];

                                   if (isset($_POST['use']) && ($_POST['use'] === 'Y')) {
                                          $_SESSION['shipping_for_billing'] = true;
                                          $_SESSION['cc_first_name']  = $_POST['first_name'][$_POST['addressId']];
                                          $_SESSION['cc_last_name']  = $_POST['last_name'][$_POST['addressId']];
                                          $_SESSION['cc_address'] = $_POST['address1'][$_POST['addressId']] . ' ' . $_POST['address2'][$_POST['addressId']];
                                          $_SESSION['cc_city'] = $_POST['city'][$_POST['addressId']];
                                          $_SESSION['cc_state'] = $_POST['state'][$_POST['addressId']];
                                          $_SESSION['cc_zip'] = $_POST['zip'][$_POST['addressId']];
                                   }else{
                                          unset($_SESSION['shipping_for_billing']);
                                          unset($_SESSION['cc_first_name']);
                                          unset($_SESSION['cc_last_name']);
                                          unset($_SESSION['cc_address']);
                                          unset($_SESSION['cc_city']);
                                          unset($_SESSION['cc_state']);
                                          unset($_SESSION['cc_zip']);
                                   }
                                   redirect('?mod=checkout&act=billing');
                            }else{
                                   $message_address = '<p>Please use a address</p>';
                            }
                     }
              }
       }
}
$list_address = get_list_address($_SESSION['user_id']);
include('view/checkout/checkout.php');
get_footer();