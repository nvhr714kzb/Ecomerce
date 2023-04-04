<div id='content' class="clearfix">
    <div class="section float-left" id="filter-product">
        <div class="section-detail">
            <div class="box">
                <div class="box-title">
                    <h5>Price</h5>
                </div>
                <div class="box-content">
                    <input type="hidden" id="hidden-minimum-price" value="100000" />
                    <input type="hidden" id="hidden-maximum-price" value="100000000" />
                    <p id="price-show">100000 - 100000000</p>
                    <div id="price-range"></div>
                </div>
            </div>
            <div class="box">
                <div class="box-title">
                    <h5>Rating</h5>
                </div>
                <div class="box-content">
                    <?php for ($i = 5; $i >= 1; $i--) { ?>
                        <div class='rating'>
                            <label for="star-<?php echo $i ?>" data-index="<?php echo $i ?>">
                                <?php
                                for ($j = 1; $j <= 5; $j++) {
                                    if ($j <= $i) {
                                        $color = 'color:#ffcc00;';
                                    } else {
                                        $color = 'color:#ccc;';
                                    }
                                    echo "<span  style='$color'>&#9733</span>";
                                }
                                ?>
                            </label>
                            <input type="radio" name="num-star" class="common-selector num-star" id="star-<?php echo $i ?>" value="<?php echo $i ?>">
                        </div>
                    <?php } ?>
                </div>
            </div>
            <?php
            if (!empty($list_attr)) {
                $tmp = $list_attr[0]['name'];
                echo "<div class='box'>"; //open box
                echo "<h5 class='box-title'>" . ucwords($list_attr[0]['name']) . "</h5>";
                echo "<div class='box-content'>"; //open box-content
                echo "<ul>"; //open select
                foreach ($list_attr as $v) {

                    if ($v['name'] != $tmp) {
                        echo "</ul>"; //end select
                        echo "</div>"; //end box-content
                        echo "</div>"; //end box
                        echo "<div class='box'>"; //open box
                        echo "<h5 class='box-title'>" . ucwords($v['name']) . "</h5>";
                        echo "<div class='box-content'>"; //open box content
                        echo "<ul>"; //open select
                    }
                    echo "<li><label><input type='checkbox' class='common-selector {$v['name']}' value='{$v['attribute_value_id']}'> {$v['value']}</label></li>";

                    $tmp = $v['name'];
                }
                echo "</ul>"; //end select
                echo "</div>"; //end box-content
                echo "</div>"; //end box
            }
            ?>
        </div>
    </div>
    <div class='section float-left' id="list-product-wp">
        <div class='section-detail'>
            <ul class='list-product'>
                <?php
                foreach ($list_sale_products as $item) {
                ?>
                    <li class="item">
                        <a href="?mod=product&act=detail_product&id=<?php echo $item['id'] ?>">
                            <img src="public/images/phone/<?php echo $item['thumb'] ?>" alt="<?php echo $item['name'] ?>">
                            <h3 class="name"><?php echo $item['name'] ?></h3>
                            <div class="price">
                                <strong class="new-price"><?php echo currency_format($item['sale_price']) ?></strong>
                                <span class="old-price"><?php echo currency_format($item['price']) ?></span>
                            </div>
                            <div class="rating">
                                <ul class="list-star">
                                    <?php
                                    $rating = get_avg_rating($item['id']);
                                    $num_rating = get_num_rating($item['id'], 0);
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
                            <label class="discount">GIẢM <?php echo currency_format(discount($item['price'], $item['sale_price'])) ?></label>
                            <label class="icon-discount"><img src="public/images/icon/sale.svg" alt=""></label>
                        </a>
                    </li>
                <?php } ?>
            </ul>

        </div>
    </div>
</div>