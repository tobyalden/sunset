package;

import flixel.*;
import flixel.addons.display.*;
import flixel.math.*;
import flixel.util.*;

class PlayState extends FlxState
{
    public static inline var BACKDROP_SCROLL_SPEED = 200;
    public static inline var TIME_BETWEEN_WAVES = 1;
    public static inline var MAX_ENEMIES = 3;

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
        // Damage enemies if they're touching
        FlxG.overlap(
            Bullet.playerAll, Enemy.all,
            function(bullet:FlxObject, enemy:FlxObject) {
                bullet.destroy();
                cast(enemy, Enemy).takeHit();
            }
        );

        // Kill player if they're touching an enemy or an enemy's bullet
        FlxG.overlap(
            player, Enemy.all,
            function(player:FlxObject, enemy:FlxObject) {
                player.kill();
            }
        );
        FlxG.overlap(
            player, Bullet.enemyAll,
            function(player:FlxObject, bullet:FlxObject) {
                bullet.destroy();
                player.kill();
            }
        );
        super.update(elapsed);
    }

    private function sendWave(_:FlxTimer) {
        if(Enemy.all.countLiving() >= MAX_ENEMIES) {
            return;
        }
        //var crasher:Enemy = new Crasher(0, 0, player);
        //crasher.setStartPosition();
        //add(crasher);
        //var archer:Enemy = new Archer(0, 0, player);
        //archer.setStartPosition();
        //add(archer);
        //var fighter:Enemy = new Fighter(0, 0, player);
        //fighter.setStartPosition();
        //add(fighter);
        //var hydra:Enemy = new Hydra(0, 0, player);
        //hydra.setStartPosition();
        //add(hydra);
        //var creeper:Enemy = new Creeper(0, 0, player);
        //creeper.setStartPosition();
        //add(creeper);
        //var fossil:Enemy = new Fossil(0, 0, player);
        //fossil.setStartPosition();
        //add(fossil);
        var demon:Enemy = new Demon(0, 0, player);
        demon.setStartPosition();
        add(demon);
        //var rock:Enemy;
        //if(new FlxRandom().bool(25)) {
            //rock = new BigRock(0, 0, player);
        //}
        //else {
            //rock = new Rock(0, 0, player);
        //}
        //rock.setStartPosition();
        //add(rock);
    }
}
