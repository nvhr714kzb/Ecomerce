<!-- =========================CONTENT====================== -->
<div id="content" class="home">
    <!-- -------------------Section Slider---------------------- -->
    

    <div class="section">
        <div class="section-detail clearfix">
            <div id="home-banner" class="float-left">
                <div id="slider-wp">
                    <div class="owl-carousel owl-theme">
                        <?php foreach ($list_slider  as $item) { ?>
                            <div class="item">
                                <a href="<?php echo $item['link'] ?>"><img src="public/images/slider/<?php echo $item['image'] ?>" alt=""></a>
                            </div>
                        <?php } ?>
                    </div>
                </div>
            </div>
            <div id="home-news" class="float-left">
                <figure class="clearfix">
                    <h2 class="float-left">Tech news</h2>
                </figure>
                <?php
                if (!empty($one_post)) {
                ?>
                    <ul class="one-post">
                        <li>
                            <a href="post/<?php echo create_slug($one_post['title']) ?>/<?php echo $one_post['id'] ?>">
                                <img src="public/images/post/<?php echo $one_post['thumb'] ?>" alt="" class="post-thumb">
                                <h3><?php echo $one_post['title'] ?></h3>
                                <span class="post-date" style="font-size: 14px;"><?php echo time_ago($one_post['date_created']) ?></span>
                            </a>
                        </li>
                    </ul>
                <?php
                }
                ?>

                <div id="two-banner">
                    <a href=""><img src="https://cdn.tgdd.vn/2020/09/banner/Sam-samsung-398-110-398x110.png" alt=""></a>
                    <a href="<?php echo BASE_URL . "phone/detail/dien-thoai-iphone-xs-64gb/4" ?>"><img src="https://cdn.tgdd.vn/2020/09/banner/398-110-398x110-2.png" alt=""></a>
                </div>
            </div>

        </div>

    </div>
    <div class="section" id="most_view_page">
        <!-- Top view -->
        <?php
        // $q = "SELECT COUNT(v_id) AS num, `v_item_id`, `p_title`, `p_description` FROM `view` INNER JOIN `pages` 
        // ON view.v_item_id = pages.p_id WHERE view.v_type = 'page'
        // GROUP BY (v_item_id) ORDER BY num DESC LIMIT 5
        // ";
        // $r = mysqli_query($dbc, $q);
        // if (mysqli_num_rows($r) > 0) {
        //     echo "<h2>Top most views</h2>";
        //     while ($row = mysqli_fetch_array($r, MYSQLI_ASSOC)) {
        //         echo "<h3><a href='?mod=page&act=page&id={$row['v_item_id']}'>{$row['p_title']}</a></h3>";
        //         echo "<p>{$row['p_description']}</p>";
        //     }
        // }
        ?>
    </div>
    <!-- -------------------Section support---------------------- -->
    <div class="section" id="support">
        <div class="section-head">

        </div>
        <div class="section-detail">
            <ul id="list-support">
                <li class="item-support">
                    <div class="thumb"><img src="public/images/sp-support.svg" alt=""></div>
                    <h3 class="title">Tư vấn 24/7</h3>
                    <div class="desc">0799500203</div>
                </li>
                <li class="item-support">
                    <div class="thumb"><img src="public/images/sp-order.svg" alt=""></div>
                    <h3 class="title">Đặt hàng online</h3>
                    <div class="desc">Thao tác đơn giản</div>
                </li>
                <li class="item-support">
                    <div class="thumb"><img src="public/images/sp-secure.svg" alt=""></div>
                    <h3 class="title">Bảo mât giao dịch</h3>
                    <div class="desc">Giao dịch an toàn</div>
                </li>
                <li class="item-support">
                    <div class="thumb"><img src="public/images/sp-transport.svg" alt=""></div>
                    <h3 class="title">Miễn phí vận chuyển</h3>
                    <div class="desc">Tới tận tay khách hàng</div>
                </li>
                <li class="item-support">
                    <div class="thumb"><img src="public/images/sp-discount.svg" alt=""></div>
                    <h3 class="title">Giảm giá</h3>
                    <div class="desc">Nhiều sản phẩm giảm giá</div>
                </li>
            </ul>
        </div>

    </div>

    <!-- -------------------Section sale product---------------------- -->
    <!-- <div class="section">
            <div class="section-head">

            </div>
            <div class="section-detail" id="binh">
                <div class="box">
                    <div class="img-box">
                        <img src="https://images-na.ssl-images-amazon.com/images/G/01/AmazonExports/Fuji/2019/July/amazonbasics_520x520._SY304_CB442725065_.jpg" alt="">
                    </div>
                    <div class="content">
                        <h3 class="title">Điện thoại di động</h3>
                        <p>Lorem ipsum dolor, sit amet consectetur adipisicing elit. Laudantium, neque molestias alias minus asperiores commodi doloremque vero quia explicabo quam saepe facere soluta rem nisi impedit accusamus nemo ab eaque.</p>
                    </div>
                </div>
                <div class="box">
                    <div class="img-box">
                        <img src="https://images-na.ssl-images-amazon.com/images/G/01/events/GFAH/GWDesktop_SingleImageCard_fitathome_1x._SY304_CB434924743_.jpg" alt="">
                    </div>
                    <div class="content">
                        <h3 class="title">Máy tính bảng</h3>
                        <p>Lorem ipsum dolor, sit amet consectetur adipisicing elit. Laudantium, neque molestias alias minus asperiores commodi doloremque vero quia explicabo quam saepe facere soluta rem nisi impedit accusamus nemo ab eaque.</p>
                    </div>
                </div>
                <div class="box">
                    <div class="img-box">
                        <img src="https://images-na.ssl-images-amazon.com/images/G/01/AmazonExports/Fuji/2020/May/Dashboard/Fuji_Dash_Deals_1x._SY304_CB430401028_.jpg" alt="">
                    </div>
                    <div class="content">
                        <h3 class="title">Laptop</h3>
                        <p>Lorem ipsum dolor, sit amet consectetur adipisicing elit. Laudantium, neque molestias alias minus asperiores commodi doloremque vero quia explicabo quam saepe facere soluta rem nisi impedit accusamus nemo ab eaque.</p>
                    </div>
                </div>
            </div>
        </div> -->
    <?php if (!empty($list_featured_products)) { ?>
        <div class="section" id="featured-product-wp">
            <div class="section-head">
                <h2 class="section-title">Featured Products</h2>
            </div>
            <div class="section-detail">
                <ul class="list-product slider">
                    <div class="owl-carousel owl-theme">
                        <?php
                        foreach ($list_featured_products as $item) {
                        ?>
                            <li class="item">
                                <a href="phone/detail/<?php echo create_slug($item['name']) ?>/<?php echo $item['id'] ?>">
                                    <img src="public/images/phone/<?php echo $item['thumb'] ?>" alt="<?php echo $item['name'] ?>">
                                    <h3 class="name"><?php echo $item['name'] ?></h3>
                                    <div class="price">
                                        <?php
                                        echo get_price($item['price'], $item['sale_price']);
                                        ?>
                                        <!-- <strong class="new-price"><?php echo currency_format($item['sale_price']) ?></strong>
                                        <span class="old-price"><?php echo currency_format($item['price']) ?></span> -->
                                    </div>
                                    <?php
                                    $num_rating = get_num_rating($item['id'], 0);
                                    if ($num_rating > 0) {
                                    ?>
                                        <div class="rating">
                                            <ul class="list-star">
                                                <?php
                                                $rating = get_avg_rating($item['id']);
                                                for ($i = 1; $i <= 5; $i++) {
                                                    if ($i <= $rating) {
                                                        $color = 'color:#ffcc00;';
                                                    } else {
                                                        $color = 'color:#ccc;';
                                                    }
                                                ?>
                                                    <li id="<?php echo $i ?>" data-index="<?php echo $i ?>" style="<?php echo $color ?>">&#9733</li>
                                                <?php
                                                } ?>
                                            </ul>
                                            <span class="num-rating">(<?php echo $num_rating ?>)</span>
                                        </div>
                                    <?php
                                    }
                                    ?>
                                    <?php
                                    if (!empty($item['promotion'])) {
                                    ?>
                                        <div class="promo">
                                            <p><?php echo $item['promotion'] ?></p>
                                        </div>
                                    <?php
                                    }
                                    ?>
                                    
                                    <label class="icon"><i class="fal fa-star-half-alt"></i></label>
                                </a>
                            </li>
                        <?php } ?>
                </ul>
            </div>
        </div>
</div>
<?php } ?>
<!-- -------------------Discount---------------------- -->
<?php if (!empty($list_sale_items)) { ?>
    <div class="section" id="discount-product-wp">
        <div class="section-head">
            <h2 class="section-title">Discount Products</h2>
        </div>
        <div class="section-detail">
            <ul class="list-product slider">
                <div class="owl-carousel owl-theme">
                    <?php
                    foreach ($list_sale_items as $item) {
                    ?>
                        <li class="item">
                            <a href="phone/detail/<?php echo create_slug($item['name']) ?>/<?php echo $item['id'] ?>">
                                <img src="public/images/phone/<?php echo $item['thumb'] ?>" alt="<?php echo $item['name'] ?>">
                                <h3 class="name"><?php echo $item['name'] ?></h3>
                                <div class="price">
                                    <strong class="new-price"><?php echo currency_format($item['sale_price']) ?></strong>
                                    <span class="old-price"><?php echo currency_format($item['price']) ?></span>
                                </div>
                                <?php
                                $num_rating = get_num_rating($item['id'], 0);
                                if ($num_rating > 0) {
                                ?>
                                    <div class="rating">
                                        <ul class="list-star">
                                            <?php
                                            $rating = get_avg_rating($item['id']);
                                            for ($i = 1; $i <= 5; $i++) {
                                                if ($i <= $rating) {
                                                    $color = 'color:#ffcc00;';
                                                } else {
                                                    $color = 'color:#ccc;';
                                                }
                                            ?>
                                                <li id="<?php echo $i ?>" data-index="<?php echo $i ?>" style="<?php echo $color ?>">&#9733</li>
                                            <?php
                                            } ?>
                                        </ul>
                                        <span class="num-rating">(<?php echo $num_rating ?>)</span>
                                    </div>
                                <?php
                                }
                                ?>

                                <?php
                                if (!empty($item['promotion'])) {
                                ?>
                                    <div class="promo">
                                        <p><?php echo $item['promotion'] ?></p>
                                    </div>
                                <?php
                                }
                                ?>
                                <label class="discount">GIẢM <?php echo currency_format(discount($item['price'], $item['sale_price'])) ?></label>
                                <label class="icon"><img src="public/images/icon/sale.svg" alt=""></label>
                            </a>
                        </li>
                    <?php } ?>
                </div>
            </ul>
        </div>
    </div>
<?php } ?>

<?php if (!empty($list_new_items)) { ?>
    <div class="section" id="new-product-wp">
        <div class="section-head">
            <h2 class="section-title">New Products</h2>
        </div>
        <div class="section-detail">
            <ul class="list-product slider">
                <div class="owl-carousel owl-theme">
                    <?php
                    foreach ($list_new_items as $item) {
                    ?>
                        <li class="item">
                            <a href="phone/detail/<?php echo create_slug($item['name']) ?>/<?php echo $item['id'] ?>">
                                <img src="public/images/phone/<?php echo $item['thumb'] ?>" alt="<?php echo $item['name'] ?>">
                                <h3 class="name"><?php echo $item['name'] ?></h3>
                                <div class="price">
                                    <?php
                                    echo get_price($item['price'], $item['sale_price']);
                                    ?>
                                    <!-- <strong class="new-price"><?php echo currency_format($item['sale_price']) ?></strong>
                                        <span class="old-price"><?php echo currency_format($item['price']) ?></span> -->
                                </div>
                                <?php
                                $num_rating = get_num_rating($item['id'], 0);
                                if ($num_rating > 0) {
                                ?>
                                    <div class="rating">
                                        <ul class="list-star">
                                            <?php
                                            $rating = get_avg_rating($item['id']);
                                            for ($i = 1; $i <= 5; $i++) {
                                                if ($i <= $rating) {
                                                    $color = 'color:#ffcc00;';
                                                } else {
                                                    $color = 'color:#ccc;';
                                                }
                                            ?>
                                                <li id="<?php echo $i ?>" data-index="<?php echo $i ?>" style="<?php echo $color ?>">&#9733</li>
                                            <?php
                                            } ?>
                                        </ul>
                                        <span class="num-rating">(<?php echo $num_rating ?>)</span>
                                    </div>
                                <?php
                                }
                                ?>
                                <?php
                                if (!empty($item['promotion'])) {
                                ?>
                                    <div class="promo">
                                        <p><?php echo $item['promotion'] ?></p>
                                    </div>
                                <?php
                                }
                                ?>
                                <label class="icon"><img src="public/images/icon/new.svg" alt=""></label>
                            </a>
                        </li>
                    <?php } ?>
                </div>
            </ul>
        </div>
    </div>
<?php } ?>
<?php if (!empty($list_most_rating_product)) { ?>
    <div class="section" id="most-rating-product-wp">
        <div class="section-head">
            <h2 class="section-title">Most Rating Products</h2>
        </div>
        <div class="section-detail">
            <ul class="list-product slider">
                <div class="owl-carousel owl-theme">
                    <?php
                    foreach ($list_most_rating_product as $item) {
                    ?>
                        <li class="item">
                            <a href="phone/detail/<?php echo create_slug($item['name']) ?>/<?php echo $item['id'] ?>">
                                <img src="public/images/phone/<?php echo $item['thumb'] ?>" alt="<?php echo $item['name'] ?>">
                                <h3 class="name"><?php echo $item['name'] ?></h3>
                                <div class="price">
                                    <?php
                                    echo get_price($item['price'], $item['sale_price']);
                                    ?>
                                    <!-- <strong class="new-price"><?php echo currency_format($item['sale_price']) ?></strong>
                                        <span class="old-price"><?php echo currency_format($item['price']) ?></span> -->
                                </div>
                                <?php
                                $num_rating = get_num_rating($item['id'], 0);
                                if ($num_rating > 0) {
                                ?>
                                    <div class="rating">
                                        <ul class="list-star">
                                            <?php
                                            $rating = get_avg_rating($item['id']);
                                            for ($i = 1; $i <= 5; $i++) {
                                                if ($i <= $rating) {
                                                    $color = 'color:#ffcc00;';
                                                } else {
                                                    $color = 'color:#ccc;';
                                                }
                                            ?>
                                                <li id="<?php echo $i ?>" data-index="<?php echo $i ?>" style="<?php echo $color ?>">&#9733</li>
                                            <?php
                                            } ?>
                                        </ul>
                                        <span class="num-rating">(<?php echo $num_rating ?>)</span>
                                    </div>
                                <?php
                                }
                                ?>
                                <?php
                                if (!empty($item['promotion'])) {
                                ?>
                                    <div class="promo">
                                        <p><?php echo $item['promotion'] ?></p>
                                    </div>
                                <?php
                                }
                                ?>
                                <label class="icon"><img src="public/images/icon/star.svg" alt=""></label>
                            </a>
                        </li>
                    <?php } ?>
                </div>
            </ul>
        </div>
    </div>
<?php } ?>
<?php if (!empty($get_list_most_order_product)) { ?>
    <div class="section" id="most-order-product-wp">
        <div class="section-head">
            <h2 class="section-title">Most Order Products</h2>
        </div>
        <div class="section-detail">
            <ul class="list-product slider">
                <div class="owl-carousel owl-theme">
                    <?php
                    foreach ($get_list_most_order_product as $item) {
                    ?>
                        <li class="item">
                            <a href="phone/detail/<?php echo create_slug($item['name']) ?>/<?php echo $item['id'] ?>">
                                <img src="public/images/phone/<?php echo $item['thumb'] ?>" alt="<?php echo $item['name'] ?>">
                                <h3 class="name"><?php echo $item['name'] ?></h3>
                                <div class="price">
                                    <?php
                                    echo get_price($item['price'], $item['sale_price']);
                                    ?>
                                    <!-- <strong class="new-price"><?php echo currency_format($item['sale_price']) ?></strong>
                                        <span class="old-price"><?php echo currency_format($item['price']) ?></span> -->
                                </div>
                                <?php
                                $num_rating = get_num_rating($item['id'], 0);
                                if ($num_rating > 0) {
                                ?>
                                    <div class="rating">
                                        <ul class="list-star">
                                            <?php
                                            $rating = get_avg_rating($item['id']);
                                            for ($i = 1; $i <= 5; $i++) {
                                                if ($i <= $rating) {
                                                    $color = 'color:#ffcc00;';
                                                } else {
                                                    $color = 'color:#ccc;';
                                                }
                                            ?>
                                                <li id="<?php echo $i ?>" data-index="<?php echo $i ?>" style="<?php echo $color ?>">&#9733</li>
                                            <?php
                                            } ?>
                                        </ul>
                                        <span class="num-rating">(<?php echo $num_rating ?>)</span>
                                    </div>
                                <?php
                                }
                                ?>
                                <?php
                                if (!empty($item['promotion'])) {
                                ?>
                                    <div class="promo">
                                        <p><?php echo $item['promotion'] ?></p>
                                    </div>
                                <?php
                                }
                                ?>
                                 <label class="icon"><i class="fas fa-shopping-bag"></i></label>
                            </a>
                        </li>
                    <?php } ?>
                </div>
            </ul>
        </div>
    </div>
<?php } ?>


<!-- ------------------------------------MOST VIEW------------------------------- -->
    <!-- <div class="section" id="flip-cart-wp">
        <div class="flip-cart">
            <div class="front-face">
                <div class="contents front ">
                    <p>David Smith</p>
                    <span>HAHA HA</span>
                </div>
            </div>
            <div class="back-face">
                <div class="contents back">
                    <h2>Coding</h2>
                    <span>Follow me</span>
                    <div class="icon">
                        <i class="fab fa-facebook-f"></i>
                        <i class="fab fa-twitter"></i>
                        <i class="fab fa-instagram"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="flip-cart">
            <div class="front-face">
                <div class="contents front ">
                    <p>David Smith</p>
                    <span>HAHA HA</span>
                </div>
            </div>
            <div class="back-face">
                <div class="contents back">
                    <h2>Coding</h2>
                    <span>Follow me</span>
                    <div class="icon">
                        <i class="fab fa-facebook-f"></i>
                        <i class="fab fa-twitter"></i>
                        <i class="fab fa-instagram"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="flip-cart">
            <div class="front-face">
                <div class="contents front ">
                    <p>David Smith</p>
                    <span>HAHA HA</span>
                </div>
            </div>
            <div class="back-face">
                <div class="contents back">
                    <h2>Coding</h2>
                    <span>Follow me</span>
                    <div class="icon">
                        <i class="fab fa-facebook-f"></i>
                        <i class="fab fa-twitter"></i>
                        <i class="fab fa-instagram"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <div id="card-wp">
        <div id="card">
            <div class="imgBox">
                <img src="http://localhost:8080/my-amazon.com/public/images/post/bc46f0a9b5e1798e0dbb46d258a9a0826196843d.png" alt="">
            </div>
            <div class="detail">
                <h2>Tieu de</h2>
                <p>Lorem ipsum dolor sit amet consectetur adipisicing elit. Est maxime eaque sed cumque similique, sapiente quo veritatis saepe quia tempore.</p>
            </div>
        </div>
        <div id="card">
            <div class="imgBox">
                <img src="public/images/film2.jpg" alt="">
            </div>
            <div class="detail">
                <h2>Tieu de</h2>
                <p>Lorem ipsum dolor sit amet consectetur adipisicing elit. Est maxime eaque sed cumque similique, sapiente quo veritatis saepe quia tempore.</p>
            </div>
        </div>
        <div id="card">
            <div class="imgBox">
                <img src="public/images/film3.jpg" alt="">
            </div>
            <div class="detail">
                <h2>Tieu de</h2>
                <p>Lorem ipsum dolor sit amet consectetur adipisicing elit. Est maxime eaque sed cumque similique, sapiente quo veritatis saepe quia tempore.</p>
            </div>
        </div>
    </div> -->