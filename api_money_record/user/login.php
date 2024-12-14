<?php
include '../connection.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

$email = $_POST['email'];
$password = md5($_POST['password']);

$sql = "SELECT * FROM users WHERE email = '$email' AND password ='$password'";

$result = $connect->query($sql);

if ($result->num_rows > 0) {
    $user = array();
    while ($row = $result->fetch_assoc()) {
        $user[] = $row;
    }

    echo json_encode(array(
        "success" => true,
        "data" => $user[0]
    ), JSON_PRETTY_PRINT);
} else {
    echo json_encode(array(
        "success" => false
    ), JSON_PRETTY_PRINT);
}
