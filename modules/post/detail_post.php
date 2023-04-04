  <?php
       if (isset($_GET['postId']) && filter_var($_GET['postId'], FILTER_VALIDATE_INT, array('min_arrange' => 1))) {
              $post_id = $_GET['postId'];
              $detail_post = get_detail_post($post_id);
              if (empty($detail_post)) {
                     $page_title = 'Error!';
                     get_header();
                     echo '<div class="alert alert-danger">This page has been accessed in error.</div>';
                     get_footer();
                     exit();
              }

              $page_title = $detail_post['title'];
              // $seo_url = cur_page_url();
              // $seo_type = 'website';
              // $seo_title = $page_title;
              // $seo_des = $detail_post['description'];
              // $seo_img = '';
              get_header();
              $list_comment_ask = get_list_comments($post_id);
              add_num_view($post_id);
              $num_comment = get_total_comments($post_id);

              include('view/post/detail_post.php');


              // if(isset($_SESSION['user_not_expired'])){

              //Make this page
              // $q = "SELECT `user_id` FROM `favorite_pages` where `user_id` = {$_SESSION['user_id']} AND `page_id` = {$_GET['pageId']}";
              // $r = mysqli_query($dbc, $q);
              // if(mysqli_num_rows($r) === 1){
              //        echo "<h3 id='favorite_h3'>
              //        <span>This is a favorite</span>
              //        <a href='?mod=page&act=remove_from_favories&id={$_GET['id']}' id='remove_favorite_link'>
              //               <img src = 'public/images/close.png' width = '32' height = '32'>
              //        </a>
              //        </h3>
              //        ";
              // }else{
              //        echo "<h3 id='favorite_h3'>
              //        <span>Make this page</span>
              //        <a href='?mod=page&act=add_to_favories&id={$_GET['id']}' id='add_favorite_link'>
              //               <img src = 'public/images/heart.png' width = '32' height = '32'>
              //        </a>
              //        </h3>
              //        ";
              // }
              //End make this page

              //Add history
              // $q = "SELECT `h_id` FROM `history` WHERE `h_user_id` = {$_SESSION['user_id']} AND `h_type` = 'page' AND `h_item_id` = {$_GET['id']}";
              // if(db_num_rows($q) === 0){
              //        $data = array(
              //               'h_user_id' => $_SESSION['user_id'],
              //               'h_type' => 'page',
              //               'h_item_id' => $_GET['id'],
              //        );
              //        db_insert('history', $data); 
              // }
              //End add history


              //=======================Add note FOR NO AJAX==================
              // if($_SERVER['REQUEST_METHOD'] == 'POST'){
              //        if (isset($_POST['notes']) && !empty($_POST['notes'])) {
              //               $note = escape_data($_POST['notes'], $dbc);
              //               $q = "REPLACE INTO `notes` (`user_id`, `page_id`, `n_note`) VALUES ({$_SESSION['user_id']}, {$_GET['id']}, '$note')";
              //               $r = mysqli_query($dbc, $q);
              //               if (mysqli_affected_rows($dbc) > 0) {
              //                      echo '<div class="alert alert-success">Your notes have been saved.</div>';
              //               }
              //        }
              // }
              // if(!isset($note)){
              //        $q = "SELECT `n_note` FROM `notes` WHERE `user_id` = {$_SESSION['user_id']} AND `page_id` = {$_GET['id']}";
              //        $r = mysqli_query($dbc, $q);
              //        if(mysqli_num_rows($r) === 1){
              //               list($note) = mysqli_fetch_array($r, MYSQLI_NUM);
              //        }
              // }
              //       echo "
              //       <form id = 'notes_form' action = '?mod=page&act=page&id={$_GET['id']}' method = 'POST' accept-charset='utf-8'>
              //               <fieldset>
              //                      <legend>Your note</legend>
              //                      <textarea name = 'notes' id = 'notes' class = 'form-control'>";
              //                      if(isset($note) && !empty($note)){
              //                             echo htmlspecialchars($note);
              //                      }
              //               echo "</textarea>
              //                      <input type = 'submit' name = 'submit_button' value = 'Save'></input>
              //               </fieldset>
              //       </form>";
              //------------------------End add note-----------------------------------------

              // }elseif(isset($_SESSION['user_id']) ){
              //        echo '<div class="alert"><h4>Expired Account</h4>Thank you for your interest in this content, but your account is no longer current. Please <a href="renew.php">renew your account</a> in order to view this page in its entirety.</div>';
              // echo '<div>' . htmlspecialchars($row['p_description']) . '</div>';
              // }else{
              //        echo '<div class="alert">Thank you for your interest in this content. You must be logged in as a registered user to view this page in its entirety.</div>';
              // echo '<div>' . htmlspecialchars($row['p_description']) . '</div>';
              // }

              // if(isset($_SESSION['user_id']) && !isset($_SESSION['user_not_expired'])){
              //        echo "<p class='error'>hank you for your interest in this content.
              //        Unfortunately your account has expired. Please <a href='renew.php'>renew your account</a> in order to access site content.</p> ";
              //        echo "<div>Mô tả:  {$row['p_description']}</div>";
              // }elseif(!isset($_SESSION['user_id'])){
              //        echo "<p class='error'>>Thank you for your interest in this content. You must be logged in as a registered user to view site content.</p>";
              //        echo "<div>Mô tả:  {$row['p_description']}</div>";
              // }else{
              //        echo "<p>Nội dung:   {$row['p_content']}</p>";
              // }                                              

       } else {
              $page_title = 'Error!';
              get_header();
              echo '<div class="alert alert-danger">This page has been accessed in error.</div>';
       }

       // ======================VARIABLE for javascript==============

       echo '<script type="text/javascript">  
var post_id = ' . $_GET['postId'] . ';
var is_login = ' . is_login() . ';
</script>
<script src="public/js/favories.js"></script>
<script src="public/js/notes.js"></script>
';
       get_footer();
       ?>