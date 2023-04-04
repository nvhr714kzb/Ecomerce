<?php
require('../includes/config.inc.php');
require('../lib/database.inc.php');
require('../lib/form_functions.inc.php');
require('lib/product_functions.inc.php');
require('../lib/user.inc.php');
require('../' . MYSQL);
require('includes/permission.php');
include('includes/header.html');
?>
<div id="content-wp" class="clearfix">
    <?php
    include('includes/sidebar.html');
    $add_slider_errors = array();
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        if (!empty($_POST['name'])) {
            $name = escape_data(strip_tags($_POST['name']), $dbc);
        } else {
            $add_slider_errors['name'] = 'Please enter the name!';
        }
        if (!empty($_POST['link'])) {
            $url = filter_var($_POST['link'], FILTER_SANITIZE_URL);
            if (filter_var($url, FILTER_VALIDATE_URL)) {
                $link = $url;
            } else {
                $add_slider_errors['link'] = 'Please enter a valid link!';
            }
        } else {
            $add_slider_errors['link'] = 'Please enter the link!';
        }

        if (!empty($_POST['description'])) {
            $des = escape_data(strip_tags($_POST['description']), $dbc);
        } else {
            $add_slider_errors['description'] = 'Please enter the description!';
        }
        if (!empty($_POST['order'])) {
            if (filter_var($_POST['order'], FILTER_VALIDATE_INT, array('min_range' => 1))) {
                $order = $_POST['order'];
            } else {
                $add_slider_errors['order'] = 'Please enter a valid order!';
            }
        } else {
            $add_slider_errors['order'] = 'Please enter the order!';
        }
        //Check for image
        if (is_uploaded_file($_FILES['image']['tmp_name']) && $_FILES['image']['error'] === UPLOAD_ERR_OK) {
            $file = $_FILES['image'];
            $size = ROUND($file['size'] / 1024);
            if ($size > 500000) {
                $add_slider_errors['size'] = 'The uploaded file was too large.';
            }

            $allowed_ext =  array('png', 'jpg', 'gif', 'jpeg');
            $file_ext = pathinfo($file['name'], PATHINFO_EXTENSION);

            $allowed_mime = array('image/gif', 'image/pjpeg', 'image/jpeg', 'image/JPG', 'image/X-PNG', 'image/PNG', 'image/png', 'image/x-png');
            $file_info = finfo_open(FILEINFO_MIME_TYPE);
            $file_type = finfo_file($file_info, $file['tmp_name']);
            finfo_close($file_info);

            if (!in_array($file_type, $allowed_mime) || !in_array($file_ext, $allowed_ext)) {
                $add_slider_errors['image'] = 'The uploaded file was not of the proper type.';
            }
            if (!array_key_exists('image', $add_slider_errors)) {
                $new_name = sha1($file['name'] . uniqid('', true));
                $new_name .= '.' . $file_ext;
                $dest = "../public/images/slider/$new_name";
                if (move_uploaded_file($file['tmp_name'], $dest)) {
                    $flag_upload_success = true;
                    // echo '<h4>The file has been uploaded!</h4>';
                } else {
                    trigger_error('The file could not be moved.');
                    unlink($file['tmp_name']);
                }
            }
        } else {
            switch ($_FILES['image']['error']) {
                case 1:
                case 2:
                    $add_slider_errors['image'] = 'The uploaded file was too large.';
                    break;
                case 3:
                    $add_slider_errors['image'] = 'The file was only partially uploaded.';
                    break;
                case 6:
                case 7:
                case 8:
                    $add_slider_errors['image'] = 'The file could not be uploaded due to a system error.';
                    break;
                case 4:
                default:
                    $add_slider_errors['image'] = 'No file was uploaded.';
                    break;
            }
        }
        if (empty($add_slider_errors)) {
            $q = "INSERT INTO slider (name, link, description, image, order_slider) VALUES ('$name', '$link', '$des', '$new_name' , '$order')";
            $r = mysqli_query($dbc, $q);
            if (mysqli_affected_rows($dbc) === 1) {
                $success = true;
                $_POST = array();
                $_FILES = array();
                unset($file);
            } else {
                trigger_error('The slider could not be added due to a system error. We apologize for any inconvenience.');
                unlink($dest);
            }
        } else {
            if (isset($flag_upload_success)) {
                unlink($dest);
            }
        }
    }
    ?>
    <div id="content" class="float-right">
        <div class="section">
            <div class="section-head">
                <h3 class="section-title">Add a slider</h3>
                <a class="section-list" href="<?php echo BASE_URL ?>admin/list_sliders.php">List sliders</a>
                <?php
                if (isset($success)) {
                    echo '<div class="alert alert-success">The slider has been added!</div>';
                }
                ?>
            </div>
            <div class="section-content">
                <form action="" method="post" enctype="multipart/form-data" accept-charset="utf-8">
                    <fieldset>
                        <legend>Fill out the form to add a slider:</legend>
                        <?php
                        create_form_input('name', 'text', 'Name', $add_slider_errors, 'POST', ['maxlength' => '100']);
                        create_form_input('link', 'text', 'Link', $add_slider_errors, 'POST', ['maxlength' => '100']);
                        create_form_input('description', 'textarea', 'Description', $add_slider_errors);
                        ?>
                        <div class="form-group">
                            <label for="order" class="control-label">Order</label>
                            <input type="number" name="order" class="form-control" value="<?php if (isset($_POST['order'])) echo $_POST['order'] ?>">
                            <?php form_error('order',  $add_slider_errors) ?>
                        </div>

                        <div class="form-group">
                            <input type="file" name="image" id="upload-thumb" class="form-control-file">
                            <?php
                            form_error('image',  $add_slider_errors);
                            ?>
                        </div>

                        <img src="../public/images/size/800x300.png" alt="" id="preview-thumb"><br>
                        <div class="form-group">
                            <input type="submit" name="addSlider" value="Add This Slider" />
                        </div>
                    </fieldset>
                </form>
            </div>
        </div>
    </div>
</div>