<?php
require('../includes/config.inc.php');
require('../lib/database.inc.php');
include('includes/header.html');
require('../lib/form_functions.inc.php');
require('../'. MYSQL);
require('includes/permission.php');
?>
<div id="content" class="clearfix">
<?php
include('includes/sidebar.html');
$count = 10;
if($_SERVER['REQUEST_METHOD'] === 'POST'){
       if(isset($_POST['category']) && filter_var($_POST['category'], FILTER_VALIDATE_INT, array('min_range' => 1))){
              $q = "INSERT INTO `specific_coffees`(`general_coffee_id`,  `size_id`, `caf_decaf`, `ground_whole`, `price`, `stock`) 
              VALUES (?, ?, ?, ?, ?, ?)";
              $stmt = mysqli_prepare($dbc, $q);
              mysqli_stmt_bind_param($stmt, 'iissii', $_POST['category'], $size, $caf_decaf, $ground_whole, $price, $stock);
              $affected = 0;
              for($i = 1; $i <= $count; $i++){
                     if(filter_var($_POST['stock'][$i], FILTER_VALIDATE_INT, array('min_range' => 1)) 
                     && filter_var($_POST['price'][$i], FILTER_VALIDATE_FLOAT, array('min_range' => 0))){
                            $size = $_POST['size'][$i];
				$caf_decaf = $_POST['caf_decaf'][$i];
				$ground_whole = $_POST['ground_whole'][$i];
				$price = $_POST['price'][$i];
				$stock = $_POST['stock'][$i];
                            mysqli_stmt_execute($stmt);
                            $affected += mysqli_stmt_affected_rows($stmt);
                     }
              }
              echo "<h4>{$affected} Product(s) Were Created!</h4>";

       }else{
              echo '<p class="error">Please select a category.</p>';
       }
}


?>
<h3 id="title-action">Add cofee product</h3>
<form action="add_specific_coffees.php" method="POST" accept-charset="utf8">
       <fieldset>
              <legend>Fill out the form to add specific coffee products to the site.</legend>
              <div class="field">
                     <label for="">General Coffee Type</label>
                     <select name="category">
                     <option>--Select one--</option>
                     <?php 
                     $q = "SELECT `id`, `category` FROM `general_coffees` ORDER BY `category` DESC";
                     $r = mysqli_query($dbc, $q);
                     while($row = mysqli_fetch_array($r, MYSQLI_ASSOC)){
                            echo "<option value = '{$row['id']}'>{$row['category']}</option>";
                     }
                     ?>
                     </select>
                     
              </div>
              <table>
                     <thead>
                            <tr>
                                   <th>Size</th>
                                   <th>Ground/Whole</th>
                                   <th>Caf./Decaf.</th>
                                   <th>Price</th>
                                   <th>Quantity in Stock</th>
                            </tr>
                     </thead>
                     <tbody>
                            <?php
                                   $q = "SELECT `id`,`size` FROM sizes";
                                   $r = mysqli_query($dbc, $q);
                                   $size = '';
                                   while($row = mysqli_fetch_array($r)){
                                         $size .= "<option value = '{$row['id']}'>{$row['size']}</option>";
                                   }
                                   $grinds = "<option value = 'ground'>Ground</option><option value = 'whole'>Whole</option>";
                                   $caf_decaf = '<option value="caf">Caffeinated</option><option value="decaf">Decaffeinated</option>';
                                   for($i = 1; $i <= $count; $i++){
                                          echo "
                                          <tr>
                                                 <td>
                                                        <select name = 'size[{$i}]'>{$size} </select>
                                                 </td>
                                                 <td>
                                                        <select name = 'ground_whole[{$i}]'>{$grinds} </select>
                                                 </td>
                                                 <td>
                                                        <select name = 'caf_decaf[{$i}]'>{$caf_decaf} </select>
                                                 </td>
                                                 <td>
                                                       <input type = 'text' name = 'price[{$i}]'>
                                                 </td>
                                                 <td>
                                                       <input type = 'text' name = 'stock[{$i}]'>
                                                 </td>
                                                 
                                          </tr>    
                                          ";
                                   }
                            ?>
              
                     </tbody>
              </table>
              <div class="field">
                     <input type="submit" value="Add these products">
              </div>
       </fieldset>
</form>
</div>
<?php
include('includes/footer.html');
?>