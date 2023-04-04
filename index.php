<?php
// ini_set('session.use_strict_mode', 1);
require("lib/template.inc.php");
require("lib/user.inc.php");
require("lib/database.inc.php");
require("lib/form_functions.inc.php");
require("lib/product_functions.inc.php");
require("lib/order_functions.inc.php");
require("lib/discount_code_functions.inc.php");
require("lib/post_functions.inc.php");
require("lib/helper.inc.php");
require("lib/send_mail.inc.php");
require("lib/message_functions.inc.php");
require("includes/config.inc.php");
include ("includes/email/confirm_order.php");
require('lib/chat_functions.inc.php');//for chat
require(MYSQL);
?>
<?php
check_request();
$mod = !empty($_GET['mod']) ? $_GET['mod'] : 'home';
$act = !empty($_GET['act']) ? $_GET['act'] : 'main';
$path = "modules/{$mod}/{$act}.php";
if (file_exists($path)) {
    require $path;
} else {
    require 'includes/404.html';
}
mysqli_close($dbc);
?>