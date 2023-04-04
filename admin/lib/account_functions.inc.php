<?php

function get_list_account(){
       $q = "CALL get_list_account()";
       return db_fetch_array($q);
}
function count_all_user(){
       $q = "CALL count_all_user()";
       list($count) = db_fetch_row($q);
       return $count;
}
function count_disabled_user(){
       $q = "CALL count_disabled_user()";
       list($count) = db_fetch_row($q);
       return $count;
}
function count_active_user(){
       $q = "CALL count_active_user()";
       list($count) = db_fetch_row($q);
       return $count;
}