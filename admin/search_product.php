<?php
require('../includes/config.inc.php');
require('../lib/database.inc.php');
// require('../lib/form_functions.inc.php');
// require('../lib/user.inc.php');
require('../' . MYSQL);
require('includes/permission.php');
require('../lib/helper.inc.php');
require('../lib/product_functions.inc.php');
if (isset($_POST['query'])) {
    $search_str = clean_url_text($_POST['query']);
    $search_str = str_replace('-', ' ',  $search_str);
    $all_words = 'off';
    $page = 1;
    $perPage = 20;
    $hint_search = search($search_str, $all_words, $page, $perPage)['product'];
    $output = '';

    if (!empty($hint_search)) {
           $output .= '<ul id = "list-hint-search">';
           foreach ($hint_search as $item) {
                  $output .= '<li data-id="'.$item['id'].'" data-src="'.$item['thumb'].'" data-name="'.$item['name'].'">';
                  $output .= "<img src='../public/images/phone/{$item['thumb']}' alt=''>";
                  $output .= "<p>{$item['name']}</p>";
                  $output .= '</li>';
           }
           $output .= '</ul>';
    }
    echo $output;
}
