<div id="content-wp" class="clearfix">
       <?php include('includes/sidebar.html') ?>
       <div id="content" class="float-right">
              <?php if (!empty($error_message)) {
                     echo "<p class='error'>$error_message</p>";
              } ?>
              <?php
              if (!empty($add_post_errors)) {
                     foreach ($add_post_errors as $item) {
                            echo "<p class='error'>$item</p>";
                     }
              }
              ?>
              <form action="" method="POST" F>
                     <h3 id="title-action">Edit the categories:</h3>
                     <?php if (count($list_cat) > 0) { ?>
                            <table cellpadding="12">
                                   <thead>
                                          <tr>
                                                 <th width='50%'>Category</th>
                                                 <th width='50%'>Actions</th>
                                          </tr>
                                   </thead>
                                   <?php foreach ($list_cat as $item) { ?>
                                          <tr>
                                                 <?php
                                                 if ($item_edit === $item['id']) {
                                                 ?>

                                                        <td><input class="category" type="text" name="category" value="<?php echo $item['category'] ?>"></td>
                                                        <td>
                                                               <input type="submit" name="submit-edit-post-<?php echo $item['id'] ?>" value="Edit post">
                                                               <input type="submit" name="submit-update-cat-<?php echo $item['id'] ?>" value="Update">
                                                               <input type="submit" name="cancel" value="Cancel">
                                                               <input type="submit" name="submit-delete-cat-<?php echo $item['id'] ?>" value="Delete">

                                                        </td>
                                                 <?php
                                                 } else {
                                                 ?>
                                                        <td><?php echo $item['category'] ?></td>
                                                        <td>
                                                               <input type="submit" name="submit-edit-post-<?php echo $item['id'] ?>" value="Edit post">
                                                               <input type="submit" name="submit-edit-cat-<?php echo $item['id'] ?>" value="Edit">
                                                               <input type="submit" name="submit-delete-cat-<?php echo $item['id'] ?>" value="Delete">

                                                        </td>
                                                 <?php } ?>

                                          </tr>
                                   <?php } ?>
                            </table>
                     <?php } else { //no cat
                            //do something
                     } ?>
                     <div>
                            <h3 class="add-action">Add new category:</h3>
                            <input type="text" name="catName" placeholder="Name" value="<?php if (isset($_POST['catName'])) echo $_POST['catName'] ?>">
                            <input type="submit" name="submit-add-cat-0" value="Add">
                            <?php
                            if (isset($_SESSION['image'])) {
                                   echo "<br />Currently '{$_SESSION['image']['file_name']}'";
                            }
                            ?>
                     </div>
              </form>

       </div>
</div>