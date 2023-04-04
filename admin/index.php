<?php
require('../includes/config.inc.php');
require('../lib/database.inc.php');
// require('lib/product_function.inc.php');
require('lib/account_functions.inc.php');
require('../lib/user.inc.php');
require('../' . MYSQL);
require('includes/permission.php');
include('includes/header.html');

$chart_data = '';
$list_account = get_list_account();
foreach ($list_account as $item) {
       $chart_data .= "{ year:" . $item["year"] . ", profit:" . $item["profit"] . ", purchase:" . $item["purchase"] . ", sale:" . $item["sale"] . "}, ";
}
$chart_data = substr($chart_data, 0, -2);
?>
<div id="content-wp" class="clearfix">
       <?php include('includes/sidebar.html') ?>
       <div id="content" class="float-right">
              <div id="list-card">
                     <div class="card">
                            <div class="card-head">
                                   Number of orders
                            </div>
                            <div class="card-body">
                                   <h5 class="cart-title">2.680</h5>
                            </div>
                            <label><img class="icon-card" src="../public/images/icon/money.svg" alt="" style="width: 50px;"></label>
                     </div>
                     <div class="card">
                            <div class="card-head">
                                   Number of users
                            </div>
                            <div class="card-body">
                                   <h5 class="cart-title">2.680</h5>
                            </div>
                            <label><img class="icon-card" src="../public/images/icon/person.svg" alt="" style="width: 50px;"></label>
                     </div>
                     <div class="card">
                            <div class="card-head">
                                   Revenue
                            </div>
                            <div class="card-body">
                                   <h5 class="cart-title">2.680</h5>
                            </div>
                            <label><img class="icon-card" src="../public/images/icon/money.svg" alt="" style="width: 50px;"></label>
                     </div>
              </div>
              <div id="chart">

              </div>

       </div>
</div>
<script>
       $(document).ready(function() {
              $(".owl-carousel").owlCarousel();
       });
       Morris.Bar({
              element: 'chart',
              data: [<?php echo $chart_data; ?>],
              xkey: 'year',
              ykeys: ['profit', 'purchase', 'sale'],
              labels: ['Profit', 'Purchase', 'Sale'],
              barColors: ['#4834d4', '#eb2f06', '#44bd32'],
              hideHover: 'auto',
              gridTextSize: '18'

       });
</script>