<?php
redirect_invalid_user(); 
get_header();
 $status_options = array(
    1 => 'placed',
    2 => 'verified',
    3 => 'completed',
    4 => 'canceled',
);
if(isset($_GET['orderId']) && filter_var($_GET['orderId'], FILTER_VALIDATE_INT, array('min_range' => '1'))){
    $order_info = get_order_info(ORDER_LOGIN, $_GET['orderId']);
    $list_order_content_history_by_customer = get_order_content_history_by_customer($_GET['orderId'], $_SESSION['user_id']);
    if(!empty($list_order_content_history_by_customer)){
        include("view/order/order_content_history.php");
    }else{
        redirect();
    }
   
}else{
    $list_order_history = get_order_history_by_customer($_SESSION['user_id']);
    include("view/order/order_history.php");
}
 
 get_footer();
