package;

import flixel.*;
import flixel.math.*;
import flixel.util.*;

class Eye extends Enemy
{
    public static inline var SPEED = 50;
    public static inline var SHOT_COOLDOWN = 2;
    public static inline var SHOT_SPEED = 210;
    public static inline var TIME_BETWEEN_SHOTS = 0.1;
    public static inline var SHOTS_IN_BURST = 1;

    private var dropDistance:Float;
    private var shootTimer:FlxTimer;
    private var bulletVelocity:FlxPoint;

    public function new(x:Int, y:Int, player:Player)
    {
        super(x, y, player);
        loadGraphic('assets/images/eye.png', true, 16, 16);
        animation.add('idle', [0, 1, 2], 10);
        animation.play('idle');
        health = 2;
        dropDistance = new FlxRandom().float(10, FlxG.height/1.5);
        shootTimer = new FlxTimer();
        shootTimer.start(SHOT_COOLDOWN, shoot, 0);
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
                    var angle = FlxAngle.angleBetween(this, player, true);
                    var bulletVelocity = FlxVelocity.velocityFromAngle(angle, SHOT_SPEED);
                    var bullet = new Bullet(
                        Std.int(x + width/2), Std.int(y + height/2),
                        bulletVelocity
                    );
                    FlxG.state.add(bullet);
                }
            );
        }
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

    override public function kill()
    {
        shootTimer.cancel();
        super.kill();
    }
}




