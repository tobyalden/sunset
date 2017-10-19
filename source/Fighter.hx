package;

import flixel.*;
import flixel.math.*;
import flixel.util.*;

class Fighter extends Enemy
{
    public static inline var PI = 3.14159265359;

    public static inline var DODGE_WIDTH = 1500;
    public static inline var SHOT_COOLDOWN = 1;
    public static inline var SHOT_SPEED = 200;

    private var sinCounter:Float;
    private var shootTimer:FlxTimer;

    public function new(x:Int, y:Int, player:Player)
    {
        super(x, y, player);
        loadGraphic('assets/images/fighter.png');
        health = 2;
        sinCounter = PI/2;
        velocity.y = 50;
        shootTimer = new FlxTimer();
        staggerShot();
        maxVelocity = new FlxPoint(200, 100);
    }

    private function staggerShot() {
        var shotStagger = new FlxRandom().float(0, SHOT_COOLDOWN);
        new FlxTimer().start(shotStagger, function(_:FlxTimer) {
            if(alive) {
                shootTimer.start(SHOT_COOLDOWN, shoot, 0);
            }
        });
    }

    private function shoot(_:FlxTimer)
    {
        if(!alive) {
            return;
        }
        var bullet = new Bullet(
            Std.int(x + width/2), Std.int(y + height/2),
            new FlxPoint(0, SHOT_SPEED)
        );
        FlxG.state.add(bullet);
    }

    override public function movement()
    {
        sinCounter += 0.1;
        acceleration.x = Math.sin(sinCounter) * DODGE_WIDTH;
        if(y < height) {
            velocity.y = 50;
        }
        if(y > FlxG.height/2) {
            velocity.y = -50;
        }
    }

    override public function setStartPosition()
    {
        x = new FlxRandom().int(
            Std.int(FlxG.width/4),
            Std.int(FlxG.width - width - FlxG.width/4)
        );
        y = -height;
    }

    override public function kill()
    {
        shootTimer.cancel();
        super.destroy();
    }
}

