<?php
function get_list_inventory_from_to($from, $to){
       $q = "CALL get_list_inventory_from_to($from, $to)";
       return db_fetch_array($q);
}