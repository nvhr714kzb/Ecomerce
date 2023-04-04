<?php
if (isset($_POST['action'])) {
       $sql = "SELECT p.id, p.name, p.thumb, p.description, p.price, s.price sale_price, p.stock, pm.promotion  FROM phones p
       INNER JOIN phone_category pc ON p.id = pc.phone_id
       LEFT OUTER JOIN sales s ON (p.id = s.product_id  AND ((NOW() BETWEEN s.start_date AND s.end_date) OR (NOW() > s.start_date AND s.end_date IS NULL)))
       LEFT OUTER JOIN promotion pm ON p.promotion_id = pm.id
       WHERE pc.category_id = {$_POST['cat_id']}";
       if (isset($_POST['minimum_price']) && isset($_POST['maximum_price'])) {
              $sql .= " AND IFNULL(s.price, p.price) BETWEEN " . (int)$_POST['minimum_price'] . " AND " . (int)$_POST['maximum_price'] . "";
       }
       if (isset($_POST['num_star'])) {
              $star_filter = implode(',', $_POST['num_star']);
              $sql .= " AND p.id IN (SELECT product_id FROM `reviews` GROUP BY product_id  HAVING ROUND(AVG(rating)) >= $star_filter)";
       }
       // echo $sql;
       if (isset($_POST['storage'])) {
              $storage_filter = implode(',', $_POST['storage']);
              $sql .= " AND p.id IN (SELECT DISTINCT  p.id FROM phones p INNER JOIN product_attribute attr ON p.id = attr.product_id 
              WHERE attribute_value_id IN ($storage_filter))";
       }
       if (isset($_POST['ram'])) {
              $ram_filter = implode(',', $_POST['ram']);
              $sql .= " AND p.id IN (SELECT DISTINCT  p.id FROM phones p INNER JOIN product_attribute attr ON p.id = attr.product_id 
              WHERE attribute_value_id IN ($ram_filter))";
       }
       if (isset($_POST['color'])) {
              $ram_filter = implode(',', $_POST['color']);
              $sql .= " AND p.id IN (SELECT DISTINCT  p.id FROM phones p INNER JOIN product_attribute attr ON p.id = attr.product_id 
              WHERE attribute_value_id IN ($ram_filter))";
       }
       if (isset($_POST['page'])) {
              $page = (int)$_POST['page'];
       } else {
              $page = 1;
       }
       $start_item = ($page - 1) * PRODUCTS_PER_PAGE;
       $total_records = db_num_rows($sql);
       $total_pages = ceil($total_records / PRODUCTS_PER_PAGE);

       $sql .= " ORDER BY p.date_created DESC LIMIT $start_item, " . PRODUCTS_PER_PAGE . "";
       $list_products = db_fetch_array($sql);
       if (!empty($list_products)) {
              $output = "<ul class='list-product'>";
              foreach ($list_products as $item) {
                     $output .= "
                      <li class='item'>
                            <a href='phone/detail/" . create_slug($item['name']) . "/{$item['id']}'>
                                   <img src='public/images/phone/{$item['thumb']}'>
                                   <h3>{$item['name']}</h3>
                                   <div class='price'>
                                          " . get_price($item['price'], $item['sale_price']) . "
                                   </div>
                                   <p class='promo'>{$item['promotion']}</p>";

                     $num_rating = get_num_rating($item['id'], 0);
                     if ($num_rating > 0) {
                            $output .=  '<div class="rating">';
                            $output .=    '<ul class="list-star">';
                            $rating = get_avg_rating($item['id']);
                            for ($i = 1; $i <= 5; $i++) {
                                   if ($i <= $rating) {
                                          $color = 'color:#ffcc00;';
                                   } else {
                                          $color = 'color:#ccc;';
                                   }
                                   $output .=    '<li id="' . $i . '" data-index="' . $i . '" style="' . $color . '">&#9733</li>';
                            }
                            $output .=  '</ul>';
                            $output .= '<span class="num-rating">(' . $num_rating . ')</span>';
                            $output .= '</div>';
                     }
                     $output .= "</a>";
                     $output .= "</li>";
              }
              $output .= "</ul>";
              echo $output;
              // ======================Pagination=================
              if ($total_pages > 1) {
                     // $output .= pagination_simple('haha' ,$_POST['cat_id'], $page, $total_pages);
                     $url = "phone/" . create_slug(get_detail_category($_POST['cat_id'])['category']) . "/{$_POST['cat_id']}";
                     link_pagination($total_pages, $page, $url);
              }
              exit();
       } else {
              $output = '<div class="alert alert-warning" role="alert">
              Your filter did not match any products.
            </div>';
       }
       echo $output;
}
