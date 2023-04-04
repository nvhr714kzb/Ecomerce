<?php
if (isset($_POST['chat_message'])) {
       add_chat_message(1, $_SESSION['user_id'], $_POST['chat_message'], 1);
       echo  fetch_user_chat_history();
       
}
