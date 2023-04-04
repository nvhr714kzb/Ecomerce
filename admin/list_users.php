 <?php
require('../includes/config.inc.php');
require('../lib/database.inc.php');
require('../lib/helper.inc.php');
require('lib/account_functions.inc.php');
require('../lib/user.inc.php');
require('../' . MYSQL);
require('includes/permission.php');
include('includes/header.html');

?>
<div id="content-wp" class="clearfix">
       <?php
       include('includes/sidebar.html');
       // ====================================Actions============================
       if (isset($_POST['smAction'])) {
              if (!empty($_POST['actions'])) {
                     if (in_array($_POST['actions'], ['delete', 'restore', 'forceDelete'])) {
                            $q = "UPDATE users SET";
                            if ($_POST['actions'] == 'delete') {
                                   $q .= " trashed = 1";
                            } elseif ($_POST['actions'] == 'restore') {
                                   $q .= " trashed = 0";
                            } elseif ($_POST['actions'] == 'forceDelete') {
                                   $q = "DELETE FROM users";
                            }
                            $q .= " WHERE id";
                            if (!empty($_POST['checkItem'])) {
                                   // ---Avoid delete yourself---
                                   foreach ($_POST['checkItem'] as $k => $id) {
                                          if ($_SESSION['user_id'] == $id) {
                                                 unset($_POST['checkItem'][$k]);
                                          }
                                          $_POST['checkItem'][$k] = (int)$id;
                                   }
                                   $list_user_id = implode(',', $_POST['checkItem']);
                                   $q .= " IN ($list_user_id)";
                                   db_query($q);
                            }
                     }
              }
       }
       // ==================================== Delete temp============================
       foreach ($_POST as $key => $value) {
              if (substr($key, 0, 6) == 'submit') {
                     $last_hyphen = strrpos($key, '-');
                     $action = substr($key, strlen('submit-'), $last_hyphen - strlen('submit-'));
                     $user_id = (int)substr($key, $last_hyphen + 1);
                     if ($action == 'delete') {
                            db_query("UPDATE users SET trashed = 1 WHERE id = $user_id");
                            $message = ' User has been trashed';
                     } elseif ($action == 'restore') {
                            db_query("UPDATE users SET trashed = 0 WHERE id = $user_id");
                            $message = ' User has been restored';
                     } elseif ($action == 'foredelete') {
                            db_query("DELETE FROM users WHERE id =  $user_id");
                            $message = ' User has been deleted';
                     }
                     break;
              }
       }
       // ==========================Query===============================
       $q = "SELECT id, type, email, username, name, trashed, date_created FROM users WHERE type >= 50";
       $status = !empty($_GET['status']) ? $_GET['status'] : 'all';
       if ($status  == 'active') {
              $q .= " AND trashed = 0";
       } elseif ($status == 'trash') {
              $q .= " AND trashed = 1";
       }
       $q .= " ORDER BY date_created DESC";
       // =========================Count==============================
       $count_user = array(
              'all' => count_all_user(),
              'active' => count_active_user(),
              'trash' => count_disabled_user()
       );
       // ==================Pagging=======================
       $page = isset($_GET['page']) && is_numeric($_GET['page'])  && $_GET['page'] > 0 ? $_GET['page'] : 1;
       $start_item = ($page - 1) * NUM_ITEMS_ADMIN;
       $num_page = ceil(count(db_fetch_array($q)) / NUM_ITEMS_ADMIN);

       $q .= " LIMIT $start_item, " . NUM_ITEMS_ADMIN . "";
       $list_users = db_fetch_array($q);

       // ============List action==================
       $list_acts = [];
       if (isset($_GET['status'])) {
              if ($_GET['status'] == 'active') {
                     $list_acts = [
                            'delete' => 'Trash'
                     ];
              } elseif ($_GET['status'] == 'trash') {
                     $list_acts = [
                            'restore' => 'Restore',
                            'forceDelete' => 'Delete'
                     ];
              }
       }
       ?>
       <div id="content" class="float-right">
              <div class="section list-user">
                     <div class="section-head">
                            <h3 class="section-title">List users</h3>
                            <a class="section-add" href="<?php echo BASE_URL ?>admin/add_user.php">Add user</a>
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
                                          <li <?php if ($status == 'all') echo "class='active'" ?>><a href="<?php echo BASE_URL ?>admin/list_users.php?status=all">All<span class="count">(<?php echo $count_user['all'] ?>)</span></a> |</li>
                                          <li <?php if ($status == 'active') echo "class='active'" ?>><a href="<?php echo BASE_URL ?>admin/list_users.php?status=active">Active<span class="count">(<?php echo $count_user['active'] ?>)</span></a> |</li>
                                          <li <?php if ($status == 'trash') echo "class='active'" ?>><a href="<?php echo BASE_URL ?>admin/list_users.php?status=trash">Disable<span class="count">(<?php echo $count_user['trash'] ?>)</span></a> |</li>
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
                                                        $back_5 = "href='" . BASE_URL . "admin/list_users.php?status=$status&page=$p'";
                                                 } else {
                                                        $back_5 = '';
                                                 }
                                                 if ($page > 1) {
                                                        $p = $page - 1;
                                                        $back_1 = "href='" . BASE_URL . "admin/list_users.php?status=$status&page=$p'";
                                                 } else {
                                                        $back_1 = '';
                                                 }
                                                 if ($page < $num_page) {
                                                        $p = $page + 1;
                                                        $next_1 = "href='" . BASE_URL . "admin/list_users.php?status=$status&page=$p'";
                                                 } else {
                                                        $next_1 = '';
                                                 }
                                                 if ($page < $num_page - 4) {
                                                        $p = $page + 5;
                                                        $next_5 = "href='" . BASE_URL . "admin/list_users.php?status=$status&page=$p'";
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

                                   <table>
                                          <thead>
                                                 <th width='5%'><input type="checkbox" name="checkAll" id="checkAll"></th>
                                                 <th width='10%'>Name</th>
                                                 <th width='25%'>Email</th>
                                                 <th width='20%'>Privilege</th>
                                                 <th width='20%'>Date created</th>
                                                 <th width='20%'>Actions</th>
                                          </thead>

                                          <tbody>
                                                 <?php if (!empty($list_users)) { ?>
                                                        <?php foreach ($list_users as $item) { ?>
                                                               <tr>
                                                                      <td><input type="checkbox" name="checkItem[]" class="checkItem" value="<?php echo $item['id'] ?>"></td>
                                                                      <td><?php echo $item['name'] ?></td>
                                                                      <td>
                                                                             <?php echo $item['email'] ?>
                                                                      </td>
                                                                      <td>
                                                                             <?php echo get_type_of_user($item['type'])['type'] ?>
                                                                      </td>
                                                                      <td><?php echo date_formate($item['date_created']) ?></td>
                                                                      <td>
                                                                             <a href="edit_user.php?userId=<?php echo $item['id'] ?>" class="btn-edit"><i class="fas fa-user-edit"></i></a>
                                                                             <?php
                                                                             if ($_SESSION['user_id'] != $item['id'] && $item['trashed'] == 0) {
                                                                             ?>
                                                                                    <button type="submit" name="submit-delete-<?php echo $item['id'] ?>" class="btn-delete"><i class="fas fa-trash-alt"></i></button>
                                                                             <?php
                                                                             }
                                                                             ?>
                                                                             <?php
                                                                             if ($_SESSION['user_id'] != $item['id'] && $item['trashed'] == 1) {
                                                                             ?>
                                                                                    <button type="submit" name="submit-restore-<?php echo $item['id'] ?>" class="btn-restore"><i class="fas fa-trash-restore-alt"></i></button>
                                                                                    <button type="submit" name="submit-foredelete-<?php echo $item['id'] ?>" class="btn-restore" onclick="return confirm('Are you sure you delete it ?')"><i class="fas fa-user-slash"></i></button>
                                                                             <?php
                                                                             }
                                                                             ?>

                                                                      </td>
                                                               </tr>
                                                        <?php } ?>
                                                 <?php } else { ?>
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