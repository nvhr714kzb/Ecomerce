<?php
require('../includes/config.inc.php');
require('../lib/database.inc.php');
require('../lib/send_mail.inc.php');
require('../' . MYSQL);
require('includes/permission.php');
if(isset($_POST['list_email'])){
    $count = 0;
    $content = $_POST['content_email'];
    $subject = $_POST['subject_email'];
    foreach($_POST['list_email'] as $item){
        $count += send_email($item['email'], $item['name'], $subject, $content);
    }
    echo $count;
}