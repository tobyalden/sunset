package;

import flixel.*;
import flixel.math.*;
import flixel.util.*;

class Archer extends Enemy
{

    public static inline var SPEED = 50;

    private var dropDistance:Float;

    public function new(x:Int, y:Int, player:Player)
    {
        super(x, y, player);
        loadGraphic('assets/images/archer.png');
        health = 1;
        dropDistance = new FlxRandom().float(10, FlxG.height/2);
    }

    override public function movement()
    {
        if(y < dropDistance) {
            velocity.y = SPEED;
        }
        else {
            velocity.y = 0;
        }
    }
}


