$(function() {
    $(document).on('click', '#review-form .star', function() {
        var id = $(this).data('index');
        remove_background();
        for (var i = 1; i <= id; i++) {
            $('#star-' + i).css('color', '#ffcc00');

        }
    });

    function remove_background() {
        for (var i = 1; i <= 5; i++) {
            $('#star-' + i).css('color', '#ccc');

        }
    }
    var notes_form = $('#review-form');
    notes_form.submit(function(event) {
        event.preventDefault();
        var form_data = $(this).serialize();
        $.ajax({
            url: '?mod=ajax&act=review',
            type: 'POST',
            dataType: 'JSON',
            data: form_data + '&product_id=' + product_id,
            success: function(response) {
                if (response.is_success) {
                    swal("You have added successfully the review!", "Please wait for approval !", "success");
                    // $('#review-form')[0].reset();
                    $('#add-review').replaceWith("<p>You already have reviewed this product</p>");
                    remove_background();
                } else {
                    for (var i = 0; i < response.list_errors.length; i++) {
                        swal(response.list_errors[i]);
                    }
                }

            }
        });
    });
});