<div id='content' class="order-history">
    <div class='section order-history'>
        <div class="section-head">
            <h2 class="section-title text-center">ORDER HISTORY</h2>
        </div>
        <div class='section-detail'>
            <?php
            if (!empty($list_order_history)) {
            ?>
                <ul class='list-order-history'>
                    <?php
                    foreach ($list_order_history as $item) {
                    ?>
                        <li>
                            <p class="order-id">
                                Order: <strong>#<?php echo $item['order_id'] ?></strong>
                            </p>
                            <div class="more-info clearfix">
                                <a href="?mod=product&act=detail_product&id=<?php echo $item['id'] ?>"><img src="public/images/phone/<?php echo $item['thumb'] ?>" alt="" class="float-left"></a>
                                <div class="order-detail float-left">
                                    <h3 class="name"><strong><?php echo $item['name'] ?></strong></h3>
                                    <span class="date">Date: <?php echo date_formate($item['order_date']) ?></span>
                                    <a href="?mod=order&act=order_history&orderId=<?php echo $item['order_id'] ?>">See detail</a>
                                </div>
                                <div class="float-right">
                                    <p class="total"><?php echo currency_format($item['total']) ?></p>
                                    <p class="status-order"><?php echo  $status_options[$item['status']] ?></p>
                                </div>
                            </div>
                        </li>
                    <?php
                    }
                    ?>

                </ul>
            <?php
            } else {
            ?>
                <div class="empty-order-history text-center">
                    <!-- <img src="public/images/icon/empty-cart.png" alt="" width="80px"> -->
                    <p >Your order history is empty!</p>
                </div>
                
            <?php
            }
            ?>

        </div>
    </div>
</div>