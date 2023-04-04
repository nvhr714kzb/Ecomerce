<div id="content" class="shopping-cart">
       <h2>Your Shopping Cart</h2>
       <?php
       if (isset($message_discount_code)) {
              echo "<div class='alert alert-success' role='alert'>
                                                        $message_discount_code
                                                      </div>";
       }
       if (isset($error_discount_code)) {
              echo "<div class='alert alert-danger' role='alert'>
                                                        $error_discount_code
                                                      </div>";
       }
       ?>
       <p><strong>You can complete checkout without an account</strong></p>
       <p>An account to enjoy</p>
       <ul style="list-style: circle; margin-left: 15px">
              <li>Faster checkout</li>
              <li>Easy access to your order status</li>
              <li>Convenient access to your past orders</li>
       </ul>
       <ul>

       </ul>
       <p>Please use this form to update your shopping cart. You may
              change the quantities, move items to your wish list for future
              purchasing, or remove items entirely. The shipping and handling
              cost is based upon the order total. When you are ready to
              complete your purchase, please click Checkout to be taken to a
              secure page for processing.</p>
       <form action="" method="POST" accept-charset="utf8">
              <table>
                     <thead>
                            <th >Item</th>
                            <th >Attribute</th>
                            <th >Image</th>
                            <th >Quantity</th>
                            <th >Price</th>
                            <th >Subtotal</th>
                            <th >Options</th>
                     </thead>
                     <tbody>
                            <?php
                            $total = 0;
                            foreach ($list_cart_items as $item) {
                                   $price = get_just_price($item['price'], $item['sale_price']);
                                   $subtotal = $price * $item['quantity'];
                            ?>

                                   <tr>
                                          <td><?php echo $item['name'] ?></td>
                                          <td><?php echo $item['attributes'] ?></td>
                                          <td><a href="phone/detail/<?php echo create_slug($item['name']) ?>/<?php echo $item['product_id'] ?>"><img src="public/images/phone/<?php echo $item['thumb'] ?>"></a></td>
                                          <td>
                                                 <input type='number' name="quantity[<?php echo $item['item_id'] ?>]" class="num-order" data-id="<?php echo $item['item_id'] ?>" data-product_id="<?php echo $item['product_id'] ?>" value="<?php echo $item['quantity'] ?>" min="1">
                                          </td>
                                          <td><?php echo currency_format($price) ?></td>
                                          <td align="right" id="sub-total-<?php echo $item['item_id'] ?>"><?php echo currency_format($subtotal) ?></td>
                                          <td align="center">
                                                 <a href="?mod=cart&act=cart&action=remove&itemId=<?php echo $item['item_id'] ?>"><i class='fas fa-trash-alt'></i></a>
                                                 <a href="?mod=cart&act=cart&action=moveSave&itemId=<?php echo $item['item_id'] ?>">Save for later</a>

                                          </td>
                                   </tr>
                            <?php
                                   //Check stock status
                                   if ($item['stock'] < $item['quantity']) {
                                          echo '<tr class="error"><td colspan="7" align="center">There are only ' . $item['stock'] . ' left in stock of the ' . $item['name'] . '. Please update the quantity, remove the item entirely, or move it to your wish list.</td></tr>';
                                   }
                                   $total += $subtotal;
                            }
                            ?>
                     </tbody>
                     <tfoot>
                            <tr>
                                   <td colspan='4' class="text-left">
                                          <input type="submit" name="updateQty" value="Update Quantities" class="btn-yellow">
                                   </td>
                                   <td colspan='2' align="right">Total</td>
                                   <td colspan="1" align="right" id="total-price"><?php echo currency_format($total) ?></td>
                            </tr>
                            <tr>
                                   <td colspan='4' class="text-left">
                                          <input type="text" name="discountCode" placeholder="Discount code" maxlength="25">
                                          <input type="submit" name="subDiscount" value="Apply" class="btn-yellow">
                                          <input type="submit" name="deleteDiscount" value="Delete" class="btn-yellow">
                                   </td>
                                   <?php
                                   $shipping_price = get_shipping($total);
                                   $_SESSION['shipping'] = $shipping_price;
                                   ?>
                                   <td colspan='2' align="right">Shipping</td>
                                   <td colspan='1' align="right" id="shipping">
                                          <?php echo currency_format($shipping_price) ?>
                                   </td>
                            </tr>
                            <?php
                            if (isset($_SESSION['discount_code'])) {
                                   $discount_code = get_discount_code($_SESSION['discount_code']);
                                   // $message_discount_code = '';
                                   if ($discount_code['active'] == 1) {
                                          if ($discount_code['expired'] == 1) {
                                                 $_SESSION['discount_price'] = 0;
                                                 // $message_discount_code = 'Sorry, this voucher has expired';
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
                                          <td colspan="6" align="right">
                                                 Discount
                                          </td>
                                          <td id="discount" colspan="1" align="right">
                                                 <?php echo  currency_format($_SESSION['discount_price']) ?>
                                          </td>
                                   </tr>
                                   <tr>
                                          <td colspan="6" align="right">
                                                 <strong>Total after discount and shipping</strong>
                                          </td>
                                          <td colspan="1" align="right">
                                                 <strong id="total-after"><?php echo currency_format($total -  $_SESSION['discount_price'] +  $shipping_price) ?></strong>
                                          </td>
                                   </tr>
                            <?php
                            } else {
                            ?>
                                   <tr>
                                          <td colspan="6" align="right">
                                                 <strong>Total after shipping</strong>
                                          </td>
                                          <td colspan="1" align="right">
                                                 <strong id="total-after"><?php echo  currency_format($total + $shipping_price) ?></strong>
                                          </td>
                                   </tr>
                            <?php
                            }
                            ?>

                            <tr>
                                   <td colspan='7' class="text-right">
                                          <?php
                                          if (is_login()) {
                                                 echo ' <a href="?mod=checkout&act=checkout" id="checkout" class="btn-yellow">Check out</a>';
                                          } else {
                                                 echo ' <a href="?mod=checkout&act=checkout_not_login" id="checkout" class="btn-yellow">Check out</a>';
                                          }
                                          ?>
                                   </td>
                            </tr>
                     </tfoot>

              </table>

       </form>
</div>