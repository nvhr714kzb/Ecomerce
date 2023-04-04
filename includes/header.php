<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <base href="<?php echo BASE_URL ?>">
    <title>
        <?php
        if (isset($page_title)) {
            echo $page_title;
        } else {
            echo 'Amazon';
        } ?>
    </title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="author" content="Nguyễn Văn Bình">
    <meta name="keywords" content="<?php echo $seo_key ?>">
    <meta name="description" content="<?php echo $seo_des ?>" />
    <link href="https://www.inclo.net/images/favicons/favicon-orange_alt.ico" rel="icon" type="image/x-icon" />
    <link rel="canonical" href="<?php echo $seo_url ?>">
    <meta http-equiv="content-language" content="vi" />
    <meta name="robots" content="noodp,index,follow" />
    <?php
            if (!empty($_GET['mod']) && $_GET['mod'] = 'post' && !empty($_GET['act']) && $_GET['act'] = 'detail_post') {
            ?>
        <meta property="og:site_name" content="Thegioididong.com" />
        <meta property="og:url" content="<?php echo $seo_url ?>" />
        <meta property="og:type" content="<?php echo $seo_type ?>" />
        <meta property="og:title" content="<?php echo  $seo_title ?>" />
        <meta property="og:description" content="<?php echo $seo_des ?>" />
        <meta property="og:image" content="<?php echo $seo_img ?>" />
    <?php
            }
    ?>

    <link rel="stylesheet" href="public/owlcarousel/assets/owl.carousel.min.css">
    <link rel="stylesheet" href="public/owlcarousel/assets/owl.theme.default.css">

    <link rel="stylesheet" href="public/css/reset.css">
    <link rel="stylesheet" href="public/css/resetCss.css">
    <link rel="stylesheet" href="public/css/global.css">

    <link rel="stylesheet" href="public/css/sweetalert.css">


    <link rel="stylesheet" href="public/css/style.css">
    <link rel="stylesheet" href="public/fontawesome/css/all.css">

    <link rel="stylesheet" href="public/css/support.css">

    <link rel="stylesheet" href="public/css/scroll-top.css">
    <link rel="stylesheet" href="public/css/scrollbal.css">
    <link rel="stylesheet" href="public/css/film.css">
    <link rel="stylesheet" href="public/css/card.css">
    <link rel="stylesheet" href="public/css/menu.css">
    <link rel="stylesheet" href="public/css/dimmed.css">

    <link rel="stylesheet" href="public/css/list-product.css">
    <link rel="stylesheet" href="public/css/detail-product.css">

    <link rel="stylesheet" href="public/css/login.css">
    <link rel="stylesheet" href="public/css/register.css">

    <link rel="stylesheet" href="public/css/checkout.css">
    <link rel="stylesheet" href="public/css/shopping-cart.css">

    <link rel="stylesheet" href="public/css/pagination.css">

    <link rel="stylesheet" href="public/css/responsive.css">
    <link rel="stylesheet" href="public/css/post.css">
    <link rel="stylesheet" href="public/css/discount_code.css">
    <link rel="stylesheet" href="public/css/order.css">
    <link rel="stylesheet" href="https://cdn.rawgit.com/mervick/emojionearea/master/dist/emojionearea.min.css">

    <link rel="stylesheet" href="public/css/jquery-ui.css">
    <link rel="stylesheet" href="public/css/bootstrap.min.css">


    <script src="public/jquery/jquery-3.5.1.min.js"></script>


    <script src="public/owlcarousel/owl.carousel.js"></script>
    <script src="public/js/sweetalert.js"></script>

    <script src="public/Ckeditor/ckeditor/ckeditor.js"></script>

    <script src="public/js/main.js"></script>
    <script src="public/js/zoom-product.js"></script>
    <script src="public/js/search.js"></script>
    <script src="public/js/filter.js"></script>
    <script src="public/js/comment.js"></script>
    <script src="public/js/chat.js"></script>
    <script src="public/js/detail_product.js"></script>
    <script src="public/js/cart.js"></script>
    <script src="public/js/post.js"></script>
    <script src="public/js/jquery-ui.js"></script>
    <script src="https://js.stripe.com/v2/"></script>
    <script src="public/js/billing_test.js"></script>
    <script src="https://cdn.rawgit.com/mervick/emojionearea/master/dist/emojionearea.min.js"></script>

</head>

<body>
    <?php
    // ----------------For notify------------------
    if (isset($_SESSION['user_id'])) {
        $list_like_notify = get_list_like_notify($_SESSION['user_id']);
        $list_reply_notify = get_list_reply_comment($_SESSION['user_id']);
        $all_notify = array_merge($list_like_notify, $list_reply_notify);
        $count_unseen = 0;
        foreach ($all_notify as $item) {
            if ($item['user_id'] != $_SESSION['user_id'] && $item['seen'] == 0) {
                $count_unseen++;
            }
        }
        $sorted_notify = quick_sort_notify($all_notify);
        // --------count unseen for ajax-------------
        echo "
        <script>
        var count_unseen = $count_unseen;
        </script>
        ";
    }

    ?>

    <!-- ===============================Script fanpage=========================== -->
    <div id="fb-root"></div>
    <script async defer crossorigin="anonymous" src="https://connect.facebook.net/vi_VN/sdk.js#xfbml=1&version=v8.0" nonce="7aTGXC4b"></script>

    <div id="site">
        <!-- =========================HEADER====================== -->
        <div id="header-wp">
            <!-- -------------------Header Top---------------------- -->
            <div id="header-top" class=" clearfix">
                <div class="container">
                    <div id="main-menu-wp" class="clearfix">
                        <ul id="main-menu">
                            <li><a href='admin'>Admin</a></li>
                            <li><a href='sale'>Sale products</a></li>
                            <li><a href='voucher'>Discount code</a></li>
                            <!-- -----------------------Message---------------------- -->
                            <?php
                            if (isset($_SESSION['user_id'])) {
                            ?>
                                <li class="drop-down">
                                    <a href="javascript:;" id="box-message">
                                        <i class="fal fa-envelope"></i>
                                        <?php
                                        if ($count_unseen > 0) {
                                            echo  '<span id = "count-unseen">' . $count_unseen . '</span>';
                                        }
                                        ?>
                                    </a>
                                    <?php
                                    if ($count_unseen != 0) {
                                    ?>
                                        <ul class="drop-down-menu drop-down-message">
                                            <?php
                                            foreach ($sorted_notify as $item) {
                                                if ($item['user_id'] == $_SESSION['user_id']) {
                                                    $name = '<b>You</b> have ';//not use
                                                } else {
                                                    $name = '<b>' . $item['name'] . '</b> has ';
                                            ?>
                                                    <li class="clearfix">
                                                        <a href="post/<?php echo create_slug($item['title']) ?>/<?php echo $item['id'] ?>">
                                                            <img src="public/images/avatar/<?php echo $item['avatar'] ?>" alt="" class="float-left">
                                                            <?php
                                                            if (isset($item['comment'])) {
                                                            ?>
                                                                <p class="float-left"><?php echo $name ?> has reply "<?php echo $item['title'] ?>": <i><?php echo $item['comment'] ?></i></p>
                                                            <?php
                                                            } else {
                                                            ?>
                                                                <p class="float-left"><?php echo $name ?> like your post "<?php echo $item['title'] ?>"</p>
                                                            <?php

                                                            }
                                                            ?>
                                                        </a>
                                                    </li>
                                                <?php
                                                }
                                                ?>

                                            <?php
                                            }
                                            ?>
                                        </ul>
                                    <?php
                                    } else {
                                    ?>
                                        <ul class="drop-down-menu drop-down-message">
                                            <li>There is no message</li>
                                        </ul>
                                    <?php
                                    }
                                    ?>

                                </li>
                                <li class="drop-down">
                                    <a href="javascript:;" data-toggle="dropdown">Account <b class="caret"></b></a>
                                    <ul class="drop-down-menu">
                                        <!-- <li><a href="?mod=user&act=update_info">Update info</a></li> -->
                                        <li><a href="?mod=user&act=change_pass">Change Your Password</a></li>
                                        <li><a href="?mod=user&act=forgot_pass">Forgot Your Password</a></li>
                                        <li><a href="?mod=order&act=order_history">Order History</a></li>
                                        <li><a href="?mod=user&act=logout">Logout</a></li>
                                    </ul>
                                </li>
                            <?php
                            }
                            $page = array(
                                'News' => 'post',
                                'Register' => '?mod=user&act=register',
                            );
                            if (isset($_GET['mod']) && isset($_GET['act'])) {
                                $this_page = "?mod=" . $_GET['mod'] . "&act=" . $_GET['act'] . "";
                            }
                            foreach ($page as $k => $v) {
                                echo "<li";
                                if (isset($_GET['mod']) && isset($_GET['act'])) {
                                    if ($this_page == $v) echo " class = 'selected'";
                                }
                                echo "><a href ='{$v}'><span>{$k}</span></a></li>";
                            }
                            if (!isset($_SESSION['user_id'])) {
                                echo "<li><a href = '?mod=user&act=login'>Login</a></li>";
                            } ?>
                        </ul>

                    </div>
                </div>

            </div>
            <!-- -------------------Header Body---------------------- -->
            <div id="header-body" class="clearfix">
                <div class="container">
                    <a href="" id="logo"><img src="public/images/logo.png" alt=""></a>

                    <div id="search-wp">
                        <?php
                        // if (isset($_POST['sm-s'])) {//due to js
                        if (isset($_POST['s'])) {
                            $all_word = isset($_POST['all-words']) ? $_POST['all-words'] : 'off';
                            $search_str = clean_url_text($_POST['s']);
                            redirect("?mod=search&act=search&searchStr=$search_str&allWords=$all_word");
                            // header("Location: " . BASE_URL . "?mod=search&act=search&searchStr=$search_str&allWords=$all_word");
                        }
                        $search_str = '';
                        if (isset($_GET['searchStr'])) {
                            $search_str = trim(str_replace('-', ' ', $_GET['searchStr']));
                        }
                        ?>
                        <form action="" method='POST' id="form-search" accept-charset="utf-8">
                            <input type="text" name="s" id="s" value="<?php echo $search_str ?>" placeholder="Enter search keywords here!" autocomplete="off">
                            <button type="submit" id="sm-s" name="sm-s"><i class="fas fa-search"></i></button>
                        </form>
                        <div id="hint-search"></div>
                    </div>
                    <div id="cart-wp">
                        <a href="wishlist" id="wish-list">My Wishlist</a>
                        <?php
                        $num_cart = shopping_cart_get_count();
                        if ($num_cart == 0) {
                            $num_cart = '';
                        }
                        ?>
                        <a href="cart" id="btn-cart"><i class="fal fa-shopping-cart cart"></i><span id="count-cart"><?php echo $num_cart ?></span></a>
                    </div>
                </div>
            </div>
            <div id="header-bottom">
                <div class="container">
                    <nav>
                        <!-- <a href=""><i class="fas fa-mobile-android-alt"></i> Phone</a>
                        <a href=""><i class="far fa-laptop"></i> Laptop</a>
                        <a href=""><i class="fal fa-tablet-android-alt"></i> Tablet</a>
                        <a href=""><i class="far fa-headphones-alt"></i> Accessories</a>
                        <a href=""><i class="fas fa-watch"></i> Fashionable watches</a>
                        <a href=""><i class="fal fa-watch-fitness"></i> Smart watch</a>
                        <a href=""><i class="far fa-desktop"></i> Pc</a>
                        <a href="voucher"><i class="fal fa-balance-scale-left"></i> Discount code</a>
                        <a href=""><i class="fas fa-history"></i>SHOPPING HISTORY</a> -->
                    </nav>
                </div>
            </div>

        </div>
        <div id="content-wp">
            <div class="container clearfix">
                <!-- <div id="content"> -->