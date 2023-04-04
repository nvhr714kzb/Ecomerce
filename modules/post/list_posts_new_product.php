<?php
 $page_title = 'List posts for new products';
 get_header();
 $list_post_by_new_product = get_list_post_by_new_product(20);
 include('view/post/list_post_new_product.php');
 get_footer();