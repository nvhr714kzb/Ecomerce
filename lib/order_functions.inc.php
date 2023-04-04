<?php
function get_order_history_by_customer($userId){
    $q = "CALL get_order_history_by_customer($userId)";
    return db_fetch_array($q);
}
function get_order_info($isLogin, $orderId)
{
      $q = "CALL get_order_info($isLogin, $orderId)";
       return db_fetch_row($q);
}
function get_order_content_history_by_customer($orderId, $userId){
    $q = "CALL get_order_content_history_by_customer($orderId, $userId)";
    return db_fetch_array($q);
}


