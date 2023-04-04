<?php
require('../includes/config.inc.php');
require('../lib/database.inc.php');
require('lib/chat_functions.inc.php');
require('../'. MYSQL);
require('includes/permission.php');
if(isset($_POST['is_type'])){
    update_is_type_status($_SESSION['user_id'], $_POST['is_type']);
    echo $_POST['is_type'];
}