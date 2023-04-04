<div id='content' class="order-content shopping-cart">
    <div class='section'>
        <div class="section-head">
            <h2 class="section-title text-center">ORDER DETAIL #<?php echo substr($order_info['order_id'], 1) ?></h2>
            <p class="text-center">Status: <span class="status-order"> <?php echo  $status_options[$order_info['status']] ?></span></p>
        </div>
        <div class='section-detail'>
            <table>
                <thead>
                    <tr>
                        <th>Item</th>
                        <th>Image</th>
                        <th>Attribute</th>
                        <th>Quantity</th>
                        <th>Price</th>
                        <th>Subtotal</th>
                    </tr>
                </thead>
                <tbody>
                    <?php
                    $total = 0;
                    foreach ($list_order_content_history_by_customer as $item) {
                        $total += $item['subtotal'];
                    ?>
                        <tr>
                            <td><?php echo $item['product_name'] ?></td>
                            <td><a href="?mod=product&act=detail_product&id=<?php echo $item['product_id'] ?>"><img src="public/images/phone/<?php echo $item['thumb'] ?>" alt=""></a></td>
                            <td><?php echo $item['attributes'] ?></td>
                            <td><?php echo $item['quantity'] ?></td>
                            <td><?php echo currency_format($item['price']) ?></td>
                            <td align="right"><?php echo currency_format($item['subtotal']) ?></td>
                        </tr>

                    <?php
                    }
                    ?>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="5" align="right">Total</td>
                        <td colspan="1" align="right"><?php echo currency_format($total) ?></td>
                    </tr>
                    <tr>
                        <td colspan="5" align="right">Shipping</td>
                        <td colspan="1" align="right">+<?php echo currency_format($order_info['shipping']) ?></td>
                    </tr>
                    <tr>
                        <td colspan="5" align="right">Discount</td>
                        <td colspan="1" align="right">-<?php echo currency_format($order_info['discount_price']) ?></td>
                    </tr>
                    <tr>
                        <td colspan="5" align="right"><strong>Total after</strong></td>
                        <td colspan="1" align="right"><strong><?php echo currency_format($order_info['total']) ?></strong></td>
                    </tr>
                </tfoot>
            </table>
            <div id="receipt-info">
                <h3>Address and recipient information</h3>
                <p><b>Name:</b> <?php echo $order_info['name'] ?></p>
                <p><b>Address:</b> <?php echo $order_info['address'] ?></p>
                <p><b>Email:</b> <?php echo $order_info['email'] ?></p>
                <p><b>Phone:</b> <?php echo $order_info['phone'] ?></p>
            </div>
            <a href="?mod=order&act=order_history" class="back-to-order">Back to order list</a>
        </div>
    </div>
</div>