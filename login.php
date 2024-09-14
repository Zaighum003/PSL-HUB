<?php
// Start the session
session_start();

// Check if the form was submitted
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Database connection details
    $servername = "localhost";
    $username = "root"; // Replace with your MySQL username
    $password = ""; // Replace with your MySQL password
    $database = "pslhub";

    // Create connection
    $conn = new mysqli($servername, $username, $password, $database);

    // Check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    // Get username and password from the form
    $username = $_POST['uname'];
    $password = $_POST['psw'];

    // SQL query to fetch user from database
    $sql = "SELECT * FROM admin WHERE username = '$username' AND password = '$password'";
    $result = $conn->query($sql);

    // Check if the query returned any rows
    if ($result->num_rows > 0) {
        // Authentication successful
        // Redirect to updatepage.html
        $_SESSION['username'] = $username; // Store username in session
        header("Location: admin_page.html");
        exit();
    } else {
        // Authentication failed
        echo "Invalid username or password";
    }

    // Close connection
    $conn->close();
}
?>
