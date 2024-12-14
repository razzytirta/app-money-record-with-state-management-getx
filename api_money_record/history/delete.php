<?php
include '../connection.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

$id = $_POST['id'];

$sql = "DELETE FROM histories
        WHERE
        id = '$id'";

$result = $connect->query($sql);

if ($result) {
    echo json_encode(array(
        "success" => true,
    ));
} else {
    echo json_encode(array(
        "success" => false,
    ));
}
