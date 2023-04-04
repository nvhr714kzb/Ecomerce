$(function() {
    $(document).on('change', '.num-order', function() {
        var item_id = $(this).data('id');
        var product_id = $(this).data('product_id');
        var qty = $(this).val();
        check_out_stock(item_id, product_id, qty);
    });

    function check_out_stock(itemId, productId, qty) {
        $.ajax({
            url: '?mod=ajax&act=check_stock_in_cart',
            method: 'POST',
            data: { product_id: productId },
            dataType: 'text',
            success: function(numStock) {
                if (qty > parseInt(numStock)) {
                    swal("Can't increment anymore due to out of stock!");
                    $('.num-order[data-id=' + itemId + ']').val(numStock);
                } else {
                    add_cart(itemId, qty);
                }
            }
        });
    }

    function add_cart(itemId, qty) {
        $.ajax({
            url: '?mod=ajax&act=cart',
            method: 'POST',
            data: { item_id: itemId, qty: qty },
            dataType: 'json',
            success: function(response) {
                if (response.is_success) {
                    $('#sub-total-' + itemId).text(response.sub_total);
                    $('#shipping').text(response.shipping);
                    $('#discount').text(response.discount);
                    if (response.message != '') {
                        swal(response.message);
                    }
                    $('#total-price').text(response.total);
                    $('#total-after').text(response.total_after);
                }

            }
        });
    }
    // =================Add cart===================
    $(document).on('click', '#add-cart', function(e) {
        $(document).on('submit', '#formCart', function(e) {
            e.preventDefault();
            var form_data = $(this).serialize();
            $.ajax({
                url: "?mod=ajax&act=add_cart",
                method: "POST",
                data: form_data,
                dataType: "json",
                success: function(response) {
                    swal(response.message);
                    $('#count-cart').text(response.num_cart);
                },
            });
        });

    });
    // =================Add wishlist===================
    $(document).on('click', '#add-wishlist', function(e) {
        $(document).on('submit', '#formCart', function(e) {
            e.preventDefault();
            var form_data = $(this).serialize();
            $.ajax({
                url: "?mod=ajax&act=add_wishlist",
                method: "POST",
                data: form_data,
                dataType: "text",
                success: function(response) {
                    swal(response);
                },
            });
        });

    });
});