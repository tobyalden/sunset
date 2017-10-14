package;

import flixel.*;
import flixel.addons.display.*;

class PlayState extends FlxState
{
    public static inline var BACKDROP_SCROLL_SPEED = 200;

    private var player:Player;
    private var backdrop:FlxBackdrop;

	override public function create():Void
	{
        player = new Player(20, 20);
        backdrop = new FlxBackdrop('assets/images/backdrop.png');
        backdrop.velocity.set(0, BACKDROP_SCROLL_SPEED);
        add(backdrop);
        add(player);
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
