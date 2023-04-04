<?php
if(!is_valid_user_type($_SESSION['user_type'], 50)){
       redirect();
}
$page_title = "Thêm trang";
get_header();
$add_page_errors = array();
if ($_SERVER['REQUEST_METHOD'] == "POST") {
       if(empty($_POST['status'] || ($_POST['status'] != 'live') || ($_POST['status'] != 'draft'))){
              $add_page_errors['status'] = "Please select a status!";
       }else{
              $status = escape_data(strip_tags($_POST['status']), $dbc);
       }
       if (empty($_POST['title'])) {
              $add_page_errors['title'] = "Please enter the title!";
       } else {
              $title = escape_data(strip_tags($_POST['title']), $dbc);
       }
       //For one-many
       // if (filter_var($_POST['category'], FILTER_VALIDATE_INT, array('min_arrange' => 1))) {
       //        $category = $_POST['category'];
       // } else {
       //        $add_page_errors['category'] = "Please select a category!";
       // }

       //For many-many
       if(count($_POST['category']) > 0){
              $category = $_POST['category'];
              print_r($category);
       }else{
              $add_page_errors['category'] = "Please enter the category!";
       }

       if (empty($_POST['description'])) {
              $add_page_errors['description'] = "Please enter the description!";
       } else {
              $description = escape_data(strip_tags($_POST['description']), $dbc);
       }

       if (empty($_POST['content'])) {
              $add_page_errors['content'] = "Please enter the content!";
       } else {
              $allowed = '<div><p><span><br><a><img><h1><h2><h3><h4>
              <ul><ol><li><blockquote>';
              $content = escape_data(strip_tags($_POST['content'], $allowed), $dbc);
       }
       if (empty($add_page_errors)) {
              //Way 1
              // $q = "INSERT INTO `pages` (`p_category_id`, `p_title`, `p_description`, `p_content`)
              //        VALUES($category, '{$title}', '{$description}', '{$content}')";
              // $r = mysqli_query($dbc, $q);
              
              //Way 2
              $data = array(
                     //for one - many
                     // 'p_category_id' => $category,
                     'p_status' => $status,
                     'p_title' => $title,
                     'p_description' => $description,
                     'p_content' => $content
              );
              //for one - many
              // db_insert("pages", $data);
              $page_id = db_insert("pages", $data);


              if (mysqli_affected_rows($dbc) == 1) {
                     echo '<div class="alert alert-success"><h3>The page has been added!</h3></div>';
                     //For many-many
                     $q = "INSERT INTO pages_categories (`page_id`, `category_id`) VALUES (?, ?)";
                     $stmt = mysqli_prepare($dbc, $q);
                     mysqli_stmt_bind_param($stmt, 'ii', $page_id, $cat);
                     foreach($_POST['category'] as $cat){
                            mysqli_stmt_execute($stmt);
                     }
                     mysqli_stmt_close($stmt);
                     $_POST = array();
              } else {
                     trigger_error('The page could not be added due to a system error. We apologize for any inconvenience.');
              }
       }
}

include('view/page/add_page.php');
// load_view('page', 'add_page', 'add_page_errors');
get_footer();
