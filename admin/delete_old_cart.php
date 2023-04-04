<div id="content-wp" class="clearfix">
       <?php include('includes/sidebar.html') ?>
       <div id="content" class="float-right">
              <div class="section delete-old-cart">

                     <div class="section-head">
                            <h3 class="section-title">Admin users' shopping carts:</h3>
                            <?php
                            if (isset($message)) {
                                   echo "<div class='alert alert-success' role='alert'>$message</div>";
                            }
                            ?>
                     </div>

                     <div class="section-detail">
                            <form action="" method="POST">
                                   <div>
                                          <select name="days" id="" class="form-control">
                                                 <?php
                                                 foreach ($day_options as $key => $val) {
                                                        $selected = '';
                                                        if (isset($days) && $days == $key) {
                                                               $selected = 'selected';
                                                        }
                                                 ?>
                                                        <option value="<?php echo $key ?>" <?php echo $selected ?>><?php echo $val ?></option>
                                                 <?php } ?>
                                          </select>
                                          <input type="submit" name="submit-count" value="Count Old Shopping Carts">
                                          <input type="submit" name="submit-delete" value="Delete Old Shopping Carts">
                                   </div>
                            </form>
                     </div>
              </div>
       </div>
</div>