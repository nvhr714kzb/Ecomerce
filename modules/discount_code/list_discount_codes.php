<?php
$page_title = "List Voucher code";
get_header();

$page = isset($_GET['page']) ? $_GET['page'] : 1;
if ($page > 1) {
       $start_item = ($page - 1) * CODE_PER_PAGE;
} else {
       $start_item = 0;
}

$q = "SELECT voucher_code, active, min_basket_cost, discount_operation, discount_amount, num_vouchers, expiry FROM discount_codes WHERE active = 1 AND (NOW() < expiry OR expiry IS NULL)";

$filter_q = $q . " LIMIT $start_item, ".CODE_PER_PAGE."";

$total_data = db_num_rows($q);
$total_link = ceil($total_data / CODE_PER_PAGE);


$list_discount_code = db_fetch_array($filter_q);
if (!empty($list_discount_code)) {
       include('view/discount_code/list_discount_codes.php');
} else {
       ?>
              <div id="content" class="discount-code">
                     <div>
                            <h2>List discount code</h2>
                            <p>List discount code is currently empty.</p>
                     </div>
              </div>
       <?php
      
}
get_footer();
