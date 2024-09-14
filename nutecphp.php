<?php
// Retrieve form data
$rollno = $_POST['rollno'];
$name = $_POST['name'];
$email = $_POST['email'];
$department = $_POST['department'];
$event = $_POST['event'];

// Database connection
$servername = "localhost"; // Change this to your database server name
$username = "root"; // Change this to your database username
$password = ""; // Change this to your database password
$dbname = "nutec"; // Change this to your database name

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}

// Insert data into the table
$sql = "INSERT INTO registrations (rollno, name, email, department, event)
        VALUES ('$rollno', '$name', '$email', '$department', '$event')";

if ($conn->query($sql) === TRUE) {
  echo "New record inserted successfully";
} else {
  echo "Error: " . $sql . "<br>" . $conn->error;
}

// Close connection
$conn->close();
?>
