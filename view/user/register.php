<div id="content" class="reg-signup">
    <div>
        <form action="" method="POST" accept-charset="utf8">
            <h1 class="reg-title">Sign-up</h1>
            <?php
            create_form_input('customerName', 'text', 'Your Name', $reg_errors);
            create_form_input('username', 'text', 'User name', $reg_errors);
            create_form_input('email', 'text', 'Email', $reg_errors, 'POST');
            create_form_input('password', 'password', 'Password', $reg_errors, 'POST', array('placeholder' => 'At least 6 characters', 'minLength' => 6, 'autocomplete' => 'off'));
            create_form_input('passwordCheck', 'password', 'Re-enter Password', $reg_errors, 'POST', array('autocomplete' => 'off'));
            ?>
            <div class="form-group">
                <input type="submit" value="Register">
            </div>
            <div class="form-group" id="reg-signin">
                Already have an account ? <a href="?mod=user&act=login">Sign-in</a>
            </div>
        </form>
    </div>
</div>