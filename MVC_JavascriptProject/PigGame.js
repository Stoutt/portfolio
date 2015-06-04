"use strict";

var PigGame = (function (){
    var init = function() {
        var turnTotal = 0;
        var turn = 0;
        var gamePlayers;
        var winCondition;
        var dice = Dice.init(6);
        var makePlayers = function (p1,p2,p3,p4){
            gamePlayers = [];
            turn = 0;
            resetTotal();
            if (p1 != "") {
                gamePlayers[gamePlayers.length] = Player.init(p1);
            }
            if (p2 != "") {
                gamePlayers[gamePlayers.length] = Player.init(p2);
            }
            if (p3 != "") {
                gamePlayers[gamePlayers.length] = Player.init(p3);
            }
            if (p4 != "") {
                gamePlayers[gamePlayers.length] = Player.init(p4);
            }
            if(gamePlayers.length < 2){

                return false;
            }
            return true;
        };

        var nextTurn = function(){
            resetTotal();
            //console.log("Len: " + gamePlayers.length + "; turn: " + turn);
            if(turn == gamePlayers.length-1){
                turn = 0;
            }
            else{
                turn++;
            }
        };

        var roll = function() {
            var myRoll = dice.roll();
            //console.log("ROLLED: " + myRoll);
            if(myRoll == 1){
                console.log("Couldn't roll again!");
                nextTurn();
            }
            else {
                game.incrementTurnTotal(myRoll);
                if(game.hasWon(gamePlayers[turn].getScore(),winCondition)){
                    console.log("YOU WIN!");
                    return 0;
                }
            }
            return myRoll;
        };

        var hold = function(){
            if(turnTotal != 0) {
                gamePlayers[turn].addScore(turnTotal);
                nextTurn();
                return true;
            }
            return false;
        };

        var setWinCondition = function(winConditionValue){
            winCondition = winConditionValue;
        };

        var resetGame = function(){
            //TODO
        };

        var getCurrentPlayerName = function(){
            //console.log("turn: " + turn);
            //console.log("len: " + gamePlayers.length);
            //console.log(gamePlayers[turn]);
            return gamePlayers[turn].getName();
        };

        var resetTotal = function (){
            turnTotal = 0;
        };

        var incrementTurnTotal = function (myRoll){
            turnTotal += myRoll;
        };

        var hasWon = function(playerScore, scoreToWin) {
            return ((playerScore + turnTotal) >= scoreToWin);
        };

        var getTurnTotal = function (){
            return turnTotal;
        };

        var getPlayers = function () {
            return gamePlayers;
        };

        return {
            //cantRollAgain: cantRollAgain,
            //canHold: canHold,
            //resetTotal: resetTotal,
            incrementTurnTotal: incrementTurnTotal,
            getTurnTotal: getTurnTotal,
            hasWon: hasWon,
            hold: hold,
            roll: roll,
            makePlayers: makePlayers,
            setWinCondition: setWinCondition,
            getCurrentPlayerName: getCurrentPlayerName,
            resetGame: resetGame,
            getPlayers: getPlayers
        }
    };

    return {
        init: init
    }
})();