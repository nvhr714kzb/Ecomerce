<div id="content">
    <div id="change-password">
        <h3>Change Your Password</h3>
        <?php
        if (isset($message)) {
            echo "<div class='alert alert-success' role='alert'>
            $message
          </div>";
        }
        ?>
        <form action="?mod=user&act=reset" method="POST" accept-charset="utf8">
            <?php create_form_input('pass1', 'password', 'Password', $pass_errors);
            create_form_input('pass2', 'password', 'Confirm Password', $pass_errors);
            ?>
            <input type="submit" name="submit_button" value="Change" id="submit_button" class="btn btn-default" />
        </form>
    </div>
</div>