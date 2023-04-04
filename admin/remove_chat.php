<?php
require('../includes/config.inc.php');
require('../lib/database.inc.php');
require('lib/chat_functions.inc.php');
require('../' . MYSQL);
require('includes/permission.php');
if(isset($_POST['chat_message_id'])){
    remove_message((int)$_POST['chat_message_id']);
}