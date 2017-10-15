package;

import flixel.*;
import flixel.addons.display.*;
import flixel.math.*;
import flixel.util.*;

class PlayState extends FlxState
{
    public static inline var BACKDROP_SCROLL_SPEED = 200;
    public static inline var TIME_BETWEEN_WAVES = 1;

    private var player:Player;
    private var backdrop:FlxBackdrop;
    private var waveTimer:FlxTimer;

	override public function create():Void
	{
        player = new Player(20, 20);
        backdrop = new FlxBackdrop('assets/images/backdrop.png');
        backdrop.velocity.set(0, BACKDROP_SCROLL_SPEED);
        waveTimer = new FlxTimer();
        waveTimer.start(TIME_BETWEEN_WAVES, sendWave, 0);
        add(backdrop);
        add(player);
		super.create();
	}

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        FlxG.overlap(
            Bullet.all, Enemy.all,
            function(bullet:FlxObject, enemy:FlxObject) {
                bullet.destroy();
                cast(enemy, Enemy).takeHit();
            }
        );
    }

    private function sendWave(_:FlxTimer) {
        var rock = new Rock(0, 0, player);
        rock.x = new FlxRandom().int(0, Std.int(FlxG.width - rock.width));
        rock.y = -rock.height;
        add(rock);
    }
}
