<?php if (!empty($list_featured_posts)) { ?>
    <div id="wp-featured-post">
        <div class="box featured-post">
            <div class="box-head">
                <h3>Featured Posts</h3>
            </div>
            <div class="box-body">
                <!-- <ul class="list-featured-post d-flex justify-content-between"> -->
                <ul class="list-featured-post slider">
                    <div class="owl-carousel owl-theme">
                        <?php foreach ($list_featured_posts as $item) { ?>
                            <li>
                                <a href="post/<?php echo create_slug($item['title']) ?>/<?php echo $item['id'] ?>" class="post-thumb">
                                    <img src="public/images/post/<?php echo $item['thumb'] ?>" alt="">
                                </a>
                                <a href="post/<?php echo create_slug($item['title']) ?>/<?php echo $item['id'] ?>" class="post-title">
                                    <?php echo $item['title'] ?>
                                </a>
                            </li>
                        <?php } ?>
                    </div>
                </ul>
            </div>
        </div>
    </div>
<?php } ?>
<!-- end featured-post -->
<!-- =================wp-content================== -->

<div class="d-flex">
    <!-- =================content================== -->
    <div id="content">
        <?php
        if (!empty($list_new_posts)) {
        ?>
            <div class="box">
                <div class="box new-post">
                    <!-- =================box-head================== -->
                    <div class="box-head">
                        <h3>New Post</h3>
                    </div>
                    <!-- =================box-body================== -->
                    <div class="box-body">
                        <ul class="list-post">
                            <?php
                            $count = 0;
                            foreach ($list_new_posts as $item) {
                                $count++;
                            ?>
                                <li>
                                    <a href="post/<?php echo create_slug($item['title']) ?>/<?php echo $item['id'] ?>" class="post-thumb">
                                        <img src="public/images/post/<?php echo $item['thumb'] ?>" alt="">
                                    </a>

                                    <div class="more-info">
                                        <a href="post/<?php echo create_slug($item['title']) ?>/<?php echo $item['id'] ?>   " class="post-title">
                                            <?php echo $item['title'] ?>
                                        </a>
                                        <div class="post-published">
                                            <span class="post-author"><?php echo $item['name'] ?></span>
                                            <span class="post-date"><?php echo time_ago($item['date_created']) ?></span>
                                        </div>
                                        <p class="post-excerpt"><?php echo $item['description'] ?></p>
                                    </div>
                                </li>
                            <?php } ?>
                            <a href="javascript:;" id="view-more-post" class="view-more" data-start="<?php echo $count ?>">View more <b></b></a>
                        </ul>
                    </div>
                </div>
            </div>
        <?php } ?>

    </div>

    <!-- end content -->
    <!-- =================sidebar================== -->
    <div id="sidebar">
        <?php
        if (!empty($list_post_most_comment)) {
        ?>
            <div class="box">
                <div class="box-head">
                    <h3>Posts Most Comment</h3>
                </div>
                <div class="box-body">
                    <ul id="list-post-most-comment">
                        <?php
                        foreach ($list_post_most_comment as $item) {
                        ?>
                            <li>
                                <a href="post/<?php echo create_slug($item['title']) ?>/<?php echo $item['id'] ?>">
                                    <h3><?php echo $item['title'] ?> <span class="more-comment">
                                            <i class="fas fa-comment-alt"></i><?php echo $item['num_comment'] ?>
                                        </span></h3>
                                </a>
                            </li>
                        <?php
                        }
                        ?>
                    </ul>
                </div>
            </div>
        <?php } ?>
        <?php
        if (!empty($list_post_by_new_product)) {
        ?>
            <div class="box">
                <div class="box-head">
                    <h3>Posts For New Product</h3>
                </div>
                <div class="box-body">
                    <ul id="list-post-top-new-product">
                        <?php
                        foreach ($list_post_by_new_product as $item) {
                        ?>
                            <li>
                                <a href="post/product/<?php echo create_slug($item['name']) ?>/<?php echo $item['id'] ?>">
                                    <img src="public/images/phone/<?php echo $item['thumb'] ?>" alt="">
                                    <h3><?php echo $item['name'] ?></h3>
                                    <p><?php echo currency_format($item['price']) ?></p>
                                    <label for=""><?php echo $item['num_post'] ?> Posts</label>
                                </a>
                            </li>
                        <?php
                        }
                        ?>
                    </ul>
                    <a href="post/new-product">See all posts for new product</a>
                </div>
            </div>
        <?php } ?>
        <?php
        if (!empty($list_most_view_post)) {
        ?>
            <div class="box">
                <div class="box-head">
                    <h3>Post Most View</h3>
                </div>
                <div class="box-body">
                    <ul class="list-post small most-view">
                        <?php foreach ($list_most_view_post as $item) { ?>
                            <li>
                                <a href="?mod=post&act=detail_post&postId=<?php echo $item['id'] ?>" class="post-thumb">
                                    <img src="public/images/post/<?php echo $item['thumb'] ?>" alt="">
                                </a>

                                <div class="more-info">
                                    <a href="?mod=post&act=detail_post&postId=<?php echo $item['id'] ?>" class="post-title">
                                        <?php echo $item['title'] ?>
                                    </a>
                                </div>
                                <label class="num-view"><i class="far fa-eye"></i> <?php  echo $item['num_view']  ?></label>
                            </li>
                        <?php } ?>
                    </ul>
                </div>
            </div>
        <?php } ?>

    </div> <!-- end sidebar -->
</div> <!-- end wp-content -->