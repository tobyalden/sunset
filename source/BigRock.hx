package;

import flixel.*;
import flixel.math.*;

class BigRock extends Enemy
{
    public static inline var FALL_ACCELERATION = 30;
    public static inline var FALL_VARIATION = 10;

    public function new(x:Int, y:Int, player:Player) {
        super(x, y, player);
        var rand = new FlxRandom();
        var path = 'assets/images/bigrock' + rand.int(1, 4) +'.png';
        loadGraphic(path);
        acceleration.y = FALL_ACCELERATION + rand.int(0, FALL_VARIATION);
        health = 4;
    }

    override public function kill() {
        FlxG.state.add(new Explosion(this, true));
        super.kill();
    }

    override public function setStartPosition() {
        x = new FlxRandom().int(0, Std.int(FlxG.width - width));
        y = -height - new FlxRandom().int(0, Std.int(FlxG.height/2));
    }
}
