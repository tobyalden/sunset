package;

import flixel.math.*;

class Rock extends Enemy
{
    public static inline var FALL_ACCELERATION = 50;
    public static inline var FALL_VARIATION = 10;

    public function new(x:Int, y:Int, player:Player) {
        super(x, y, player);
        var rand = new FlxRandom();
        var path = 'assets/images/rock' + rand.int(1, 8) +'.png';
        loadGraphic(path);
        acceleration.y = FALL_ACCELERATION + rand.int(0, FALL_VARIATION);
        health = 2;
    }
}
