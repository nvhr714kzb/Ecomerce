<?php
require('../includes/config.inc.php');
require('../lib/database.inc.php');
require('../lib/helper.inc.php');
require('lib/post_functions.inc.php');
require('lib/account_functions.inc.php');
require('../lib/user.inc.php');
require('../' . MYSQL);
require('includes/permission.php');
include('includes/header.html');
?>
<div id="content-wp" class="clearfix">
    <?php
    include('includes/sidebar.html');
    ?>
    <div id="content" class="float-right">
        <h3>List users for chat</h3>
        <!-- ---------------List user for chat------------------- -->
        <div id="list_user_for_chat">
        </div>
        <!-- ------------------Chat box------------------ -->
        <div id="chat-box">
            
        </div>
    </div>
</div>
