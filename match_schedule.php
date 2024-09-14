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

// Fetch match schedule data
$sql = "SELECT matches.match_id AS match_number,
               team1.team_name AS team_1,
               team2.team_name AS team_2,
               CASE WHEN matches.winning_team IS NOT NULL THEN winning_team.team_name ELSE 'Not played yet' END AS winning_team
        FROM matches
        INNER JOIN teams AS team1 ON matches.team1_id = team1.team_id
        INNER JOIN teams AS team2 ON matches.team2_id = team2.team_id
        LEFT JOIN teams AS winning_team ON matches.winning_team = winning_team.team_id
        ORDER BY matches.match_id ASC";

$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // Output data of each row
    echo '<table class="match-schedule-table">';
    echo '<tr><th>Match Number</th><th>Team 1</th><th>Team 2</th><th>Winning Team</th></tr>';
    while ($row = $result->fetch_assoc()) {
        echo '<tr>';
        echo '<td>' . $row["match_number"] . '</td>';
        echo '<td>' . $row["team_1"] . '</td>';
        echo '<td>' . $row["team_2"] . '</td>';
        echo '<td>' . $row["winning_team"] . '</td>';
        echo '</tr>';
    }
    echo '</table>';
} else {
    echo "0 results";
}

$conn->close();
?>
