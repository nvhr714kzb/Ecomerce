<?php
if(isset($_GET['cat_id']) && filter_var($_GET['cat_id'], FILTER_VALIDATE_INT, array('min_arrange' => 1))){
       $q = "SELECT `c_category` FROM `categories` WHERE `c_id` = ".$_GET['cat_id']."";
       $r = mysqli_query($dbc, $q);
       if(mysqli_num_rows($r) != 1){
              $page_title = 'Error!';
              get_header();
              echo '<div class="alert alert-danger">This page has been accessed in error.</div>';
              get_sidebar();
              get_footer();
              exit();
       }
       list($page_title) = mysqli_fetch_array($r, MYSQLI_NUM);
       get_header();
       if(isset($_SESSION['user_id']) && !isset($_SESSION['user_not_expired'])){
              echo '<div class="alert"><h4>Expired Account</h4>Thank you for your interest in this content. Unfortunately your account has expired. Please <a href="?mod=user&act=renew">renew your account</a> in order to access site content.</div>';
       }elseif(!isset($_SESSION['user_id'])){
              echo '<div class="alert">Thank you for your interest in this content. You must be logged in as a registered user to view site content.</div>';
       }
       //For one - many: add column p_category_id into pages table
       // $q = "SELECT `p_id`, `p_title`, `p_description` FROM `pages` WHERE `p_category_id` = {$_GET['cat_id']} AND `p_status` = 'live' ORDER BY p_date_created DESC";
       
       //For many: create join table pages_caterories
       $q = "SELECT `p_id`, `p_title`, `p_description` FROM `pages`, `pages_categories`
       WHERE pages.p_id = pages_categories.page_id AND  pages_categories.category_id = {$_GET['cat_id']}
       AND `p_status` = 'live' ORDER BY p_date_created DESC";
       $r = mysqli_query($dbc, $q);
       if(mysqli_num_rows($r) > 0){
              while($row = mysqli_fetch_array($r, MYSQLI_ASSOC)){
                     echo "<div>";
                     echo "<h4><a href='?mod=page&act=page&id=".$row['p_id']."'>".htmlspecialchars($row['p_title'])."</a></h4>";
                     echo "<p>".htmlspecialchars($row['p_description'])."</p>";
                     echo "</div>";
              }
       }else{
              echo '<p>There are currently no pages of content associated with this category. Please check back again!</p>';
       }

}else{
       $page_title = 'Error!';
       get_header();
       echo '<div class="alert alert-danger">This page has been accessed in error.</div>';
}
get_sidebar();
get_footer();