<div id="content" class="login">
    <form action="" method="POST" accept-charset="utf8">
        <h1 class="login-title">Sign-In</h1>
        <?php create_form_input('emailLogin', 'text', 'Email', $login_errors) ?>
        <?php create_form_input('passwordLogin', 'password', 'Password', $login_errors, 'POST') ?>
        <input type="submit" value="Login">
        <?php  form_error('login', $login_errors) ?>
       <div class="clearfix">
        <div class="float-left">
            <?php
                $checked = '';
                if( isset($_COOKIE['email_login'])){
                    $checked = 'checked';
                }
            ?>
            <label ><input class="remember-me" type="checkbox" name="rememberMe" value="true" <?php echo $checked ?>>Keep me signed in.</label>
        </div>
        <div class="forget-pass float-right">
            <a href="?mod=user&act=forgot_pass">Forgot password</a>
        </div>
       </div>
    </form>
    <div>
        <p class="text-center">New to Amazon</p>
        <a href="?mod=user&act=register" id="register" class="text-center">Create your account</a>
    </div>
</div>
