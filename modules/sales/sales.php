<?php
$page_title = 'Sale Items';
get_header();
$list_sale_products = get_sale_items(1000);
if (!empty($list_sale_products)) {
       include('view/sale/list_sales.php');
} else {
       include('view/error/empty_product.html');
}
get_footer();
