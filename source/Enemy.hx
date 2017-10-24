package;

import flixel.*;
import flixel.effects.*;
import flixel.group.*;
import flixel.math.*;
import flixel.system.*;
import flixel.util.*;

class Enemy extends FlxSprite
{
    static public var all:FlxGroup = new FlxGroup();

    private var player:Player;
    private var hitSfx:FlxSound;
    private var explodeSfx:FlxSound;

    public function new(x:Int, y:Int, player:Player) {
        super(x, y);
        this.player = player;
        all.add(this);
        hitSfx = FlxG.sound.load('assets/sounds/hit.wav');
        explodeSfx = FlxG.sound.load('assets/sounds/explode.wav');
    }

    public function movement() {
        // Overridden in child classes
    }

    override public function update(elapsed:Float)
    {
        if(y > FlxG.height || x + width < 0 || x > FlxG.width) {
            kill();
            return;
        }
        movement();
        super.update(elapsed);
    }

    override public function kill() {
        FlxG.state.add(new Explosion(this));
        super.kill();
    }

    public function setStartPosition() {
        x = new FlxRandom().int(0, Std.int(FlxG.width - width));
        y = -height;
    }

    public function takeHit() {
        health -= 1;
        if(health <= 0) {
            kill();
            explodeSfx.play();
        }
        else {
            FlxFlicker.flicker(this, 0.2);
            hitSfx.play();
        }
    }
}
