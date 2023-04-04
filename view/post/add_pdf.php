<form action="?mod=page&act=add_pdf" method="POST" enctype="multipart/form-data" accept-charset="utf8">
    <fieldset>
        <legend>Fill out the form to add a PDF to the site:</legend>
        <p>
            <label for="title"><strong>Title</strong></label><br>
            <?php create_form_input('title', 'text', $add_pdf_errors, 'POST') ?>
        </p>

        <p>
            <label for="desc"><strong>Mô tả</strong></label><br>
            <?php create_form_input('desc', 'textarea', $add_pdf_errors, 'POST') ?>
        </p>

        <p>
            <label for="pdf"><strong>PDF</strong></label><br>
            <?php echo '<input type ="file" name = "pdf" id = "pdf"';
                     if (array_key_exists('pdf', $add_pdf_errors)) {
                            echo 'class = "error" /> <span class = "error">'. $add_pdf_errors['pdf'] . '</span>';
                     } else {
                            echo '/>';
                            if (isset($_SESSION['pdf'])) {
                                   echo " Currently {$_SESSION['pdf']['file_name']}";
                            }
                            
                     }
              ?>
            <small>PDF only, 1MB Limit</small>
        </p>
        <p>
            <input type="submit" id="submit_button" name="submit_button" value="Add this PDF" class="formbutton">
        </p>

    </fieldset>
</form>