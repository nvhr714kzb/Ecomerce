<div id="content" class="clearfix">
       <!-- <div id="bedcrumb-shipping">
              <img src="https://images-na.ssl-images-amazon.com/images/G/01/x-locale/checkout/checkout-spc-address-banner._CB485941369_.gif" alt="">
       </div> -->
       <div id="shipping-address">
              <h2>Edit a shipping address</h2>
              <form action="" method="POST" accept-charset="utf8">
                     <?php
                     create_form_input('first_name', 'text', 'First name', $shipping_errors , $value);
                     create_form_input('last_name', 'text', 'Last name', $shipping_errors, $value);
                     create_form_input('country', 'text', 'Country', $shipping_errors, $value);
                     create_form_input('address1', 'text', 'Street Address', $shipping_errors, $value);
                     create_form_input('address2', 'text', 'Street Address, Continued', $shipping_errors, $value);
                     create_form_input('city', 'text', 'City', $shipping_errors, $value);
                     create_form_input('state', 'select', 'State', $shipping_errors, $value);
                     create_form_input('zip', 'text', 'Zip Code', $shipping_errors, $value);
                     create_form_input('phone', 'text', 'Phone number', $shipping_errors, $value);
                     create_form_input('email', 'text', 'Email Address', $shipping_errors, $value);
                     ?>
                     <div class="form-group text-right">
                            <input type="submit" value="Update address" class="no-style submit btn-yellow">
                     </div>
              </form>
       </div>
</div>