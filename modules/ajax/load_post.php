<?php
if (isset($_GET['start'])) {
    $list_posts = get_list_new_posts((int)$_GET['start'], 5);
    $output = '';
    if (!empty($list_posts)) {
        $count = (int)$_GET['start'];
        foreach ($list_posts as $item) {
            $count++;
            $output .= '<li>';
            $output .= '<a href="post/'.create_slug($item['title']).'/' . $item['id'] . '" class="post-thumb">';
            $output .= '<img src="public/images/post/' . $item['thumb'] . '" alt="">';
            $output .= '</a>';

            $output .= '<div class="more-info">';
            $output .= '<a href="?mod=post&act=detail_post&postId=' . $item['id'] . '" class="post-title">';
            $output .= '' . $item['title'] . '';
            $output .= '</a>';
            $output .= ' <div class="post-published">';
            $output .= '<span class="post-author">' . $item['name'] . '</span>';
            $output .= '<span class="post-date">' . time_ago($item['date_created']) . '</span>';
            $output .= '</div>';
            $output .= '<p class="post-excerpt">' . $item['description'] . '</p>';
            $output .= '</div>';
            $output .= '</li>';
        }
        $output .= '<a  href="javascript:;" id="view-more-post" class="view-more" data-start="'.$count.'">View more <b></b></a>';
    }
    echo $output;
}
