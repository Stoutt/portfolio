<!DOCTYPE html>
<html>
<head>
</head>
<body>

<?php
function connect($username, $password)
{
    // Create an mysqli object connected to the database.
    $connection = new mysqli("cis.gvsu.edu", $username, $password);

    // Complain if the the connection fails.  (This would have to be more graceful
    // in a production environment)
    if (!$connection || $connection->connect_error) {
        die('Unable to connect to database [' . $connection->connect_error . ']');
    }
    $connection->select_db("stoutt");
    return $connection;
}

function checkIfTurn ($user, $friend, $connection) {
    $query = "SELECT game, friend1, friend2 FROM TicTacFriends WHERE ( friend1='$friend' OR friend1='$user' ) AND ( friend2='$friend' OR friend2='$user' )";
    $request = $connection->query($query);
    if($request->num_rows > 0){
        while($req = $request->fetch_assoc()) {
            $game = $req['game'];
            if ($req['friend1'] == $user) {
                echo "<div id=\"p1turnCheck\" style=\"display: none;\">" . $game . "</div>";
            } else if ($req['friend2'] == $user) {
                echo "<div id=\"p2turnCheck\" style=\"display: none;\">" . $game . "</div>";
            } else {
                echo "ERROR";
            }
        }
    }
    else {
        echo "no matches for " . $user . " containing " . $friend;
    }
}

$q = ($_GET['q']);
$user = $_GET['u'];

$con = connect("stoutt","tyler125");

checkIfTurn($user,$q,$con);
?>
</body>
</html>

