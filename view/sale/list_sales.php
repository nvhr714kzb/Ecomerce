<div id='content'>
       <div class='section'>
              <div class="section-head">
              <h2 class="section-title">List Sale Phones</h2>
              </div>
              <div class='section-detail'>
                     <ul class='list-product'>
                            <?php
                            foreach ($list_sale_products as $item) {
                            ?>
                                   <li class='item'>
                                          <a href="phone/detail/<?php echo create_slug($item['name']) ?>/<?php echo $item['id'] ?>">
                                                 <img src="public/images/phone/<?php echo $item['thumb'] ?>">
                                                 <h3><?php echo $item['name'] ?></h3>
                                                 <div class='price'>
                                                        <?php echo get_price($item['price'], $item['sale_price']) ?>
                                                 </div>
                                                 <p class='promo'><?php echo $item['promotion'] ?></p>
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
                                          </a>
                                   </li>
                            <?php } ?>
                     </ul>
              </div>
       </div>
</div>