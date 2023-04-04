<form action="?mod=page&act=add_page" method="POST" accept-charset="utf8">
    <fieldset>
        <legend>Fill out the form to add a page of content:</legend>
        <div class="form-group">
            <label for="status" class="control-panel">Status</label>
            <select name="status" id="status" class="form-control">
                       <option value="live" <?php if(isset($_POST['status']) && $_POST['status'] == 'live') echo " selected = selected"; ?>>Live</option>
                       <option value="draft" <?php if(isset($_POST['status']) && $_POST['status'] == 'draft') echo " selected = selected"; ?>>Draft</option>
            </select>
        </div>
        <?php form_error_2('status', $add_page_errors) ?>
        
        <?php 
        create_form_input('title', 'text', 'Title', $add_page_errors, 'POST');
        ?>
        <div class="form-group">
            <label for="category" class="control-label">Category</label><br>
            <select name="category[]" multiple size = "2"><br>
                     <option value="">Select one</option>
                     <?php
                            $q = "SELECT c_id, c_category FROM categories ORDER BY c_category ASC";
                            $r = mysqli_query($dbc, $q);
                            while($row = mysqli_fetch_array($r, MYSQLI_NUM)){
                                   echo "<option value = '{$row[0]}' ";
                                          if(isset($_POST['category']) && $_POST['category'] == $row[0]) echo " selected = selected";
                                
                                   echo ">{$row[1]}</option>";
                            }
                     ?>
        </select>
        </div>
        <?php form_error_2('category', $add_page_errors) ?>

        <?php 
        create_form_input('description', 'textarea', 'Description', $add_page_errors);
        create_form_input('content', 'textarea', 'Content', $add_page_errors) 
        ?>

        <div class="form-group">
            <input type="submit" name="submit_button" id="submit_button" value="Add This Page">
        </div>

    </fieldset>
</form>