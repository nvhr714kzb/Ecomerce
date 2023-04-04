<?php
if(isset($_SESSION['user_id'])){
    $q = "CALL count_unseen_message(1, ".$_SESSION['user_id'].")";
    list($count) = db_fetch_row($q);
    echo $count;
}