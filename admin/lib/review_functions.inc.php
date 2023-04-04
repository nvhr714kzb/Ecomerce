<?php
function count_all_review(){
    $q = "CALL count_all_review()";
    list($num_review) = db_fetch_row($q);
    return $num_review;
}
function count_approved_review(){
    $q = "CALL 	count_approved_review()";
    list($num_review) = db_fetch_row($q);
    return $num_review;
}

function count_pending_review(){
    $q = "CALL 	count_pending_review()";
    list($num_review) = db_fetch_row($q);
    return $num_review;
}

function count_trashed_review(){
    $q = "CALL count_trashed_review()";
    list($num_review) = db_fetch_row($q);
    return $num_review;
}

