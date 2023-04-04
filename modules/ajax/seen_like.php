<?php
foreach(get_list_comment_by_user($_SESSION['user_id']) as $item){
    seen_like_comment($item['comment_id']);
}