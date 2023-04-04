<div id="content-wp" class="clearfix">
       <?php include('includes/sidebar.html') ?>
       <div id="content" class="float-right">

              <div class="section">
                     <div class="section-head">
                            <h3 class="section-title">List brands:</h3>
                            <?php if (!empty($error_message)) {
                                   echo "<div class='alert alert-danger' role='alert'>$error_message</div>";
                            } ?>
                            <?php
                            if (!empty($add_cat_errors)) {
                                   foreach ($add_cat_errors as $item) {
                                          echo "<div class='alert alert-danger' role='alert'>$item</div>";
                                   }
                            }
                            if(isset($message)){
                                   echo '<div class="alert alert-success" role="alert">
                                   '.$message.'
                                 </div>';
                            }
                            ?>
                     </div>
                     <div class="section-detail">
                            <form action="" method="POST" enctype="multipart/form-data">
                                   <table cellpadding="12">
                                          <thead>
                                                 <tr>
                                                        <th width='20%'>Brand</th>
                                                        <th width='10%'>Image</th>
                                                        <th width='40%'>Description</th>
                                                        <th width='30%'>Actions</th>
                                                 </tr>
                                          </thead>
                                          <?php
                                          if (!empty($list_cats)) {
                                                 foreach ($list_cats as $item) {
                                          ?>
                                                        <tr>
                                                               <?php
                                                               if ($item_edit == $item['id']) {
                                                               ?>
                                                                      <td>
                                                                             <div class="form-group">
                                                                                    <input type="text" name="category" value="<?php echo $item['category'] ?>" class="form-control" maxlength="40">
                                                                             </div>
                                                                      </td>
                                                                      <td><img src="../public/images/phone/<?php echo $item['image'] ?>" alt=""></td>
                                                                      <td>
                                                                             <div class="form-group">
                                                                                    <textarea name="description" rows="5" class="description form-control" maxlength="500" style="resize: none;"><?php echo $item['description'] ?></textarea>
                                                                             </div>
                                                                      </td>
                                                                      <td>
                                                                             <input type="submit" name="submit-edit-product-<?php echo $item['id'] ?>" value="Edit product">
                                                                             <input type="submit" name="submit-update-cat-<?php echo $item['id'] ?>" value="Update">
                                                                             <input type="submit" name="cancel" value="Cancel">
                                                                             <input type="submit" name="submit-delete-cat-<?php echo $item['id'] ?>" value="Delete"  onclick="return confirm('Are you sure you delete it ?')">

                                                                      </td>
                                                               <?php
                                                               } else {
                                                               ?>
                                                                      <td><?php echo $item['category'] ?></td>
                                                                      <td><img src="../public/images/phone/<?php echo $item['image'] ?>" alt=""></td>
                                                                      <td>
                                                                             <p><?php echo $item['description'] ?></p>
                                                                      </td>
                                                                      <td>
                                                                             <input type="submit" name="submit-edit-product-<?php echo $item['id'] ?>" value="Edit products">
                                                                             <input type="submit" name="submit-edit-cat-<?php echo $item['id'] ?>" value="Edit">
                                                                             <input type="submit" name="submit-delete-cat-<?php echo $item['id'] ?>" value="Delete"  onclick="return confirm('Are you sure you delete it ?')">

                                                                      </td>
                                                               <?php } ?>

                                                        </tr>
                                                 <?php } ?>
                                          <?php } else {
                                          ?>
                                                 <tr>
                                                        <td colspan="4">There is no record!</td>
                                                 </tr>
                                          <?php
                                          } ?>
                                   </table>

                                   <div class="section">
                                          <div class="section-head">
                                                 <h3 class="section-title">Add new brand:</h3>
                                          </div>
                                          <div class="section-detail">

                                                 <div class="form-group">
                                                        <label for="cat-name" class="control-label">Name of brand</label>
                                                        <input type="text" name="catName" id="cat-name" class="form-control" value="<?php if (isset($_POST['catName'])) echo $_POST['catName'] ?>" maxlength="40">
                                                 </div>
                                                 <div class="form-group">
                                                
                                                 <label for="cat-des" class="control-label"> Description of brand</label>
                                                        <textarea name="catDes" id="cat-des" class="form-control" rows="5" cols="100"  maxlength="500" style="resize: none;"><?php if (isset($_POST['catDes'])) echo $_POST['catDes'] ?></textarea>
                                                 </div>
                                                 <!-- <input type="text" name="nameImg" maxlength="45" placeholder="Name of image"> -->
                                                 <div class="form-group">
                                                        <label for="upload-thumb" class="control-label">Thumb</label>
                                                        <input type="file" name="image" id="upload-thumb" class="form-control-file">
                                                 </div>
                                                 <img src="../public/images/size/400x400.png" alt="" id="preview-thumb" width="400" height="600"><br>
                                                 <div class="form-group">
                                                        <input type="submit" name="submit-add-cat-0" value="Add a brand">
                                                 </div>
                                          </div>
                                   </div>
                            </form>
                     </div>
              </div>

       </div>
</div>