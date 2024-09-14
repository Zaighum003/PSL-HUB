<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "pslhub";

// Create connection

$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}


$searchTerm = $_GET['search'];

// Fetch player data based on the search term
$sql = "SELECT p.*, b.runs, bw.wickets, t.team_name
        FROM players p
        LEFT JOIN battingstats_players b ON p.player_id = b.player_id
        LEFT JOIN bowlingstats_players bw ON p.player_id = bw.player_id
        LEFT JOIN teams t ON p.team_id = t.team_id
        WHERE p.player_name LIKE '%$searchTerm%' OR p.player_id LIKE '%$searchTerm%'";

$result = $conn->query($sql);

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        echo "<div class='player-card'>";
        echo "<h2>" . $row["player_name"] . "</h2>";
        echo "<p>Player ID: " . $row["player_id"] . "</p>";
        echo "<p>Nationality: " . $row["nationality"] . "</p>";
        echo "<p>Date of Birth: " . $row["dob"] . "</p>";
        echo "<p>Team Name: " . $row["team_name"] . "</p>"; // Changed to team_name
        echo "<p>Role: " . $row["role"] . "</p>";
        echo "<p>Runs: " . $row["runs"] . "</p>";
        echo "<p>Wickets: " . $row["wickets"] . "</p>";
        echo "</div>";
    }
} else {
    echo "No results found";
}

$conn->close();
?>
