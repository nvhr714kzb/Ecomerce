<?php
require('../includes/config.inc.php');
require('../lib/database.inc.php');
require('../lib/helper.inc.php');
require('lib/chat_functions.inc.php');
require('../'. MYSQL);
require('includes/permission.php');
echo fetch_user_chat_history($_SESSION['user_id'], $_POST['to_user_id']);