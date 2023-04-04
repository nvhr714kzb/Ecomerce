<?php

if(isset($_POST['chat_message_id'])){
    remove_message((int)$_POST['chat_message_id']);
}