<?php
if (isset($_POST['post_id'])) {
    $output = '';
    $list_comment_ask = get_list_comments($_POST['post_id']);
    foreach ($list_comment_ask as $itemParent) {
        $output .=  '<div class="comment-ask">';
        $output .=   '<div class="user-info">';
        $output .=   '<img class="avatar" src="https://nganhangphapluat.thukyluat.vn/images/CauHoi_Hinh/9eb6abaa-8cda-456c-ad66-26ba4da23ffe.jpg" alt="" width="50px">';
        $output .=   '<strong class="name">' . $itemParent['name'] . '</strong>';
        $output .=   '</div>';
        $output .=   '<div class="relate-info-comment">';
        $output .=   '<span class="reply reply-parent" data-index="' . $itemParent['comment_id'] . '">Reply</span>';
        $output .=   '<b class="dot">.</b>';
        if (is_login() && is_user_has_already_like_comment($itemParent['comment_id'], $_SESSION['user_id'])) {
            $output .=   '<span class="num-like" style="color: gray;" data-id="' . $itemParent['comment_id'] . '">Like (' . count_like_comment($itemParent['comment_id']) . ')</span>';
        } else {
            $output .=    '<span class="num-like" data-id="' . $itemParent['comment_id'] . '">Like (' . count_like_comment($itemParent['comment_id']) . ')</span>';
        }
        $output .=   '<span class="date">' . time_ago($itemParent['date']) . '</span>';
        $output .=   '</div>';
        $output .=   '<p class="comment-content">';
        $output .=   '' . htmlspecialchars($itemParent['comment']) . '';
        $output .=   '</p>';
        $output .=   '</div>';


        if (!empty(get_list_comments_reply($itemParent['comment_id'], $_POST['post_id']))) {
            $output .=     '<div class="comment-reply">';
            foreach (get_list_comments_reply($itemParent['comment_id'], $_POST['post_id']) as $itemChild) {
                $output .=   '<div class="comment-ask">';
                $output .=   '<div class="user-info">';
                $output .=   '<img src="https://nganhangphapluat.thukyluat.vn/images/CauHoi_Hinh/9eb6abaa-8cda-456c-ad66-26ba4da23ffe.jpg" alt="" width="50px">';
                $output .=   '<strong>' . $itemChild['name'] . '</strong>';
                $output .=   '</div>';
                $output .=   '<div class="relate-info-comment">';
                $output .=   '<span class="reply reply-child" data-index="' . $itemParent['comment_id'] . '">Reply</span>';
                $output .=   '<b class="dot">.</b>';
                if (is_login() && is_user_has_already_like_comment($itemChild['comment_id'], $_SESSION['user_id'])) {
                    $output .=   '<span class="num-like" style="color: gray;" data-id="' . $itemChild['comment_id'] . '">Like (' . count_like_comment($itemChild['comment_id']) . ')</span>';
                } else {
                    $output .=    '<span class="num-like" data-id="' . $itemChild['comment_id'] . '">Like (' . count_like_comment($itemChild['comment_id']) . ')</span>';
                }
                $output .=   '<span class="date">' . time_ago($itemChild['date']) . '</span>';
                $output .=   '</div>';
                $output .=   '<p class="comment-content">';
                $output .=   '' . htmlspecialchars($itemChild['comment']) . '';
                $output .=   '</p>';
                $output .=   '</div>';
            }
            $output .=  '</div>';
        }
    }
    echo $output;
}
