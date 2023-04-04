<?php
if(isset($_POST['comment_id'])){
        add_like((int)$_POST['comment_id'], $_SESSION['user_id']);
        $num_like = count_like_comment((int)$_POST['comment_id']);
        echo $num_like;
}