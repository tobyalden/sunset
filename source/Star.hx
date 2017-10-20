package;

import flixel.*;
import flixel.math.*;
import flixel.util.*;

class Star extends Enemy
{
    public static inline var SPEED = 50;
    public static inline var SHOT_COOLDOWN = 2.5;
    public static inline var SHOT_SPEED = 50;
    public static inline var TIME_BETWEEN_SHOTS = 0.10;
    public static inline var SHOTS_IN_BURST = 10;
    public static inline var TURN_THRESHOLD = 100;

    private var dropDistance:Float;
    private var shootTimer:FlxTimer;

    public function new(x:Int, y:Int, player:Player)
    {
        super(x, y, player);
        loadGraphic('assets/images/star.png', true, 24, 24);
        animation.add('idle', [0, 1, 2], 10);
        animation.play('idle');
        health = 4;
        dropDistance = new FlxRandom().float(10, FlxG.height/2);
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
                    var bullet1 = new Bullet(
                        Std.int(x + width/2), Std.int(y + height/2),
                        new FlxPoint(SHOT_SPEED + velocity.x, SHOT_SPEED)
                    );
                    var bullet2 = new Bullet(
                        Std.int(x + width/2), Std.int(y + height/2),
                        new FlxPoint(-SHOT_SPEED + velocity.x, SHOT_SPEED)
                    );
                    var bullet3 = new Bullet(
                        Std.int(x + width/2), Std.int(y + height/2),
                        new FlxPoint(SHOT_SPEED + velocity.x, -SHOT_SPEED)
                    );
                    var bullet4 = new Bullet(
                        Std.int(x + width/2), Std.int(y + height/2),
                        new FlxPoint(-SHOT_SPEED + velocity.x, -SHOT_SPEED)
                    );
                    FlxG.state.add(bullet1);
                    FlxG.state.add(bullet2);
                    FlxG.state.add(bullet3);
                    FlxG.state.add(bullet4);
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
            if(velocity.x == 0) {
                velocity.x = new FlxRandom().sign() * SPEED;
            }
            if(x < 0) {
                x = 0;
                velocity.x = SPEED;
            }
            else if(x > FlxG.width - width) {
                x = FlxG.width - width;
                velocity.x = -SPEED;
            }
        }
    }

    override public function kill()
    {
        shootTimer.cancel();
        super.kill();
    }
}




