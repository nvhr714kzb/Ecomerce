<?php
require('../includes/config.inc.php');
require('../lib/database.inc.php');
require('../lib/helper.inc.php');
require('lib/slider_functions.inc.php');
require('../lib/user.inc.php');
require('../' . MYSQL);
require('includes/permission.php');
include('includes/header.html');

?>
<div id="content-wp" class="clearfix">
       <?php
       include('includes/sidebar.html');
       // ====================================POST ACTION============================
       if (isset($_POST['smAction'])) {
              if (!empty($_POST['checkItem'])) {
                     if (in_array($_POST['actions'], ['trash', 'restore', 'delete'])) {
                            $q = "UPDATE slider SET";
                            switch ($_POST['actions']) {
                                   case 'trash':
                                          $q .= " trashed = 1";
                                          break;
                                   case 'restore':
                                          $q .= " trashed = 0";
                                          break;
                                   case 'delete':
                                          $q = "DELETE FROM slider ";
                                          break;
                            }
                            $q .= " WHERE id";
                            //validation
                            foreach ($_POST['checkItem'] as $key => $value) {
                                   $_POST['checkItem'][$key] = (int)$value;
                            }
                            $list_comment_id = implode(',', $_POST['checkItem']);
                            $q .= " IN ($list_comment_id)";
                            db_query($q);
                     }
              }
       }
       // ====================================POST UPDATE============================
       $item_edit = 0;
       foreach ($_POST as $key => $value) {
              if (substr($key, 0, 6) == 'submit') {
                     $last_hyphen = strrpos($key, '-');
                     $action = substr($key, strlen('submit-'), $last_hyphen - strlen('submit-'));
                     $slider_id = (int)substr($key, $last_hyphen + 1);
                     if ($action == 'trash') {
                            db_query("UPDATE slider SET trashed = 1 WHERE id = $slider_id");
                            $message = ' Slider has been trashed';
                     } elseif ($action == 'restore') {
                            db_query("UPDATE slider SET trashed = 0 WHERE id = $slider_id");
                            $message = ' Slider has been restored';
                     }elseif($action == 'update'){
                           $url = filter_var($_POST['link'], FILTER_SANITIZE_URL);
                           if(filter_var($url, FILTER_VALIDATE_URL) && filter_var($_POST['order'], FILTER_VALIDATE_INT, array('min_range' => 1))){
                                   db_query("UPDATE slider SET link =  '$url', order_slider =  {$_POST['order']} WHERE id = $slider_id");
                                   $message = ' Slider has been updated';
                           }

                     }elseif ($action == 'delete') {
                            db_query("DELETE FROM slider  WHERE id = $slider_id");
                            $message = ' Slider has been deleted';
                     } elseif ($action == 'edit') {
                            $item_edit = $slider_id;
                            // redirect("edit_slider.php?id=$slider_id");
                     }
                     break;
              }
       }
       // ==========================QUERRY===============================
       $q = "SELECT id, name, description, link, image, order_slider, date_created, trashed FROM slider";
       $status = !empty($_GET['status']) ? $_GET['status'] : 'all';
       if ($status  == 'active') {
              $q .= " WHERE trashed = 0";
       } else
       if ($status  == 'trashed') {
              $q .= " WHERE trashed = 1";
       }
       $q .= " ORDER BY date_created DESC";
       // =========================COUNT==============================
       $count_review = array(
              'all' => count_all_slider(),
              'active' => count_status_slider(0),
              'trashed' => count_status_slider(1)
       );
       // ==================PAGGING=======================
       $page = isset($_GET['page']) ? (int)$_GET['page'] : 1;
       $start_item = ($page - 1) * NUM_ITEMS_ADMIN;
       $num_page = ceil(count(db_fetch_array($q)) / NUM_ITEMS_ADMIN);

       $q .= " LIMIT $start_item, " . NUM_ITEMS_ADMIN . "";
       $list_sliders = db_fetch_array($q);
       // ============List action==================
       $list_acts = [];
       if (isset($_GET['status'])) {
              if ($_GET['status'] == 'active') {
                     $list_acts = [
                            'trash' => 'Trash'
                     ];
              } elseif ($_GET['status'] == 'trashed') {
                     $list_acts = [
                            'restore' => 'Restore',
                            'delete' => 'Delete'
                     ];
              }
       }
       ?>
       <div id="content" class="float-right">
              <div class="section">
                     <div class="section-head">
                            <h3 class="section-title">List Slider</h3>
                            <a href="add_slider.php" class="section-add">Add a slider</a>
                            <?php
                                   if(isset($message)){
                                          echo '<div class="alert alert-success" role="alert">
                                          '.$message.'
                                        </div>';
                                   }
                            ?>
                     </div>
                     <div class="section-detail">

                            <div id="filter-wp">
                                   <ul>
                                          <li <?php if ($status == 'all') echo "class='active'" ?>><a href="<?php echo BASE_URL ?>admin/list_sliders.php">All <span class="count">(<?php echo $count_review['all'] ?>)</span></a> |</li>
                                          <li <?php if ($status == 'active') echo "class='active'" ?>><a href="<?php echo BASE_URL ?>admin/list_sliders.php?status=active">Active<span class="count">(<?php echo $count_review['active'] ?>)</span></a> |</li>
                                          <li <?php if ($status == 'trashed') echo "class='active'" ?>><a href="<?php echo BASE_URL ?>admin/list_sliders.php?status=trashed">Trash <span class="count">(<?php echo $count_review['trashed'] ?>)</span></a> |</li>
                                   </ul>
                            </div>

                            <form action="" method="POST">
                                   <div id="action-wp" class="clearfix">
                                          <div id="actions" class="float-left">
                                                 <select name="actions">
                                                        <option value="">---Actions---</option>
                                                        <?php foreach ($list_acts as $key => $value) { ?>
                                                               <option value="<?php echo $key ?>"><?php echo $value ?></option>
                                                        <?php } ?>
                                                 </select>
                                                 <input type="submit" name="smAction" value="Apply">
                                          </div>
                                          <div id="pagging" class="float-right">
                                                 <?php
                                                 if ($page > 5) {
                                                        $p = $page - 5;
                                                        $back_5 = "href='" . BASE_URL . "admin/list_sliders.php?status=$status&page=$p'";
                                                 } else {
                                                        $back_5 = '';
                                                 }
                                                 if ($page > 1) {
                                                        $p = $page - 1;
                                                        $back_1 = "href='" . BASE_URL . "admin/list_sliders.php?status=$status&page=$p'";
                                                 } else {
                                                        $back_1 = '';
                                                 }
                                                 if ($page < $num_page) {
                                                        $p = $page + 1;
                                                        $next_1 = "href='" . BASE_URL . "admin/list_sliders.php?status=$status&page=$p'";
                                                 } else {
                                                        $next_1 = '';
                                                 }
                                                 if ($page < $num_page - 4) {
                                                        $p = $page + 5;
                                                        $next_5 = "href='" . BASE_URL . "admin/list_sliders.php?status=$status&page=$p'";
                                                 } else {
                                                        $next_5 = '';
                                                 } ?>
                                                 <a <?php echo $back_5 ?>><i class="fas fa-chevron-double-left"></i></a>
                                                 <a <?php echo $back_1 ?>><i class="far fa-chevron-left"></i></a>
                                                 <span><?php echo $page ?> / <?php echo $num_page ?></span>
                                                 <a <?php echo $next_1 ?>><i class="far fa-chevron-right"></i></a>
                                                 <a <?php echo $next_5 ?>><i class="fas fa-chevron-double-right"></i></a>
                                          </div>
                                   </div>

                                   <table id="table">
                                          <thead>
                                                 <th width='5%'><input type="checkbox" name="checkAll" id="checkAll"></th>
                                                 <th width='30%'>Image</th>
                                                 <th width='25%'>Link</th>
                                                 <th width='10%'>Order</th>
                                                 <th width='10%'>Date created</th>
                                                 <th width='20%'>Actions</th>
                                          </thead>

                                          <tbody>

                                                 <?php
                                                 if (!empty($list_sliders)) {
                                                        foreach ($list_sliders as $item) {
                                                 ?>
                                                               <tr>
                                                                      <td><input type="checkbox" name="checkItem[]" class="checkItem" value="<?php echo $item['id'] ?>"></td>
                                                                      <td><img src="../public/images/slider/<?php echo $item['image']  ?>" alt=""></td>
                                                                      <?php
                                                                      if ($item_edit == $item['id']) {
                                                                      ?>

                                                                             <td>
                                                                                    <div class="form-group">
                                                                                           <input type="text" name="link" value=" <?php echo $item['link'] ?>" class="form-control">
                                                                                    </div>
                                                                             </td>
                                                                             <td>
                                                                                    <div class="form-group">
                                                                                           <input type="number" name="order" value="<?php echo $item['order_slider'] ?>" class="form-control">
                                                                                    </div>
                                                                             </td>
                                                                             <td>
                                                                                    <?php echo date_formate($item['date_created']) ?>
                                                                             </td>
                                                                             <td>
                                                                                    <?php if ($item['trashed'] == 0) { ?>
                                                                                           <input type="submit" name="submit-trash-<?php echo $item['id'] ?>" value="Trash">
                                                                                    <?php } else {
                                                                                    ?>
                                                                                           <input type="submit" name="submit-restore-<?php echo $item['id'] ?>" value="Restore">
                                                                                           <input type="submit" name="submit-delete-<?php echo $item['id'] ?>" value="Delete" onclick="return confirm('Are you sure you delete it?')">
                                                                                    <?php
                                                                                    } ?>
                                                                                    <input type="submit" name="submit-update-<?php echo $item['id'] ?>" value="Update">
                                                                                    <input type="submit" name="cancel" value="Cancel">
                                                                             </td>
                                                                      <?php
                                                                      } else {
                                                                      ?>
                                                                             <td>
                                                                                    <?php echo $item['link'] ?>
                                                                             </td>
                                                                             <td>
                                                                                    <?php echo $item['order_slider'] ?>
                                                                             </td>
                                                                             <td>
                                                                                    <?php echo date_formate( $item['date_created']) ?>
                                                                             </td>
                                                                             <td>
                                                                                    <?php if ($item['trashed'] == 0) { ?>
                                                                                           <input type="submit" name="submit-trash-<?php echo $item['id'] ?>" value="Trash">
                                                                                    <?php } else {
                                                                                    ?>
                                                                                           <input type="submit" name="submit-restore-<?php echo $item['id'] ?>" value="Restore">
                                                                                           <input type="submit" name="submit-delete-<?php echo $item['id'] ?>" value="Delete" onclick="return confirm('Are you sure you delete it?')">
                                                                                    <?php
                                                                                    } ?>
                                                                                    <input type="submit" name="submit-edit-<?php echo $item['id'] ?>" value="Edit">
                                                                             </td>

                                                                      <?php
                                                                      }

                                                                      ?>

                                                               </tr>
                                                        <?php
                                                        }
                                                 } else {
                                                        ?>
                                                        <tr>
                                                               <td colspan="6">
                                                                      There is no record!
                                                               </td>
                                                        </tr>
                                                 <?php } ?>
                                          </tbody>
                                   </table>
                            </form>
                     </div>
              </div>


       </div>
</div>