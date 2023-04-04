<?php
function count_all_comment(){
    $q = "CALL count_all_comment()";
    list($num_comments) = db_fetch_row($q);
    return $num_comments;
}
function count_approved_comment(){
    $q = "CALL count_approved_comment()";
    list($num_comments) = db_fetch_row($q);
    return $num_comments;
}

function count_pending_comment(){
    $q = "CALL count_pending_comment()";
    list($num_comments) = db_fetch_row($q);
    return $num_comments;
}

function count_trash_comment(){
    $q = "CALL count_trash_comment()";
    list($num_comments) = db_fetch_row($q);
    return $num_comments;
}

