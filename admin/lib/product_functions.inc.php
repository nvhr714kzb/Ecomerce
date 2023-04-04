<?php
function show_array($data)
{
       echo "<pre>";
       print_r($data);
       echo "</pre>";
}
function currency_format($number, $unit = 'đ')
{
       return number_format($number, 0, ',', '.') . ' ' .$unit;
}
function get_list_categories()
{
       $q = "CALL get_list_categories()";
       return db_fetch_array($q);
}
function add_category($brand, $des, $image)
{
       $q = "CALL add_category('$brand', '$des', '$image')";
       db_query($q);
}
function update_category($brandId, $category, $description, $img)
{
       $q = "CALL update_category($brandId, '$category', '$description', '$img')";
       db_query($q);
}
function delete_category($catId)
{
       $q = "CALL delete_category($catId)";
       list($status) = db_fetch_row($q);
       return $status;
}
function get_products_by_cat($catId, $startItem, $perPage)
{
       $q = "CALL get_products_by_category($catId, $startItem, $perPage)";
       return db_fetch_array($q);
}
function get_detail_category($catId)
{
       $q = "CALL get_detail_category($catId)";
       return db_fetch_row($q)['category'];
}

// ========================Product Detail=========================
function count_categories_of_product($pId)
{
       $q = "CALL count_categories_of_product($pId)";
       list($num_cat) = db_fetch_row($q);
       return $num_cat;
}
function delete_product($pId)
{
       $q = "CALL delete_products($pId)";
       db_query($q);
}
function remove_product_from_category($id, $catId)
{
       $q = "CALL remove_product_from_category($id, $catId)";
       list($status) = db_fetch_row($q);
       return $status;
}
function get_categories()
{
       $q = "CALL select_categories()";
       $result  = array();
       $list =  db_fetch_array($q);
       foreach ($list as $item) {
              $result[$item['id']] = $item['category'];
       }
       return $result;
}
function get_product_info($pId)
{
       $q = "CALL get_product_info($pId)";
       return db_fetch_row($q);
}
function get_detail_phone($pId)
{
       $sql = "CALL select_detail_product($pId)";
       return  db_fetch_row($sql);
}
function get_categories_for_product($pId)
{
       $q = "CALL get_categories_for_product($pId)";
       $result  = array();
       $list =  db_fetch_array($q);
       foreach ($list as $item) {
              $result[$item['id']] = $item['category'];
       }
       return $result;
}
function assign_product_category($pId, $catId)
{
       $q = "CALL assign_product_to_category($pId, $catId)";
       db_query($q);
}
function move_product_to_category($pId, $sourceCatId, $targetId)
{
       $q = "CALL move_product_to_category($pId, $sourceCatId, $targetId)";
       db_query($q);
}

function get_product_attributes($pId)
{
       $q = "CALL get_product_attributes($pId)";
       return db_fetch_array($q);
}
function get_attributes_not_assign_to_product($pId)
{
       $q = "CALL  get_attributes_not_assign_to_product($pId)";
       return db_fetch_array($q);
}
function assign_attribute_to_product($pId, $attrValueId)
{
       $q = "CALL assign_attribute_to_product($pId, $attrValueId)";
       db_query($q);
}
function remove_product_attribute_value($pId, $attrValueId)
{
       $q = "CALL remove_product_attribute_value($pId, $attrValueId)";
       db_query($q);
}
function set_thumb($type, $pId, $nameImg)
{
       $q = "CALL set_thumb('$type', $pId, '$nameImg')";
       db_query($q);
}
function is_valid_product($pId){
       $q ="CALL is_valid_product($pId)";
       list($count) = db_fetch_row($q);
       if($count > 0){
              return true;
       }else{
              return false;
       }
}
// ========================Attribute=========================
function get_all_attr(){
       $q = "CALL get_all_attr()";
       return db_fetch_array($q);
}
function get_attributes()
{
       $q = "CALL get_attributes()";
       return db_fetch_array($q);
}
function add_attribute($name)
{
       $q = "CALL add_attribute('$name')";
       db_query($q);
}
function update_attribute($id, $name)
{
       $q = "CALL update_attribute($id, '$name')";
       db_query($q);
}
function delete_attribute($id)
{
       global $dbc;
       $q = "CALL delete_attribute($id)";
       $r = mysqli_query($dbc, $q);
       mysqli_next_result($dbc);
       $row = mysqli_fetch_array($r, MYSQLI_NUM);
       return $row[0];
}
function get_attr_detail($id)
{
       $q = "CALL get_attr_detail($id)";
       return db_fetch_row($q);
}
// =====================Attr Values=================
function get_attr_values($id)
{
       $q = "CALL get_attr_values($id)";
       return db_fetch_array($q);
}
function add_attr_value($attrId, $value)
{
       $q = "CALL add_attr_value($attrId, '$value')";
       db_query($q);
}
function update_attr_value($id, $value)
{
       $q = "CALL update_attr_value($id, '$value')";
       db_query($q);
}
function delete_attr_value($attrValueId)
{
       global $dbc;
       $q = "CALL delete_attr_value($attrValueId)";
       $r = mysqli_query($dbc, $q);
       mysqli_next_result($dbc);
       $row = mysqli_fetch_array($r, MYSQLI_NUM);
       return $row[0];
}
function get_count_old_cart($days)
{
       $q = "CALL get_count_old_cart($days)";
       list($num_old_cart) = db_fetch_row($q);
       return $num_old_cart;
}
function delete_old_carts($days){
       $q = "CALL delete_old_carts($days)";
       db_query($q);
}
function add_image($productId, $imageProduct){
       $q = "CALL add_image($productId, $imageProduct)";
       db_query($q);
}
function get_list_product_not_sale(){
       $q = "CALL get_list_product_not_sale()";
       return db_fetch_array($q);
}
function get_list_product_sale($numItem){
       $q = "CALL get_list_product_sale($numItem)";
       return db_fetch_array($q);
}
function update_sale_product($productId ,$salePrice, $startDate, $endDate){
       echo $q = "CALL update_sale_product($productId ,$salePrice, '$startDate', '$endDate')";
       db_query($q);
}
function delete_sale_product($productId){
       $q = "CALL delete_sale_product($productId)";
       db_query($q);
}
//Not working
function get_list_notify_stock(){
       $q = "CALL get_list_notify_stock()";
       return db_fetch_array($q);
}
//Not working
function add_discount_code($code, $active, $minCost, $operation, $amount, $num, $exp){
       $q = "CALL add_discount_code('$code', $active, $minCost, '$operation', $amount, $num, '$exp')";
       db_query($q);
}
function is_valid_category($catId){
       $q = "CALL is_valid_category($catId)";
       list($count) = db_fetch_row($q);
       if($count == 1){
              return true;
       }else{
              return false;
       }
}
function is_valid_product_in_category($productId, $categoryId){
       $q = "CALL is_valid_product_in_category($productId, $categoryId)";
       list($count) = db_fetch_row($q);
       if($count == 1){
              return true;
       }else{
              return false;
       }
}
function update_product($productId, $name, $des, $price, $thumb){
       $q = "CALL update_product($productId, '$name', '$des', $price, '$thumb')";
       db_query($q);
}
function is_valid_attr($attrId ){
       $q = "CALL is_valid_attr($attrId)";
       list($count) = db_fetch_row($q);
       if($count == 1){
              return true;
       }else{
              return false;
       }
}
// ===================Related product======================
function get_list_related_products(){
       $q = "CALL get_list_related_products()";
       return db_fetch_array($q);
}
function get_recommend_related_products($pId, $limitItem){
       $q = "CALL get_recommend_related_products($pId, $limitItem)";
       return db_fetch_array($q);
}

