$(function() {
    // ==================View more==================
    $(document).on("click", "#view-more-product", function() {
        $("#detail-product-body .section-detail").toggleClass('more');
        if ($('#detail-product-body .section-detail').hasClass('more')) {
            $(this).text('Less more');
        } else {
            $(this).text('View more');
        }
    });
    $(document).on("click", "#plus", function() {
        var current_val = $("#num-cart").val();
        $("#num-cart").val(parseInt(current_val) + 1);
        if ($("#num-cart").val() > num_stock) {
            //check stock
            $("#num-cart").val(num_stock);
            swal("Can't increment anymore due to out of stock!");
        }
    });
    $(document).on("click", "#minus", function() {
        var current_val = $("#num-cart").val();
        $("#num-cart").val(parseInt(current_val) - 1);
        if ($("#num-cart").val() < 1) {
            //check -
            if (num_stock == 0) {
                $("#num-cart").val(0);
            } else {
                $("#num-cart").val(1);
            }
        }
    });
    $(document).on("submit", "#formNotify", function(e) {
        var form_data = $(this).serialize();
        $.ajax({
            url: '?mod=ajax&act=add_notify_stock',
            type: 'POST',
            dataType: 'json',
            data: form_data + '&product_id=' + product_id,
            success: function(response) {
                swal(response.message);
                if (response.is_success) {
                    $("#formNotify")[0].reset();
                }
            }
        });

        e.preventDefault();
    });
    // ==============Attr click==================
    $(document).on("click", "label.attr", function() {
        $(this).nextAll().css("box-shadow", "");
        $(this).prevAll().css("box-shadow", "");
        $(this).nextAll().css("border-color", "#A2A6AC");
        $(this).prevAll().css("border-color", "#A2A6AC");
        $(this).css("box-shadow", "0px 0px 2px 2px #f1c40f");
        $(this).css("border-color", "transparent");
    });
});