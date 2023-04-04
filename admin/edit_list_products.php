<div id="content-wp" class="clearfix">
       <?php include('includes/sidebar.html') ?>
       <div id="content" class="float-right">
              <?php if (!empty($error_message)) {
                     echo "<p class='error'>$error_message</p>";
              } ?>
              <div class="section">
                     <div class="section-head">
                            <h3 class="section-title">Edit product for brand: <?php echo get_detail_category($cat_id) ?></h3>
                     </div>
                     <div class="section-detail">
                            <form action="" method="POST">
                                   <table cellpadding="12">
                                          <thead>
                                                 <tr>
                                                        <th width="20%">Name</th>
                                                        <th width="10%">Image</th>
                                                        <th width="40%">Description</th>
                                                        <th width="10%">Price</th>
                                                        <th width="10%">Discount</th>
                                                        <th width="10%">Action</th>
                                                 </tr>
                                          </thead>
                                          <tbody>
                                                 <?php
                                                 if (!empty($list_products)) {
                                                        foreach ($list_products as $item) {
                                                 ?>
                                                               <tr>
                                                                      <td><?php echo $item['name'] ?></td>
                                                                      <td><img src="../public/images/phone/<?php echo $item['thumb'] ?>" alt=""></td>
                                                                      <td>
                                                                             <p><?php echo $item['description'] ?></p>
                                                                      </td>
                                                                      <td><?php echo currency_format($item['price']) ?></td>
                                                                      <td>
                                                                             <?php
                                                                             if (!empty($item['sale_price']))
                                                                                    echo  currency_format($item['sale_price']);
                                                                             else {
                                                                                    echo "No";
                                                                             }
                                                                             ?>
                                                                      </td>
                                                                      <td>
                                                                             <input type="submit" name="submit-edit-pro-<?php echo $item['id'] ?>" value="Edit">
                                                                      </td>
                                                               </tr>
                                                        <?php
                                                        }
                                                 } else {
                                                        ?>
                                                        <tr>
                                                               <td colspan="6">There is no record!</td>
                                                        </tr>
                                                 <?php
                                                 }
                                                 ?>
                                          </tbody>
                                   </table>
                            </form>
                     </div>
              </div>
       </div>
</div>