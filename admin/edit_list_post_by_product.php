<div id="content-wp" class="clearfix">
    <?php include('includes/sidebar.html') ?>
    <div id="content" class="float-right">
        <div class="section list-posts-for-product">
            <div class="section-head">
                <h3 class="section-title">List post for <?php echo $phone_info['name'] ?></h3>
                <?php
                    if(isset($success_delete)){
                        echo '<div class="alert alert-success" role="alert">
                        This post deleted successfully
                      </div>';
                    }
                    if(isset($success_live)){
                        echo '<div class="alert alert-success" role="alert">
                        This post lived successfully
                      </div>';
                    }
                ?>
            </div>
            <div class="section-detail">
                <div id="filter-wp" class="clearfix">
                    <ul class="float-left">
                        <li <?php if ($status == 'all') echo "class='active'" ?>><a href="<?php echo BASE_URL ?>admin/edit_post_catalog.php?page=post&pId=<?php echo $product_id ?>&status=all">All<span class="count">(<?php echo $count_post['all'] ?>)</span></a> |</li>
                        <li <?php if ($status == 'live') echo "class='active'" ?>><a href="<?php echo BASE_URL ?>admin/edit_post_catalog.php?page=post&pId=<?php echo $product_id ?>&status=live">Live<span class="count">(<?php echo $count_post['live'] ?>)</span></a> |</li>
                        <li <?php if ($status == 'draft') echo "class='active'" ?>><a href="<?php echo BASE_URL ?>admin/edit_post_catalog.php?page=post&pId=<?php echo $product_id ?>&status=draft">Draft<span class="count">(<?php echo $count_post['draft'] ?>)</span></a> |</li>
                    </ul>
                    <div id="pagging" class="float-right">
                        <?php
                        if ($page > 5) {
                            $p = $page - 5;
                            $back_5 = "href='" . BASE_URL . "admin/edit_post_catalog.php?page=post&pId=$product_id&status=$status&p=$p'";
                        } else {
                            $back_5 = '';
                        }
                        if ($page > 1) {
                            $p = $page - 1;
                            $back_1 = "href='" . BASE_URL . "admin/edit_post_catalog.php?page=post&pId=$product_id&status=$status&p=$p'";
                        } else {
                            $back_1 = '';
                        }
                        if ($page < $num_page) {
                            $p = $page + 1;
                            $next_1 = "href='" . BASE_URL . "admin/edit_post_catalog.php?page=post&pId=$product_id&status=$status&p=$p'";
                        } else {
                            $next_1 = '';
                        }
                        if ($page < $num_page - 4) {
                            $p = $page + 5;
                            $next_5 = "href='" . BASE_URL . "admin/edit_post_catalog.php?page=post&pId=$product_id&status=$status&p=$p'";
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
                <form action="" method="POST">
                    <table>
                        <thead>
                            <th width='20%'>Title</th>
                            <th width='15%'>Author</th>
                            <th width='20%'>Image</th>
                            <th width='25%'>Description</th>
                            <th width='10%'>Date Created</th>
                            <th width='10%'>Actions</th>
                        </thead>

                        <tbody>
                            <?php if (!empty($list_post)) { ?>
                                <?php foreach ($list_post as $item) { ?>
                                    <tr>
                                        <td><p><?php echo $item['title'] ?></p></td>
                                        <td><?php echo $item['name'] ?></td>
                                        <td>
                                            <img src="../public/images/post/<?php echo $item['thumb'] ?>" alt="">
                                        </td>
                                        <td>
                                           <p> <?php echo $item['description'] ?></p>
                                        </td>
                                        <td><?php echo date_formate($item['date_created']) ?></td>
                                        <td>
                                            <?php
                                                if($item['status'] === 'draft'){
                                                    ?>
                                                     <button type="submit" name="submit-live-<?php echo $item['id'] ?>" class="btn-live">Live</button>
                                                    <?php
                                                }
                                            ?>
                                            <button type="submit" name="submit-delete-<?php echo $item['id'] ?>" class="btn-delete" onclick="return confirm('Are you sure you delete this post!')"><i class="fas fa-trash-alt"></i></button>
                                        </td>
                                    </tr>
                                <?php } ?>
                            <?php } else { ?>
                                <tr>
                                    <td colspan="7">
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