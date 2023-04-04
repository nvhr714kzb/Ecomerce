<div id="content">
       <div id="ship-address" class="float-left">
              <h3>Choose a shipping address</h3>
              <form action="" method="POST">
                     <div class="box ship">
                            <div class="box-head">
                                   <span>Your addresses</span>
                            </div>
                            <div class="box-body">
                                   <ul class="list-address">
                                          <?php
                                          if (!empty($list_address)) {
                                                 foreach ($list_address as $item) {
                                          ?>
                                                        <li class="item-address">
                                                               <label>
                                                                      <div class="address">
                                                                             <input type="radio" name="addressId" value="<?php echo $item['id'] ?>">
                                                                             <span><b><?php echo $item['first_name'] . ' ' . $item['last_name'] ?></b> <?php echo $item['address1'] . ', ' . $item['address2'] . ', ' . $item['city'] . ', ' . $item['state'] . ', ' . $item['zip'] . ', ' . $item['country'] ?></span>
                                                                      </div>
                                                                      <div class="edit-address">
                                                                             <a href="?mod=checkout&act=edit_address&addressId=<?php echo $item['id'] ?>" style="display: inline-block;">Edit</a>
                                                                             <input type="submit" name="submit-delete-<?php echo $item['id'] ?>" value="Delete">
                                                                      </div>
                                                                      <input type="hidden" name="first_name[<?php echo $item['id'] ?>]" value="<?php echo $item['first_name'] ?>">
                                                                      <input type="hidden" name="last_name[<?php echo $item['id'] ?>]" value="<?php echo $item['last_name'] ?>">
                                                                      <input type="hidden" name="address1[<?php echo $item['id'] ?>]" value="<?php echo $item['address1'] ?>">
                                                                      <input type="hidden" name="address2[<?php echo $item['id'] ?>]" value="<?php echo $item['address2'] ?>">
                                                                      <input type="hidden" name="city[<?php echo $item['id'] ?>]" value="<?php echo $item['city'] ?>">
                                                                      <input type="hidden" name="state[<?php echo $item['id'] ?>]" value="<?php echo $item['state'] ?>">
                                                                      <input type="hidden" name="zip[<?php echo $item['id'] ?>]" value="<?php echo $item['zip'] ?>">

                                                               </label>
                                                        </li>
                                                 <?php }
                                          } else {
                                                 ?>
                                                 <p>List of address is empty. Please add new address</p>
                                          <?php
                                          }
                                          ?>
                                   </ul>
                                   <?php if (count($list_address) < 5) { ?>
                                          <div class="add-address">
                                                 <a href="?mod=checkout&act=add_address"><i class="fas fa-plus"></i> Add a new address</a>

                                          </div>
                                   <?php } ?>

                            </div>

                            <?php if (!empty($list_address)) { ?>
                                   <div class="box-bottom">
                                          <div class="form-group">
                                                 <legend for="">Is this address also your billing address (the address that appears on your credit card or bank statement)?</legend>
                                                 <label><input type="radio" name="use" checked class="no-style" value="Y" <?php if (isset($_POST['use'])) echo "checked = 'checked'" ?>><span class="radio-label">Yes</span></label>
                                                 <label><input type="radio" name="use" class="no-style" value="N" <?php if (isset($_POST['use'])) echo "checked = 'checked'" ?>><span class="radio-label">No (If not, we'll ask you for it in a moment.)</span></label>
                                          </div>
                                          <div class="form-group">
                                                 <input type="submit" name="submit-use-0" value="Use this address" class="btn-yellow">
                                          </div>
                                          <?php
                                          if (isset($message_address)) {
                                                 echo "<div class='alert alert-danger' role='alert'>
                                                 $message_address
                                               </div>";
                                          }
                                          ?>
                                   </div>
                            <?php }
                            ?>

                     </div>
              </form>
       </div>
       <?php include('view/checkout/checkout_cart.php'); ?>
</div>