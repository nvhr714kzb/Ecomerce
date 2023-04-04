<?php
if ($_POST['count_unseen'] > 0) {
    seen_notify_like($_SESSION['user_id']);
    seen_notify_comment($_SESSION['user_id']);
}
