<?php
require('../includes/config.inc.php');
require('../lib/database.inc.php');
require('../lib/user.inc.php');
require('../' . MYSQL);
require('includes/permission.php');
require('../lib/helper.inc.php');
if(isset($_POST['is_login']) && $_POST['is_login'] == 'false'){
    $list_customer = get_list_customer();
    if(!empty($list_customer)){
        $output = '<option value="">Select</option>';
        foreach($list_customer as $item){
            $output .= '<option value="'.$item['id'].'">'.$item['name'].'</option>';
        }
    }else{
        $output = '';
    }
    

}else{
    $list_customer = get_list_users();
    if(!empty($list_customer)){
        $output = '<option value="">Select</option>';
        foreach($list_customer as $item){
            $output .= '<option value="'.$item['id'].'">'.$item['name'].'</option>';
        }
    }else{
        $output = '';
    }
    
}
echo $output;