<?php
include '../connection.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

$user_id = $_POST['user_id'];
$type = $_POST['type'];
$date = $_POST['date'];
$total = $_POST['total'];
$details = $_POST['details'];
$created_at = $_POST['created_at'];
$updated_at = $_POST['updated_at'];

$sql_check = "SELECT * FROM histories
WHERE
user_id = '$user_id' AND date = '$date' AND type= '$type'";

$result_check = $connect->query($sql_check);

if ($result_check->num_rows > 0) {
    echo json_encode(array(
        "success" => false,
        "message" => "date",
    ));
} else {
    $sql = "INSERT INTO histories
        SET
        user_id = '$user_id',
        type = '$type',
        date = '$date',
        total = '$total',
        details = '$details',
        created_at = '$created_at',
        updated_at = '$updated_at'
        ";

    $result = $connect->query($sql);

    if ($result) {
        echo json_encode(array(
            "success" => true,
        ));
    } else {
        echo json_encode(array(
            "success" => false,
            "message" => "Gagal",
        ));
    }
}
