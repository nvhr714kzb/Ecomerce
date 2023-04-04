$(document).ready(function() {
    var sidebar_menu = $('#sidebar-menu > .nav-item > .nav-link');
    sidebar_menu.on('click', function() {
        if (!$(this).parent('li').hasClass('active')) {
            $('.sub-menu').slideUp();
            $(this).parent('li').find('.sub-menu').stop().slideDown();
            $('#sidebar-menu > .nav-item').removeClass('active');
            $(this).parent('li').addClass('active');
            return false;
        } else {
            $('.sub-menu').stop().slideUp();
            $('#sidebar-menu > .nav-item').removeClass('active');
            return false;
        }
    });
    $('.calendar').datepicker({ dateFormat: "yy-mm-dd", minDate: 0 });

    $('#checkAll').click(function() {
        var status = $(this).prop('checked');
        $('.checkItem').prop('checked', status);
    });
    // ========================COMMENT=======================
    $('#table tr').hover(function() {
        $('#table tr').find('.actions').css({ 'visibility': 'hidden' });
        $(this).find('.actions').css({ 'visibility': 'visible' });
    });
    // =====================Notify out of stock======================
    $(document).on('click', '.email-button', function() {
        $(this).attr('disabled', 'disabled');
        var id = $(this).attr('id');
        var action = $(this).data('action');
        var list_email = [];
        var subject_email = $('#subjectEmail').val();
        var content_email = $('#contentEmail').val();
        if (subject_email == '' || content_email == '') {
            swal("Email subject and email content must not be empty!");
            $('#' + id).attr('disabled', false);
        } else {
            if (action == 'single') {
                list_email.push({
                    name: $(this).data('name'),
                    email: $(this).data('email')
                });
            } else {
                $('.single-select').each(function() {
                    if ($(this).prop('checked')) {
                        list_email.push({
                            name: $(this).data('name'),
                            email: $(this).data('email')
                        });
                    }
                });
            }

            $.ajax({
                url: 'send_email_stock.php',
                method: 'POST',
                data: { list_email: list_email, content_email: content_email, subject_email: subject_email },
                beforeSend: function() {
                    $('#' + id).html('Sending...');
                },
                success: function(response) {
                    if (response > 0) {
                        $('#' + id).text('Sent ' + response + ' emails successfully');
                        swal('Sent ' + response + ' emails successfully');
                        $('#subjectEmail').val('');
                        $('#contentEmail').val('');
                        $('input[type="checkbox"]').prop('checked', false);

                    } else {
                        $('#' + id).text('Send email failed');
                        // $('#' + id).attr('disabled', false);
                    }
                    $('#' + id).attr('disabled', false);
                    setTimeout(function() {
                        if ($('#' + id).data('action') == 'single') {
                            $('#' + id).text('Send single');
                        } else {
                            $('#' + id).text('Send bulk');
                        }

                    }, 2000);
                },

            });
        }

    });
    // ============================ADD DISCOUNT CODE====================
    $(document).on('keypress', '#prefix, #suffix', function() {
        $('#mark').val('');
    });
    $(document).on('click', '#expiryNever', function() {
        $('#expiry').val('');
    });
    $(document).on('change', '#expiry', function() {
        $('#expiryNever').prop('checked', false);
    });
    $(document).on('change', '.formate, #length', function() {
        $('#mark').val('');
    });
    $(document).on('keypress', '#mark', function() {
        $('.formate[type="checkbox"]').prop('checked', false);
        $('select[name="letter"]').prop('selectedIndex', 0);
        $('input[name="length"]').val('');
        $('input[name="prefix"]').val('');
        $('input[name="suffix"]').val('');
    });
    $(document).on('change', '#use-mark', function() {
        if ($(this).prop("checked")) {
            $('#mark').removeAttr('disabled');
            $('.not-use-mark').attr('disabled', 'disabled');
        } else {
            $('#mark').attr('disabled', 'disabled');
            $('.not-use-mark').removeAttr('disabled');
        }

    });
    // =======================Show orders by customer============================
    $(document).on('change', '#has-login', function() {
        var is_login = $(this).prop("checked");
        $.ajax({
            url: 'get_customer.php',
            'method': 'POST',
            'dataType': 'text',
            data: { is_login: is_login },
            success: function(response) {
                if (response != '') {
                    $('#customer-id').html(response);
                }
            }
        });
    });
    // =====================Search product for post=================
    $('#search-product').keyup(function() {
        var query = $(this).val();
        $.ajax({
            url: 'search_product.php',
            method: 'POST',
            dataType: 'text',
            data: { query: query },
            success: function(response) {
                if (response != '') {
                    $('#hint-search').fadeIn();
                    $('#hint-search').html(response);
                }
            }

        });
    });
    $(document).on('click', '#list-hint-search li', function() {
        var id = $(this).data('id');
        var src = $(this).data('src');
        var name = $(this).data('name');
        $('#search-product').val('');
        $('#hint-search').fadeOut();
        $('#product-id').val(id);
        $('#preview-product').attr('src', '../public/images/phone/' + src + '');
        $('#name-product').text(name);
        //for related product
        if ($('#list-related-product').length) {
            if (!$('#list-related-product li.' + id + '').length) {
                $('#form-search-related-product').append('<input type="hidden" name="productId[]" value="' + id + '" class="' + id + '">');
                $('#list-related-product').append('<li class="' + id + '"><img src="../public/images/phone/' + src + '" alt="" width="200px"><h4>' + name + '</h4><label class="delete-item" data-id="' + id + '"><i class="far fa-minus-circle"></i></label></li>');
            } else {
                swal("This product added. Please try another product!")
            }
        }
    });

    $(document).on('click', '#list-related-product .delete-item', function() {
        var id = $(this).data('id');
        $('#list-related-product li.' + id + '').remove();
        $('#form-search-related-product input.' + id + '').remove();
    });
    // ===================UPLOAF IMAGE PRODUCT======================
    var preview = document.getElementById('preview-thumb');
    $('#upload-thumb').change(function(e) {
        var files = e.target.files;
        if (files && files.length > 0) {
            reader = new FileReader();
            reader.onload = function(e) {
                preview.src = reader.result;
            }
            reader.readAsDataURL(files[0]);
        }
    });
    // =================Avatar====================
    var avatar = document.getElementById('preview-avatar');
    $('#upload-avatar').change(function(e) {
        var files = e.target.files;
        if (files && files.length > 0) {
            reader = new FileReader();
            reader.onload = function(e) {
                avatar.src = reader.result;
            }
            reader.readAsDataURL(files[0]);
        }
    });
    // ----List image---------
    var preview_1 = document.getElementById('preview-1');
    $('#upload-1').change(function(e) {
        var files = e.target.files;
        if (files && files.length > 0) {
            reader = new FileReader();
            reader.onload = function() {
                preview_1.src = reader.result;
            }
            reader.readAsDataURL(files[0]);
        }
    });

    var preview_2 = document.getElementById('preview-2');
    $('#upload-2').change(function(e) {
        files = e.target.files;
        if (files && files.length > 0) {
            reader = new FileReader();
            reader.onload = function() {
                preview_2.src = reader.result;
            }
            reader.readAsDataURL(files[0]);
        }
    });
    var preview_3 = document.getElementById('preview-3');
    $('#upload-3').change(function(e) {
        files = e.target.files;
        if (files && files.length > 0) {
            reader = new FileReader();
            reader.onload = function() {
                preview_3.src = reader.result;
            }
            reader.readAsDataURL(files[0]);
        }
    });

    var preview_4 = document.getElementById('preview-4');
    $('#upload-4').change(function(e) {
        files = e.target.files;
        if (files && files.length > 0) {
            reader = new FileReader();
            reader.onload = function() {
                preview_4.src = reader.result;
            }
            reader.readAsDataURL(files[0]);
        }
    });
    // ======================Related product================
    $(".list-related-by-product .owl-carousel").owlCarousel({
        loop: false,
        margin: 10,
        nav: true,
        responsive: {
            0: {
                items: 2,
            },
            600: {
                items: 3,
            },
            1000: {
                items: 4,
            },
        },
    });
});