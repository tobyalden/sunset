package;

import flixel.*;
import flixel.math.*;
import flixel.util.*;

class Player extends FlxSprite
{
    public static inline var SPEED = 200;
    public static inline var SHOT_SPEED = 600;
    public static inline var SHOT_COOLDOWN = 0.25;

    private var shootTimer:FlxTimer;

    public function new(x:Int, y:Int)
    {
        super(x, y);
        loadGraphic('assets/images/player.png');
        shootTimer = new FlxTimer();
    }

    override public function update(elapsed:Float)
    {
        movement();
        super.update(elapsed);
        FlxSpriteUtil.bound(this);
    }

    private function movement()
    {
        if(Controls.checkPressed('up')) {
            velocity.y = -SPEED;
        }
        else if(Controls.checkPressed('down')) {
            velocity.y = SPEED;
        }
        else {
            velocity.y = 0;
        }

        if(Controls.checkPressed('left')) {
            velocity.x = -SPEED;
        }
        else if(Controls.checkPressed('right')) {
            velocity.x = SPEED;
        }
        else {
            velocity.x = 0;
        }

        if(velocity.x != 0 && velocity.y != 0) {
            velocity.scale(0.707106781);
        }

        if(Controls.checkPressed('shoot')) {
            if(!shootTimer.active) {
                shootTimer.start(SHOT_COOLDOWN);
                var bullet = new Bullet(
                    Std.int(x + width/2), Std.int(y + height/2),
                    new FlxPoint(0, -SHOT_SPEED)
                );
                FlxG.state.add(bullet);
            }
        }
    }
}
