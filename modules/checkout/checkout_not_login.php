<?php
get_header();
if (isset($_COOKIE['SESSION']) && (strlen($_COOKIE['SESSION']) === 32)) {
       $cart_id = $_COOKIE['SESSION'];
} else {
       redirect('?mod=cart&act=cart');
}
$list_cart_items = shopping_cart_get_products(CART_NOT_LOGIN, CART, $cart_id, 0);
if (empty($list_cart_items)) {
       redirect('?mod=cart&act=cart');
}
$shipping_errors = array();
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
       if (empty($_POST['first_name'])) {
              $shipping_errors['first_name'] = 'Please enter your first name!';
       } else {
              if (preg_match('/^[A-Z \'.-]{2,20}$/i', $_POST['first_name'])) {
                     $fn = addslashes($_POST['first_name']);
              } else {
                     $shipping_errors['first_name'] = 'Please enter a valid your first name!';
              }
       }

       if (empty($_POST['last_name'])) {
              $shipping_errors['last_name'] = 'Please enter your last name!';
       } else {
              if (preg_match('/^[A-Z \'.-]{2,40}$/i', $_POST['last_name'])) {
                     $ln  = addslashes($_POST['last_name']);
              } else {
                     $shipping_errors['last_name'] = 'Please enter a valid  your last name!';
              }
       }

       if (empty($_POST['address1'])) {
              $shipping_errors['address1'] = 'Please enter  your address!';
       } else {
              if (preg_match('/^[A-Za-z \'.-]{2,80}$/i', $_POST['address1'])) {
                     $a1 = addslashes($_POST['address1']);
              } else {
                     $shipping_errors['address1'] = 'Please enter a valid your address!';
              }
       }


       if (empty($_POST['address2'])) {
              $a2 = NULL;
       } else {
              if (preg_match('/^[A-Za-z \'.-]{2,80}$/i', $_POST['address2'])) {
                     $address2 = addslashes($_POST['address2']);
              } else {
                     $shipping_errors['address2'] = 'Please enter a valid your address!';
              }
       }

       if (empty($_POST['city'])) {
              $shipping_errors['city'] = 'Please enter your city!';
       } else {
              if (preg_match('/^[A-Za-z \'.-]{2,60}$/i', $_POST['city'])) {
                     $c = addslashes($_POST['city']);
              } else {
                     $shipping_errors['city'] = 'Please enter a valid your city!';
              }
       }

       if (preg_match('/^[A-Z]{2}$/i', $_POST['state'])) {
              $s = $_POST['state'];
       } else {
              $shipping_errors['state'] = 'Please enter a valid your state!';
       }

       if (empty($_POST['zip'])) {
              $shipping_errors['zip'] = 'Please enter your zip!';
       } else {
              if (preg_match('/^(\d{5})$|(\d{5}-\d{4})$/i', $_POST['zip'])) {
                     $z = $_POST['zip'];
              } else {
                     $shipping_errors['zip'] = 'Please enter a valid your zip!';
              }
       }

       if (empty($_POST['phone'])) {
              $shipping_errors['phone'] = 'Please enter your phone!';
       } else {
              $p = str_replace(array(' ', '-', '(', ')'), '', $_POST['phone']);
              if (preg_match('/^[0-9]{10}$/i', $p)) {
                     $p = $p;
              } else {
                     $shipping_errors['phone'] = 'Please enter a valid your phone!';
              }
       }

       if (empty($_POST)) {
              $shipping_errors['email'] = 'Please enter your email!';
       } else {
              if (filter_var($_POST['email'], FILTER_VALIDATE_EMAIL)) {
                     $e = $_POST['email'];
                     $_SESSION['email'] = $e;
              } else {
                     $shipping_errors['email'] = 'Please enter a valid your email!';
              }
       }
       if (isset($_POST['use']) && ($_POST['use'] === 'Y')) {
              $_SESSION['shipping_for_billing'] = true;
              $_SESSION['cc_first_name']  = $_POST['first_name'];
              $_SESSION['cc_last_name']  = $_POST['last_name'];
              $_SESSION['cc_address']  = $_POST['address1'] . ' ' . $_POST['address2'];
              $_SESSION['cc_city'] = $_POST['city'];
              $_SESSION['cc_state'] = $_POST['state'];
              $_SESSION['cc_zip'] = $_POST['zip'];
       } else {
              unset($_SESSION['shipping_for_billing']);
              unset($_SESSION['cc_first_name']);
              unset($_SESSION['cc_last_name']);
              unset($_SESSION['cc_address']);
              unset($_SESSION['cc_city']);
              unset($_SESSION['cc_state']);
              unset($_SESSION['cc_zip']);
       }
       if (empty($shipping_errors)) {
              $q = "CALL add_customer('$e', '$fn', '$ln', '$a1', '$a2', '$c', '$s', $z, $p, @cid)";
              $r = mysqli_query($dbc, "$q");
              if ($r) {
                     $r = mysqli_query($dbc, 'SELECT @cid');
                     if (mysqli_num_rows($r) == 1) {
                            list($_SESSION['customer_id']) = mysqli_fetch_array($r);
                            $_SESSION['name'] = $_POST['first_name'] . ' ' . $_POST['last_name'];
                            redirect('?mod=checkout&act=billing_not_login');
                            exit();
                     }
              }
              trigger_error('Your order could not be processed due to a system error. We apologize for the inconvenience.');
       }
}
include("view/checkout/checkout_not_login.php");
get_footer();
