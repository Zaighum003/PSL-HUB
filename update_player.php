<?php
// Database connection parameters
$servername = "localhost";
$username = "root"; // Assuming your MySQL username is "root"
$password = ""; // Enter your MySQL password here
$dbname = "pslhub";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get player ID from form
$player_id = $_POST['player_id'];

// Get attribute and updated data from form
$attribute = $_POST['attribute'];
$updated_data = $_POST['updated_data'];

// Update player information based on the selected attribute
$sql = "UPDATE players SET $attribute = '$updated_data' WHERE player_id = '$player_id'";

// Perform the update
if ($conn->query($sql) === TRUE) {
    echo "Player $attribute updated successfully";
} else {
    echo "Error updating player $attribute: " . $conn->error;
}

$conn->close();
?>
