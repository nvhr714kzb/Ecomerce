<?php
function is_login()
{
       //due to undefine in jquery: must 1 or 0
       if (isset($_SESSION['user_id'])) {
              return 1;
       }
       return 0;
}
function is_admin()
{
       if (isset($_SESSION['user_admin'])) {
              return true;
       }
       return false;
}
function get_info_user($uerId)
{
       $q = "CALL get_info_user($uerId)";
       return db_fetch_row($q);
}
function get_list_users()
{
       $q = "CALL get_list_users()";
       return db_fetch_array($q);
}
function get_list_customer(){
       $q = "CALL get_list_customer()";
       return db_fetch_array($q);
}
function add_address($u, $f, $l, $ct, $a1, $a2, $c, $s, $z, $p, $e)
{
       $q = "CALL add_address($u, '$f', '$l', '$ct', '$a1', '$a2', '$c', '$s', $z, $p, '$e')";
       db_query($q);
}
function get_list_address($userId)
{
       $q = "CALL get_list_address($userId)";
       return db_fetch_array($q);
}
function get_address($addressId, $userId)
{
       $q = "CALL get_address($addressId, $userId)";
       return db_fetch_row($q);
}
function update_address($addressId, $userId, $fn, $ln, $ct, $a1, $a2, $c, $s, $z, $p, $e)
{
       $q = "CALL update_address($addressId, $userId, '$fn', '$ln', '$ct', '$a1', '$a2', '$c', '$s', $z , $p, '$e')";
       return db_query($q);
}
function get_list_privileges()
{
       $q = "CALL get_list_privileges()";
       return db_fetch_array($q);
}
function check_active_token($activeToken)
{
       $q = "CALL check_active_token('$activeToken')";
       list($is_active) = db_fetch_row($q);
       return $is_active;
}
function active_user($activeToken)
{
       $q = "CALL active_user('$activeToken')";
       db_query($q);
}
function is_valid_admin($userId)
{
       $q = "CALL is_valid_admin($userId)";
       list($count) = db_fetch_row($q);
       if ($count == 1) {
              return true;
       } else {
              return false;
       }
}
function delete_shipping_address($addressId, $userId)
{
       $q = "CALL delete_shipping_address($addressId, $userId)";
       db_query($q);
}
function is_review($productId, $userId)
{
       $q = "CALL is_review($productId, $userId)";
       list($count) = db_fetch_row($q);
       if ($count > 0) {
              return true;
       } else {
              return false;
       }
}
function get_type_of_user($typeUser)
{
       $q = "CALL get_type_of_user($typeUser)";
       return db_fetch_row($q);
}
function add_email_get_news($email)
{
       $q = "CALL add_email_get_news('$email')";
       list($status) = db_fetch_row($q);
       return $status;
}
