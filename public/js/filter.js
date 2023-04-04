$(function() {
    // filter_data();
    function filter_data(page = 1) {
        var action = 'fetch_data';
        var minimum_price = $('#hidden-minimum-price').val();
        var maximum_price = $('#hidden-maximum-price').val();
        var num_star = get_filter('num-star');
        var storage = get_filter('storage');
        var ram = get_filter('ram');
        var color = get_filter('color');
        $.ajax({
            url: '?mod=ajax&act=filter',
            method: 'POST',
            dataType: 'text',
            data: { action: action, page: page, minimum_price: minimum_price, maximum_price: maximum_price, cat_id: cat_id, num_star: num_star, storage: storage, ram: ram, color: color },
            success: function(response) {
                $('#list-product-wp .section-detail').html(response);
            },
            error: function(xhr, ajaxOptions, thrownError) {
                alert(xhr.status);
                alert(thrownError);
            }
        });
    }

    function get_filter(class_name) {
        var filter = [];
        $('.' + class_name + ':checked').each(function() {
            filter.push($(this).val());
        });
        return filter;
    }
    $(document).on('click', '.common-selector', function() {
        filter_data();
    });
    // ============Pagination===============
    $(document).on('click', '.page-item', function(e) {
        if (!$(this).hasClass('disabled') && !$(this).hasClass('active')) {
            var page = $(this).attr('id');
            filter_data(page);
        }
        e.preventDefault();
    });

    $('#price-range').slider({
        range: true,
        min: 100000,
        max: 100000000,
        values: [100000, 100000000],
        step: 100000,
        stop: function(event, ui) {
            $('#price-show').html(ui.values[0] + ' - ' + ui.values[1]);
            $('#hidden-minimum-price').val(ui.values[0]);
            $('#hidden-maximum-price').val(ui.values[1]);
            filter_data();
        }
    });
});