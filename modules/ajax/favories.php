<?php
if(isset($_GET['page_id'], $_GET['action'], $_SESSION['user_id']) && filter_var($_GET['page_id'], FILTER_VALIDATE_INT, array('min_arrange' => 1))
&& filter_var($_SESSION['user_id'], FILTER_VALIDATE_INT, array('min_range' => 1) )
){
       // $q = "SELECT `p_title`, `p_description`, `p_content` FROM `pages` WHERE `p_id` = {$_GET['id']} AND `p_status` = 'live'";
       // $r = mysqli_query($dbc, $q);
       // if(mysqli_num_rows($r) != 1){
       //        $page_title = 'Error!';
	// 	get_header();
	// 	echo '<div class="alert alert-danger">This page has been accessed in error.</div>';
       //        get_sidebar();
       //        get_footer();
	// 	exit();
       // }
       // if(isset($_SESSION['user_not_expired'])){
       //        $data = array(
       //               'user_id' => $_SESSION['user_id'],
       //               'page_id' => $_GET['id']
       //        );
       //        db_insert('favorite_pages', $data);
       //        redirect("?mod=page&act=page&id={$_GET['id']}");
       // }
      
       if($_GET['action'] === 'add'){
              $q = "REPLACE INTO favorite_pages (user_id, page_id) VALUES (?, ?)";
       }elseif($_GET['action'] === 'remove'){
              $q = "DELETE FROM favorite_pages WHERE user_id ? AND page_id = ?";
       }
       if(isset($q)){
              $stmt = mysqli_prepare($dbc, $q);
              mysqli_stmt_bind_param($stmt, 'ii', $_SESSION['user_id'], $_GET['page_id']);
              mysqli_stmt_execute($stmt);
              if(mysqli_stmt_affected_rows($stmt) > 0){
                     echo 'true';
                     exit;
              }
       }
}
echo 'false';