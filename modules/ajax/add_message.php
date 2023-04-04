<?php
if (isset($_POST['to_user_id'])) {
       // -----------------------Add message--------------------------
       $_POST['to_user_id'] = 1;//due to send to admin, 1 is admin
       add_message($_SESSION['user_id'], $_POST['to_user_id'], $_POST['chat_message']);
       // ------------------------Fetch message----------------------------
       echo fetch_user_chat_history($_SESSION['user_id'], $_POST['to_user_id']);
}
