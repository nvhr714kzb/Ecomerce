<?php

define('MIN_LENGTH', 8);
function generate($options = []){
    
    // if (!is_array($options) && func_num_args() > 0) {
    //     $keys = ['length', 'prefix', 'suffix', 'letters', 'numbers', 'symbols', 'mixed_case', 'mask'];
    //     $opt = [];
    //     foreach (func_get_args() as $key => $value) {
    //         $opt[ $keys[ $key ] ] = $value;
    //     }
    //     $options = $opt;
    // }
    // print_r($options);
    $length = isset($options['length']) ? filter_var($options['length'], FILTER_VALIDATE_INT, ['options' => ['default' => 10, 'min_range' => 1]]): 15;
    $prefix = isset($options['prefix']) ? filter_var($options['prefix'], FILTER_SANITIZE_STRING) : '';
    $suffix = isset($options['suffix']) ? filter_var($options['suffix'], FILTER_SANITIZE_STRING) : '';
    $use_letters = isset($options['letters']) ? filter_var($options['letters'], FILTER_VALIDATE_BOOLEAN) : true;
    $use_numbers = isset($options['numbers']) ? filter_var($options['numbers'], FILTER_VALIDATE_BOOLEAN) : false;
    $use_symbols = isset($options['symbols']) ? filter_var($options['symbols'], FILTER_VALIDATE_BOOLEAN) : false;
    $use_mixed_case = isset($option['mixed_case']) ? filter_var($options['mixed_case'], FILTER_VALIDATE_BOOLEAN) : false;
    $mask = isset($options['mask']) ? filter_var($options['mask'], FILTER_SANITIZE_STRING) : '';
    $uppercase = ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', 'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', 'Z', 'X', 'C', 'V', 'B', 'N', 'M'];
    $lowercase = ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'z', 'x', 'c', 'v', 'b', 'n', 'm'];
    $numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
    $symbols = ['`', '~', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '-', '_', '=', '+', '\\', '|', '/', '[', ']', '{', '}', '"', "'", ';', ':', '<', '>', ',', '.', '?'];
    
    $characters = [];
    $coupon = '';
    if($use_letters){
        if($use_mixed_case){
            $characters = array_merge($characters, $uppercase, $lowercase);
        }else{
            $characters = array_merge($characters, $uppercase);
        }
    }
    if($use_numbers){
        $characters = array_merge($characters, $numbers);
    }
    if($use_symbols){
        $characters = array_merge($characters, $symbols);
    }
    if(!empty($mask)){
        for($i = 0; $i < strlen($mask); $i++){
            if($mask[$i] === 'X'){
                $coupon .= $characters[mt_rand(0, count($characters) - 1)];
            }else{
                $coupon .= $mask[$i];
            }
        }
    }else{
        for($i = 0; $i < $length; $i++){
            $coupon .= $characters[mt_rand(0, count($characters) - 1)];
        }
    }
    
    return $prefix.$coupon.$suffix;

}

function generate_coupon($max_number_of_coupon = 1, $options = []){
    $coupon = [];
    for($i = 0; $i < $max_number_of_coupon; $i++){
        $coupon[] = generate($options);
    }
    return $coupon;
}


$options = array(
    'length' => 8,
    'prefix' => 'COVID',
    'suffix' => '2020',
    'letters' => true,
    'numbers' => false,
    'symbols' => false,
    'mixed_case' => false,
    'mask' => '123XXX456'
);
function get_list_discount_code(){
    $q = "CALL get_list_discount_code()";
    return db_fetch_array($q);
}
function delete_discount_code($code){
    $q = "CALL delete_discount_code('$code')";
    db_query($q);
}

function change_status_discount_code($code, $active){
    $q = "CALL change_status_discount_code('$code', $active)";
    db_query($q);
}