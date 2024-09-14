<?php
// Database connection details
$servername = "localhost";
$username = "root";
$password = "";
$database = "theme_park";

// Create connection
$conn = new mysqli($servername, $username, $password, $database);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get form data
$park_code = $_GET["park_code"];
$park_name = $_GET["park_name"];
$park_city = $_GET["park_city"];
$park_country = $_GET["park_country"];

// Prepare SQL statement
$sql = "INSERT INTO themepark (parkname, parkcity, parkcountry, park_code)
VALUES ('$park_name', '$park_city', '$park_country', '$park_code')";

// Execute the query
if ($conn->query($sql) === TRUE) {
    echo "Data saved successfully!";
} else {
    echo "Error: " . $sql . "<br>" . $conn->error;
}

// Close the connection
$conn->close();
?>