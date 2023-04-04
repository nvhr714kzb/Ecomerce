<?php
$cat_id = $category = false;
if (isset($_GET['catId']) && filter_var($_GET['catId'], FILTER_VALIDATE_INT, array('min_range' => 1))) {
       $cat_id = $_GET['catId'];
       $category =get_detail_category($cat_id);
       $name_cat =  $category['category'];
}
if (!$cat_id) {
       $page_title = 'Error';
       get_header();
       include('view/error/error.html');
       get_footer();
       exit();
}
$page_title = "List " . ucfirst($name_cat) . "";
get_header();

$page = isset($_GET['page']) ? $_GET['page'] : 1;
$num_page = get_num_page($cat_id);
$start_item = ($page - 1) * PRODUCTS_PER_PAGE;
$list_attr = get_list_attributes();
$list_phones = get_products_by_category($cat_id, $start_item, PRODUCTS_PER_PAGE);
if (!empty($list_phones)) {
       include('view/product/list_products.php');
       echo "
       <script>
              var cat_id = $cat_id;
       </script>
       ";
} else {
       include('view/error/empty_product.html');
}
get_footer();
