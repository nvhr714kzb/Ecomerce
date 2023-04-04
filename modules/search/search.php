<?php
if (!empty($_GET['searchStr'])) {
       $search_str = str_replace('-', ' ', $_GET['searchStr']);
       $page_title = "Amazon.com :  $search_str";
       get_header();
       $all_words = isset($_GET['allWords']) ? $_GET['allWords'] : 'off';
       $page = isset($_GET['page']) ? $_GET['page'] : 1;
       $search_result = search($search_str, $all_words, $page, PRODUCTS_PER_PAGE);
       include('view/search/search.php');
} else {
       $page_title = "Error";
       get_header();
       include('view/error/error.html');
}
get_footer();
