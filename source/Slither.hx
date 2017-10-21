package;

import flixel.*;
import flixel.math.*;
import flixel.util.*;

class Slither extends Enemy
{
    public static inline var SPEED = 60;
    public static inline var SHOT_COOLDOWN = 2;
    public static inline var SHOT_SPEED = 80;
    public static inline var SHOT_SPREAD = 10;
    public static inline var TIME_BETWEEN_SHOTS = 0.00001;
    public static inline var SHOTS_IN_BURST = 3;

    private var shootTimer:FlxTimer;

    public function new(x:Int, y:Int, player:Player)
    {
        super(x, y, player);
        loadGraphic('assets/images/slither.png', true, 24, 24);
        animation.add('idle', [0, 1, 2], 10);
        animation.play('idle');
        health = 3;
        shootTimer = new FlxTimer();
        shootTimer.start(SHOT_COOLDOWN, shoot, 0);
        var rand = new FlxRandom();
        velocity.set(rand.sign() * SPEED, SPEED);
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
                    for(count in 0...2) {
                        var angle = FlxAngle.angleBetween(this, player, true);
                        angle += new FlxRandom().float(-SHOT_SPREAD, SHOT_SPREAD);
                        var bulletVelocity = FlxVelocity.velocityFromAngle(
                            angle, SHOT_SPEED
                        );
                        var bullet = new Bullet(
                            Std.int(x + width/2), Std.int(y + height/2),
                            bulletVelocity
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
        if(y < 0 && velocity.y < 0) {
            y = 0;
            velocity.y = SPEED;
        }
        else if(y > FlxG.height - height) {
            y = FlxG.height - height;
            velocity.y = -SPEED;
        }
    }

    override public function kill()
    {
        shootTimer.cancel();
        super.kill();
    }
}





