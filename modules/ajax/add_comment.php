<?php
$message = '';
if(empty(trim($_POST['commentContent']))){
       $message = 'Content is required';
}elseif(strlen($_POST['commentContent']) > 1000){
       $message = 'Content must be lower or equal 1000 characters';
}
if($message == ''){
       $allowed = '<div><p><span><br><a><img><h1><h2><h3><h4><ul><ol><li><blockquote>';
       $content = strip_tags($_POST['commentContent'], $allowed);
       add_comment((int)$_POST['commentId'], $content, $_SESSION['user_id'], $_POST['post_id']);
       $message = 'Your comment has been added. Please wait for approval !';
}
echo $message;

