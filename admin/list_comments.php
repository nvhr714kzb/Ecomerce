<?php
require('../includes/config.inc.php');
require('../lib/database.inc.php');
require('../lib/helper.inc.php');
require('lib/post_functions.inc.php');
require('lib/comment_functions.inc.php');
require('../lib/user.inc.php');
require('../' . MYSQL);
require('includes/permission.php');
include('includes/header.html');

if (!isset($_SESSION['user_type']) || !is_valid_user_type($_SESSION['user_type'], 50)) {
       redirect('login.php');
}
?>
<div id="content-wp" class="clearfix">
       <?php
       include('includes/sidebar.html');
       // ====================================Post actions============================
       if (isset($_POST['smAction'])) {
              if (!empty($_POST['checkItem'])) {
                     if (in_array($_POST['actions'], [1, 2, 3, 4, 5])) {
                            $q = "UPDATE comments SET";
                            switch ($_POST['actions']) {
                                   case 1:
                                          $q .= " approved = 1";
                                          break;
                                   case 2:
                                          $q .= " trashed = 1";
                                          break;
                                   case 3:
                                          $q .= " trashed = 0";
                                          break;
                                   case 4:
                                          $q = "DELETE FROM comments ";
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
       // ====================================Post update============================
       foreach ($_POST as $key => $value) {
              if (substr($key, 0, 6) == 'submit') {
                     $last_hyphen = strrpos($key, '-');
                     $action = substr($key, strlen('submit-'), $last_hyphen - strlen('submit-'));
                     $comment_id = (int)substr($key, $last_hyphen + 1);
                     if ($action == 'approved') {
                            db_query("UPDATE comments SET approved = 1 WHERE id = $comment_id");
                            $message = ' Comment has been approved';
                     } elseif ($action == 'trash') {
                            db_query("UPDATE comments SET trashed = 1 WHERE id = $comment_id");
                            $message = ' Comment has been trashed';
                     } elseif ($action == 'restore') {
                            db_query("UPDATE comments SET trashed = 0 WHERE id = $comment_id");
                            $message = ' Comment has been restored';
                     } elseif ($action == 'delete') {
                            db_query("DELETE FROM comments  WHERE id = $comment_id");
                            $message = ' Comment has been deleted';
                     }
                     break;
              }
       }
       // ==========================Query===============================
       $q = "SELECT c.id, c.parent_comment_id, c.comment, c.user_id, c.approved, c.approved, c.trashed, c.post_id, c.date_created, u.name, p.title FROM comments c
       INNER JOIN users u ON c.user_id = u.id INNER JOIN posts p ON c.post_id = p.id";
       $status = !empty($_GET['status']) ? $_GET['status'] : 'all';
       if ($status  == 'pending') {
              $q .= " AND c.approved = 0 AND c.trashed = 0";
       } elseif ($status  == 'approved') {
              $q .= " AND c.approved = 1 AND c.trashed = 0";
       } elseif ($status  == 'trashed') {
              $q .= " AND c.approved = 1 AND c.trashed = 1";
       }
       $q .= " ORDER BY date_created DESC";
       // =========================Count==============================
       $count_comment = array(
              'all' => count_all_comment(),
              'pending' => count_pending_comment(),
              'approved' => count_approved_comment(),
              'trashed' => count_trash_comment()
       );
       // ==================Pagging=======================
       $page = isset($_GET['page']) && is_numeric($_GET['page'])  && $_GET['page'] > 0 ? $_GET['page'] : 1;
       $start_item = ($page - 1) * NUM_ITEMS_ADMIN;
       $num_page = ceil(count(db_fetch_array($q)) / NUM_ITEMS_ADMIN);

       $q .= " LIMIT $start_item, " . NUM_ITEMS_ADMIN . "";
       $list_comments = db_fetch_array($q);
       // ============List action==================
       $list_acts = [];
       if (isset($_GET['status'])) {
              if ($_GET['status'] == 'approved') {
                     $list_acts = [
                            2 => 'Trash'
                     ];
              } elseif ($_GET['status'] == 'pending') {
                     $list_acts = [
                            1 => 'Approve',

                     ];
              } elseif ($_GET['status'] == 'trashed') {
                     $list_acts = [
                            4 => 'Delete',
                            3 => 'Restore'
                     ];
              }
       }
       ?>
       <div id="content" class="float-right">
              <div class="section list-comment">
                     <div class="section-head">
                            <h3 class="section-title">List Comments</h3>
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
                                          <li <?php if ($status == 'all') echo "class='active'" ?>><a href="<?php echo BASE_URL ?>admin/list_comments.php">All <span class="count">(<?php echo $count_comment['all'] ?>)</span></a> |</li>
                                          <li <?php if ($status == 'pending') echo "class='active'" ?>><a href="<?php echo BASE_URL ?>admin/list_comments.php?status=pending">Pending <span class="count">(<?php echo $count_comment['pending'] ?>)</span></a> |</li>
                                          <li <?php if ($status == 'approved') echo "class='active'" ?>><a href="<?php echo BASE_URL ?>admin/list_comments.php?status=approved">Approved <span class="count">(<?php echo $count_comment['approved'] ?>)</span></a> |</li>
                                          <li <?php if ($status == 'trashed') echo "class='active'" ?>><a href="<?php echo BASE_URL ?>admin/list_comments.php?status=trashed">Trash <span class="count">(<?php echo $count_comment['trashed'] ?>)</span></a> |</li>
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
                                                        $back_5 = "href='" . BASE_URL . "admin/list_comments.php?status=$status&page=$p'";
                                                 } else {
                                                        $back_5 = '';
                                                 }
                                                 if ($page > 1) {
                                                        $p = $page - 1;
                                                        $back_1 = "href='" . BASE_URL . "admin/list_comments.php?status=$status&page=$p'";
                                                 } else {
                                                        $back_1 = '';
                                                 }
                                                 if ($page < $num_page) {
                                                        $p = $page + 1;
                                                        $next_1 = "href='" . BASE_URL . "admin/list_comments.php?status=$status&page=$p'";
                                                 } else {
                                                        $next_1 = '';
                                                 }
                                                 if ($page < $num_page - 4) {
                                                        $p = $page + 5;
                                                        $next_5 = "href='" . BASE_URL . "admin/list_comments.php?status=$status&page=$p'";
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
                                                 <th width='15%'>Author</th>
                                                 <th width='40%'>Comment</th>
                                                 <th width='25%'>In Response To</th>
                                                 <th width='15%'>Submitted On</th>
                                          </thead>

                                          <tbody>
                                                 <?php
                                                 if (!empty($list_comments)) {
                                                        foreach ($list_comments as $item) {
                                                 ?>
                                                               <tr>
                                                                      <td><input type="checkbox" name="checkItem[]" class="checkItem" value="<?php echo $item['id'] ?>"></td>
                                                                      <td><?php echo $item['name'] ?></td>
                                                                      <td>
                                                                             <p><?php echo htmlspecialchars($item['comment']) ?></p>
                                                                             <div class="actions">
                                                                                    <?php if ($item['approved'] == 0 && $item['trashed'] == 0) { ?>
                                                                                           <button type="submit" name="submit-approved-<?php echo $item['id'] ?>">Approve</button>
                                                                                    <?php } elseif ($item['approved'] == 1 && $item['trashed'] == 0) { ?>
                                                                                           <button type="submit" name="submit-trash-<?php echo $item['id'] ?>">Trash</button>
                                                                                    <?php } ?>

                                                                                    <?php if ($item['trashed'] == 1 && $item['approved'] == 1) { ?>
                                                                                           <button type="submit" name="submit-delete-<?php echo $item['id'] ?>" onclick="return confirm('Are you sure you delete it ?')">Delete</button>
                                                                                           <button type="submit" name="submit-restore-<?php echo $item['id'] ?>">Restore</button>
                                                                                    <?php } else { ?>

                                                                                    <?php } ?>
                                                                             </div>
                                                                      </td>
                                                                      <td>
                                                                             <p><?php echo $item['title'] ?></p>
                                                                             <a href="<?php echo BASE_URL ?>?mod=post&act=detail_post&postId=<?php echo $item['post_id'] ?>">View post</a>
                                                                      </td>
                                                                      <td><?php echo date_formate( $item['date_created']) ?></td>
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
