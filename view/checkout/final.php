<div id="content" class="final">
    <h2>Your Order is Complete</h2>
    <p>Thank you for your order (#<?php echo $_SESSION['order_id']; ?>). Please use this order number in any correspondence with us.</p>
    <p>A charge of $<?php echo currency_format($_SESSION['order_total']); ?> will appear on your credit card when the order ships. All orders are processed on the next business day. You will be contacted in case of any delays.</p>
    <p>An email confirmation has been sent to your email address. <a href="?mod=checkout&act=receipt&x=<?php echo $_SESSION['order_id'] . '&y=' . sha1($_SESSION['email']); ?>&z=1" style="display: inline-block;" target="_blank">Click here</a> to create a printable receipt of your order.</p>
</div>