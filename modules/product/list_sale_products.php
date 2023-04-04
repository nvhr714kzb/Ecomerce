<?php
$page_title = "List sale product";
get_header();

$page = isset($_GET['page']) && is_numeric($_GET['page']) && $_GET['page'] > 0 ? $_GET['page'] : 1;
// $num_page = get_num_page($cat_id);
$start_item = ($page - 1) * PRODUCTS_PER_PAGE;

$list_attr = get_list_attributes();
$list_sale_products = get_sale_items($start_item, PRODUCTS_PER_PAGE);
if (!empty($list_sale_products)) {
       include('view/product/list_sale_products.php');
} else {
       include('view/error/empty_product.html');
}
get_footer();
