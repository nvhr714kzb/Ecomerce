<?php
function count_all_slider(){
    $q = "CALL count_all_slider()";
    list($num_slider) = db_fetch_row($q);
    return $num_slider;
}
function count_status_slider($status){
    $q = "CALL count_status_slider($status)";
    list($num_slider) = db_fetch_row($q);
    return $num_slider;
}
