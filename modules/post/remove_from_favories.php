<?php
if(isset($_GET['id']) && filter_var($_GET['id'], FILTER_VALIDATE_INT, array('min_arrange' => 1))){
       $q = "SELECT `p_title`, `p_description`, `p_content` FROM `pages` WHERE `p_id` = {$_GET['id']} AND `p_status` = 'live'";
       $r = mysqli_query($dbc, $q);
       if(mysqli_num_rows($r) != 1){
              $page_title = 'Error!';
		get_header();
		echo '<div class="alert alert-danger">This page has been accessed in error.</div>';
              get_sidebar();
              get_footer();
		exit();
       }
       if(isset($_SESSION['user_not_expired'])){
              $q = "DELETE FROM `favorite_pages` WHERE `user_id` AND `page_id` = {$_GET['id']}";
              $r = mysqli_query($dbc, $q);
              redirect("?mod=page&act=page&id={$_GET['id']}");
       }
}