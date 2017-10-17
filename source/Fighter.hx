package;

import flixel.*;
import flixel.math.*;
import flixel.util.*;

class Fighter extends Enemy
{
    public static inline var DODGE_WIDTH = 250;
    public static inline var PI = 3.141592653589793;

    private var sinCounter:Float;

    public function new(x:Int, y:Int, player:Player) {
        super(x, y, player);
        loadGraphic('assets/images/fighter.png');
        health = 2;
        sinCounter = 0;
        velocity.y = 50;
    }

    override public function movement() {
        sinCounter += 0.1;
        velocity.x = Math.sin(sinCounter) * DODGE_WIDTH;
        if(y < height) {
            velocity.y = 50;
        }
        if(y > FlxG.height/2) {
            velocity.y = -50;
        }
    }

    override public function setStartPosition() {
        x = new FlxRandom().int(
            Std.int(FlxG.width/3),
            Std.int(FlxG.width - width - FlxG.width/3)
        );
        y = -height;
    }
        
}

