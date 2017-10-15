package;

import flixel.math.*;

class Rock extends Enemy
{
    public static inline var FALL_ACCELERATION = 50;

    public function new(x:Int, y:Int, player:Player) {
        super(x, y, player);
        var path = 'assets/images/rock' + new FlxRandom().int(1, 8) +'.png';
        loadGraphic(path);
        acceleration.y = FALL_ACCELERATION;
        health = 2;
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
    }
}
