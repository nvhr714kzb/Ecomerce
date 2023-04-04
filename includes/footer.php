<!-- =========================FOOTER====================== -->
</div>
</div>
<div id="footer-wp">
    <div class="container">
        <div id="footer-body" class="clearfix">
            <div class="block about">
                <div class="block-head">
                    <h3 class="title">ABOUT US</h3>
                </div>
                <div class="block-body">
                    <ul class="list-item">
                        <li><a href="#"><i class="fas fa-map-marker-alt"></i> <span>Address: 123 - abc - xyz</span></a></li>
                        <li><a href="#"><i class="fal fa-phone-volume"></i><span>Hotline: Support: 0799500203</span></a></li>
                        <li><a href="#"><i class="far fa-envelope"></i><span>Email: amazon_support@gmail.com</span></a></li>
                    </ul>
                </div>
            </div>

            <div class="block">
                <div class="block-head">
                    <h3 class="title">RECEIVE NEWS</h3>
                </div>
                <div class="block-body">
                    <p id="desc">Register with us to receive promotional information at the earliest</p>
                    <form action="" method="POST" id="form-receive-news">
                        <input type="email" name="email" id="emailNews" placeholder="Enter your email here" maxlength="80">
                        <button type="submit" id="sm-reg">Register</button>
                    </form>
                </div>
            </div>
            <div class="block">
                <div class="block-body">
                    <div class="fb-page" data-href="https://www.facebook.com/cione.vn/" data-tabs="" data-width="" data-height="" data-small-header="false" data-adapt-container-width="true" data-hide-cover="false" data-show-facepile="true">
                        <blockquote cite="https://www.facebook.com/cione.vn/" class="fb-xfbml-parse-ignore"><a href="https://www.facebook.com/cione.vn/">CiOne Elearning</a></blockquote>
                    </div>
                </div>
            </div>

        </div>
        <div id="footer-bot">
            <!-- ------------------------Social--------------------------- -->
            <div id="social">
                <h3 id="social-title">Follow us</h3>
                <ul id="list-social">
                    <li>
                        <a href="https://vi-vn.facebook.com/AliBabaJack/" target="_blank">
                            <span></span>
                            <span></span>
                            <span></span>
                            <span></span>
                            <span class="fab fa-facebook-f"></span>
                        </a>
                    </li>
                    <li>
                        <a href="https://twitter.com/jackma" target="_blank">
                            <span></span>
                            <span></span>
                            <span></span>
                            <span></span>
                            <span class="fab fa-twitter"></span>
                        </a>
                    </li>
                    <li>
                        <a href="https://www.whatsapp.com/" target="_blank">
                            <span></span>
                            <span></span>
                            <span></span>
                            <span></span>
                            <span class="fab fa-whatsapp"></span>
                        </a>
                    </li>
                    <li>
                        <a href="https://www.linkedin.com/in/jack-ma-99228aa4?challengeId=AQG4EvvomYKfVgAAAXVP__k3ZIS_KlZH99nnA2nzZGNH8cs8xP0N6lefNB1YioJThnYF2kimJzO7M8FdeFQwOPyKUmn7Pxcysw&submissionId=27d4f38d-f34b-4016-9c7f-fededde81104" target="_blank">
                            <span></span>
                            <span></span>
                            <span></span>
                            <span></span>
                            <span class="fab fa-linkedin-in"></span>
                        </a>
                    </li>
                    <li>
                        <a href="https://www.instagram.com/accounts/login/?next=/jack.ma/%3Fhl%3Dvi" target="_blank">
                            <span></span>
                            <span></span>
                            <span></span>
                            <span></span>
                            <span class="fab fa-instagram"></span>
                        </a>
                    </li>
                </ul>

            </div>
            <!-- =========================CREDIT-ACCEPT================= -->
            <div id="creadit-accept">
                <ul>
                    <li>
                        <a href="javascript:;" style="cursor: auto;"><img src="public/images/credit1.webp" alt=""></a>
                    </li>
                    <li>
                        <a href="javascript:;" style="cursor: auto;"><img src="public/images/credit2.webp" alt=""></a>
                    </li>
                    <li>
                        <a href="javascript:;" style="cursor: auto;"><img src="public/images/credit3.webp" alt=""></a>
                    </li>
                    <li>
                        <a href="javascript:;" style="cursor: auto;"><img src="public/images/credit4.webp" alt=""></a>
                    </li>
                </ul>
            </div>
            <div id="copyright">
                <p>© Bản quyền thuộc về Nguyễn Văn Bình</p>
            </div>
        </div>
    </div>
</div>
<!-- ===============MENU================ -->
<div id="wp-menu">
    <div id="menu-head">
        <a href="javascript:;" id="icon-menu" class="fas fa-bars"></a>
        <h2 id="menu-title">Amazon</h2>
    </div>
    <div id="menu-body">
        <ul class="list-menu">
            <li class="item">
                <a href="javascript:;" class="btn">Phone Brands</a>
                <ul class="smenu">
                    <?php
                    $list_category = category_tree(get_list_category());
                    foreach ($list_category as $item) {
                        // echo "<li><a href='?mod=product&act=browse&catId={$item['id']}' title='{$item['category']}'>{$item['category']}</a></li>";
                        echo "<li><a href='phone/" . create_slug($item['category']) . "/{$item['id']}' title='{$item['category']}'>" . ucwords($item['category']) . "</a></li>";
                    }
                    ?>
                </ul>
            </li>
        </ul>
    </div>
</div>
<div id="progress-ball"></div>
<div id="scroll-top" onclick="scrollToTop();"></div>
<div id="dimmed"></div>
<?php
if (isset($_SESSION['user_id']) && $_SESSION['user_type'] == 0) {
?>
    <button class="start-chat" data-touserid="1" data-tousername="Nguyen Van Binh" data-avatar="avatar.svg">
        <i class="far fa-comment-alt"></i>
        How Can I Help You ?
        <span id="count-unseen-message"></span>
    </button>

    <div id="chat-box">
    </div>
<?php
}
?>

</body>

</html>