<?php
function get_detail_post($postId)
{
       $q = "CALL get_detail_post($postId)";
       return db_fetch_row($q);
}
function get_list_new_posts($startId, $perPage)
{
       $q = "CALL get_list_new_posts($startId, $perPage)";
       return db_fetch_array($q);
}
function get_list_featured_posts($startId, $perPage)
{
       $q = "CALL get_list_featured_posts($startId, $perPage)";
       return db_fetch_array($q);
}
function get_list_comments($postId)
{
       $q = "CALL get_list_comments($postId)";
       return db_fetch_array($q);
}
function get_list_comments_reply($commentId, $postId)
{
       $q = "CALL get_list_comments_reply($commentId, $postId)";
       return db_fetch_array($q);
}
function add_comment($parentComId, $commentContent, $userId, $postId)
{
       $q = "CALL add_comment($parentComId, '$commentContent', $userId, $postId)";
       db_query($q);
}
function get_list_post_by_product_id($pId, $numItem)
{
       $q = "CALL get_list_post_by_product_id($pId, $numItem)";
       return db_fetch_array($q);
}
function get_one_post()
{
       global $dbc;
       $q = "CALL get_one_post()";
       return db_fetch_row($q);
}
function add_num_view($postId){
       $q = "CALL add_num_view($postId)";
       return db_query($q);
}
function get_list_post_most_view($numItem){
       $q = "CALL get_list_post_most_view($numItem)";
       return db_fetch_array($q);
}
function get_total_comments($postId){
       $q = "CALL get_total_comments($postId)";
       list($num_comment) = db_fetch_row($q);
       return $num_comment;
}
function is_user_has_already_like_comment($commentId, $userId){
       $q = "CALL is_user_has_already_like_comment($commentId, $userId)";
       list($count) = db_fetch_row($q);
       if($count > 0){
              return true;
       }else{
              return false;
       }
}
function add_like($commentId, $userId){
       $q = "CALL add_like($commentId, $userId)";
       db_query($q);
}
function count_like_comment($commentId){
       $q = "CALL count_like_comment($commentId)";
       list($count) = db_fetch_row($q);
       return $count;
}
function get_list_post_most_comment($numItem){
       $q = "CALL get_list_post_most_comment($numItem)";
       return db_fetch_array($q);
}
function get_list_post_by_new_product($numItem){
       $q = "CALL get_list_post_by_new_product($numItem)";
       return db_fetch_array($q);
}
function get_list_post_by_product($pId, $numItem){
       $q = "CALL get_list_post_by_product($pId, $numItem)";
       return db_fetch_array($q);
}
function get_product_attributes($pId)
{
       $q = "CALL get_product_attributes($pId)";
       return db_fetch_array($q);
}