package;

import flixel.*;
import flixel.effects.*;
import flixel.math.*;
import flixel.util.*;

class Player extends FlxSprite
{
    public static inline var SPEED = 200;
    public static inline var SHOT_SPEED = 800;
    public static inline var SHOT_COOLDOWN = 0.25;
    public static inline var RESPAWN_TIME = 1.5;
    public static inline var INVINCIBLE_TIME = 1.25;

    private var shootTimer:FlxTimer;
    private var invincible:FlxTimer;

    public function new(x:Int, y:Int)
    {
        super(x, y);
        loadGraphic('assets/images/player.png');
        shootTimer = new FlxTimer();
        invincible = new FlxTimer();
        width = 8;
        height = 8;
        offset.x = 8;
        offset.y = 8;
    }

    override public function update(elapsed:Float)
    {
        movement();
        super.update(elapsed);
        FlxSpriteUtil.bound(this);
    }

    override public function kill() {
        velocity.set(0, 0);
        if(invincible.active) {
            return;
        }
        FlxG.state.add(new Explosion(this));
        new FlxTimer().start(RESPAWN_TIME, function(_:FlxTimer) {
            respawn();
        });
        super.kill();
    }

    private function respawn() {
        revive();
        invincible.start(INVINCIBLE_TIME);
        FlxFlicker.flicker(this, INVINCIBLE_TIME);
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
                    new FlxPoint(0, -SHOT_SPEED),
                    true
                );
                FlxG.state.add(bullet);
            }
        }
    }
}
