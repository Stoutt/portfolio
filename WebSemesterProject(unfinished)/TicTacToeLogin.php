<?php
session_start();
?>
<?php
/**
 * Created by IntelliJ IDEA.
 * User: stoutt
 * Date: 4/8/15
 * Time: 3:07 PM
 *
 * ideas:
 * friends list (100 friends max)
 * ajax: for moves and friend requests (assume if your friends you can start a game)
 * database: for friends, stats, login
 * -users, friend pairs, game states
 * php: login
 * javascript: rendering board,game logic
 */

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

function validateUser($username, $password, $sqlConnection){
    $query = "SELECT username, password FROM TicTacUsers WHERE username = '$username'";
    //echo "Querying: <BR>";
    $request = $sqlConnection->query($query);
    //echo "VU: starting: <BR>";
    if($request->num_rows > 0){
        //echo "HERE <BR>";
        while ($row = $request->fetch_assoc()){
            //echo "VU ROW: ".$row['password'];
            if($row["password"] != $password) {
                //echo "VU: password <BR>";
                return "password";
            }
        }
    }
    else {
        //echo "ERROR: ".$sqlConnection->error;
        return "username";
    }
    //echo "VU: success";
    return "success";
}

function createAccount($username, $password, $sqlConnection){
    $query = "INSERT INTO TicTacUsers (username, password) VALUES ('$username','$password')";
    $request = $sqlConnection->query($query);
    if($request === TRUE){
        return TRUE;
    }
    else {
        echo "ERROR: " . $sqlConnection . "<BR>" . $sqlConnection->error;
        return FALSE;
    }
}
?>
<HTML>
<HEAD>

</HEAD>
<BODY>
<FIELDSET>
    <LEGEND>Multiplayer Tic Tac Toe</LEGEND>
    <form action="TicTacToeLogin.php" method="post" id="theForm">
        Username:
        <input type="text" name="username" id="uName"><BR>
        Password:
        <input type="password" name="password" id="pWord"><BR>
        <input type="checkbox" name="remember" id="rem" value="Remember me."> Remember me.
        <BR><BR>
        <input id='login' type="submit" name="lsubmit" value="Login">
        <input id='create' type="submit" name="csubmit" value="Create an account">
    </form>
</FIELDSET>
<?php
if(true){
    $conn = connect("stoutt","tyler125");
}

//echo "Login submit: " . $_POST['lsubmit'] . "<BR>";
//echo "Create sumbit: " . $_POST['csubmit'];
if(!empty($_POST['username']) && !empty($_POST['password']) && !empty($_POST['lsubmit'])){
    $user = $conn->real_escape_string($_POST['username']);
    $pw = $conn->real_escape_string($_POST['password']);
    $valid = validateUser($user,$pw,$conn);
    echo "Login status: " . $valid;
    if($valid == "success"){
        $_SESSION["username"] = $_POST["username"];
        //redirect
        header("Location: TicTacToeHome.php");
    }
    else if($valid == "username"){
        echo "Invalid username. Try again.";
    }
    else if($valid == "password"){
        echo "Invalid password. Try again.";
    }
    else {
        echo "Other login issue: " . $valid;
    }
}

elseif(!empty($_POST['username']) && !empty($_POST['password']) && !empty($_POST['csubmit'])){
    $create = createAccount($_POST['username'],$_POST['password'],$conn);
    echo "Account created: " . $create;
}
else{
    echo "<BR>Missing username and password.";
}


?>
</BODY>
</HTML>