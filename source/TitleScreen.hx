package;

import flixel.*;
import flixel.system.*;
import flixel.addons.display.*;

class TitleScreen extends FlxState
{
    public static inline var BACKDROP_SCROLL_SPEED = 200;

    private var titleSfx:FlxSound;
    private var backdrop:FlxBackdrop;
    private var title:FlxSprite;

    override public function create():Void
    {
        title = new FlxSprite(0, 0);
        title.loadGraphic('assets/images/title.png', true, 256, 240);
        title.animation.add('idle', [1, 2, 3, 4, 3, 2, 1], 4);
        title.animation.play('idle');
        backdrop = new FlxBackdrop('assets/images/backdrop.png');
        backdrop.velocity.set(0, BACKDROP_SCROLL_SPEED);
        add(backdrop);
        add(title);
        titleSfx = FlxG.sound.load('assets/sounds/sunset.ogg');
        titleSfx.play();
        FlxG.sound.playMusic(
            FlxAssets.getSound('assets/music/menuscreen')
        );
        super.create();
    }

    override public function update(elapsed:Float):Void
    {
        Controls.controller = FlxG.gamepads.getByID(0);
        if(
            Controls.checkPressed('shoot')
            || Controls.checkPressed('jump')
            || FlxG.keys.firstJustPressed() != -1
        ) {
            FlxG.switchState(new PlayState());
            FlxG.sound.music.stop();
        }
        super.update(elapsed);
    }
}
