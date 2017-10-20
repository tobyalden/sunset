package;

import flixel.*;
import flixel.math.*;
import flixel.util.*;

class Fossil extends Enemy
{
    public static inline var SPEED = 25;
    public static inline var SHOT_COOLDOWN = 1.5;
    public static inline var SHOT_SPEED = 156;
    public static inline var TIME_BETWEEN_SHOTS = 1;
    public static inline var SHOTS_IN_BURST = 1;

    private var shootTimer:FlxTimer;

    public function new(x:Int, y:Int, player:Player)
    {
        super(x, y, player);
        loadGraphic('assets/images/fossil.png', true, 16, 16);
        animation.add('right', [0]);
        animation.add('left', [1]);
        animation.play(new FlxRandom().getObject(['right', 'left']));
        health = 3;
        shootTimer = new FlxTimer();
        shootTimer.start(SHOT_COOLDOWN, shoot, 0);
        velocity.set(SPEED * new FlxRandom().sign(), SPEED);
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
                    var downBullet = new Bullet(
                        Std.int(x + width/2), Std.int(y + height/2),
                        new FlxPoint(0, SHOT_SPEED/3)
                    );
                    var sideBullet = new Bullet(
                        Std.int(x + width/2), Std.int(y + height/2),
                        new FlxPoint(SHOT_SPEED/3, 0)
                    );
                    if(animation.name == 'left') {
                        sideBullet.velocity.x *= -1;
                    }
                    FlxG.state.add(downBullet);
                    FlxG.state.add(sideBullet);
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




