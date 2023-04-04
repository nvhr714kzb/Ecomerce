<?php
function show_array($data)
{
       echo "<pre>";
       print_r($data);
       echo "</pre>";
}
function get_detail_category($catId){
       $q = "CALL get_detail_category($catId)";
       return db_fetch_row($q);
}
function num_page_search($searchString, $allWord)
{
       global $dbc;
       $r = mysqli_query($dbc, "CALL count_search_result('$searchString', '$allWord')");
       mysqli_next_result($dbc);
       $row = mysqli_fetch_array($r, MYSQLI_NUM);
       $count = $row[0];
       $number_pages = ceil($count / PRODUCTS_PER_PAGE);
       return $number_pages;
}
function search($searchString, $allWord, $pageNo, $perPage)
{
       global $dbc;
       $search_result = array(
              'accepted_words' => array(),
              'ignored_words' => array(),
              'product' => array()
       );
       if (empty($searchString)) {
              return $search_result;
       }
       $dilimiters = ',.; ';
       $word = strtok($searchString, $dilimiters);
       while ($word) {
              if (strlen($word) < FT_MIN_WORD_LEN) {
                     $search_result['ignored_words'][] = $word;
              } else {
                     $search_result['accepted_words'][] = $word;
              }
              $word = strtok($dilimiters);
       }
       if (count($search_result['accepted_words']) === 0) {
              return  $search_result;
       }
       if (strcmp($allWord, 'on') == 0) {
              $search_str = implode('+', $search_result['accepted_words']);
       } else {
              $search_str = implode(' ', $search_result['accepted_words']);
       }
       //Pagging
       // $r = mysqli_query($dbc, "CALL count_search_result('$search_str', '$allWord')");
       // $row = mysqli_fetch_array($r, MYSQLI_NUM);
       // $count = $row[0];
       // $how_many_pages = ceil($count/PRODUCTS_PER_PAGE);
       $start_item = ($pageNo - 1) * $perPage;
       //Retrieve
       // mysqli_next_result($dbc);
       $sql = "CALL search('$search_str', '$allWord', $start_item, $perPage)";
       $search_result['product'] = db_fetch_array($sql);
       return $search_result;
}
function get_images($id)
{
       $q = "CALL get_images_product($id)";
       return db_fetch_array($q);
}
function get_attribute($id)
{
       return db_fetch_array("CALL get_product_attributes($id)");
}

function get_stock_status($stock)
{
       if ($stock > 5) {
              return 'In Stock';
       } elseif ($stock > 0) {
              return 'Low Stock';
       } else {
              return 'Currently Out of Stock';
       }
}
// function get_price($type , $regular, $sales){
//        if($type === 'phone'){
//               if((0 < $sales)&&($regular > $sales)){
//                      return "Sale: $".$sales."";
//               }
//        }elseif($type === 'racket'){
//               if((0 < $sales)&&($regular > $sales)){
//                      return "<strong>Sale price: </strong>$ ". $sales ."! (normal $ ".$regular.")<br>";
//               }else{
//                      return "<strong>Price:</strong>$".$regular."<br>";
//               }
//        }
// }
function get_price($regular, $sales, $unit = 'đ')
{
       if (($sales < $regular) && ($sales > 0)) {
              return "<strong class = 'new-price'>" . currency_format($sales, $unit) . " </strong>
              <span class = 'old-price'>" . currency_format($regular) . " $unit</span>";
       } else {
              return "<strong class = 'new-price'>" . currency_format($regular, $unit) . " </strong>";
       }
}
function currency_format($number, $unit = 'đ')
{
       return number_format($number, 0, ',', '.') . $unit;
}

function get_just_price($regular, $sales)
{
       if ((0 < $sales) && ($sales < $regular))
              return $sales;
       return $regular;
}
function parse_sku($sku)
{
       $type = substr($sku, 0, 1);
       $id = substr($sku, 1);
       if ($type === 'R') {
              $type = 'racket';
       } elseif ($type === 'P') {
              $type = 'phone';
       } else {
              $type = NULL;
       }
       $id = filter_var($id, FILTER_VALIDATE_INT, array('min_range' => 1)) ? $id : NULL;
       return array($type, $id);
}


// function parse_sku($sku){
//        $type_abbr = substr($sku, 0, 1);
//        $pid = substr($sku, 1);
//        // echo "<br>pid = " . $pid;

//        //Validate the type
//        if($type_abbr === 'C'){
//               $type = 'coffee';
//        }elseif($type_abbr === 'G'){
//               $type = 'goodies';
//        }else{
//               $type = NULL;
//        }

//        //Validate the product ID:
//        $pid = (filter_var($pid, FILTER_VALIDATE_INT, array('min_range' => 1))) ? $pid :NULL;

//        //Return the values
//        return array($type, $pid);
// }
function get_shipping($total = 0)
{
       $shipping = 10000;
       if ($total < 10) {
              $rate = .25;
       } elseif ($total < 20) {
              $rate = .20;
       } elseif ($total < 50) {
              $rate = .18;
       } elseif ($total < 100) {
              $rate = .16;
       } else {
              $rate =  .02;
       }
       return $shipping + $total * $rate;
}
function discount($origin, $sale)
{
       return $origin - $sale;
}
function get_detail_phone($pId)
{
       $sql = "CALL select_detail_product($pId)";
       return  db_fetch_row($sql);
}
function get_sale_items($numProduct)
{
       $sql = "CALL get_sale_items($numProduct)";
       $list_sale_phones = db_fetch_array($sql);
       return $list_sale_phones;
}
function get_new_items($numProduct)
{
       $sql = "CALL get_new_items($numProduct)";
       $list_sale_phones = db_fetch_array($sql);
       return $list_sale_phones;
}
function get_featured_items($numProduct)
{
       $sql = "CALL get_featured_items($numProduct)";
       $list_sale_phones = db_fetch_array($sql);
       return $list_sale_phones;
}
function get_avg_rating($pId)
{
       $sql = "CALL get_avg_rating($pId)";
       list($avg_rating) = db_fetch_row($sql);
       return round($avg_rating);
}
function get_num_rating($pId, $numStar)
{
       $sql = "CALL get_num_rating($pId, $numStar)";
       list($num_rating) = db_fetch_row($sql);
       return $num_rating;
}
function get_reviews($pId)
{
       $sql = "CALL get_reviews($pId)";
       return db_fetch_array($sql);
}
function add_review($userId, $pId, $review, $rating)
{
       $sql = "CALL add_review($userId, $pId, '$review', $rating)";
       db_query($sql);
}
function shopping_cart_get_count(){
       if(is_login() && isset($_COOKIE['SESSION'])){
              $sql = "CALL shopping_cart_get_count(1, '{$_COOKIE['SESSION']}', {$_SESSION['user_id']})";
       }elseif(!is_login() && isset($_COOKIE['SESSION'])){
              $sql = "CALL shopping_cart_get_count(0, '{$_COOKIE['SESSION']}', 0)";
       }else{
              return 0;
       }
       list($count_cart) = db_fetch_row($sql);
       return $count_cart;
}
function shopping_cart_add_product($isLogin, $isCart, $cartId, $userId, $pId, $attr, $qty)
{
       $sql = "CALL shopping_cart_add_product($isLogin, $isCart, '$cartId', $userId, $pId, '$attr', $qty)";
       db_query($sql);
}
function shopping_cart_get_products($isLogin, $isCart, $cartId, $userId)
{
       $sql = "CALL shopping_cart_get_products($isLogin, $isCart, '$cartId', $userId)";
       return db_fetch_array($sql);
}
function shopping_cart_update_product($itemId, $qty)
{
       $sql = "CALL shopping_cart_update_product($itemId, $qty)";
       db_query($sql);
}
function shopping_cart_remove_product($itemId)
{
       $sql = "CALL shopping_cart_remove_product($itemId)";
       db_query($sql);
}
function shopping_cart_save_product_for_later($itemId)
{
       $sql = "CALL shopping_cart_save_product_for_later($itemId)";
       db_query($sql);
}
function shopping_cart_move_product_to_cart($itemId)
{
       $sql = "CALL shopping_cart_move_product_to_cart($itemId)";
       db_query($sql);
}
function check_item_id_belong_to_cart_id($itemId, $cartId)
{
       $sql = "CALL shopping_cart_check_item_id_belong_to_cart_id($itemId, '$cartId')";
       list($count) = db_fetch_row($sql);
       return $count;
}
function shopping_cart_get_subtotal($itemId){
       $sql = "CALL shopping_cart_get_subtotal($itemId)";
       list($sub_total) = db_fetch_row($sql);
       return $sub_total;
}
function shopping_cart_get_total_amount($cartId){
       $sql = "CALL shopping_cart_get_total_amount('$cartId')";
       list($total) = db_fetch_row($sql);
       return $total;
}
function transfer_cart_to_user($userId, $cartId)
{
       $sql = "CALL transfer_cart_to_user($userId, '$cartId')";
       db_query($sql);
}
function get_products_by_category($cat, $startItem, $perPage){
       $sql = "CALL get_products_by_category($cat, $startItem, $perPage)";
       return db_fetch_array($sql);
}
function get_num_page($catId){
       $sql = "CALL count_products_in_category($catId)";
       list($count) = db_fetch_row($sql);
       $total_page = ceil($count/PRODUCTS_PER_PAGE);
       return $total_page;
}
function get_list_attributes(){
       $sql = "CALL get_list_attributes()";
       return db_fetch_array($sql);
}
function get_rating($id){
       $output = "<div class='rating'>";
       $output .= "<ul class='list-star'>";
       $rating = get_avg_rating($id);
       $num_rating = get_num_rating($id, 0);
       for ($i = 1; $i <= 5; $i++) {
              if ($i <= $rating) {
                     $color = 'color:#ffcc00;';
              } else {
                     $color = 'color:#ccc;';
              }
              $output .= "<li  style='$color'>&#9733</li>";
       }
       $output .= "</ul>";
       $output .= "<span class='num-rating'>($num_rating)</span>";
       $output .= "</div>";
       return $output;
}
function get_recommend_related_product($pId, $limitItem){
       $sql = "CALL get_recommend_related_products($pId, $limitItem)";
       return db_fetch_array($sql);
}
function get_recommends_also_bought($pId, $limitItem){
       $sql = "CALL get_recommends_also_bought($pId, $limitItem)";
       return db_fetch_array($sql);
}
function get_list_sliders($limit){
       $sql = "CALL get_list_sliders($limit)";
       return db_fetch_array($sql);
}
function add_notify_out_of_stock($pId , $name , $email){
       $sql = "CALL add_notify_out_of_stock($pId , '$name' , '$email')";
       return db_query($sql);
}
function num_stock($pId){
       $sql = "CALL num_stock($pId)";
       list($num_stock) = db_fetch_row($sql);
       return $num_stock;
}

function add_order($cartId, $customerId, $shippingId, $taxId){

}
function get_list_category(){
       $q = "CALL get_list_category()";
       return db_fetch_array($q);
}
function get_recommend_products_same_category($pId, $numItem){
       $q = "CALL get_recommend_products_same_category($pId, $numItem)";
       return db_fetch_array($q);
}
function get_address_by_id($userId, $idAddress){
       $q = "CALL get_address_by_id($userId, $idAddress)";
       return db_fetch_row($q);
}
function get_product_most_rating($numItem){
       $q = "CALL get_product_most_rating($numItem)";
       return db_fetch_array($q);
}
function get_list_most_order_product($numItem){
       $q = "CALL get_list_most_order_product($numItem)";
       return db_fetch_array($q);
}