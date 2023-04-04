<?php

if (isset($_GET['id']) && filter_var(isset($_GET['id']), FILTER_VALIDATE_INT, array('min_range' => 1))) {
       $id = $_GET['id'];
       $detail_phone = get_detail_phone($id);
       if (!empty($detail_phone)) {
              $page_title = $detail_phone['name'];
              get_header();
              $list_images = get_images($id);
              $list_attr = get_attribute($id);
              $total_rating = get_num_rating($id, 0);
              $list_reviews = get_reviews($id);
              $list_posts = get_list_post_by_product_id($id, POSTS_PER_PAGE_FOR_PRODUCT);
              $num_stock = num_stock($id);

              $list_related_products = get_recommend_related_product($id, NUM_ITEMS_SLIDER);
              $list_also_bought = get_recommends_also_bought($id, NUM_ITEMS_SLIDER);
              $list_products_same_category = get_recommend_products_same_category($id, NUM_ITEMS_SLIDER);
              //Out of stock
              // if (isset($_POST['name'])) { //due to ajax must POST['name']
              //        $error_notify = '';
              //        if (empty($_POST['name'])) {       
              //               $error_notify = 'Please enter your name';
              //        } else {
              //               if (!is_name($_POST['name'])) {
              //                      $error_notify = 'Your name is invalid';
              //               }
              //        }
              //        if (empty($_POST['email'])) {
              //               $error_notify .= 'Please enter your email';
              //        } else {
              //               if (!is_email($_POST['email'])) {
              //                      $error_notify .= 'Email is invalid';
              //               }
              //        }
              //        if (empty($error_notify)) {
              //               add_notify_out_of_stock($id, $_POST['name'], $_POST['email']);
              //        }
              // }
              //Review
              // if (isset($_POST['submitAddReview'])) {
              //        $review = strip_tags($_POST['review']);
              //        if (empty($review)) {
              //               $review_errors['review'] = 'Please enter your review!';
              //        }
              //        if (!empty($_POST['star'])) {
              //               if (filter_var($_POST['star'], FILTER_VALIDATE_INT, array('min_rage' => 1, 'max_range' => 5))) {
              //                      $star = $_POST['star'];
              //               } else {
              //                      $review_errors['star'] = 'Please select your rating!';
              //               }
              //        } else {
              //               $review_errors['star'] = 'Please select your rating!';
              //        }
              //        if (empty($review_errors)) {
              //               add_review($_SESSION['user_id'], $id, $review, $star);
              //               $message = 'Thank you for your review!';
              //               $_POST = array();
              //        }
              // }
              include("view/product/detail_product.php");
              echo "
              <script>
              var product_id = $id;
              var num_stock = $num_stock;
              </script>
              <script src='public/js/reviews.js'></script>
              ";
       } else {
              $page_title = 'Error';
              get_header();
              include('view/error/error.html');
       }
} else {
       $page_title = 'Error';
       get_header();
       include('view/error/error.html');
}
get_footer();
