<?php
get_header();
if (isset($_GET['activeToken']) && strlen($_GET['activeToken']) === 32) {
    if (check_active_token($_GET['activeToken'])) {
        active_user(($_GET['activeToken']));
        $url_login = "".BASE_URL . "?mod=user&act=login";
?>
        <div id="content" class="active-account">
            <div>
                <img src="public/images/icon/success.png" alt="" width="100px">
                <p>You have activated successfully. Please click this link to login: <a href='<?php echo $url_login ?>'>Login</a></p>
            </div>
            
        </div>
    <?php
    } else {
    ?>
        <div id="content" class="active-account">
            <div>
                <img src="public/images/icon/failure.jpg" alt="" width="100px">
                <p>Activation request is invalid or has been previously activated or has expired</p>
            </div>
        </div>
<?php
    }
} else {
    // trigger_error('You could not be registered due to a system error. We apologize for any inconvenience.');
    redirect();
}
get_footer();
