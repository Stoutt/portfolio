"use strict"

var Player = (function (){
    var init = function(playerName) {
        var name = playerName;
        var score = 0;

        var getName = function () {
            return name;
        };

        var getScore = function () {
            return score;
        };

        var addScore = function (newTurnTotal) {
            score += newTurnTotal;
        };

        return {
            getName: getName,
            getScore: getScore,
            addScore: addScore
        }
    };

    return {
        init: init
    }
})();