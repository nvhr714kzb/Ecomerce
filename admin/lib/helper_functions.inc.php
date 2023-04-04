<?php
function re_array_files($file){
    $file_arrange = array();
    $file_count = count($file['name']);
    $file_key = array_keys($file);
    for($i = 0; $i < $file_count; $i++){
        foreach($file_key as $key){
            $file_arrange[$i][$key] = $file[$key][$i];
        }
    }
    return $file_arrange;
}