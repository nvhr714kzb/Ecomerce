<?php
function create_form_input($name, $type, $label = '', $error, $values = 'POST', $option = array())
{
       $value = false;
       if ($values === 'SESSION') {
              if (isset($_SESSION[$name])){
                     $value = htmlspecialchars($_SESSION[$name], ENT_QUOTES, 'UTF-8');
              }
       } elseif ($values === 'POST') {
              if (isset($_POST[$name])) {
                     $value = htmlspecialchars($_POST[$name], ENT_QUOTES, 'UTF-8');
              }
       } elseif ($values === 'GET') {
              $value = htmlspecialchars($_POST[$name], ENT_QUOTES, 'UTF-8');
       } elseif ($values === 'DATABASE') {
              if (isset($_GET['userId'])) {
                     //for edit user at admin
                     $user = get_info_user((int)$_GET['userId']);
                     $value = $user[$name];
              } elseif (isset($_GET['addressId'])) {//for edit address
                     $address = get_address((int)$_GET['addressId'], $_SESSION['user_id']);
                     $value = $address[$name];
              }
       }
       // ====================Login Cookie=======================
       if($_SERVER['REQUEST_METHOD'] != 'POST'){
              if ($name == 'emailLogin') {
                     if (isset($_COOKIE['email_login'])) {
                            $value = htmlspecialchars($_COOKIE['email_login']);
                     }
              }
              if ($name == 'passwordLogin') {
                     if (isset($_COOKIE['email_login'])) {
                            $value = htmlspecialchars($_COOKIE['pass_login']);
                     }
              }
       }
       
       echo "<div class = 'form-group'>";
       // echo "<div class = 'form-group ";
       // if (array_key_exists($name, $error)) {
       //        echo " has-error'>";
       // } else {
       //        echo "'>";
       // }

       if (!empty($label)) {
              echo "<label for = '$name' class = 'control-label'>{$label}</label>";
       }
       if ($type === 'text' || $type === 'password' || $type === 'email') {
              echo "<input type = '{$type}' name = '{$name}' id = '{$name}' class = 'form-control' ";
              if ($value) {
                     echo "value = '{$value}' ";
              }
              foreach ($option as $k => $v) {
                     echo "$k = '$v' ";
              }
              echo ">";
              if (array_key_exists($name, $error)) {
                     echo "<div class = 'error' ><i class='fas fa-exclamation-triangle'></i> {$error[$name]}</div>";
              }
       } elseif ($type == 'textarea') {
              if (array_key_exists($name, $error)) {
                     echo "<div class = 'error'><i class='fas fa-exclamation-triangle'></i> {$error[$name]}</div>";
              }
              echo "<textarea type = '$type' name = '$name' id = '$name' class= 'ckeditor' rows = '5' cols = '75' ";
              if (array_key_exists($name, $error)) {
                     echo "class = 'error'>";
              } else {
                     echo ">";
              }
              if ($value) {
                     echo $value;
              }
              echo "</textarea>";
       } elseif ($type == 'select') {
              $data = array();
              if ($name === 'state') {
                     $data = array('AL' => 'Alabama', 'AK' => 'Alaska', 'AZ' => 'Arizona', 'AR' => 'Arkansas', 'CA' => 'California', 'CO' => 'Colorado', 'CT' => 'Connecticut', 'DE' => 'Delaware', 'FL' => 'Florida', 'GA' => 'Georgia', 'HI' => 'Hawaii', 'ID' => 'Idaho', 'IL' => 'Illinois', 'IN' => 'Indiana', 'IA' => 'Iowa', 'KS' => 'Kansas', 'KY' => 'Kentucky', 'LA' => 'Louisiana', 'ME' => 'Maine', 'MD' => 'Maryland', 'MA' => 'Massachusetts', 'MI' => 'Michigan', 'MN' => 'Minnesota', 'MS' => 'Mississippi', 'MO' => 'Missouri', 'MT' => 'Montana', 'NE' => 'Nebraska', 'NV' => 'Nevada', 'NH' => 'New Hampshire', 'NJ' => 'New Jersey', 'NM' => 'New Mexico', 'NY' => 'New York', 'NC' => 'North Carolina', 'ND' => 'North Dakota', 'OH' => 'Ohio', 'OK' => 'Oklahoma', 'OR' => 'Oregon', 'PA' => 'Pennsylvania', 'RI' => 'Rhode Island', 'SC' => 'South Carolina', 'SD' => 'South Dakota', 'TN' => 'Tennessee', 'TX' => 'Texas', 'UT' => 'Utah', 'VT' => 'Vermont', 'VA' => 'Virginia', 'WA' => 'Washington', 'WV' => 'West Virginia', 'WI' => 'Wisconsin', 'WY' => 'Wyoming');
              } elseif ($name === 'cc_exp_month') {
                     $data = array(1 => 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August',  'September', 'October', 'November', 'December');
              } elseif ($name === 'cc_exp_year') {
                     $data = array();
                     $start = date('Y');
                     for ($i = $start; $i <= $start + 5; $i++) {
                            $data[$i] = $i;
                     }
              }
              echo "<select name = '$name' id = '$name'";
              if (array_key_exists($name, $error)) {
                     echo "class = 'error'>";
              } else {
                     echo ">";
              }
              foreach ($data as $k => $v) {
                     echo "<option value=\"$k\"";
                     if ($value === $k) {
                            echo "selected='selected'";
                     }
                     echo ">$v</option>";
              }
              echo "</select>";
              if (array_key_exists($name, $error)) {
                     echo "<div class = 'error'><i class='fas fa-exclamation-triangle'></i> {$error[$name]}</div>";
              }
       }
       echo "</div>";
}

function form_error_2($label_field)
{
       // global $error;
       global $login_errors;
       if (!empty($login_errors[$label_field])) {
              echo "<div class = 'error' >" . $login_errors[$label_field] . "</div>";
              //use div
       }
       //  if(array_key_exists($label_field, $error)){
       //        echo "<div class = 'error' >".$error[$label_field]."</div>";
       //  }
}
function form_error($label_field, $error)
{
       if (array_key_exists($label_field, $error)) {
              echo "<div class = 'error'><i class='fas fa-exclamation-triangle'></i> {$error[$label_field]}</div>";
       }
}
function set_value($label_field)
{
       global $$label_field;
       if (!empty($$label_field)) {
              return $$label_field;
       }
}
function is_username($username)
{
       $pattern = "/^[A-Z0-9]{2,45}$/i";
       if (preg_match($pattern, $username, $matchs)) {
              return true;
       }
       return false;
}
function is_name($name)
{
       $pattern = "/^[A-Z \'.-]{2,45}$/i";
       if (preg_match($pattern, $name, $matchs)) {
              return true;
       }
       return false;
}
function is_password($pass)
{
       $pattern = "/^(\w*(?=\w*\d)(?=\w*[a-z])(?=\w*[A-Z])\w*){6,}$/";
       if (preg_match($pattern, $pass, $matchs)) {
              return true;
       }
       return false;
}
function is_email($email)
{
       if (filter_var($email, FILTER_VALIDATE_EMAIL)) {
              return true;
       }
       return false;
}
