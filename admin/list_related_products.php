<?php
require('../includes/config.inc.php');
require('../lib/database.inc.php');
require('../lib/helper.inc.php');
require('lib/product_functions.inc.php');
require('../lib/user.inc.php');
require('../' . MYSQL);
require('includes/permission.php');
include('includes/header.html');
?>
<div id="content-wp" class="clearfix">
    <?php
    include('includes/sidebar.html');
    if($_SERVER['REQUEST_METHOD'] === 'POST'){
        foreach($_POST as $key => $value){
            if(substr($key, 0, 6) === 'submit'){
                $last_hyphen = strrpos($key, '-');
                $action = substr($key, strlen('submit-'), $last_hyphen - strlen('submit-'));
                $underline = strrpos($key, '_');
                $product_id = substr($key , $last_hyphen + 1, $underline - $last_hyphen - 1);
               
                $list_product_id_related = substr($key , $underline + 1);
                if($action == 'delete'){
                    $q = "DELETE FROM related_phone WHERE (product_a = $product_id OR  product_b = $product_id) AND (product_a IN ($list_product_id_related) OR  product_b IN ($list_product_id_related))";
                    db_query($q);
                    $message = 'All related products has been deleted successfully';
                }
            }
        }
    }
    $list_related_products = get_list_related_products();
    ?>
    <div id="content" class="float-right">
        <div class="section list-relate-product">
            <div class="section-head">
                <h3 class="section-title">List Related Product</h3>
                <a class="section-add" href="<?php echo BASE_URL ?>admin/add_related_products.php">Add related products</a>
                <?php
                    if(isset($message)){
                        echo "<div class='alert alert-success' role='alert'>
                        $message
                      </div>";
                    }
                ?>
            </div>
            <div class="section-detail">
                <form action="" method="POST">
                    <table id="table">
                        <thead>
                            <th>Product</th>
                            <th >Image</th>
                            <th >List related products</th>
                            <th >Action</th>
                        </thead>
                        <tbody>
                            <?php
                            foreach ($list_related_products as $item) {
                            ?>
                                <tr>
                                    <td><?php echo $item['name'] ?></td>
                                    <td><img src="../public/images/phone/<?php echo $item['thumb'] ?>" alt="" width="100px"></td>
                                    <td >
                                        <ul class="list-related-by-product">
                                            <!-- <div class="owl-carousel owl-theme"> -->
                                                <?php
                                                $list_recommend_related_product = get_recommend_related_products($item['product_id'], 100);
                                                $list_product_id = array();
                                                foreach ($list_recommend_related_product as $item_related) {
                                                    $list_product_id[] = $item_related['id'];
                                                ?>
                                                    <li class="item"> <img src="../public/images/phone/<?php echo $item_related['thumb'] ?>" alt="" width="50px"></li>
                                                  
                                                <?php
                                                }
                                                ?>
                                            <!-- </div> -->
                                        </ul>
                                    </td>

                                    <td>
                                        <input type="submit" name="submit-delete-<?php  echo $item['product_id']?>_<?php  echo implode(',', $list_product_id)?>" value="Delete products related this product" onclick="return confirm('Are you sure you delete it ?')">
                                    </td>   
                                </tr>
                            <?php
                            }
                            ?>
                        </tbody>
                    </table>
                </form>
            </div>
        </div>
    </div>
</div>