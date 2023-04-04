<?php
function count_unseen_like_notify($userId)
{
    $q = "CALL count_unseen_like_notify($userId)";
    list($count) = db_fetch_row($q);
    return $count;
}
function get_list_like_notify($userId)
{
    $q = "CALL get_list_like_notify($userId)";
    return db_fetch_array($q);
}
function get_list_reply_comment($userId)
{
    $q = "CALL get_list_reply_comment($userId)";
    return db_fetch_array($q);
}
function get_list_comment_by_user($userId)
{
    $q = "CALL get_list_comment_by_user($userId)";
    return db_fetch_array($q);
}
function seen_notify_like($userId){
    echo $q = "CALL seen_notify_like($userId)";
    db_query($q);
}
function seen_notify_comment($userId){
    $q = "CALL seen_notify_comment($userId)";
    db_query($q);
}
function quick_sort_notify($my_array)
{
    $loe = $gt = array();
    if (count($my_array) < 2) {
        return $my_array;
    }
    $pivot_key = key($my_array);
    $pivot = array_shift($my_array);
    foreach ($my_array as $val) {
        if (strtotime($val['date_created']) > strtotime($pivot['date_created'])) {
            $loe[] = $val;
        } elseif (strtotime($val['date_created']) <= strtotime($pivot['date_created'])) {
            $gt[] = $val;
        }
    }
    return array_merge(quick_sort_notify($loe), array($pivot_key => $pivot), quick_sort_notify($gt));
}
