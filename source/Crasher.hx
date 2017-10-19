package;

import flixel.*;
import flixel.effects.*;
import flixel.group.*;
import flixel.math.*;
import flixel.system.*;
import flixel.util.*;

class Crasher extends Enemy
{
    public static inline var DOWN_ACCELERATION = 75;
    public static inline var TURN_ACCELERATION = 400;
    public static inline var TURN_THRESHOLD = 10;
    public static inline var EDGE_THRESHOLD = 100;

    public function new(x:Int, y:Int, player:Player) {
        super(x, y, player);
        loadGraphic('assets/images/crasher.png', true, 16, 16);
        animation.add('down', [0]);
        animation.add('left', [1]);
        animation.add('right', [2]);
        animation.play('down');
        health = 1;
    }

    override public function movement() {
        // Overridden in child classes
        acceleration.y = DOWN_ACCELERATION;
        if(x - player.x > TURN_THRESHOLD) {
            acceleration.x = -TURN_ACCELERATION;
            animation.play('left');
        }
        else if(x - player.x < -TURN_THRESHOLD) {
            acceleration.x = TURN_ACCELERATION;
            animation.play('right');
        }
        else {
            acceleration.x = 0;
            animation.play('down');
        }
        if(x < EDGE_THRESHOLD) {
            acceleration.x = TURN_ACCELERATION;
        }
        else if(x > FlxG.width - EDGE_THRESHOLD) {
            acceleration.x = -TURN_ACCELERATION;
        }
    }
}

