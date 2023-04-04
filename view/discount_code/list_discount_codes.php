<div id='content' class="clearfix">
    <div class='section discount-code'>
        <div class="section-head">
            <h1>List discount codes</h1>
        </div>
        <div class='section-detail'>
                <ul id='list-code'>
                    <?php
                    foreach ($list_discount_code as $item) {
                    ?>
                        <li class='item'>
                            <div class="short-name">
                                <?php
                                if ($item['discount_operation'] == '%') {
                                    echo 'Discount: ' . $item['discount_amount'] . '%';
                                } elseif ($item['discount_operation'] == '-') {
                                    echo 'Discount: ' . currency_format($item['discount_amount']);
                                }
                                ?>
                            </div>
                            <?php
                            if (!empty($item['expiry'])) {
                            ?>
                                <div><b>Expiration date:</b> <?php echo date_formate($item['expiry']) ?></div>
                            <?php
                            } else {
                            ?>
                                <div><b>Expiration date:</b> Unlimited</div>
                            <?php
                            }
                            ?>
                            <!-- <div class="other"><?php echo $item['active'] ?></div> -->
                            <div><b>Min cost:</b> <?php echo currency_format($item['min_basket_cost']) ?></div>

                            <div><b>Quantity:</b> <?php echo $item['num_vouchers'] ?></div>
                            <div class="clearfix">
                                <p class="code-text float-left">Get discount code</p>
                                <button class="code-icon float-right" data-code="<?php echo $item['voucher_code'] ?>"><i class="far fa-cut"></i></button>
                            </div>


                        </li>
                    <?php
                    }
                    ?>

                </ul>
                <?php link_pagination($total_link, $page, 'voucher'); ?>
        </div>
    </div>
</div>