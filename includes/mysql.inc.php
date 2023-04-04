<?php
DEFINE('DB_HOST', 'localhost');
DEFINE('DB_NAME', 'gzcrlwrnhosting_dictionary4it');
//DB_NAME vanbinhunitopcv_my_project
//user vanbinhunitopcv_root
//pass -tHDWJArZUe]
DEFINE('DB_USER', 'gzcrlwrnhosting_dictionary4it');
DEFINE('DB_PASS', 'Aa0799500203');
// if (isset($user) && ($user == 'general')) {
//        DEFINE('DB_USER', 'root');
//        DEFINE('DB_PASS', '');
// }elseif(isset($user) && ($user == 'cart')){
//        DEFINE('DB_USER', 'binh0799500203');
//        DEFINE('DB_PASS', '0799500203');
// }
// $dbc = mysqli_connect(DB_HOST, DB_USER, DB_PASS, DB_NAME);
db_connect(DB_HOST, DB_USER, DB_PASS, DB_NAME);
mysqli_set_charset($dbc, 'utf8mb4');
function escape_data($data , $dbc)
{
       return mysqli_real_escape_string($dbc, trim($data));
}

// function get_password_hash($password)
// {
//        global $dbc;
//        return mysqli_escape_string($dbc, hash_hmac('sha256', $password, 'c#haRl891', true));
// }
