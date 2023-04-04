<?php
$valid = false;
if (isset($_GET['id']) && (strlen($_GET['id'])) && (substr($_GET['id'], 0, 1) != '.')) {
       $file = PDFS_DIR . $_GET['id'];
       if (file_exists($file) && is_file($file)) {
              $q = "SELECT `pdf_title`, `pdf_description`, `pdf_file_name` FROM `pdfs`
                     WHERE `id` = {$_GET['id']}";
              $r = mysqli_query($dbc, $q);
              if (mysqli_num_rows($r) == 1) {
                     $row = mysqli_fetch_array($r, MYSQLI_ASSOC);
                     $valid = true;
              }
       }
       if (isset($_SESSION['user_not_expired'])) {
            
              header('Content-type:application/pdf');
              header('Content-Disposition:inline;filename="'.$row['pdf_file_name'].'"');
              $fs = filesize($file);
              header("Content-Length:$fs\n");
              readfile($file);
              exit();
       } else {
              $page_title = $row['pdf_title'];
              get_header();
              echo "<h3>{$row['pdf_title']}</h3>";
              if (isset($_SESSION['user_id'])) {
                     echo "<div>Vui long gia han tai khoan tai: <a href = '?mod=user&act=renew'>Gia han</a></div>";
              } else {
                     echo "<div>Vui long dang ki tai: <a href = '?mod=user&act=register'>Dang ki</a></div>";
              }
              echo "<div>{$row['pdf_description']}</div>";
              get_sidebar();
              get_footer();
       }
}
