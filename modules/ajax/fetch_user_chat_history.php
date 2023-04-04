<?php
$_POST['to_user_id'] = 1;
echo fetch_user_chat_history($_SESSION['user_id'], $_POST['to_user_id']);