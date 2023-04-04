<?php
require('../includes/config.inc.php');
require('../lib/database.inc.php');
require('lib/chat_functions.inc.php');
require('../' . MYSQL);
require('includes/permission.php');
if (isset($_POST['to_user_id'])) {
       // -----------------------Add message--------------------------
       add_message($_SESSION['user_id'], $_POST['to_user_id'], $_POST['chat_message']);
       // ------------------------Fetch message----------------------------
       echo fetch_user_chat_history($_SESSION['user_id'], $_POST['to_user_id']);
}
