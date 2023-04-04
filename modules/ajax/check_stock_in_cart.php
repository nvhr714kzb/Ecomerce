<?php
if(isset($_POST['product_id']) && filter_var($_POST['product_id'], FILTER_VALIDATE_INT, array('min_range' => 1))){
    $num_stock = num_stock($_POST['product_id']);
    echo $num_stock;
}