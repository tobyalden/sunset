package;

import flixel.*;
import flixel.addons.display.*;
import flixel.math.*;
import flixel.util.*;

class PlayState extends FlxState
{
    public static inline var BACKDROP_SCROLL_SPEED = 200;
    public static inline var MAX_ENEMIES = 1;

    private var player:Player;
    private var backdrop:FlxBackdrop;
    private var waveTimer:FlxTimer;
    private var waves:Array<Wave>;

    override public function create():Void
    {
        player = new Player(20, 20);
        backdrop = new FlxBackdrop('assets/images/backdrop.png');
        backdrop.velocity.set(0, BACKDROP_SCROLL_SPEED);
        waveTimer = new FlxTimer();
        waves = [
            new Wave(['archer', 'slither', 'slither'], 5, player),
            //new Wave(['crasher', 'devil'], 5, player),
            //new Wave(['creeper', 'demon', 'demon'], 6, player),
            //new Wave(['demon', 'eye'], 5, player),
            //new Wave(['eye', 'eye'], 5, player),
            //new Wave(['fighter', 'fossil'], 6, player),
            //new Wave(['fossil', 'hydra'], 4, player),
            //new Wave(['hydra', 'star'], 6, player),
            //new Wave(['slither', 'slither'], 5, player),
            //new Wave(['star', 'archer', 'archer'], 6, player),
            new Wave(['turret', 'turret', 'turret'], 5, player)
        ];
        new FlxRandom().shuffle(waves);
        add(backdrop);
        add(player);
        sendNextWave(null);
        super.create();
    }

    override public function update(elapsed:Float):Void
    {
        if(Enemy.all.countLiving() <= 1 && waveTimer.timeLeft > 0.5) {
            waveTimer.reset(0.5);
        }
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

    private function sendNextWave(_:FlxTimer) {
        var wave = waves.pop();
        if (wave == null) {
            if(Enemy.all.countLiving() > 0) {
                waveTimer.reset();
                return;
            }
            var boss:Enemy = new Boss(0, 0, player);
            boss.setStartPosition();
            add(boss);
            // dont forget boss difficulty,.. and rocks..
            return;
        }
        wave.activate();
        for (enemy in wave.enemies) {
            enemy.setStartPosition();
            add(enemy);
        }
        waveTimer.start(wave.timeTillNext, sendNextWave, 1);
        //if(new FlxRandom().bool(25)) {
            //rock = new BigRock(0, 0, player);
        //}
        //else {
            //rock = new Rock(0, 0, player);
        //}
        //var turret:Enemy = new Turret(0, 0, player);
        //turret.setStartPosition();
        //add(turret);
        //var turret:Enemy = new Archer(0, 0, player);
        //turret.setStartPosition();
        //add(turret);
    }
}
