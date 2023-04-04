<?php
require('../includes/config.inc.php');
require('../lib/database.inc.php');
require('../' . MYSQL);
require('includes/permission.php');
$q = "UPDATE login_details SET last_activity = NOW() WHERE login_detail_id = {$_SESSION['login_details_id']}";
db_query($q);