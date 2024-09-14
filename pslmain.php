<!DOCTYPE html>
<html>
<head>
    <title>Top 10 Highest Run Scorers</title>
    <style>
        table {
            border-collapse: collapse;
            width: 100%;
        }
        th, td {
            padding: 8px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <h1>Top 10 Highest Run Scorers</h1>
    <table>
        <tr>
            <th>Player ID</th>
            <th>Runs</th>
        </tr>
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

        // Query the database to get the top 10 highest run scorers
        $sql = "SELECT player_id, runs FROM battingstats_players ORDER BY runs DESC LIMIT 10";
        $result = $conn->query($sql);

        // Display the results
        if ($result->num_rows > 0) {
            while($row = $result->fetch_assoc()) {
                echo "<tr>";
                echo "<td>" . $row["player_id"] . "</td>";
                echo "<td>" . $row["runs"] . "</td>";
                echo "</tr>";
            }
        } else {
            echo "<tr><td colspan='2'>No results found</td></tr>";
        }

        $conn->close();
        ?>
    </table>
</body>
</html>