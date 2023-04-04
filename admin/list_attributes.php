<div id="content-wp" class="clearfix">
       <?php include('includes/sidebar.html') ?>
       <div id="content" class="float-right">
              <div class="section">
                     <div class="section-head">
                            <h3 class="section-title">List product attribute</h3>
                            <?php
                            if (!empty($error_message)) {
                                   echo "<div class='alert alert-danger' role='alert'>
                                   $error_message
                                 </div>";
                            }
                            if (isset($message)) {
                                   echo "<div class='alert alert-success' role='alert'>
                                   $message
                                 </div>
                                   ";
                            }
                            ?>
                     </div>
                     <div class="section-detail">
                            <form action="" method="POST">
                                   <table cellpadding="12">
                                          <thead>
                                                 <tr>
                                                        <th width="50%">Attribute Name</th>
                                                        <th width="50%">Actions</th>
                                                 </tr>
                                          </thead>
                                          <tbody>
                                                 <?php
                                                 if (!empty($list_attrs)) {
                                                        foreach ($list_attrs as $item) {
                                                 ?>
                                                               <tr>
                                                                      <?php if ($item['attribute_id'] == $item_edit) { ?>
                                                                             <td>
                                                                                    <div class="form-group">
                                                                                           <input type="text" name="name" value="<?php echo $item['name'] ?>" class="form-control" maxlength="20">
                                                                                    </div>
                                                                             </td>
                                                                             <td>
                                                                                    <input type="submit" name="submit-edit-attr-val-<?php echo $item['attribute_id'] ?>" value="Edit Attribute Values">
                                                                                    <input type="submit" name="submit-update-<?php echo $item['attribute_id'] ?>" value="Update">
                                                                                    <input type="submit" name="cancel" value="Cancel">
                                                                                    <input type="submit" name="submit-delete-<?php echo $item['attribute_id'] ?>" value="Delete" onclick="return confirm('Are you sure you delete it ?')">
                                                                             </td>
                                                                      <?php } else { ?>
                                                                             <td><?php echo $item['name'] ?></td>
                                                                             <td>
                                                                                    <input type="submit" name="submit-edit-attr-val-<?php echo $item['attribute_id'] ?>" value="Edit Attribute Values">
                                                                                    <input type="submit" name="submit-edit-<?php echo $item['attribute_id'] ?>" value="Edit">
                                                                                    <input type="submit" name="submit-delete-<?php echo $item['attribute_id'] ?>" value="Delete" onclick="return confirm('Are you sure you delete it ?')">
                                                                             </td>

                                                                      <?php } ?>
                                                               </tr>
                                                        <?php
                                                        }
                                                 } else {
                                                        ?>
                                                        <tr>
                                                               <td colspan="2">There is no record!</td>
                                                        </tr>
                                                 <?php
                                                 }
                                                 ?>
                                          </tbody>
                                   </table>
                                   <div class="section">
                                          <div class="section-head">
                                                 <h3 class="section-title">Add new attribute</h3>
                                          </div>
                                          <div class="section-detail">

                                                 <div>
                                                        <div class="form-group">
                                                               <label for="name-attr" class="control-label">Name of attribute</label>
                                                               <input type="text" name="name-attr" id="name-attr" class="form-control" maxlength="20">
                                                        </div>
                                                        <div class="form-group">
                                                               <input type="submit" name="submit-add-attr-0" value="Add a attribute">
                                                        </div>
                                                 </div>
                                          </div>
                                   </div>
                            </form>
                     </div>
              </div>
       </div>
</div>