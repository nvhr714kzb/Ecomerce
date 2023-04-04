<?php

function add_category_for_post($name){
       $q = "CALL add_category_for_post('$name')";
       db_query($q);
}
function get_list_categories_for_post(){
       $q = "CALL get_list_categories_for_post()";
       return db_fetch_array($q);
}
function  update_category_for_post($catId, $category){
       $q = "CALL update_category_for_post($catId, '$category')";
       db_query($q);
}
function delete_category_for_post($postId){
       $q = "CALL delete_category_for_post($postId)";
       db_query($q);
}
function get_all_comment(){
       $q = "CALL get_all_comment()";
       return db_fetch_array($q);
}
function delete_post_by_product($pId){
       $q = "CALL delete_post_by_product($pId)";
       db_query($q);
}
function delete_post($id){
       $q = "CALL delete_post($id)";
       db_query($q);
}
function update_status_post($id, $status){
       $q= "CALL update_status_post($id, '$status')";
       db_query($q);
}