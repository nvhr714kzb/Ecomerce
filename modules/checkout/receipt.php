<?php
if (!isset($_GET['x'], $_GET['y'], $_GET['z']) || !filter_var($_GET['x'], FILTER_VALIDATE_INT, array('min_range' => 1)) || strlen($_GET['y']) !== 40) {
    redirect();
} else {
    $order_id = $_GET['x'];
    $email_hash = $_GET['y'];
}
include('includes/plain_header.php');
if($_GET['z'] == 0){
    $q = "SELECT o.total, o.shipping, o.discount_price, o.credit_card_number, DATE_FORMAT(order_date, '%a %b %e, %Y at %h:%i:%p') od, 
    c.email, CONCAT(c.first_name, ' ', c.last_name) customer_name, CONCAT_WS(' ', c.address1, c.address2, c.city, c.state, c.zip) address,
    c.phone, p.name product_name, oc.quantity, oc.attributes, oc.price FROM orders_not_login o 
    INNER JOIN order_contents_not_login oc ON o.order_id = oc.order_id 
    INNER JOIN customers c ON o.customer_id = c.id 
    INNER JOIN phones p ON oc.product_id = p.id
    WHERE o.order_id = $order_id AND SHA1(c.email) = '$email_hash'";
}else{
    $q = "SELECT o.total, o.shipping, o.discount_price, o.credit_card_number, DATE_FORMAT(order_date, '%a %b %e, %Y at %h:%i:%p') od, 
    o.email, CONCAT(o.first_name, ' ', o.last_name) customer_name, CONCAT_WS(' ', o.address1, o.address2, o.city, o.state, o.zip) address,
    o.phone, p.name product_name, oc.quantity, oc.attributes, oc.price FROM orders o 
    INNER JOIN order_contents oc ON o.order_id = oc.order_id 
    INNER JOIN users u ON o.customer_id = u.id 
    INNER JOIN phones p ON oc.product_id = p.id
    WHERE o.order_id = $order_id AND SHA1(o.email) = '$email_hash'";
}

$stmt = mysqli_prepare($dbc, $q);
mysqli_stmt_execute($stmt);
mysqli_stmt_store_result($stmt);
if (mysqli_stmt_num_rows($stmt) > 0) {
    echo '<h3>Your Order</h3>';
    mysqli_stmt_bind_result($stmt, $total_after, $shipping, $discount_price, $cc_num, $order_date, $email, $name, $address, $phone, $item, $quantity, $attributes, $price);
    mysqli_stmt_fetch($stmt);
    // Display the order and customer information:
    echo '<p><strong>Order ID</strong>: ' . $order_id . '</p><p><strong>Order Date</strong>: ' . $order_date . '</p><p><strong>Customer Name</strong>: ' . htmlspecialchars($name) . '</p><p><strong>Shipping Address</strong>: ' . htmlspecialchars($address) . '</p><p><strong>Customer Email</strong>: ' . htmlspecialchars($email) . '</p><p><strong>Customer Phone</strong>: ' . htmlspecialchars($phone) . '</p><p><strong>Credit Card Number Used</strong>: *' . $cc_num . '</p>';

    // Create the table:
    echo '<table border="0" cellspacing="3" cellpadding="3">
        <thead>
            <tr>
            <th align="center">Item</th>
            <th align="center">Attribute</th>
            <th align="center">Quantity</th>
            <th align="right">Price</th>
            <th align="right">Subtotal</th>
        </tr>
        </thead>
        <tbody>';
    $total = 0;
    do {
        echo '<tr>
                <td align="left">' . $item . '</td>
                <td align="left">' . $attributes . '</td>
                <td align="center">' . $quantity . '</td>
                <td align="right">' .currency_format($price) . '</td>
                <td align="right">' . currency_format($price * $quantity) . '</td>
            </tr>';
            $total += $price * $quantity;
    } while (mysqli_stmt_fetch($stmt));

    echo '<tr>
    <td align="right" colspan="4"><strong>Total</strong></td>
    <td align="right">' . currency_format($total) . '</td>
</tr>';
    echo '<tr>
            <td align="right" colspan="4"><strong>Shipping</strong></td>
            <td align="right">' . currency_format($shipping) . '</td>
        </tr>';
    if (!empty($discount_price)) {
        echo '<tr>
            <td align="right" colspan="4"><strong>Discount price</strong></td>
            <td align="right">' . currency_format($discount_price) . '</td>
        </tr>';
    }

    echo '<tr>
            <td align="right" colspan="4"><strong>Total after</strong></td>
            <td align="right">' . currency_format($total_after) . '</td>
        </tr>';

    // Complete the table and the form:
    echo '</tbody></table>';
} else { // No records returned!
    echo '<h3>Error!</h3><p>This page has been accessed in error.</p>';
}

include('includes/plain_footer.php');
