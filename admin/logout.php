<?php
require('../includes/config.inc.php');
require('includes/permission.php');
if(!headers_sent()){
       // redirect_invalid_user();
       destroy_session_and_data();
       // $page_title = "Logout";
       if (!headers_sent()) {
              header("Location: ".BASE_URL."");
              exit();
       } else {
              trigger_error('A system error occurred. We apologize for the inconvenience');
       }
       // get_header();
       // echo '<h3>Logged Out</h3><p>Thank you for visiting. You are now
       // logged out. Please come back soon!</p>';
       // get_footer();
}else{   
       // include_once('./includes/header.html');
       // trigger_error("You do not have permission to access this page. Please log in and try again.");
       // include_once('./includes/footer.html');
       trigger_error('A system error occurred. We apologize for the inconvenience');
}




