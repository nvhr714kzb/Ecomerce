<div id="content-wp" class="clearfix">
       <?php include('includes/sidebar.html') ?>
       <div id="content" class="float-right">
              <div class="section">
                     <div class="section-head">
                            <h3 class="section-detail">Edit product attribute</h3>
                            <?php
                                   if(isset($success_add)){
                                          echo '<div class="alert alert-success" role="alert">
                                          Product updated successfully
                                        </div>';
                                   }
                            ?>
                     </div>
                     <div class="section-detail">
                            <form enctype="multipart/form-data" action="" method="POST">
                                   <div class="row">
                                          <div class="col-md-6">
                                                 <div class="form-group">
                                                        <label for="name" class="control-label">Product name:</label>
                                                        <input type="text" name="name" id="name" class="form-control" value="<?php echo $name ?>">
                                                        <?php
                                                        form_error('name', $update_product_errors);
                                                        ?>
                                                 </div>
                                                 <div class="form-group">
                                                        <label for="description" class="control-label"> Product description:</label>
                                                        <?php
                                                        form_error('description', $update_product_errors);
                                                        ?>
                                                        <textarea name="description" id="description" class="form-control" cols="30" rows="10"><?php echo $description  ?></textarea>

                                                 </div>
                                                 <div class="form-group">
                                                        <label for="upload-thumb" class="control-label">Thumbnail:</label>
                                                        <input type="file" name="thumb" id="upload-thumb" class="form-control-file">
                                                        <?php
                                                        form_error('thumb', $update_product_errors);
                                                        ?>
                                                        <img src="../public/images/phone/<?php echo $detail_product['thumb'] ?>" alt="" id="preview-thumb" width="400px" height="400px"><br>
                                                 </div>

                                                 <div class="form-group">
                                                        <label for="" class="control-label">Product price:</label>
                                                        <input type="number" name="price" class="form-control" value="<?php echo $price ?>" type="number">
                                                        <?php
                                                        form_error('price', $update_product_errors);
                                                        ?>
                                                 </div>
                                                 <div class="form-group">
                                                        <input type="submit" name="updateInfo" value="Update Info">
                                                 </div>
                                          </div>
                                          <div class="col-md-6">
                                                 <p>Product belongs to these categories: <?php echo ucwords(implode(', ', $list_categories_for_product)) ?></p>
                                                 <p>Remove this product from:</p>
                                                 <p>
                                                        <select name="targetCatRemove">
                                                               <?php foreach ($list_categories_for_product as $key => $val) { ?>
                                                                      <option value="<?php echo $key ?>"><?php echo $val ?></option>
                                                               <?php } ?>
                                                        </select>
                                                        <input type="submit" name="removeCat" value="Remove" <?php if ($num_cat == 1) echo 'disabled style="background-color: #bdc3c7"' ?>>
                                                 </p>
                                                 <!-- check empty -->
                                                 <?php if (!empty($list_categories_not_assign)) { ?>
                                                        <p>Assign product to this brand:</p>
                                                        <p>
                                                               <select name="targetCatAssign">
                                                                      <?php foreach ($list_categories_not_assign as $key => $val) { ?>
                                                                             <option value="<?php echo $key ?>"><?php echo $val ?></option>
                                                                      <?php } ?>
                                                               </select>
                                                               <input type="submit" name="assignCat" value="Assign">
                                                        </p>
                                                        <p>Move product to this brand:</p>
                                                        <p>
                                                               <select name="sourceCatMove">
                                                                      <?php foreach ($list_categories_for_product as $key => $val) { ?>
                                                                             <option value="<?php echo $key ?>"><?php echo $val ?></option>
                                                                      <?php } ?>
                                                               </select>
                                                               <span> To </span>
                                                               <select name="targetCatMove">
                                                                      <?php foreach ($list_categories_not_assign as $key => $val) { ?>
                                                                             <option value="<?php echo $key ?>"><?php echo $val ?></option>
                                                                      <?php } ?>
                                                               </select>
                                                               <input type="submit" name="moveCat" value="move">
                                                               <input type="submit" name="removeCatalog" value="Remove product from catalog" onclick="return confirm('Are your sure you delete this product ?')">
                                                        </p>
                                                 <?php } ?>

                                                 <?php if (!empty($product_attrs)) { ?>
                                                        <p>Remove Product attributes:</p>
                                                        <p>
                                                               <select name="targetAttrRemove">
                                                                      <?php foreach ($product_attrs as $item) { ?>
                                                                             <option value="<?php echo $item['attribute_value_id'] ?>"><?php echo ucwords($item['name']) ?>: <?php echo ucwords($item['value']) ?></option>
                                                                      <?php } ?>
                                                               </select>
                                                               <input type="submit" name="removeAttr" value="Remove">
                                                        </p>
                                                 <?php } ?>

                                                 <?php if (!empty($list_product_attrs_not_assign)) { ?>
                                                        <p>Assign Product attributes:</p>
                                                        <p>
                                                               <select name="targetAttrAssign">
                                                                      <?php foreach ($list_product_attrs_not_assign as $item) { ?>
                                                                             <option value="<?php echo $item['attribute_value_id'] ?>"><?php echo ucwords($item['name']) ?>: <?php echo ucwords($item['value']) ?></option>
                                                                      <?php } ?>
                                                               </select>
                                                               <input type="submit" name="assignAttr" value="Assign">
                                                        </p>
                                                 <?php } ?>
                                          </div>
                                   </div>
                                   <!-- <p>
                            Image name
                            <input type="file">
                            <input type="submit" value="Upload">
                     </p>
                     <p>
                            <img src="" alt="">
                     </p>
                     <p>
                            Image 2 name
                            <input type="file">
                            <input type="submit" value="Upload">
                     </p>
                     <p>
                            <img src="" alt="">
                     </p>
                     <p>
                            Thumbnail name:
                            <input type="file">
                            <input type="submit" value="Upload">
                     </p>
                     <p>
                            <img src="" alt="">
                     </p> -->
                            </form>
                     </div>
              </div>
       </div>
</div>