<?php
    if(isset($_POST['btn_add'])){
        echo $_POST['post_content'];
    }
?>
<html>
    <head>
        <title>Tich hop trinh soan thao van ban vao website</title>
        <script src="ckeditor/ckeditor.js" type="text/javascript"></script>
    </head>
    <body>
        <style>
            #content{
                width: 960px;
                margin: 0px auto;
            }
        </style>
        <div id="content">
            <h1>Tich hop Ckeditor vao website</h1>
            <form method="POST">
                <textarea class="ckeditor" name="post_content"></textarea><br>
                <input type="submit" name="btn_add" value="Thêm dữ liệu"></input>
            </form>
            
        </div>
    </body>
</html>