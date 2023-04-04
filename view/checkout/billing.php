<div id="content" class="clearfix">
       <!-- <div id="bedcrumb-shipping">
              <img src="https://images-na.ssl-images-amazon.com/images/G/01/x-locale/checkout/checkout-spc-address-banner._CB485941369_.gif" alt="">
       </div> -->
       <div id="billing" class="float-left">
              <h1>Your Billing Information</h1>
              <?php
                     if(isset($message)){
                            echo "<div class='alert alert-danger' role='alert'>
                            $message;
                          </div>";
                     }
              ?>
              <p>Please enter your billing information below. Then click the button to complete your order. For your security, we will not store your billing information in any way. We accept Visa, MasterCard, American Express, and Discover.</p>
              <?php if (isset($message)) echo "<p class=\"error\">$message</p>"; ?>
              <form action="?mod=checkout&act=billing" method="POST" id="billing-form" accept-charset="utf8">
                     <span id="error-span"></span>
                     <?php
                     create_form_input('cc_number', 'text', 'Card Number', $billing_errors, 'POST', array('autocomplete' => 'off'));
                     create_form_input('cc_exp_month', 'select', 'Expiration Month', $billing_errors);
                     create_form_input('cc_exp_year', 'select', 'Expiration Year', $billing_errors);
                     create_form_input('cc_cvv', 'text', 'CVV', $billing_errors, 'POST', array('autocomplete' => 'off'));
                     create_form_input('cc_first_name', 'text', 'First name', $billing_errors, $values);
                     create_form_input('cc_last_name', 'text', 'Last name', $billing_errors, $values);
                     create_form_input('cc_address', 'text', 'Street Address', $billing_errors, $values);
                     create_form_input('cc_city', 'text', 'City', $billing_errors, $values);
                     create_form_input('state', 'select', 'State', $billing_errors, $values);
                     create_form_input('cc_zip', 'text', 'Zip Code', $billing_errors, $values);
                     ?>

                     <div class="form-group text-right" id="submit_div">
                            <input type="submit" name="submitPlaceOrder" value="Place order" class="no-style submit btn-yellow">
                     </div>
              </form>
       </div>
       <?php include('view/checkout/checkout_cart.php'); ?>
</div>