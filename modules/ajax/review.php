<?php
$review_errors = array();
if (empty($_POST['star'])) {
       $review_errors[] = 'Please select a star!';
} elseif (!filter_var($_POST['star'], FILTER_VALIDATE_INT, array('min_rage' => 1))) {
       $review_errors[] = 'Please select a valid star!';
}
$review = addslashes(strip_tags($_POST['reviewContent']));
if (empty($review)) {
       $review_errors[] = 'Please enter your review content!';
} elseif (strlen($review) > 1000) {
       $review_errors[] = 'Preview content must be less than or equal to 1000 characters!';
}
if (empty($review_errors)) {
       add_review($_SESSION['user_id'], $_POST['product_id'], $review, $_POST['star']);
       $data = array(
              'is_success' => true,
       );
}else{
       $data = array(
              'is_success' => false,
              'list_errors' =>  $review_errors
       );
}
echo json_encode($data);
