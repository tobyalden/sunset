package;

import flixel.*;
import flixel.math.*;
import flixel.util.*;

class Demon extends Enemy
{
    public static inline var SPEED = 25;
    public static inline var SHOT_COOLDOWN = 1.5;
    public static inline var SHOT_SPEED = 50;
    public static inline var SHOT_SPREAD = 10;
    public static inline var TIME_BETWEEN_SHOTS = 0.5;
    public static inline var SHOTS_IN_BURST = 3;

    private var shootTimer:FlxTimer;

    public function new(x:Int, y:Int, player:Player)
    {
        super(x, y, player);
        loadGraphic('assets/images/demon.png');
        health = 2;
        shootTimer = new FlxTimer();
        shootTimer.start(SHOT_COOLDOWN, shoot, 0);
        acceleration.y = SPEED;
    }

    private function shoot(_:FlxTimer)
    {
        if(!alive) {
            return;
        }
        for(i in 0...SHOTS_IN_BURST) {
            new FlxTimer().start(
                i * TIME_BETWEEN_SHOTS,
                function(_:FlxTimer) {
                    if(!alive) {
                        return;
                    }
                    for(spread in -2...3) {
                        var bullet = new Bullet(
                            Std.int(x + width/2), Std.int(y + height/2),
                            new FlxPoint(SHOT_SPREAD * spread, SHOT_SPEED)
                        );
                        FlxG.state.add(bullet);
                    }
                }
            );
        }
    }

    override public function movement()
    {
        if(x < 0) {
            x = 0;
            velocity.x = SPEED;
        }
        else if(x > FlxG.width - width) {
            x = FlxG.width - width;
            velocity.x = -SPEED;
        }
    }

    override public function kill()
    {
        shootTimer.cancel();
        super.kill();
    }
}





