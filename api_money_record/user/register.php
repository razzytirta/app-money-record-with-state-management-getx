<?php
include '../connection.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

$name = $_POST['name'];
$email = $_POST['email'];
$password = md5($_POST['password']);
$created_at = $_POST['created_at'];
$updated_at = $_POST['updated_at'];

$sql_check = "SELECT * FROM users WHERE email = '$email'";

$result_check = $connect->query($sql_check);

if ($result_check->num_rows > 0) {
    echo json_encode(array(
        "success" => false,
        "message" => "email",
    ));
} else {
    $sql = "INSERT INTO users
            SET
            name = '$name',
            email = '$email',
            password = '$password',
            created_at = '$created_at',
            updated_at = '$updated_at'
            ";

    $result = $connect->query($sql);


    if ($result) {
        echo json_encode(array(
            "success" => true,
        ), JSON_PRETTY_PRINT);
    } else {
        echo json_encode(array(
            "success" => false,
            "message" => 'Failed',
        ), JSON_PRETTY_PRINT);
    }
}
