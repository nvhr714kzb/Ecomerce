<?php
if(!is_login()){
       redirect('?mod=home&act=main'); 
}
get_header();
$shipping_errors = array();
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
       // Check for a first name:
       if (preg_match('/^[A-Z \'.-]{2,20}$/i', $_POST['first_name'])) {
              $fn = addslashes($_POST['first_name']);
       } else {
              $shipping_errors['first_name'] = 'Please enter your first name!';
       }

       // Check for a last name:
       if (preg_match('/^[A-Z \'.-]{2,40}$/i', $_POST['last_name'])) {
              $ln  = addslashes($_POST['last_name']);
       } else {
              $shipping_errors['last_name'] = 'Please enter your last name!';
       }
       if (preg_match('/^[A-Za-z \'.-]{2,60}$/i', $_POST['country'])) {
              $ct = addslashes($_POST['country']);
       } else {
              $shipping_errors['country'] = 'Please enter a valid your country!';
       }

       if (preg_match('/^[A-Za-z \'.-]{2,80}$/i', $_POST['address1'])) {
              $address1 = addslashes($_POST['address1']);
       } else {
              $shipping_errors['address1'] = 'Please enter a valid your address!';
       }

       if (empty($_POST['address2'])) {
              $address2 = NULL;
       } else {
              if (preg_match('/^[A-Za-z \'.-]{2,80}$/i', $_POST['address2'])) {
                     $address2 = addslashes($_POST['address2']);
              } else {
                     $shipping_errors['address2'] = 'Please enter a valid your address!';
              }
       }

       if (preg_match('/^[A-Za-z \'.-]{2,60}$/i', $_POST['city'])) {
              $city = addslashes($_POST['city']);
       } else {
              $shipping_errors['city'] = 'Please enter a valid your city!';
       }

       if (preg_match('/^[A-Z]{2}$/i', $_POST['state'])) {
              $state = $_POST['state'];
       } else {
              $shipping_errors['state'] = 'Please enter a valid your state!';
       }

       if (preg_match('/^(\d{5})$|(\d{5}-\d{4})$/i', $_POST['zip'])) {
              $zip = $_POST['zip'];
       } else {
              $shipping_errors['zip'] = 'Please enter a valid your zip!';
       }

       $p = str_replace(array(' ', '-', '(', ')'), '', $_POST['phone']);
       if (preg_match('/^[0-9]{10}$/i', $p)) {
              $phone = $p;
       } else {
              $shipping_errors['phone'] = 'Please enter a valid your phone!';
       }

       if (filter_var($_POST['email'], FILTER_VALIDATE_EMAIL)) {
              $email = $_POST['email'];
       } else {
              $shipping_errors['email'] = 'Please enter a valid your email!';
       }
       if (empty($shipping_errors)) {
              add_address($_SESSION['user_id'], $fn, $ln, $ct, $address1, $address2, $city, $state, $zip, $phone, $email);
              redirect('?mod=checkout&act=checkout');
       }
}
include("view/checkout/add_address.php");
get_footer();
