<div id="content" class="clearfix">
       <!-- <div id="bedcrumb-shipping">
              <img src="https://images-na.ssl-images-amazon.com/images/G/01/x-locale/checkout/checkout-spc-address-banner._CB485941369_.gif" alt="">
       </div> -->
       <div id="shipping-address" class="float-left">
              <h2>Your Shipping Information</h2>
              <p>Please enter your shipping information. On the next page, you'll be able to enter your billing information and complete the order. Please check the first box if your shipping and billing addresses are the same. <span class="required">*</span> Indicates a required field. </p>
              <form action="" method="POST" accept-charset="utf8">
                     <div class="form-group">
                            <label for="use"><strong>Use Same Address for Billing?</strong></label>
                            <input type="checkbox" name="use" value="Y" id="use" <?php if (isset($_POST['use'])) echo 'checked="checked" '; ?> />
                     </div>
                     <?php
                     create_form_input('first_name', 'text', 'First name', $shipping_errors);
                     create_form_input('last_name', 'text', 'Last name', $shipping_errors);
                     create_form_input('address1', 'text', 'Street Address', $shipping_errors);
                     create_form_input('address2', 'text', 'Street Address, Continued', $shipping_errors);
                     create_form_input('city', 'text', 'City', $shipping_errors);
                     create_form_input('state', 'select', 'State', $shipping_errors);
                     create_form_input('zip', 'text', 'Zip Code', $shipping_errors);
                     create_form_input('phone', 'text', 'Phone number', $shipping_errors);
                     create_form_input('email', 'text', 'Email Address', $shipping_errors);
                     ?>
                     <div class="form-group text-right">
                            <input type="submit" value="Continue onto Billing" class="no-style submit btn-yellow">
                     </div>
              </form>
       </div>
       <?php include('view/checkout/checkout_cart.php'); ?>
</div>