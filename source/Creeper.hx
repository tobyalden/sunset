package;

import flixel.*;
import flixel.math.*;
import flixel.util.*;

class Creeper extends Enemy
{
    public static inline var SPEED = 35;
    public static inline var SHOT_COOLDOWN = 1.8;
    public static inline var SHOT_SPEED = 150;
    public static inline var TIME_BETWEEN_SHOTS = 0.08;
    public static inline var SHOTS_IN_BURST = 2;

    private var shootTimer:FlxTimer;

    public function new(x:Int, y:Int, player:Player)
    {
        super(x, y, player);
        loadGraphic('assets/images/creeper.png', true, 16, 16);
        animation.add('idle', [0, 1, 2], 10);
        animation.play('idle');
        health = 2;
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
                    var leftBullet = new Bullet(
                        Std.int(x + width/2), Std.int(y + height/2),
                        new FlxPoint(-SHOT_SPEED/3, SHOT_SPEED)
                    );
                    var rightBullet = new Bullet(
                        Std.int(x + width/2), Std.int(y + height/2),
                        new FlxPoint(SHOT_SPEED/3, SHOT_SPEED)
                    );
                    FlxG.state.add(leftBullet);
                    FlxG.state.add(rightBullet);
                }
            );
        }
    }

    override public function movement()
    {
        velocity.x = -player.velocity.x/2;
        velocity.y = SPEED;
    }

    override public function kill()
    {
        shootTimer.cancel();
        super.kill();
    }
}




