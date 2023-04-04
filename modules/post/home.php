<?php
 $page_title = 'Post';
 get_header();
 $list_new_posts = get_list_new_posts(0, 10);
 $list_featured_posts = get_list_featured_posts(0, NUM_ITEMS_SLIDER);
 $list_post_most_comment = get_list_post_most_comment(10);
 $list_post_by_new_product = get_list_post_by_new_product(10);
 $list_most_view_post = get_list_post_most_view(10);
 include('view/post/home.php');
 get_footer();