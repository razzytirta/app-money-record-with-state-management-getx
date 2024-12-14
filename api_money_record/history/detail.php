<?php
include '../connection.php';
// Set CORS headers
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

$user_id = $_POST['user_id'];
$date = $_POST['date'];
$type = $_POST['type'];

$sql = "SELECT * FROM histories
        WHERE 
        user_id='$user_id' AND type='$date' AND date='$type'";

$result = $connect->query($sql);

if ($result->num_rows > 0) {
    $data = array();
    while ($row = $result->fetch_assoc()) {
        $data[] = $row;
    }
    echo json_encode(array(
        "success" => true,
        "data" => $data[0]
    ));
} else {
    echo json_encode(array(
        "success" => false
    ));
}
