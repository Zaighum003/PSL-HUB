<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Retrieve form data
    $searchBy = $_POST['search_by'];
    $searchData = $_POST['search_data'];

    // Connect to your database (replace hostname, username, password, and dbname with your actual database details)
    $conn = new mysqli("localhost", "root", "", "nutec");

    // Check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    // Prepare and execute the SQL statement based on the selected search option
    $sql = "";
    if ($searchBy === "roll_no") {
        $sql = "SELECT * FROM registrations WHERE rollno = '$searchData'";
    } elseif ($searchBy === "event_name") {
        $sql = "SELECT * FROM registrations WHERE name = '$searchData'";
    } elseif ($searchBy === "department") {
        $sql = "SELECT * FROM registrations WHERE department = '$searchData'";
    }

    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        // Output the search results
        echo "<h2>Search Results</h2>";
        echo "<table>";
        echo "<tr><th>Roll No</th><th>Event</th><th>Department</th></tr>";
        while ($row = $result->fetch_assoc()) {
            echo "<tr><td>".$row["rollno"]."</td><td>".$row["name"]."</td><td>".$row["department"]."</td></tr>";
        }
        echo "</table>";
    } else {
        echo "No records found.";
    }

    $conn->close();
}
?>