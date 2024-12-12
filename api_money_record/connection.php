<?php


$hostname = "localhost";
$username = "root";
$password = "";
$database = "money_record";

$connect = new mysqli($hostname, $username, $password, $database);

if ($connect->connect_error) {
    die("Connection failed: " . $connect->connect_error);
}
