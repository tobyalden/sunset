package;

import flixel.*;
import flixel.util.*;

class Explosion extends FlxSprite
{
    public function new(source:FlxSprite, big:Bool=false) {
        super(source.x, source.y);
        if(big) {
            loadGraphic('assets/images/bigexplosion.png', true, 64, 64);
        }
        else {
            loadGraphic('assets/images/explosion.png', true, 32, 32);
        }
        x += source.width/2 - width/2;
        y += source.height/2 - height/2;
        animation.add('explode', [0, 1], 10, false);
        animation.play('explode');
    }
    
    override public function update(elapsed:Float)
    {
        if(animation.finished) {
            destroy();
            return;
        }
        super.update(elapsed);
    }

}
