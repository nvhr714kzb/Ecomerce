<?php
if(isset($_GET['type']) && $_GET['type'] === 'racket'){
       $type = 'racket';
       $page_title = "Badminton Brand";
}else{
       $type = 'phone';
       $page_title = "Phone Brand";
}

get_header();

$r = mysqli_query($dbc, "CALL select_categories('$type')");
if(mysqli_num_rows($r) > 0){
       include('view/product/list_categories.php');
}else{
       include('view/error/error.html');
}

mysqli_close($dbc);
db_connect(DB_HOST, DB_USER, DB_PASS, DB_NAME);
get_sidebar();
get_footer();