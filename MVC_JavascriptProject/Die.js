"use strict";

var Dice = (function (){
    var init = function(sides) {
        var sideNum = sides;
        var currentRoll = 0;
        var roll = function () {
            currentRoll = Math.floor(Math.random() * sideNum) + 1;
            return currentRoll;
        };

        var getCurrentRoll = function () {
            return currentRoll;
        };

        return {
            roll: roll,
            getCurrentRoll: getCurrentRoll
        }
    };

    return {
        init: init
    }
})();