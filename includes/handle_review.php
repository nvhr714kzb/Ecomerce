<?php
 $review_errors = array();
if($_SERVER['REQUEST_METHOD'] === 'POST'){
       if (preg_match ('/^[A-Z \'.-]{2,60}$/i', $_POST['name'])) {
              $name = $_POST['name'];
       }else{
              $review_errors['name'] = 'Please enter your name!';
       }
       if(filter_var($_POST['email'], FILTER_VALIDATE_EMAIL)){
              $email = $_POST['email'];
       }else{
              $review_errors['email'] = 'Please enter a valid email address!';
       }
       $review = strip_tags($_POST['review']);
       if(empty($review)){
              $review_errors['review'] = 'Please enter your review!';
       }
       if(empty($review_errors)){
              $r = mysqli_query($dbc, "CALL add_review('$type', $id, '$name', '$email', '$review')");
              if(mysqli_affected_rows($dbc) > 0){
                     $message = 'Thank you for your review!';
                     $_POST = array();
              }
       }
}