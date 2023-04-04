<?php

if (isset($_GET['pId']) && filter_var($_GET['pId'], FILTER_VALIDATE_INT, array('min_range' => 1))) {
    $product_id = $_GET['pId'];
    $list_post_by_product = get_list_post_by_product($product_id, 20);
    if (!empty($list_post_by_product)) {
        $phone_info = get_detail_phone($product_id);
        $attribute = get_product_attributes($product_id);
        foreach ($attribute as $item) {
            if ($item['name'] == 'ram') {
                $attr_ram[] = $item['value'];
            } elseif ($item['name'] == 'storage') {
                $attr_storage[] = $item['value'];
            }
        }
        $list_attr_ram = implode(', ', $attr_ram);
        $list_attr_storage = implode(', ', $attr_storage);
        $page_title = 'List posts for ' . $phone_info['name'];
        get_header();
        include('view/post/list_post_by_product.php');
        get_footer();
    } else {
        redirect('?mod=post&act=home');
    }
} else {
    redirect('?mod=post&act=home');
}
