package;

import flixel.*;
import flixel.group.*;
import flixel.math.*;
import flixel.system.*;
import flixel.util.*;

class Bullet extends FlxSprite
{
    public static inline var SIZE = 4;
    //private var hitSfx:FlxSound;

    public static var playerAll:FlxGroup = new FlxGroup();
    public static var enemyAll:FlxGroup = new FlxGroup();

    public function new(
        x:Int, y:Int, velocity:FlxPoint, shotByPlayer:Bool=false
    )
    {
        super(x - SIZE/2, y - SIZE/2);
        this.velocity = velocity;
        makeGraphic(SIZE, SIZE, FlxColor.WHITE);
        if(shotByPlayer) {
            playerAll.add(this);
        }
        else {
            enemyAll.add(this);
        }
    }

    override public function update(elapsed:Float)
    {
        if(!isOnScreen()) {
            destroyQuietly();
            return;
        }
        super.update(elapsed);
    }

    override public function destroy()
    {
        FlxG.state.add(new Explosion(this));
        //hitSfx.play(true);
        playerAll.remove(this);
        enemyAll.remove(this);
        super.destroy();
    }

    public function destroyQuietly()
    {
        playerAll.remove(this);
        enemyAll.remove(this);
        super.destroy();
    }
}
