<div class="shopping-cart checkout-cart float-right">
       <h3>Order Summary</h3>
       <table cellpadding="10">
              <thead>
                     <th>Item</th>
                     <th>Quantity</th>
                     <th>Price</th>
                     <th>Subtotal</th>
              </thead>
              <tbody>

                     <?php
                     $total = 0;
                     $remove = array();
                     foreach ($list_cart_items as $item) {
                            if ($item['stock'] < $item['quantity']) {
                                   echo "
                                          <tr>
                                          <td colspan='4'>There are only {$item['stock']} left in stock of the  {$item['name']} This item has been removed from your cart and placed in your wish list.</td>
                                          </tr>
                                          ";
                                   $remove[$item['item_id']] = $item['quantity'];
                            } else {
                                   $price = get_just_price($item['price'], $item['sale_price']);
                                   $subtotal = $price * $item['quantity'];
                                   $total += $subtotal;
                                   echo "
                                          <tr>
                                          <td>{$item['name']}</td>
                                          <td>{$item['quantity']}</td>
                                          <td>" . currency_format($price) . "</td>
                                          <td align='right'>" . currency_format($subtotal) . "</td>
                                          </tr>
                                          ";
                            }
                     }
                     // $shipping = get_shipping($total);
                     // $total += $shipping;
                     ?>

              </tbody>
              <tfoot>
                     <tr>
                            <td colspan="3" align="right">Total</td>
                            <td colspan="1" align="right">
                                   <?php echo currency_format($total) ?>
                            </td>
                     </tr>
                     <tr>
                            <?php
                            $shipping_price = get_shipping($total);
                            $_SESSION['shipping'] = $shipping_price;
                            ?>
                            <td colspan="3" align="right">Shipping</td>
                            <td colspan="1" align="right">
                                   <?php echo currency_format($shipping_price) ?>
                            </td>
                     </tr>
                     <?php
                     if (isset($_SESSION['discount_code'])) {
                            $discount_code = get_discount_code($_SESSION['discount_code']);
                            $message_discount_code = '';
                            if ($discount_code['active'] == 1) {
                                   if ($discount_code['expired'] == 1) {
                                          $_SESSION['discount_price'] = 0;
                                          $message_discount_code = 'Sorry, this voucher has expired';
                                   } else {
                                          if ($discount_code['num_vouchers'] != 0) {
                                                 if ($discount_code['min_basket_cost'] <= $total) { //ADDDDDDDDDDDDDDDDDDDDDDD   NUMBERRRRRRRRRRRRRRR
                                                        if ($discount_code['discount_operation'] == '%') {
                                                               // $message_discount_code = "A {$discount_code['discount_amount']} % discount has been applied to your order";
                                                               $_SESSION['discount_price'] = round(($total * $discount_code['discount_amount']) / 100);
                                                               // $_SESSION['discount_code'] = $_POST['discountCode'];
                                                        } elseif ($discount_code['discount_operation'] == '-') {
                                                               // $message_discount_code = "A discount of $ {$discount_code['discount_amount']} discount has been applied to your order";
                                                               $_SESSION['discount_price'] = $discount_code['discount_amount'];
                                                               // $_SESSION['discount_code'] = $_POST['discountCode'];
                                                        } elseif ($discount_code['discount_operation'] == 's') {
                                                               // $message_discount_code = "Your order shipping cost has been reduced to $ {$discount_code['discount_amount']}";
                                                        }
                                                 } else {
                                                        $_SESSION['discount_price'] = 0;
                                                        // $message_discount_code = 'Sorry, your order total is not enough for your order to qualify for this discount code';
                                                 }
                                          } else {
                                                 $_SESSION['discount_price'] = 0;
                                                 // $message_discount_code = 'Sorry, this was a limited edition voucher code, there are no more instances of that code left';
                                          }
                                   }
                            } else {
                                   $_SESSION['discount_price'] = 0;
                                   // $message_discount_code = 'Sorry, the voucher code you entered is no longer active';
                            }
                     ?>
                            <tr>
                                   <td colspan="3" align="right">
                                          Discount
                                   </td>
                                   <td colspan="1" align="right">
                                          <?php echo  currency_format($_SESSION['discount_price']) ?>
                                   </td>
                            </tr>
                            <tr>
                                   <td colspan="3" align="right">
                                          <strong>Total after discount and shipping</strong>
                                   </td>
                                   <td colspan="1" align="right">
                                          <strong id="total-after"><?php echo  currency_format($total -  $_SESSION['discount_price'] + $shipping_price) ?></strong>
                                   </td>
                            </tr>
                     <?php
                     } else {
                     ?>
                            <tr>
                                   <td colspan="3" align="right">
                                          <strong>Total after shipping</strong>
                                   </td>
                                   <td colspan="1" align="right">
                                          <strong id="total-after"><?php echo  currency_format($total + $shipping_price) ?></strong>
                                   </td>
                            </tr>
                     <?php
                     }
                     ?>
              </tfoot>
       </table>
</div>
<?php if (!empty($remove)) {
       foreach ($remove as $key => $value) {
              //Add to wish list
              shopping_cart_save_product_for_later($key);
       }
} ?>