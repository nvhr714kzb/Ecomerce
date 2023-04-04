<div id="content" class="shopping-cart">
       <h2>Your Wish List</h2>
       <form action="?mod=cart&act=cart" method="POST" accept-charset="utf8">
              <table>
                     <tr>
                            <th>Item</th>
                            <th>Attribute</th>
                            <th>Image</th>
                            <th>Quantity</th>
                            <th>Price</th>
                            <th>Subtotal</th>
                            <th>Options</th>
                     </tr>

                     <?php
                     $total = 0;
                     foreach ($list_save_items as $item) {
                            $price = get_just_price($item['price'], $item['sale_price']);
                            $subtotal = $price * $item['quantity'];
                     ?>
                            <tr>
                                   <td><?php echo $item['name'] ?></td>
                                   <td><?php echo $item['attributes'] ?></td>
                                   <td><a href="phone/detail/<?php echo create_slug($item['name']) ?>/<?php echo $item['product_id'] ?>"><img src="public/images/phone/<?php echo $item['thumb'] ?>"></a></td>
                                   <td>
                                         <?php echo $item['quantity'] ?>
                                   </td>
                                   <td><?php echo currency_format($price) ?></td>
                                   <td><?php echo currency_format($subtotal) ?></td>
                                   <td align="center">
                                          <a href="?mod=cart&act=wishlist&action=remove&itemId=<?php echo $item['item_id'] ?>"><i class='fas fa-trash-alt'></i></a>
                                          <a href="?mod=cart&act=wishlist&action=moveCart&itemId=<?php echo $item['item_id'] ?>">Move to cart</a>

                                   </td>
                            </tr>
                     <?php
                     }
                     ?>
              </table>
       </form>
</div>