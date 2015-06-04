<?php
session_start();
?>
<html>
<head lang="en">
    <title></title>
    <style type="text/css">
        tr#top td {
            border-bottom: 1px solid black;
        }

        tr#mid td {
            border-top: 1px solid black;
            border-bottom: 1px solid black;
        }

        tr#bot td {
            border-top: 1px solid black;
        }

        td#left {
            border-right: 1px solid black;
        }

        td#mid {
            border-left: 1px solid black;
            border-right: 1px solid black;
        }

        td#right {
            border-left: 1px solid black;
        }
        td.tile {
            width: 50px;
            height: 50px;
            text-align: center;
        }
        div#friendslist {
            width: 100px;
            height: 400px;
            overflow: auto;
        }
        #board {
            align-content: center;
        }

        #LogoutButton {
            float: right;
        }
    </style>
    <script type="text/javascript" src="TicTacToeGame.js"></script>
</head>
<body>
<button id="LogoutButton">Logout</button>
<H1>TIC TAC TOE</H1>
<table>
    <TD>Friends:<BR>
        <div id="friendslist">
            <dl class="friends">
            <?php
            //pull friends from db into <dt> tags
            function getFriends($username,$sqlConnection){
                //TODO inplement button that adds the add friend field and stops the refreshes
                $query = "SELECT friend1, friend2 FROM TicTacFriends WHERE friend1 = '$username' OR friend2 = '$username'";
                $request = $sqlConnection->query($query);
                if($request->num_rows > 0){
                    while ($row = $request->fetch_assoc()){
                        if($row["friend1"] == $username) {
                           echo "<dt class=\"friend\">".$row['friend2']."</dt>";
                        }
                        else if($row["friend2"] == $username){
                            echo "<dt class=\"friend\">".$row['friend1']."</dt>";
                        }
                    }
                }
                else {
                    echo "<dt>No friends :(</dt>";
                }
            }

            if(TRUE) {
                $conn = connect("stoutt","tyler125");
            }

            //createFriendDB($conn);
            getFriends($_SESSION['username'],$conn);
            ?>
            </dl>
        </div>
        <form action="TicTacToeHome.php" method="get">
            Add a friend:<BR>
            <input type="text" width="100" name="addFriend" id="addFriend" maxlength="15">
        </form>
    </TD>
    <TD>
        <div id="board">
        <table class="gboard">
            <TR id="top">
                <TD class="tile" id="left"></TD>
                <TD class="tile" id="mid"></TD>
                <TD class="tile" id="right"></TD>
            </TR>
            <TR id="mid">
                <TD class="tile" id="left"></TD>
                <TD class="tile" id="mid"></TD>
                <TD class="tile" id="right"></TD>
            </TR>
            <TR id="bot">
                <TD class="tile" id="left"></TD>
                <TD class="tile" id="mid"></TD>
                <TD class="tile" id="right"></TD>
            </TR>
        </table>
        </div>
        <div id="gameXML"></div>

    </TD>
</table>
<script>

    function move(i){
        //console.log("i: " +  i);
        game.placePiece(Math.floor(i/3), i%3);
        document.getElementsByClassName("tile")[i].innerHTML = game.getPiece(Math.floor(i/3), i%3);
        //console.log("move: " + game.getPiece(Math.floor(i/3), i%3));

        //TODO Testing
        game.evaluateXML(game.generateXML());
    }

    function logout() {
        document.location = 'logout.php';
    }
    LogoutButton.addEventListener('click',logout,false);

    var game = TicTacToeGame.init();
    game.startGame();
    function checkMove(friendName) {

        if (friendName == "") {
            document.getElementById("txtHint").innerHTML = "";
            return;
        } else {
            if (window.XMLHttpRequest) {
                // code for IE7+, Firefox, Chrome, Opera, Safari
                xmlhttp = new XMLHttpRequest();
            } else {
                // code for IE6, IE5
                xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
            }
            xmlhttp.onreadystatechange = function() {
                if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                    document.getElementById("gameXML").innerHTML = xmlhttp.responseText;
                }
            };
            var user = document.getElementById("username").innerText;
            xmlhttp.open("GET","getBoard.php?q="+friendName+"&u="+user,true);
            xmlhttp.send();
        }
        var p1 = document.getElementById("p1turnCheck");
        var p2 = document.getElementById("p2turnCheck");
        //while(p1 == null && p2 == null){
            p1 = document.getElementById("p1turnCheck");
            p2 = document.getElementById("p2turnCheck");
        //}

        console.log("TURNCHECKS~~~~~~~");
        console.log(document.getElementById("p1turnCheck"));
        console.log(document.getElementById("p2turnCheck"));
        console.log("TURNCHECKDONE~~~~~");
    }

    //checking if friend is clicked
    var friends = document.getElementsByClassName("friend");
    //console.log(friends[0].innerText);
    for(var f = 0; f < friends.length; f++){
        var listener2 = (function(friend){
            return function() {
                checkMove(friend);
            }
        })(friends[f].innerText);
        friends[f].addEventListener('click',listener2,false);
    }


    //checking if tile is clicked
    var tiles = document.getElementsByClassName("tile");
    for (var i = 0; i < tiles.length;i++){
        document.getElementsByClassName("tile")[i].innerHTML = game.getPiece(Math.floor(i/3), i%3);
        var listener = (function(index){
        return function() {
            //console.log("Index is " + index);
            move(index);
        }
        })(i);
        tiles[i].addEventListener('click', listener, false);

    }
</script>
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

    function createFriendDB ($sqlConnection) {
        if(!($sqlConnection->query("DROP TABLE IF EXISTS TicTacFriends"))){
            echo "Table deletion failed: ".$sqlConnection->error;
        }
        $table = "CREATE TABLE TicTacFriends (
        id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        friend1 VARCHAR(15) NOT NULL,
        friend2 VARCHAR(15) NOT NULL,
        game VARCHAR(200)
    )";
        if($sqlConnection->query($table) === TRUE) {
            return TRUE; //SUCCESS
        }
        else {
            return FALSE;
        }
    }

    function createLoginDB ($sqlConnection) {
        if(!($sqlConnection->query("DROP TABLE IF EXISTS TicTacUsers"))){
            echo "Table deletion failed: ".$sqlConnection->error;
        }
        /*
        $table = "CREATE TABLE TicTacUsers (
        id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        friend1 VARCHAR(15) NOT NULL,
        friend2 VARCHAR(15) NOT NULL,
        game VARCHAR(200)
    )";
        */
        $table = "";
        if($sqlConnection->query($table) === TRUE) {
            return TRUE; //SUCCESS
        }
        else {
            return FALSE;
        }
    }

    function addFriend ($user, $friend, $connection) {
        $query = "SELECT username FROM TicTacUsers WHERE '$friend' = username";
        $request = $connection->query($query);
        //TODO duplicate friend adding
        if($request->num_rows > 0){
            $entry = "INSERT INTO TicTacFriends (friend1,friend2, game) VALUES ('$user','$friend', NULL)";
            if($connection->query($entry) === TRUE) {
                return TRUE;
            }
            else {
                echo "ERROR: " . $connection . "<BR>" . $connection->error;
                return false;
            }
        }
        else {
            return false;
        }
    }

    function checkIfTurn ($user, $friend, $connection) {
        $query = "SELECT game,friend1, friend2 FROM TicTacFriends WHERE (friend1='$friend' OR friend1='$user') AND
        (friend2='$friend' OR friend2='$user')";
        $request = $connection->query($query);
        if($request->num_rows > 0){
            $req = $request->fetch_assoc();
            $game = $req['game'];
            if($req['friend1'] == $user) {
                echo "<div id=\"p1turnCheck\" style=\"display: none;\">".$game."</div>";
            } else if($req['friend2'] == $user){
                echo "<div id=\"p2turnCheck\" style=\"display: none;\">".$game."</div>";
            }

        }
    }

    if(TRUE) {
        $conn = connect("stoutt","tyler125");
    }

    if(empty($_SESSION['username'])){
        echo "You are not logged in. Redirecting in: ";
        header("Location: TicTacToeLogin.php");
    }
    else {
        echo "<div id=\"username\" style=\"display: none;\">" . $_SESSION['username'] . "</div>";
    }
    if(!empty($_GET['addFriend'])){
        $friend = $conn->real_escape_string($_GET['addFriend']);
        if(addFriend($_SESSION['username'],$friend,$conn)){
            header ("Location: TicTacToeHome.php");
            //^removes get preventing duplicates thanks to refresh
        }
        else {
            echo "<BR>ERR: User not found.";
        }
    }
?>
</body>
</html>