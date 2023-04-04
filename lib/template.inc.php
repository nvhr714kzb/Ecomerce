<?php
function get_header($version = "")
{
       global $dbc;
       global $page_title, $og_url, $og_type, $og_title, $og_des, $og_img;
       if (empty($version)) {
              $path_header = "includes/header.php";
       } else {
              $path_header = "includes/header-{$version}.php";
       }
       if (file_exists($path_header)) {
              include $path_header;
       } else {
              trigger_error("Khong ton tai duong dan {$path_header}");
              // echo "Khong ton tai duong dan {$path_header}";
       }
}
function get_footer()
{
       global $dbc;
       $path_footer = "includes/footer.php";

       if (file_exists($path_footer)) {
              include $path_footer;
       } else {
              trigger_error("Khong ton tai duong dan {$path_footer}");
              // echo "Khong ton tai duong dan {$path_footer}";
       }
}
function get_sidebar()
{
       global $dbc;
       $path_sidebar = "includes/sidebar.php";
       if(file_exists($path_sidebar)){
              include $path_sidebar;
       }else{
              trigger_error("Khong ton tai duong dan {$path_sidebar}");
              // echo "Khong ton tai duong dan {$path_sidebar}";
       }
}
function load_view($mod, $act, $error = ''){
       if(!empty($error)){
              global $$error;
       }
       global $dbc;
       $path_view = "view/$mod/$act.html";
       if(file_exists($path_view)){
              include($path_view);
       }else{
              // echo "Khong ton tai duong dan {$path_view}";
              trigger_error("Khong ton tai duong dan {$path_view}");
       }
      
}
