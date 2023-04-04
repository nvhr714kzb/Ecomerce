<?php
function parse_order_id($orderId){
       $has_login = substr($orderId, 0, 1);
       $order_id = substr($orderId, 1);
       if($has_login == 'Y'){
              $has_login = 'Login';
       }elseif($has_login == 'N'){
              $has_login = 'No Login';
       }else{
              $has_login = NULL;
       }
       $order_id = filter_var($order_id, FILTER_VALIDATE_INT, array('min_range' => '1')) ? $order_id : NULL;
       return array($has_login, $order_id);
}
function get_order_by_customer_id($isLogin, $userId)
{
       $q = "CALL get_order_by_customer_id($isLogin, $userId)";
       return db_fetch_array($q);
}
function get_order_by_id($isLogin, $orderId)
{
       $q = "CALL get_order_by_id($isLogin, $orderId)";
       return db_fetch_array($q);
}

function get_most_recent_orders($isLogin ,$numItem)
{
       $q = "CALL get_most_recent_orders($isLogin, $numItem)";
       return db_fetch_array($q);
}
function get_order_between_dates($isLogin ,$startDate, $endDate)
{
       $q = "CALL get_order_between_dates($isLogin, '$startDate', '$endDate')";
       return db_fetch_array($q);
}
function get_order_by_status($isLogin , $status)
{
       $q = "CALL get_order_by_status($isLogin, $status)";
       return db_fetch_array($q);
}
function get_order_info($isLogin, $orderId)
{
      $q = "CALL get_order_info($isLogin, $orderId)";
       return db_fetch_row($q);
}
function get_orders_content($isLogin, $orderId)
{
       $q = "CALL get_orders_content($isLogin, $orderId)";
       return db_fetch_array($q);
}


