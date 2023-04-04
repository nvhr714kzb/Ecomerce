$(function() {
    $(document).on('click', '#view-more-post', function() {
        var start = $(this).data('start');
        $(this).html('Loading');
        $.ajax({
            url: '?mod=ajax&act=load_post&start=' + start + '',
            type: 'GET',
            dataType: 'text',
            success: function(response) {
                if (response != '') {
                    $('#view-more-post').remove();
                    $('.list-post').append(response);
                } else {
                    $('#view-more-post').html('No more');
                    $('#view-more-post').css('cursor', 'auto');
                }
            }
        });
    });
});