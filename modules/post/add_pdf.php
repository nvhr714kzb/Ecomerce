<?php
get_header();

$add_pdf_errors = array();
if($_SERVER['REQUEST_METHOD'] == "POST"){
       if(empty($_POST['title'])){
              $add_pdf_errors['title'] = "Không để trống tiêu đề";
       }else{
              $title = escape_data(strip_tags($_POST['title']));
       }

       if(empty($_POST['desc'])){
              $add_pdf_errors['desc'] = "Không để trống mô tả";
       }else{
              $desc = escape_data(strip_tags($_POST['desc']));
       }

       if(is_uploaded_file($_FILES['pdf']['tmp_name']) && ($_FILES['pdf']['error'] == UPLOAD_ERR_OK)){
              $file = $_FILES['pdf'];
              $size = round($file['size'] / 1024);
              if($size > 1008651656550056){
                     $add_pdf_errors['pdf'] = " Loi file lon hon x kb";
              }
              if(($file['type'] != 'application/pdf') && (substr($file['name'], -4) != ".pdf")){
                     $add_pdf_errors['pdf'] = "Khong phải file pdf";
              }
              if(!array_key_exists('pdf', $add_pdf_errors)){
                     $tmp_name = sha1($file['name'].uniqid('', true));
                     $dest = PDFS_DIR.$tmp_name.'_tmp';
                    if(move_uploaded_file($file['tmp_name'], $dest)){
				$_SESSION['pdf']['tmp_name'] = $tmp_name;
				$_SESSION['pdf']['size'] = $size;
				$_SESSION['pdf']['file_name'] = $file['name'];
				
				echo '<h4>The file has been uploaded!</h4>';

                    }else{
                           trigger_error('The file could not be moved.');
                           unlink($file['tmp_name']);
                    }
              }
       } elseif (!isset($_SESSION['pdf'])) { // No current or previous uploaded file.
		switch ($_FILES['pdf']['error']) {
			case 1:
			case 2:
				$add_pdf_errors['pdf'] = 'The uploaded file was too large.';
				break;
			case 3:
				$add_pdf_errors['pdf'] = 'The file was only partially uploaded.';
				break;
			case 6:
			case 7:
			case 8:
				$add_pdf_errors['pdf'] = 'The file could not be uploaded due to a system error.';
				break;
			case 4:
			default: 
				$add_pdf_errors['pdf'] = 'No file was uploaded.';
				break;
		} // End of SWITCH.

	} // End of $_FILES IF-ELSEIF-ELSE.

       if(empty($add_pdf_errors)){
              $tmp_name = escape_data($tmp_name);
              $file_name = escape_data($file['name']);
              $q = "INSERT INTO `pdfs` (`pdf_tmp_name`, `pdf_title`, `pdf_description`, `pdf_file_name`, `pdf_size`)
               VALUES ('$tmp_name', '$title', '$desc', '$file_name', '$size')";
              $r = mysqli_query($dbc, $q);
              if(mysqli_affected_rows($dbc) == 1){
                     $original = PDFS_DIR . $tmp_name . '_tmp';
                     $dest = PDFS_DIR . $tmp_name;
                     rename($original, $dest);
                     $_POST = array();
                     $_FILES = array();
                     unset($file, $_SESSION['pdf']);
              }else{
                     trigger_error('The PDF could not be added due to a system error. We apologize for any inconvenience.');
                     unlink($dest);
              }
       }

}else{
       unset($_SESSION['pdf']);
}
include("view/page/add_pdf.php");
get_footer();