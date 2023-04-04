<?php
if (isset($_POST['query'])) {
       $search_str = clean_url_text($_POST['query']);
       $search_str = str_replace('-', ' ',  $search_str);
       $all_words = 'off';
       $page = 1;
       $perPage = 10;
       $hint_search = search($search_str, $all_words, $page, $perPage)['product']; 
       $output = '';

       if (!empty($hint_search)) {
              $output .= '<ul id = "list-hint-search">';
              foreach ($hint_search as $item) {
                     $output .= '<li>';
                     $output .= "<img src='public/images/phone/{$item['thumb']}' alt=''>";
                     $output .= "<p>{$item['name']}</p>";
                     $output .= '</li>';
              }
              $output .= '</ul>';
       }
       echo $output;
}
