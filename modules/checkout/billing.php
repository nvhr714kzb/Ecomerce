<?php
$page_title = 'Your Billing Information';
get_header();
if (!is_login()) {
       redirect('?mod=cart&act=cart');
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

if (empty($_SESSION['address_id'])) {
       redirect('?mod=checkout&act=checkout');
} else {
       $address = get_address_by_id($_SESSION['user_id'], $_SESSION['address_id']);
       if (empty($address)) {
              redirect('?mod=checkout&act=checkout');
       }
}
$billing_errors = array();
// if (isset($_POST['submitPlaceOrder'])) {
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
       if (preg_match('/^[A-Z \'.-]{2,20}$/i', $_POST['cc_first_name'])) {
              $cc_first_name = $_POST['cc_first_name'];
       } else {
              $billing_errors['cc_first_name'] = 'Please enter your first name!';
       }

       if (preg_match('/^[A-Z \'.-]{2,40}$/i', $_POST['cc_last_name'])) {
              $cc_last_name  = $_POST['cc_last_name'];
       } else {
              $billing_errors['cc_last_name'] = 'Please enter your last name!';
       }

       // $cc_n = str_replace(array('', '-'), '', $_POST['cc_number']);
       // if (
       //        !preg_match('/^4[0-9]{12}(?:[0-9]{3})?$/', $cc_n) // Visa
       //        && !preg_match('/^5[1-5][0-9]{14}$/', $cc_n) // MasterCard
       //        && !preg_match('/^3[47][0-9]{13}$/', $cc_n) // American Express
       //        && !preg_match('/^6(?:011|5[0-9]{2})[0-9]{12}$/', $cc_n) // Discover
       // ) {
       //        $billing_errors['cc_number'] = 'Please enter your credit card number!';
       // }

       // if (($_POST['cc_exp_month'] < 1) || ($_POST['cc_exp_month'] > 12)) {
       //        $billing_errors['cc_exp_month'] = 'Please enter a valid your expiration month!';
       // }

       // if ($_POST['cc_exp_year'] < date('Y')) {
       //        $billing_errors['cc_exp_year'] = 'Please enter a valid your expiration year!';
       // }

       // if (preg_match('/^[0-9]{3,4}$/', $_POST['cc_cvv'])) {
       //        $cc_vvv = $_POST['cc_vvv'];
       // } else {
       //        $billing_errors['cc_vvv'] = 'Please a valid enter your CVV!';
       // }
       if (isset($_POST['token'])) {
              $token = $_POST['token'];
       } else {
              $message = 'The order cannot be processed. Please make sure you have JavaScript enabled and try again.';
              $billing_errors['token'] = true;
       }

       if (preg_match('/^[A-Za-z0-9 \',.#-]{2,160}$/i', $_POST['cc_address'])) {
              $cc_address = $_POST['cc_address'];
       } else {
              $billing_errors['cc_address'] = 'Please a valid enter your address!';
       }

       if (preg_match('/^[A-Za-z \',.#-]{2,160}$/i', $_POST['cc_city'])) {
              $cc_city = $_POST['cc_city'];
       } else {
              $billing_errors['cc_city'] = 'Please a valid enter your city!';
       }
       if (preg_match('/^[A-Z]{2}$/', $_POST['state'])) {
              $cc_state = $_POST['state'];
       } else {
              $billing_errors['cc_state'] = 'Please a valid enter your state!';
       }
       if (preg_match('/^(\d{5})|(^\d{5}-\d{4})$/', $_POST['cc_zip'])) {
              $cc_zip = $_POST['cc_zip'];
       } else {
              $billing_errors['cc_zip'] = 'Please a valid enter your zip!';
       }
       if (empty($billing_errors)) {
              if (isset($_SESSION['order_id'])) {
                     $order_id = $_SESSION['order_id'];
                     $order_total = $_SESSION['order_total'];
              } else {
                     $cc_last_four = substr($_POST['cc_number'], -4);
                     $_SESSION['email'] = $address['email'];//from session address_id
                     $shipping = $_SESSION['shipping'];//from session in checkout_cart
                     if(isset($_SESSION['discount_price'])){//from session in shopping cart
                            $discount_price = $_SESSION['discount_price'];
                            $discount_code = $_SESSION['discount_code'];
                     }else{
                            $discount_price = 0;
                            $discount_code = NULL;
                     }
                     $q = "CALL add_order({$_SESSION['user_id']}, '$cart_id', $shipping, $discount_price, '$discount_code', $cc_last_four, '{$address['first_name']}', '{$address['last_name']}', '{$address['country']}', '{$address['address1']}',  '{$address['address2']}', '{$address['city']}', '{$address['state']}', {$address['zip']}, '{$address['phone']}', '{$address['email']}', @total, @oid)";

                     $r = mysqli_query($dbc, $q);
                     if ($r) {
                            $r = mysqli_query($dbc, 'SELECT @total, @oid');
                            if (mysqli_num_rows($r) == 1) {
                                   list($order_total, $order_id) = mysqli_fetch_array($r);
                                   $_SESSION['order_id'] =  $order_id;
                                   $_SESSION['order_total'] = $order_total;
                            } else {
                                   unset($cc_number, $cc_cvv, $_POST['cc_number'], $_POST['cc_cvv']);
                                   trigger_error('Your order could not be processed due to a system error. We apologize for the inconvenience.');
                            }
                     } else {
                            unset($cc_number, $cc_cvv, $_POST['cc_number'], $_POST['cc_cvv']);
                            trigger_error('Your order could not be processed due to a system error. We apologize for the inconvenience.');
                     }
              }
              if (isset($order_id, $order_total)) {
                     try {
                            require_once 'includes/vendor/autoload.php';
                            \Stripe\Stripe::setApiKey('sk_test_51HcMVfERGNfztik59f5CdZD7s50FzQo828mAIgCdI1rXiZRmcpgghwVgjuqhvCPSnCSWbyu34t0frP2ZbS7NxbV300DTJu8Emv');
                            $charge = \Stripe\Charge::create(array(
                                   'amount' => $order_total,
                                   'currency' => 'usd',
                                   'card' => $token,
                                   'description' => $_SESSION['email'],
                                   'capture' => false
                            ));
                            if ($charge->paid == 1) {
                                   // Add slashes to two text values:
                                   $full_response = addslashes(serialize($charge));

                                   // Record the transaction:
                                   $r = mysqli_query($dbc, "CALL add_charge('{$charge->id}', $order_id, 'auth_only', $order_total, '$full_response')");

                                   // Add the transaction info to the session:
                                   $_SESSION['response_code'] = $charge->paid;

                                   // Redirect to the next page:
                                   redirect('?mod=checkout&act=final');
                                   // $location = 'https://' . BASE_URL . 'final.php';
                                   // header("Location: $location");
                                   // exit();
                            } else {
                                   $message =  $charge->response_reason_text;
                            }
                     } catch (Exception $e) {
                            trigger_error(print_r($e, 1));
                     }
              }
       }
}

$list_cart_items = shopping_cart_get_products(CART_LOGIN, CART, $cart_id, $_SESSION['user_id']);
if (!empty($list_cart_items)) {
       if (isset($_SESSION['shipping_for_billing']) && $_SERVER['REQUEST_METHOD'] !== 'POST') {
              $values = "SESSION";
       } else {
              $values = "POST";
       }
       include("view/checkout/billing.php");
} else {
       // include("view/cart/empty_cart.php");
       redirect('?mod=checkout&act=checkout');
}
get_footer();
