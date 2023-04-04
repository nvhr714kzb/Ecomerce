<div id='content'>
       <div class='section'>
              <div class='section-detail'>
              <?php 
                     if(!empty($search_result['product'])){
              ?>
                     <ul class='list-product'>
                     <?php
                            foreach ($search_result['product'] as $item) {
                      ?>
                            <li class='item'>
                                   <a href="?mod=product&act=detail_product&id=<?php echo $item['id'] ?>">
                                          <img src="public/images/phone/<?php echo htmlspecialchars($item['thumb']) ?>"">
                                          <h3><?php echo $item['name'] ?></h3>
                                          <p class='stock'>Availability: <?php echo get_stock_status($item['stock']) ?></p>
                                          <div class='price'>
                                                 <?php echo get_price($item['price'], $item['sale_price']) ?>
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
                                   </a>
                            </li>
                            <?php }?>
                     </ul>
              <?php
                     }else{
              ?>
                            <p>Your search -<strong> <?php echo $search_str ?></strong> - did not match any documents.</p>
                            <p>Suggestions:</p>
                            <ul style="list-style: circle;">
                                   <li>Make sure that all words are spelled correctly.</li>
                                   <li>Try different keywords.</li>
                                   <li>Try more general keywords.</li>
                                   <li>Try fewer keywords.</li>
                            </ul>
              <?php
                     }
              ?>
              </div>
              <?php
              $num_pages_search = num_page_search($_GET['searchStr'], $all_words, $page);
              if($num_pages_search > 1){
                     $url = "?mod=search&act=search&searchStr={$_GET['searchStr']}&all-words=$all_words";
                     pagination($num_pages_search, $page, $url);
              }
              ?>

       </div>
</div>