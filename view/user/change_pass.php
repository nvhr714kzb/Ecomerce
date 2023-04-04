<div id="content">
    <div id="change-password">
        <h3>Change password</h3>
        <?php
            if(isset($message)){
                echo "<div class='alert alert-success' role='alert'>
                $message
              </div>";
            }
        ?>
        <form action="" method="POST" accept-charset="utf8">
            <?php create_form_input('passwordCurrent', 'password', 'Current password', $pass_errors) ?>
            <?php create_form_input('passwordNew', 'password', 'New password', $pass_errors) ?>
            <?php create_form_input('passwordCheck', 'password', 'Confirm password', $pass_errors) ?>
            <input type="submit" name="" value="Change">
        </form>
    </div>
</div>