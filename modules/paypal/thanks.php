<?php
$page_title = "Thanks";
get_header();
redirect_invalid_user('reg_user_id');
$q = "UPDATE users SET u_date_expires = ADDDATE(u_date_expires, INTERVAL 1  YEAR) WHERE u_id = {$_SESSION['reg_user_id']}";
$r = mysqli_query($dbc, $q);
unset($_SESSION['reg_user_id']);
?>
       <p>Thank you for your payment! You may now access all of the site's
       content for the next year! <strong>Note: Your access to the site will
       automatically be renewed via PayPal each year. To disable this feature,
       or to cancel your account, see the "My preapproved purchases"
       section of your PayPal Profile page.</strong></p>
<?php
get_sidebar();
get_footer();
?>