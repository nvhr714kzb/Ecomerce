<div id="content-wp" class="clearfix">
       <?php include('includes/sidebar.html') ?>
       <div id="content" class="float-right">
              <div class="section">
                     <div class="section-head">
                            <h3 id="section-title">Edit values for attribute: <?php echo get_attr_detail($attr_id)['name']; ?></h3>
                            <?php
                            if (isset($error_message)) {
                                   echo "<div class='alert alert-danger' role='alert'>
                                          $error_message
                                        </div>";
                            }
                            if (isset($message)) {
                                   echo "<div class='alert alert-success' role='alert'>
                                         $message
                                        </div>";
                            }
                            ?>
                     </div>
                     <div class="section-detail">
                            <form action="" method="POST">
                                   <table cellpadding="12">
                                          <thead>
                                                 <tr>
                                                        <th width="50%">Attribute Value</th>
                                                        <th width="50%">Actions</th>
                                                 </tr>
                                          </thead>
                                          <tbody>
                                                 <?php
                                                 if (!empty($list_attr_values)) {
                                                        foreach ($list_attr_values as $item) { ?>
                                                               <tr>
                                                                      <?php if ($item_edit == $item['attribute_value_id']) { ?>
                                                                             <td>
                                                                                    <div class="form-group">
                                                                                           <input type="text" name="value" value="<?php echo $item['value'] ?>" class="form-control" maxlength="20">
                                                                                    </div>
                                                                             </td>
                                                                             <td>
                                                                                    <input type="submit" name="submit-update-<?php echo $item['attribute_value_id'] ?>" value="Update">
                                                                                    <input type="submit" name="cancel" value="Cancel">
                                                                             </td>
                                                                      <?php } else { ?>
                                                                             <td><?php echo $item['value'] ?></td>
                                                                             <td>
                                                                                    <input type="submit" name="submit-edit-<?php echo $item['attribute_value_id'] ?>" value="Edit">
                                                                                    <input type="submit" name="submit-delete-<?php echo $item['attribute_value_id']  ?>" value="Delete">
                                                                             </td>
                                                                      <?php  } ?>
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
                                                 <h3 class="section-title">Add new attribute value</h3>
                                          </div>
                                          <div class="section-detail">

                                                 <div>
                                                        <div class="form-group">
                                                               <label for="attribute-value" class="control-label">Name of attribute value</label>
                                                               <input type="text" name="attribute-value" id="attribute-value" class="form-control">
                                                        </div>
                                                        <div class="form-group">
                                                               <input type="submit" name="submit-add-val-0" value="Add a attribute value" maxlength="20">
                                                        </div>
                                                 </div>
                                          </div>
                                   </div>
                            </form>
                     </div>
              </div>
       </div>
</div>