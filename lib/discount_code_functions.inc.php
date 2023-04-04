<?php
function get_list_discount_code($startItem, $perPage){
    $q = "CALL get_list_discount_code($startItem, $perPage)";
    return db_fetch_array($q);
}
function get_discount_code($code){
    $sql = "CALL get_discount_code('$code')";
    return db_fetch_row($sql);
}