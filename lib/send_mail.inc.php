<?php

// Import PHPMailer classes into the global namespace
// These must be at the top of your script, not inside a function
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

require 'PHPMailer/src/Exception.php';
require 'PHPMailer/src/PHPMailer.php';
require 'PHPMailer/src/SMTP.php';

// Load Composer's autoloader
//require 'vendor/autoload.php';//Xoa cai nay di
// Instantiation and passing `true` enables exceptions
function send_email($sent_to_email, $sent_to_fullname, $subject, $content, $option = array())
{
    global $config;
    $config_email = $config['email'];
    $mail = new PHPMailer(true);

    try {
        //Server settings
        // $mail->SMTPDebug = SMTP::DEBUG_SERVER;   // =0 se ko check error                   // Enable verbose debug output
        $mail->SMTPDebug = 0;   // =0 se ko check error                   // Enable verbose debug output
        $mail->isSMTP(); //Tra google smtp gmail google             // Send using SMTP
        $mail->Host = $config_email['smtp_host'];                    // Set the SMTP server to send through
        $mail->SMTPAuth = true;                                   // Enable SMTP authentication
        $mail->Username = $config_email['smtp_user'];                     // SMTP username
        $mail->Password = $config_email['smtp_pass'];                             // SMTP password
        $mail->SMTPSecure = $config_email['smtp_secure'];          // Enable TLS encryption; `PHPMailer::ENCRYPTION_SMTPS` encouraged
        $mail->Port = $config_email['smtp_port'];                                      // TCP port to connect to, use 465 for `PHPMailer::ENCRYPTION_SMTPS` above
        $mail->CharSet = 'UTF-8';
        //Recipients
        $mail->setFrom( $config_email['smtp_user'], $config_email['smtp_fullname']); //them nguoi
        $mail->addAddress($sent_to_email, $sent_to_fullname);     // Add a recipient
//    $mail->addAddress('ellen@example.com');//gui them nguoi nua               // Name is optional
        $mail->addReplyTo($config_email['smtp_user'], $config_email['smtp_fullname']); //nguoi nhan phan hoi gui qua dau
//    $mail->addCC('cc@example.com');
//    $mail->addBCC('bcc@example.com');
        // Attachments  Them vao file gui cho khach hang
//    $mail->addAttachment('binh.txt');         // Add attachments
//        $mail->addAttachment('binh.txt', 'huy.txt');    // Optional name // rename
        // Content
        $mail->isHTML(true);                                  // Set email format to HTML
        $mail->Subject = $subject;
        $mail->Body = $content;
//    $mail->AltBody = 'This is the body in plain text for non-HTML mail clients';

        $mail->send();
        // echo 'Đã gừi thành công';
        return 1;
    } catch (Exception $e) {
        // echo "Email khong duoc gui. Chi tiet loi {$mail->ErrorInfo}";
        return 0;
    }
}
