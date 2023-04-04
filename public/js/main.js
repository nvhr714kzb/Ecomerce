$(document).ready(function() {
    // ===================Code==================
    $(document).on('click', '#list-code .code-icon', function() {
        var code = $(this).data('code');
        swal("Copy the code below to use it!", code);
    });
    // =====================Dropdown menu=============
    $('.drop-down').click(function(e) {
        $('.drop-down-menu').css('display', 'none');
        $(this).find('.drop-down-menu').css('display', 'block');
    });
    $(document).click(function(e) {
        if (!$(e.target).closest('.drop-down').length) {
            $('.drop-down-menu').css('display', 'none');
        }
    });

    // ==========================SEEN MESSAGE===================
    // $('#dropdown-message').blur(function(){
    //     $('#dropdown-message').hide();
    // });
    // $(document).on('click', '#box-message', function(){
    //     $('#dropdown-message').toggle();
    //     $.ajax({
    //         url:'?mod=ajax&act=seen_like',
    //         method:'POST',
    //         dataType:'text',
    //         success: function(response) {
    //             $('#count-unseen').html('');
    //         }
    //     });
    // });
    // $("#box-message").hover(function () {
    //   $.ajax({
    //     url: "?mod=ajax&act=seen_like",
    //     method: "POST",
    //     dataType: "text",
    //     success: function (response) {
    //       $("#count-unseen").html("");
    //     },
    //   });
    // });
    //=================Ajax make this favories===============

    // =================MENU==================
    $("#icon-menu").click(function() {
        $("#site").toggleClass("open-menu");
        $("#icon-menu").toggleClass("fa-bars fa-times");
        // =================BO sung respon===============
        // $(window).resize(function() {
        //     if ($(document).width() > 768) {
        //         $('#site').removeClass('open-menu');
        //         $('#icon-menu').removeClass('fa-times').addClass('fa-bars');
        //     }
        // });
        //neu bo false bat buoc the href = #
        // return false;
        // ====================Xoa click ban da u=============
        $("#wp-menu .list-menu .item").removeClass("open");
        // ==================DIMMED===================
        $("#dimmed").toggleClass("open-dimmed");
        return false;
    });
    $(document).click(function(e) {
        if (!$(e.target).closest('.list-menu .item').length) {
            $("#site").removeClass("open-menu");
            $("#icon-menu").attr('class', 'fas fa-bars');
            $("#wp-menu .list-menu .item").removeClass("open");
            $("#dimmed").removeClass("open-dimmed");
        }
    });

    // ===============LIST MENU================
    // $("#wp-menu .list-menu .item").click(function() {
    //     $("#wp-menu .list-menu .item").toggleClass("open");
    // });

    // ====================PREvENTING dUPLICATE ORdERS================
    // $("#billing-form").submit(function () {
    //   $("input[type = submit]", this).attr("disabled", "disabled");
    //   $("#submit_div").html('<p class = "button">Processing....<p>');
    //   return false;
    // });
    // ================Add email for news======================
    $(document).on('submit', '#form-receive-news', function(e) {
        e.preventDefault();
        var form_data = $(this).serialize();
        $.ajax({
            url: '?mod=ajax&act=add_email',
            method: 'POST',
            data: form_data,
            dataType: 'text',
            success: function(response) {
                swal(response);
                $("#form-receive-news")[0].reset();
            }
        });
    });

    // ==============List slider==========
    $("#slider-wp .owl-carousel").owlCarousel({
        autoplayTimeout: 4000,
        autoplay: true,
        vav: true,
        loop: true,
        smartSpeed: 800,
        responsive: {
            0: {
                items: 1,
            },
            600: {
                items: 1,
            },
            1000: {
                items: 1,
            },
        },
    });
    // ========================List product===============
    $(".list-product .owl-carousel").owlCarousel({
        autoplayTimeout: 1000,
        autoplay: false,
        vav: true,
        loop: false,
        smartSpeed: 400,
        responsive: {
            0: {
                items: 4,
            },
            600: {
                items: 4,
            },
            1000: {
                items: 4,
            },
        },
    });
    // =================List feature post======================
    $(".list-featured-post .owl-carousel").owlCarousel({
        autoplayTimeout: 1000,
        autoplay: false,
        margin: 20,
        vav: true,
        loop: false,
        smartSpeed: 400,
        responsive: {
            0: {
                items: 3,
            },
            600: {
                items: 3,
            },
            1000: {
                items: 3,
            },
        },
    });

    // ===========================Relate product==============

    $("#related-product .owl-carousel").owlCarousel({
        loop: true,
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
                items: 6,
            },
        },
    });

    // =================scroll ball==================
    $(window).scroll(function() {
        var scroll = $(window).scrollTop(),
            dh = $(document).height(),
            wh = $(window).height();
        scrollPercent = (scroll / (dh - wh)) * 100;
        $("#progress-ball").css("height", scrollPercent + "%");
        // alert("jquery " + scroll);
    });
});
// ====================Javascript=================

// window.onload = function() {
// ====================slider================
// =================scroll top=============
window.addEventListener("scroll", function() {
    var scroll = document.querySelector("#scroll-top");
    scroll.classList.toggle("active", window.scrollY > 1000);
    // alert('oke');
});

// ==================Film================
// var film = document.getElementById('film');
// window.addEventListener('scroll', function() {
//     var value = window.scrollY - 1500;
//     film.style.clipPath = "circle(" + value + "px at center)";

// });
// };

function scrollToTop() {
    window.scrollTo({
        top: 0,
        behavior: "smooth",
    });
}