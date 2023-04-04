<?php
if (isset($_POST['name'])) {
    if (empty($_POST['name'])) {       
           $message = 'Please enter your name';
    } else {
           if (!is_name($_POST['name'])) {
                  $message = 'Your name is invalid';
           }
    }
    if (empty($_POST['email'])) {
           $message .= 'Please enter your email';
    } else {
           if (!is_email($_POST['email'])) {
                  $message .= 'Email is invalid';
           }
    }
    if (empty($message)) {
           add_notify_out_of_stock($_POST['product_id'], $_POST['name'], $_POST['email']);
           $message = 'Added successfully';
           $data = array(
                  'is_success' => true,
                  'message' => $message
           );
    }else{
       $data = array(
              'is_success' => false,
              'message' => $message
       );

    }
    echo json_encode($data);
}