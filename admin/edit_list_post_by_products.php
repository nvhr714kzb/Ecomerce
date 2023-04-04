<div id="content-wp" class="clearfix">
    <?php include('includes/sidebar.html') ?>
    <div id="content" class="float-right">
        <div class="section">
            <div class="section-head">
                <h3 class="section-title">List posts by products:</h3>
                <a class="section-add" href="<?php echo BASE_URL ?>admin/add_post.php">Add post</a>
                <?php
                    if(isset($success_delete)){
                        echo '<div class="alert alert-success" role="alert">
                        These posts deleted successfully
                      </div>';
                    }
                ?>
            </div>
            <div class="section-detail">
                <form action="" method="POST" enctype="multipart/form-data">
                    <table cellpadding="12">
                        <thead>
                            <tr>
                                <th width='20%'>Name</th>
                                <th width='10%'>Image</th>
                                <th width='35%'>Quantity post</th>
                                <th width='30%'>Actions</th>
                            </tr>
                        </thead>
                        <?php
                        if (!empty($list_post)) {
                            foreach ($list_post as $item) {
                        ?>
                                <tr>
                                    <td><?php echo $item['name'] ?></td>
                                    <td><img src="../public/images/phone/<?php echo $item['thumb'] ?>" alt=""></td>
                                    <td>
                                        <p><?php echo $item['num_post'] ?></p>
                                    </td>
                                    <td>
                                        <input type="submit" name="submit-view-posts-<?php echo $item['id'] ?>" value="View Posts">
                                        <input type="submit" name="submit-delete-posts-<?php echo $item['id'] ?>" value="Delete Posts" onclick="return confirm('Are you sure you delete these posts!')">
                                    </td>

                                </tr>
                            <?php } ?>
                        <?php } else {
                        ?>
                            <tr>
                                <td colspan="4">There is no record!</td>
                            </tr>
                        <?php
                        } ?>
                    </table>
                </form>
            </div>
        </div>

    </div>
</div>