$(function() {

    $('#add_favorite_link').click(function() {
        alert('binh');
        // manage_favorites('add');
        //  alert('OK');
        return false;
    });

    //     $('#remove_favorite_link').click(function() {
    //         manage_favorites('remove');
    //         return false;
    //     });

    function manage_favorites(action) {
        $.ajax({
            // url: 'ajax/favorite.php',
            url: '?mod=ajax&act=favories',
            type: 'GET',
            dataType: 'text',
            data: {
                page_id: page_id,
                action: action
            },
            success: function(response) {
                    if (response === 'true') {
                        update_page(action);
                    } else {
                        // Do something!
                    }
                } // Success function.
        }); // Ajax
    } // End of manage_favorites() function.

    function update_page(action) {
        if (action === 'add') {
            $('#favorite_h3').html('<img src="public/images/heart.png" width="32" height="32"><span class="label label-info">This a favorite!</span> <a id="remove_favorite_link" href="?mod=page&act=remove_from_favories&id=' + page_id + '"><img src="public/images/close.png" width="32" height="32"></a></h3>');
            // $('#remove_favorite_link').click(function() { manage_favorites('remove'); return false; });
        } else {
            $('#favorite_h3').html('<h3 id="favorite_h3"><span class="label label-info">Make this a favorite!</span> <a id="add_favorite_link" href="?mod=page&act=add_to_favories&id=' + page_id + '"><img src="public/images/heart.png" width="32" height="32"></a></h3>');
            // $('#add_favorite_link').click(function() { manage_favorites('add'); return false; });
        }
    } // End of update_page() function.



}); // Main anonymous function