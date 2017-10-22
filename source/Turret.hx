package;

import flixel.*;
import flixel.math.*;
import flixel.util.*;

class Turret extends Enemy
{
    public static inline var SPEED = 50;
    public static inline var SHOT_COOLDOWN = 2;
    public static inline var SHOT_SPEED = 210;
    public static inline var TIME_BETWEEN_SHOTS = 0.1;
    public static inline var SHOTS_IN_BURST = 4;

    private var dropDistance:Float;
    private var shootTimer:FlxTimer;
    private var bulletVelocity:FlxPoint;

    public function new(x:Int, y:Int, player:Player)
    {
        super(x, y, player);
        loadGraphic('assets/images/turret.png', true, 16, 16);
        animation.add('idle', [0, 1, 2], 10);
        animation.play('idle');
        health = 2;
        dropDistance = new FlxRandom().float(10, FlxG.height/2);
        shootTimer = new FlxTimer();
        shootTimer.start(SHOT_COOLDOWN, shoot, 0);
    }

    private function shoot(_:FlxTimer)
    {
        if(velocity.y > 0 || !alive) {
            return;
        }
        for(i in 0...SHOTS_IN_BURST) {
            new FlxTimer().start(
                i * TIME_BETWEEN_SHOTS,
                function(_:FlxTimer) {
                    if(!alive) {
                        return;
                    }
                    var bullet = new Bullet(
                        Std.int(x + width/2), Std.int(y + height/2),
                        new FlxPoint(0, SHOT_SPEED)
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
            if(velocity.x == 0) {
                if(x > FlxG.width/2) {
                    velocity.x = -SPEED;
                }
                else {
                    velocity.x = SPEED;
                }
            }
            velocity.y = 0;
        }
    }

    override public function kill()
    {
        shootTimer.cancel();
        super.kill();
    }
}
