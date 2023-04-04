<?php
$message = '';
if(empty(trim($_POST['email']))){
    $message = 'Email is required!';
}elseif(strlen($_POST['email']) > 80){
    $message = 'Email must be lower or equal 80 characters!';
}elseif(!filter_var($_POST['email'], FILTER_VALIDATE_EMAIL)){
    $message = "Email isn't valid!";
}
if($message == ''){
    $status = add_email_get_news($_POST['email']);
    if($status == 1){
        $message = 'You subscribed to the newsletter successfully';
    }else{
        $message = 'You have subscribed to the newsletter!';
    }
   
}
echo $message;