$(function () {
    $('#s').keyup(function () {
        var query = $(this).val();
        $.ajax({
            url: '?mod=ajax&act=search',
            method: 'POST',
            dataType: 'text',
            data: { query: query },
            success: function (response) {
                if (response != '') {
                    $('#hint-search').fadeIn();
                    $('#hint-search').html(response);
                }
            }

        });
    });
    $(document).on('click', '#list-hint-search li', function (e) {

        var text = $(this).children('p').text();
        $('#s').val(text);
        $('#hint-search').fadeOut();
        $('#form-search').submit();
    });
    $(document).on('click', 'html', function () {
        $('#hint-search').fadeOut();
    });
})