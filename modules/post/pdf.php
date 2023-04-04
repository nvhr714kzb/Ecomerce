<?php
$page_title = "PDF";
get_header();
if (!isset($_SESSION['user_id'])) {
       echo '<p class="error">Thank you for your interest in this content.
       You must be logged in as a registered user to view any of the PDFs
       listed below.</p>';
} elseif (!isset( $_SESSION['user_not_expired'])) {
       echo '<p class="error">Thank you for your interest in this content.
       Unfortunately your account has expired. Please <a href="renew.php">
       renew your account</a> in order to view any of the PDFs listed
       below.</p>';
}

$q = "SELECT `pdf_tmp_name`, `pdf_title`, `pdf_description`, `pdf_size` FROM pdfs";
$r = mysqli_query($dbc, $q);
if (mysqli_num_rows($r) > 0) {
       while ($row = mysqli_fetch_assoc($r)) {
              echo "
                     <div>
                            <h4>{$row['pdf_title']}</h4>
                            <a href = '?mod=page&act=view_pdf&id={$row['pdf_tmp_name']}'>{$row['pdf_size']}</a>
                            <p>{$row['pdf_description']}</p>
                     </div>
              ";
       }
} else {
       echo "<div>Khong ton tai ban ghi nao</div>";
}
get_sidebar();
get_footer();
