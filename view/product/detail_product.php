<!-- <div class="section">
        <div class="section-detail">
            <ul class="beadcrumb">
                <li><a href="?mod=home&act=main">Home</a><span>></span></li>
                <li><a href="">Điện thoại</a><span>></span></li>
                <li><a href="">Vmart</a></li>
            </ul>
        </div>
    </div> -->
<div id="content-left" class='float-left'>
    <div class="section" id="detail-product-head">
        <div class="section-detail">
            <div id="thumb-wp" class="clearfix">
                <div id="thumb">
                    <img id="my-img" src="" alt="">
                    <div id="my-result"></div>

                    <div id="list-thumb-wp">
                        <ul id="list-thumb">
                            <?php
                            foreach ($list_images as $img) {

                                echo "
                                <li>
                                    <a href=''><img src='public/images/phone/{$img['image']}' alt=''></a>
                                </li>
                            ";
                            }
                            ?>
                        </ul>
                    </div>

                </div>
                <div id="info">
                    <div class="box product-name">
                        <div class="box-detail">
                            <h1><?php echo  $detail_phone['name'] ?></h1>
                        </div>
                    </div>
                    <div class="box">
                        <div class="box-detail">
                            <div class="rating">
                                <ul class="list-star">
                                    <?php
                                    $rating = get_avg_rating($detail_phone['id']);
                                    $num_rating = get_num_rating($detail_phone['id'], 0);
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
                        </div>
                    </div>

                    <div class="box product-price">
                        <div class="box-content">
                            <?php
                            if (isset($detail_phone['sale_price'])) {
                                echo "
                            <strong class = 'price'>" . currency_format($detail_phone['sale_price']) . "</strong>
                            <span class = 'old-price'>" . currency_format($detail_phone['price']) . "</span>
                            ";
                            } else {
                                echo "<strong class = 'price'>" . currency_format($detail_phone['price']) . "</strong>";
                            }
                            ?>
                        </div>
                    </div>
                    <div class="box product-stock">
                        <h5 class="box-title">Status</h5>
                        <div class="box-content"><?php echo get_stock_status($detail_phone['stock']) ?></div>
                    </div>
                    <form action="?mod=cart&act=cart&id=<?php echo  $detail_phone['id'] ?>&action=add" method="POST" id="formCart">
                        <?php
                        if (!empty($list_attr)) {
                            $tmp = $list_attr[0]['name'];
                            echo "<div class='box'>"; //open box
                            echo "<h5 class='box-title'>" . ucwords($list_attr[0]['name']) . "</h5>";
                            echo "<div class='box-content'>"; //open box-content
                            // echo "<select name = 'attr" . ucwords($list_attr[0]['name']) . "'>"; //open select
                            foreach ($list_attr as $v) {

                                if ($v['name'] != $tmp) {
                                    // echo "</select name = 'attr" . ucwords($v['name']) . "'>"; //end select
                                    echo "</div>"; //end box-content
                                    echo "</div>"; //end box
                                    echo "<div class='box'>"; //open box
                                    echo "<h5 class='box-title'>" . ucwords($v['name']) . "</h5>";
                                    echo "<div class='box-content'>"; //open box content
                                    // echo "<select name='attr" . ucwords($v['name']) . "'>"; //open select
                                }
                                // echo "<option>{$v['value']}</option>";
                                echo "<label class='attr attr" . ucwords($v['name']) . "' color='" . ucwords($v['value']) . "'> {$v['value']}  <input type = 'checkbox' name= 'attr" . ucwords($v['name']) . "' value='" . $v['value'] . "' class='attrInput'></label>";

                                $tmp = $v['name'];
                            }
                            // echo "</select>"; //end select
                            echo "</div>"; //end box-content
                            echo "</div>"; //end box
                        }
                        ?>

                        <div class="box quantity">
                            <h5 class="box-title">Quantity</h5>
                            <div class="box-content">
                                <button id="minus" type="button"><i class="fas fa-minus"></i></button>
                                <?php
                                $num_default = 1;
                                if ($num_stock == 0) {
                                    $num_default = 0;
                                }
                                ?>
                                <input type="number" name="num-cart" id="num-cart" value="<?php echo $num_default ?>" min="0">
                                <button id="plus" type="button"><i class="fas fa-plus"></i></button>
                            </div>
                        </div>
                        <!-- -----------------------Cart---------------- -->
                        <div id="add-cart-wp">
                            <?php
                            $disabled = '';
                            if ($num_stock == 0) {
                                $disabled = 'disabled';
                            } ?>
                            <input type="hidden" name="id" value="<?php echo $id ?>">
                            <button type="submit" name="addCart" id="add-cart" <?php echo $disabled ?>><i class="fas fa-shopping-cart"></i> Add to cart</button>
                            <button type="submit" name="addWishlist" id="add-wishlist" <?php echo $disabled ?>>Add to wishlist</button>
                        </div>
                    </form>
                    <!-- ====================OUT OF STOCK=================== -->
                    <?php if ($num_stock == 0) { ?>
                        <?php  ?>
                        <div id="out-of-stock">
                            <p>Sorry, this product is currently out of stock</p>
                            <p>Enter your email and your name. We will notify you once it returns in stock</p>
                            <form action="" method="POST" id="formNotify">
                                <input type="text" name="name" placeholder="Enter your name">
                                <input type="email" name="email" placeholder="Enter your email">
                                <input type="submit" name="submitNotify" id="notify" value="NOTIFY ME">
                            </form>
                            <?php
                            if (isset($error_notify) && !empty($error_notify)) {
                                echo "<p>$error_notify</p>";
                            }
                            ?>
                        </div>
                    <?php } ?>
                </div>
            </div>
        </div>

    </div>
    <div class="section" id="detail-product-body">
        <!-- <div class="section-head">
            <h3>Mô tả sản phẩm</h3>
        </div> -->
        <div class="section-detail">
            <article>
                <?php echo  $detail_phone['content'] ?>
            </article>
        </div>
        <a href="javascript:;" id="view-more-product" class="view-more">View more <b></b></a>
    </div>
    <div class="section" id="analysis-rating">
        <div class="section-head">
            <h2>Customer reviews</h2>
            <div class="rating">
                <ul class="list-star">
                    <?php
                    $rating = get_avg_rating($detail_phone['id']);
                    $num_rating = get_num_rating($detail_phone['id'], 0);
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
                <span class="num-rating"><?php echo $rating ?> out of 5</span>
            </div>
        </div>
        <div class="section-detail">
            <?php
            for ($i = 5; $i >= 1; $i--) {
                $num_rating = get_num_rating($id, $i);
                if ($total_rating == 0) {
                    $percent_star = 0;
                } else {
                    $percent_star = ($num_rating / $total_rating) * 100;
                }
            ?>
                <div>
                    <span class="star"><?php echo $i ?> &#9733</span>
                    <div class="bg">
                        <div class="bg-in" style="width:<?php echo $percent_star ?>%"></div>
                    </div>
                    <span class="num-rating"><?php echo $num_rating ?> reviews</span>
                </div>
            <?php } ?>
        </div>
    </div>
    <?php
    //Recommend

    if (!empty($list_related_products)) {
        include('view/recommend/related.php');
    }

    if (!empty($list_also_bought)) {
        include('view/recommend/also_bought.php');
    }

    if (!empty($list_products_same_category)) {
        include('view/recommend/same_category.php');
    }
    include('view/review/review.php'); ?>
</div>
<div id="content-right" class="float-left">
    <div class="section" id="table-parameter">
        <div class="section-head">
            <h2>Technical specifications</h2>
        </div>
        <div class="section-detail">
            <ul class="parameter">
                <li>
                    <span>Screen:</span>
                    <div><?php echo $detail_phone['screen'] ?></div>
                </li>
                <li>
                    <span>Operating system:</span>
                    <div><?php echo $detail_phone['os'] ?></div>
                </li>
                <li>
                    <span>Back camera:</span>
                    <div><?php echo $detail_phone['camera_back'] ?></div>
                </li>
                <li>
                    <span>Front camera:</span>
                    <div><?php echo $detail_phone['camera_front'] ?></div>
                </li>
                <li>
                    <span>CPU:</span>
                    <div><?php echo $detail_phone['cpu'] ?></div>
                </li>
                <li>
                    <span>RAM:</span>
                    <div>
                        <?php
                        foreach ($list_attr as $item) {
                            if ($item['name'] == 'ram') {
                                echo $item['value'] . ' ';
                            }
                        }
                        ?>
                    </div>
                </li>
                <li>
                    <span>Storage: </span>
                    <div>
                        <?php
                        foreach ($list_attr as $item) {
                            if ($item['name'] == 'storage') {
                                echo $item['value'] . ' ';
                            }
                        }
                        ?>
                    </div>
                </li>
                <li>
                    <span>SIM:</span>
                    <div><?php echo $detail_phone['sim'] ?></div>
                </li>
                <li>
                    <span>Battery capacity:</span>
                    <div><?php echo $detail_phone['battery'] ?></div>
                </li>
            </ul>
        </div>
    </div>
    <?php if (!empty($list_posts)) {  ?>
        <div class="section news-list">
            <div class="section-head">
                <h2>News about <?php echo  $detail_phone['name'] ?></h2>
            </div>
            <div class="section-detail">
                <ul class="list-post small">
                    <?php foreach ($list_posts as $item) { ?>
                        <li>
                            <a href="?mod=post&act=detail_post&postId=<?php echo $item['id'] ?>" class="post-thumb">
                                <img src="public/images/post/<?php echo $item['thumb'] ?>" alt="">
                            </a>

                            <div class="more-info">
                                <a href="?mod=post&act=detail_post&postId=<?php echo $item['id'] ?>" class="post-title">
                                    <?php echo $item['title'] ?>
                                </a>
                            </div>
                        </li>
                    <?php } ?>
                </ul>
                <a href="post/product/<?php echo create_slug($detail_phone['name']) ?>/<?php echo  $id ?>">See all related news</a>
            </div>
        </div>
    <?php } ?>
</div>