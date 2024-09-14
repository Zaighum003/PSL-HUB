<?php
// Database connection
$servername = "localhost";
$username = "root";
$password = "";
$database = "pslhub";

$conn = new mysqli($servername, $username, $password, $database);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Fetch points table data
$sql = "SELECT teams.team_name,
               COUNT(matches.match_id) AS matches_played,
               SUM(CASE WHEN matches.winning_team = teams.team_id THEN 2
                        WHEN matches.winning_team IS NULL THEN 1
                        ELSE 0 END) AS points
        FROM teams
        LEFT JOIN matches ON teams.team_id = matches.team1_id OR teams.team_id = matches.team2_id
        GROUP BY teams.team_id
        ORDER BY points DESC";

$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // Output data of each row
    echo '<table class="points-table">';
    echo '<tr><th>Team</th><th>Matches Played</th><th>Points</th></tr>';
    while ($row = $result->fetch_assoc()) {
        echo '<tr>';
        echo '<td>' . $row["team_name"] . '</td>';
        echo '<td>' . $row["matches_played"] . '</td>';
        echo '<td>' . $row["points"] . '</td>';
        echo '</tr>';
    }
    echo '</table>';
} else {
    echo "0 results";
}

$conn->close();
?>
