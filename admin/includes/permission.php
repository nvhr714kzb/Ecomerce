<?php
if (!isset($_SESSION['user_type']) || !is_valid_user_type($_SESSION['user_type'], 50)) {
    redirect('admin/login.php');
}