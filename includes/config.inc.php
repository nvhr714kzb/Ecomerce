<?php
$config['email'] = Array(
       'protocol' => 'smtp',
       'smtp_host' => 'smtp.gmail.com',
       'smtp_port' => 587,
       'smtp_user' => 'binh0799500203@gmail.com',
       'smtp_fullname' => 'Nguyen Van Binh',
       // 'smtp_pass' => 'Naetmcxt',
       'smtp_pass' => 'isjekdzdhykymcdx',
       'smtp_secure' => 'tls',
       'smtp_timeout' => '7',
       'mailtype' => 'html',
       'charset' => 'UTF-8'
);
define('BASE_URL', 'https://www.dictionary4it.com/project/');
define('HTTP_SERVER_PORT', '8080');
define('VIRTUAL_LOCATION', '/project/');
define('LIVE', true);
define('CONTACT_EMAIL', 'binh0799500203@gmail.com');
define('BASE_URI', '../../my_project/');
// define('MYSQL', BASE_URI . 'mysql.inc.php');
define('MYSQL', 'includes/mysql.inc.php');
define('PRODUCTS_PER_PAGE', 100);
define('CODE_PER_PAGE', 20);
define('POSTS_PER_PAGE_FOR_PRODUCT', 10);
define('NUM_ITEMS_ADMIN', 10);
define('FT_MIN_WORD_LEN', 4);
define('NUM_ITEMS_SLIDER', 28);

define('CART_LOGIN', 1);
define('CART_NOT_LOGIN', 0);
define('ORDER_LOGIN', 1);
define('ORDER_NOT_LOGIN', 0);
define('CART', 1);
define('WISHLIST', 0);


session_start();
ob_start();
date_default_timezone_set('Asia/Ho_Chi_Minh');
function destroy_session_and_data(){
       $_SESSION = array();
       setcookie(session_name(), '', time() - 2592000, '/');
       session_destroy();
       // setcookie(session_name(), '', time() - 300);
}
function my_error_handler ($e_number, $e_message, $e_file, $e_line) {
	// Build the error message:
	$message = "An error occurred in script '$e_file' on line $e_line:\n$e_message\n";
	// Add the backtrace:
	// $message .= "<pre>" .print_r(debug_backtrace(), 1) . "</pre>\n";
	// Or just append $e_vars to the message:
	//	$message .= "<pre>" . print_r ($e_vars, 1) . "</pre>\n";
	if (!LIVE) { // Show the error in the browser.
		echo '<div class="error">' . nl2br($message) . '</div>';
	} else { // Development (print the error).
		// Send the error in an email:
		// error_log ($message, 1, CONTACT_EMAIL, 'From:admin@example.com');
		// Only print an error message in the browser, if the error isn't a notice:
		if ($e_number != E_NOTICE) {
			// echo '<div class="error">A system error occurred. We apologize for the inconvenience.</div>';
		}
	} // End of $live IF-ELSE.
	return true; // So that PHP doesn't try to handle the error, too.
} // End of my_error_handler() definition.
// Use my error handler:
set_error_handler ('my_error_handler');

function redirect_invalid_user($check ='user_id', $destination = "?mod=home&act=main", $protocol = 'http://'){
       if(!headers_sent()){
              if(!isset($_SESSION[$check]) || ($_SESSION['check'] != hash('ripemd128', $_SERVER['REMOTE_ADDR'] . $_SERVER['HTTP_USER_AGENT']))){
                     if(($_SESSION['check'] != hash('ripemd128', $_SERVER['REMOTE_ADDR'] . $_SERVER['HTTP_USER_AGENT']))){
                            destroy_session_and_data();
                            trigger_error("A system error occurred. Please login again!");
                     }
                     // $url = $protocol.BASE_URL.$destination;
                     $url = BASE_URL.$destination;
                     header("Location: $url");
                     exit();
              }
       }else{
              trigger_error("You do not have permission to access this page. Please log in and try again.");
       }
      
}
function is_valid_user_type($user_level = 0, $required = 50){
       if($user_level >= $required)
              return true;
       return false;
}
function redirect($url = ''){
       if(!headers_sent()){
                     header("Location: ".BASE_URL."{$url}");
                     exit();
       }else{
              trigger_error('A system error occurred. We apologize for the inconvenience');
       }
}
function sample(){
       if(!headers_sent()){
              //Redirect-code
       }else{
              //note once
              include_once('./includes/header.html');
              trigger_error("You do not have permission to access this page. Please log
              in and try again.");
              include_once('./includes/footer.html');
       }
}