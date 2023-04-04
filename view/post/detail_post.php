<article>
       <div id="post-detail">
              <h1 class="title-detail"><?php echo htmlspecialchars($detail_post['title']) ?></h1>
              <div class="user-detail">
                     <span class="profile"><?php echo $detail_post['name'] ?></span>
                     <span><?php echo time_ago($detail_post['date_created']) ?></span>
                     <span><?php echo $detail_post['num_view'] ?> views</span>
                     <a href="<?php echo BASE_URL ?>post/<?php echo create_slug( $detail_post['title']) ?>/<?php echo $post_id ?>#list-comment"><i class="fas fa-comment-alt"></i> <?php echo $num_comment; ?> comments</a>
              </div>
              <div class="content-detail">
                     <?php echo $detail_post['content'] ?>
              </div>
       </div>
       <div id="post-like-share" class="fb-like" data-href="<?php echo cur_page_url(); ?>" data-width="" data-layout="standard" data-action="like" data-size="small" data-share="true"></div>
       <div id="wp-comment">
              <?php
              if (is_login()) {
              ?>
                     <form action="" method="POST" class="comment-form clearfix">
                            <textarea name="commentContent" id="box-comment" rows="7" placeholder=" Enter your comment" maxlength="1000"></textarea>
                            <input type="hidden" name="commentId" value="0">
                            <input type="submit" value="Add a comment" name="addComment" class="float-right">
                     </form>
              <?php } else { ?>
                     <p>You must log in to add a comment</p>
              <?php } ?>
              <h5><?php echo $num_comment; ?> Comments</h5>
              <div id="list-comment">
                     <?php foreach ($list_comment_ask as $itemParent) { ?>
                            <div class="comment-ask">
                                   <div class="user-info">
                                          <img class="avatar" src="public/images/avatar/<?php echo $itemParent['avatar'] ?>" alt="" width="30px">
                                          <strong class="name"><?php echo $itemParent['name'] ?></strong>
                                          <?php
                                          if ($itemParent['type'] >= 50) {
                                          ?>
                                                 <b class="admin">Admin</b>
                                          <?php
                                          }
                                          ?>
                                   </div>
                                   <p class="comment-content">
                                          <?php echo htmlspecialchars($itemParent['comment']) ?>
                                   </p>
                                   <div class="relate-info-comment">
                                          <span class="reply reply-parent" data-index="<?php echo $itemParent['id'] ?>">Reply</span>
                                          <b class="dot">.</b>
                                          <!-- Change color if exist  -->
                                          <?php
                                          if (is_login() && is_user_has_already_like_comment($itemParent['id'], $_SESSION['user_id'])) {
                                          ?>
                                                 <span class="num-like" style="color: gray;" data-id="<?php echo $itemParent['id'] ?>">Like (<?php echo count_like_comment($itemParent['id']) ?>)</span>
                                          <?php
                                          } else {
                                          ?>
                                                 <span class="num-like" data-id="<?php echo $itemParent['id'] ?>">Like (<?php echo count_like_comment($itemParent['id']) ?>)</span>
                                          <?php
                                          }
                                          ?>

                                          <span class="date"><?php echo time_ago($itemParent['date_created']) ?></span>
                                   </div>
                            </div>


                            <?php
                            if (!empty(get_list_comments_reply($itemParent['id'], $_GET['postId']))) {
                            ?>
                                   <div class="comment-reply">
                                          <?php foreach (get_list_comments_reply($itemParent['id'], $_GET['postId']) as $itemChild) { ?>
                                                 <div class="comment-ask">
                                                        <div class="user-info">
                                                               <img class="avatar" src="public/images/avatar/<?php echo $itemParent['avatar'] ?>" alt="" width="30px">
                                                               <strong><?php echo $itemChild['name'] ?></strong>
                                                               <?php
                                                               if ($itemChild['type'] >= 50) {
                                                               ?>
                                                                      <b class="admin">Admin</b>
                                                               <?php
                                                               }
                                                               ?>
                                                        </div>
                                                        <p class="comment-content">
                                                               <?php echo htmlspecialchars($itemChild['comment']) ?>
                                                        </p>
                                                        <div class="relate-info-comment">
                                                               <span class="reply reply-child" data-index="<?php echo $itemParent['id'] ?>">Reply</span>
                                                               <b class="dot">.</b>
                                                               <!-- Change color if exist  -->
                                                               <?php
                                                               if (is_login() && is_user_has_already_like_comment($itemChild['id'], $_SESSION['user_id'])) {
                                                               ?>
                                                                      <span class="num-like" style="color: gray;" data-id="<?php echo $itemChild['id'] ?>">Like (<?php echo count_like_comment($itemChild['id']) ?>)</span>
                                                               <?php
                                                               } else {
                                                               ?>
                                                                      <span class="num-like" data-id="<?php echo $itemChild['id'] ?>">Like (<?php echo count_like_comment($itemChild['id']) ?>)</span>
                                                               <?php
                                                               }
                                                               ?>
                                                               <span class="date"><?php echo time_ago($itemChild['date_created']) ?></span>
                                                        </div>
                                                 </div>
                                          <?php } ?>
                                   </div>
                            <?php
                            }
                            ?>

                     <?php } ?>
                     <!-- ================================= -->

              </div>
       </div>
</article>