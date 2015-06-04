"use strict";

var TicTacToeGame = (function (){
    var init = function () {
        var board = [];
        var state;
        var player;
        var startGame = function(){
            //set board to blank
            state = "p1turn";
            board[board.length] = [0,0,0];
            board[board.length] = [0,0,0];
            board[board.length] = [0,0,0];
            player = 1;
        };
        //player is either 1 or 2
        var placePiece = function (row, col) {
            //display();
            if(isValidMove(row,col)){
                board[row][col] = player;
                if(hasWon(row,col)){
                    state = "p" + player + "won";
                }
                else if(hasTie()){
                    state = "tie";
                }
                else{
                    switchPlayer();
                }
                //console.log("state: " + state);
            }
            else{
                console.log("invalid move");
            }
        };

        var getPiece = function(row, col){
            return board[row][col];
        };

        var isValidMove = function (row, col) {
            //console.log("row" + row + " col" + col);
            return (board[row][col] == 0);
        };

        var hasWon = function(row, col){
            //display();
            if(board[row][0] == board[row][1] && board[row][0] == board[row][2] && board[row][0] != 0){
                console.log("here1");
                return true;
            }
            else if(board[0][col] == board[1][col] && board[0][col] == board[2][col] && board[0][col] != 0){
                console.log("here2");
                return true;
            }
            else if(board[0][0] == board[1][1] && board[0][0] == board[2][2] && board[0][0] != 0) {
                console.log("here3");
                return true;
            }
            else if(board[0][2] == board[1][1] && board[0][2] == board[2][0] && board[0][2] != 0) {
                console.log("here4");
                return true;
            }
            else {
                return false;
            }
        };

        var hasTie = function (){
            for(var r = 0; r < 3; r++){
                for(var c = 0; c < 3; c++){
                    if(board[r][c] == 0){
                        return false;
                    }
                }
            }
            return true;
        };

        var switchPlayer = function(){
            if(state == "p1turn") {
                state = "p2turn";
                player++;
            }
            else if(state == "p2turn"){
                state = "p1turn";
                player--;
            }
        };

        var generateXML = function(){
            var xml =  "<game>" +
                "<turn>" + player + "</turn>" +
                "<state>" + state + "</state>" +
                "<board>";
                for(var i = 0; i < 3; i++) {
                    xml = xml + "<row><col>" + board[i][0] + "</col>";
                    xml = xml + "<col>" + board[i][1] + "</col>";
                    xml = xml + "<col>" + board[i][2] + "</col></row>";
                }
                //console.log(xml + "</board></game>");
                return xml + "</board></game>";
        };

        var evaluateXML = function(XML){
            if (window.DOMParser)
            {
                var parser=new DOMParser();
                var xmlDoc=parser.parseFromString(XML,"text/xml");
            }
            else // Internet Explorer
            {
                var xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
                xmlDoc.async=false;
                xmlDoc.loadXML(XML);
            }
            player = xmlDoc.getElementsByTagName("turn")[0].childNodes[0].nodeValue;
            //console.log(xmlDoc.getElementsByTagName("turn")[0].childNodes[0].nodeValue);
            state = xmlDoc.getElementsByTagName("state")[0].childNodes[0].nodeValue;
            //console.log(xmlDoc.getElementsByTagName("state")[0].childNodes[0].nodeValue);
            var xmlBoard = xmlDoc.getElementsByTagName("board")[0].childNodes;
            //console.log(xmlBoard);
            for(var r = 0; r < xmlBoard.length; r++){
                var row = xmlBoard[r].childNodes;
                //console.log(row);
                for (var c = 0; c < row.length; c++) {
                    //console.log(row[c].childNodes[0].nodeValue);
                    board[r][c] = row[c].childNodes[0].nodeValue;
                }
            }

        };

        var display = function (){
            for(var i = 0; i < 3; i++) {
                console.log(board[i][0] + "|" + board[i][1] + "|" + board[i][2]);
            }
        };

        var setPlayerTurn = function (newTurn) {
            player = newTurn;
            state = "p" + newTurn + "turn";
        };

        var getState = function (){
            return state;
        };

        return {
            startGame: startGame,
            placePiece: placePiece,
            getPiece: getPiece,
            getState: getState,
            setPlayerTurn: setPlayerTurn,
            generateXML: generateXML,
            evaluateXML: evaluateXML
        }
    };

    return {
        init: init
    }
})();