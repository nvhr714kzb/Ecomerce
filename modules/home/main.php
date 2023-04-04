 <?php 
 get_header();
 $list_slider = get_list_sliders(5);
 $one_post = get_one_post();
 $list_featured_products = get_featured_items(NUM_ITEMS_SLIDER);
 $list_sale_items = get_sale_items(NUM_ITEMS_SLIDER);
 $list_new_items = get_new_items(NUM_ITEMS_SLIDER);
 $list_most_rating_product = get_product_most_rating(NUM_ITEMS_SLIDER);
 $get_list_most_order_product = get_list_most_order_product(NUM_ITEMS_SLIDER);
 include("view/home/main.php");
 get_footer();
 ?>