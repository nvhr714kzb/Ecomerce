<div id="content" class="clearfix">
       <div id="shipping-address">
              <h2>Add a shipping address</h2>
              <form action="" method="POST" accept-charset="utf8">
                     <?php
                     create_form_input('first_name', 'text', 'First name', $shipping_errors);
                     create_form_input('last_name', 'text', 'Last name', $shipping_errors);
                     create_form_input('country', 'text', 'Country', $shipping_errors);
                     create_form_input('address1', 'text', 'Street Address', $shipping_errors);
                     create_form_input('address2', 'text', 'Street Address, Continued', $shipping_errors);
                     create_form_input('city', 'text', 'City', $shipping_errors);
                     create_form_input('state', 'select', 'State', $shipping_errors);
                     create_form_input('zip', 'text', 'Zip Code', $shipping_errors);
                     create_form_input('phone', 'text', 'Phone number', $shipping_errors);
                     create_form_input('email', 'text', 'Email Address', $shipping_errors);
                     ?>
                     <div class="form-group text-right">
                            <input type="submit" value="Add new address" class="no-style submit btn-yellow">
                     </div>
              </form>
       </div>
</div>