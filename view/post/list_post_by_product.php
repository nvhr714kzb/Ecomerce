<div class="d-flex">
    <!-- =================content================== -->
    <div id="content">
        <?php
        if (!empty($list_post_by_product)) {
        ?>
            <div class="box">
                <div class="box">
                    <!-- =================box-head================== -->
                    <div class="box-head">
                        <h3>List Posts for <?php echo $phone_info['name']  ?></h3>
                    </div>
                    <!-- =================box-body================== -->
                    <div class="box-body">
                        <ul class="list-post">
                            <?php
                            $count = 0;
                            foreach ($list_post_by_product as $item) {
                                $count++;
                            ?>
                                <li>
                                    <a href="post/<?php echo create_slug( $item['title']) ?>/<?php echo $item['id'] ?>" class="post-thumb">
                                        <img src="public/images/post/<?php echo $item['thumb'] ?>" alt="">
                                    </a>

                                    <div class="more-info">
                                        <a href="post/<?php echo create_slug( $item['title']) ?>/<?php echo $item['id'] ?>" class="post-title">
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
                        </ul>
                    </div>
                </div>
            </div>
        <?php } ?>

    </div>

    <!-- end content -->
    <!-- =================sidebar================== -->
    <div id="sidebar">
        <div id="product-info">
            <h3><?php echo $phone_info['name'] ?></h3>
            <?php
            if (!empty($phone_info['sale_price'])) {
            ?>
                <strong><?php echo currency_format($phone_info['sale_price']) ?></strong>
            <?php
            } else {
            ?>
                <strong><?php echo currency_format($phone_info['price']) ?></strong>
            <?php
            }
            ?>

            <img src="public/images/phone/<?php echo $phone_info['thumb'] ?>" alt="">
            <figure>Screen: <?php echo $phone_info['screen'] ?></figure>
            <figure>CPU: <?php echo $phone_info['cpu'] ?> </figure>
            <figure>Ram: <?php echo $list_attr_ram?>, Storage: <?php echo $list_attr_storage ?></figure>
            <figure>Back camera: <?php echo $phone_info['camera_back'] ?></figure>
            <figure>Front camera:  <?php echo $phone_info['camera_front'] ?></figure>
            <a href="phone/detail/<?php echo create_slug($phone_info['name']) ?>/<?php echo $phone_info['id'] ?>">See detail</a>
        </div>
    </div> <!-- end sidebar -->
</div> <!-- end wp-content -->