package;

import flixel.*;
import flixel.system.*;
import flixel.addons.display.*;
import flixel.math.*;
import flixel.util.*;
import flixel.effects.*;

class PlayState extends FlxState
{
    public static inline var BACKDROP_SCROLL_SPEED = 200;
    public static inline var MAX_ENEMIES = 1;

    private var player:Player;
    private var backdrop:FlxBackdrop;
    private var clouds:FlxBackdrop;
    private var waveTimer:FlxTimer;
    private var waves:Array<Wave>;
    private var allWaves:Array<Array<Wave>>;
    private var gameOver:FlxSprite;
    private var levelComplete:FlxSprite;
    private var youWin:FlxSprite;
    private var currentLevel:Int;
    private var spawnBoss:Bool;
    private var flyIntoTheSunsetSfx:FlxSound;
    private var levelCompleteSfx:Map<Int, FlxSound>;

    override public function create():Void
    {
        spawnBoss = true;
        player = new Player(Std.int(FlxG.width/2), FlxG.height - 30);
        backdrop = new FlxBackdrop('assets/images/backdrop.png');
        backdrop.velocity.set(0, BACKDROP_SCROLL_SPEED);
        clouds = new FlxBackdrop('assets/images/clouds.png');
        clouds.velocity.set(0, BACKDROP_SCROLL_SPEED + 20);
        waveTimer = new FlxTimer();
        // archer, crasher, creeper, demon, eye
        // fighter, fossil, hydra, slither, star, turret
        allWaves = new Array<Array<Wave>>();
        // level 1
        flyIntoTheSunsetSfx = FlxG.sound.load(
            'assets/sounds/flyintothesunset.wav'
        );
        levelCompleteSfx = new Map<Int, FlxSound>();
        for(i in 1...8) {
            var sfx = FlxG.sound.load('assets/sounds/' + i + 'complete.wav');
            levelCompleteSfx.set(i, sfx);
        }
        allWaves.push([
            new Wave(['fossil', 'fossil'], 7, player),
            new Wave(['crasher', 'crasher'], 6, player),
            new Wave(['fighter'], 10, player),
            new Wave(['demon'], 10, player),
            new Wave(['demon'], 10, player),
            new Wave(['eye'], 7, player),
            new Wave(['archer'], 7, player),
            new Wave(['hydra'], 5, player),
            new Wave(['slither'], 5, player),
            new Wave(['turret', 'turret'], 5, player),
            new Wave(['rock', 'rock', 'rock', 'rock'], 5, player),
            new Wave(['rock', 'rock', 'rock', 'rock'], 5, player)
        ]);
        // level 2
        allWaves.push([
            new Wave(['fossil', 'creeper'], 7, player),
            new Wave(['crasher', 'hydra'], 6, player),
            new Wave(['fighter'], 8, player),
            new Wave(['demon'], 7, player),
            new Wave(['demon'], 7, player),
            new Wave(['eye', 'eye'], 7, player),
            new Wave(['archer', 'archer'], 7, player),
            new Wave(['hydra', 'star'], 5, player),
            new Wave(['crasher', 'crasher'], 5, player),
            new Wave(['crasher', 'crasher'], 5, player),
            new Wave(['turret', 'turret', 'turret'], 5, player),
            new Wave(['rock', 'rock', 'rock', 'rock', 'rock'], 5, player),
            new Wave(['rock', 'rock', 'rock', 'rock', 'rock'], 5, player)
        ]);
        // level 3
        allWaves.push([
            new Wave(['archer', 'creeper'], 7, player),
            new Wave(['hydra', 'hydra', 'hydra'], 6, player),
            new Wave(['fighter'], 7, player),
            new Wave(['demon'], 4, player),
            new Wave(['demon'], 5, player),
            new Wave(['turret', 'eye', 'turret'], 7, player),
            new Wave(['archer', 'archer'], 7, player),
            new Wave(['hydra', 'star'], 5, player),
            new Wave(['crasher', 'crasher', 'crasher'], 7, player),
            new Wave(['crasher', 'crasher'], 5, player),
            new Wave(['turret', 'turret', 'turret'], 5, player),
            new Wave(['rock', 'rock', 'rock', 'rock', 'rock'], 5, player),
            new Wave(['rock', 'rock', 'rock', 'rock', 'rock'], 5, player)
        ]);
        // level 4
        allWaves.push([
            new Wave(['archer', 'eye', 'eye'], 7, player),
            new Wave(['hydra', 'slither', 'hydra'], 6, player),
            new Wave(['rock', 'rock', 'turret', 'turret', 'rock'], 7, player),
            new Wave(['demon', 'fighter', 'creeper'], 4, player),
            new Wave(['demon', 'creeper'], 5, player),
            new Wave(['crasher', 'turret', 'crasher', 'turret', 'turret'], 7, player),
            new Wave(['archer', 'archer', 'star'], 7, player),
            new Wave(['hydra', 'star', 'fossil'], 6, player),
            new Wave(['crasher', 'crasher', 'crasher'], 7, player),
            new Wave(['crasher', 'crasher'], 5, player),
            new Wave(['turret', 'turret', 'turret'], 5, player),
            new Wave(['rock', 'rock', 'rock', 'rock', 'rock'], 5, player),
            new Wave(['rock', 'rock', 'rock', 'rock', 'rock'], 5, player)
        ]);
        // level 5
        allWaves.push([
            new Wave(['archer', 'eye', 'eye'], 6, player),
            new Wave(['hydra', 'slither', 'hydra'], 5, player),
            new Wave(['rock', 'rock', 'turret', 'turret', 'rock'], 7, player),
            new Wave(['fighter', 'fighter', 'rock', 'rock', 'rock'], 6, player),
            new Wave(['demon', 'turret', 'creeper'], 5, player),
            new Wave(['crasher', 'turret', 'crasher', 'turret', 'turret'], 7, player),
            new Wave(['archer', 'star', 'star', 'creeper'], 6, player),
            new Wave(['hydra', 'star', 'fossil'], 6, player),
            new Wave(['crasher', 'crasher', 'crasher', 'rock', 'rock'], 6, player),
            new Wave(['crasher', 'crasher', 'crasher', 'rock', 'rock'], 5, player),
            new Wave(['turret', 'turret', 'turret'], 5, player),
            new Wave(['rock', 'rock', 'rock', 'rock', 'rock', 'rock', 'creeper'], 4, player),
            new Wave(['rock', 'rock', 'rock', 'rock', 'rock', 'rock'], 4, player)
        ]);
        // level 6
        allWaves.push([
            new Wave(['crasher', 'turret', 'crasher', 'turret', 'turret'], 6, player),
            new Wave(['fossil', 'crasher', 'star'], 6, player),
            new Wave(['fossil', 'fossil', 'crasher', 'hydra'], 3, player),
            new Wave(['crasher', 'crasher', 'turret', 'eye'], 5, player),
            new Wave(['fighter', 'fighter'], 4, player),
            new Wave(['demon', 'demon', 'creeper'], 2, player),
            new Wave(['demon', 'hydra', 'creeper', 'rock', 'rock'], 4, player),
            new Wave(['eye', 'slither', 'turret', 'creeper'], 4, player),
            new Wave(['hydra', 'star', 'fossil', 'rock'], 6, player),
            new Wave(['crasher', 'crasher', 'crasher', 'rock', 'rock'], 6, player),
            new Wave(['turret', 'turret', 'turret', 'rock', 'rock'], 5, player),
            new Wave(['rock', 'rock', 'rock', 'rock', 'rock', 'rock'], 4, player),
            new Wave(['rock', 'rock', 'rock', 'rock', 'rock', 'rock'], 4, player)
        ]);
        // final level
        allWaves.push([
            new Wave(['fossil', 'fossil', 'crasher', 'hydra'], 3, player),
            new Wave(['crasher', 'crasher', 'turret', 'eye'], 5, player),
            new Wave(['fighter', 'fighter'], 4, player),
            new Wave(['demon', 'demon'], 2, player),
            new Wave(['demon', 'hydra', 'creeper'], 4, player),
            new Wave(['eye', 'slither', 'turret'], 4, player),
            new Wave(['archer', 'archer', 'archer'], 4, player),
            new Wave(['hydra', 'star', 'crasher'], 3, player),
            new Wave(['slither', 'slither', 'slither'], 4, player),
            new Wave(['turret', 'turret', 'turret', 'turret'], 4, player)
        ]);
        for(waves in allWaves) {
            new FlxRandom().shuffle(waves);
        }
        gameOver = new FlxSprite(0, 0);
        gameOver.loadGraphic('assets/images/gameover.png');
        levelComplete = new FlxSprite(0, 0);
        levelComplete.loadGraphic('assets/images/levelcomplete.png');
        youWin = new FlxSprite(0, 0);
        youWin.loadGraphic('assets/images/youwin.png');
        add(backdrop);
        add(clouds);
        add(player);
        add(gameOver);
        add(levelComplete);
        add(youWin);
        gameOver.visible = false;
        levelComplete.visible = false;
        youWin.visible = false;
        currentLevel = 1;
        waves = allWaves[currentLevel - 1];
        sendNextWave(null);
        var startSfx = FlxG.sound.load('assets/sounds/start.wav');
        startSfx.play();
        FlxG.sound.playMusic(
            FlxAssets.getSound('assets/music/playloop')
        );
        super.create();
    }

    override public function update(elapsed:Float):Void
    {
        Controls.controller = FlxG.gamepads.getByID(0);
        gameOver.visible = player.gameIsOver;
        if(Enemy.all.countLiving() <= 1 && waveTimer.timeLeft > 0.5) {
            waveTimer.reset(0.5);
        }
        if(Enemy.all.countLiving() > 5) {
            waveTimer.reset(1);
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

    public function beatLevel() {
        if(currentLevel == 7) {
            FlxG.sound.music.stop();
            new FlxTimer().start(3, function(_:FlxTimer) {
                flyIntoTheSunsetSfx.play();
                youWin.visible = true;
                FlxFlicker.flicker(youWin, 0.2);
                new FlxTimer().start(1, function(_:FlxTimer) {
                    player.sendOff();
                });
            });
        }
        else {
            nextLevel();
        }
    }

    private function nextLevel() {
        spawnBoss = false;
        new FlxTimer().start(3, function(_:FlxTimer) {
            spawnBoss = true;
        });
        new FlxTimer().start(0.5, function(_:FlxTimer) {
            levelCompleteSfx.get(currentLevel).play();
            currentLevel += 1;
            levelComplete.visible = true;
            FlxFlicker.flicker(levelComplete, 0.2);
            new FlxTimer().start(2, function(_:FlxTimer) {
                waves = allWaves[currentLevel - 1];
                sendNextWave(null);
                levelComplete.visible = false;
            });
        });
    }

    private function sendNextWave(_:FlxTimer) {
        var wave = waves.pop();
        if (wave == null) {
            if(Enemy.all.countLiving() > 0) {
                waveTimer.reset();
                return;
            }
            var difficulty = 0.5;
            if(currentLevel == 2) {
                difficulty = 0.6;
            }
            else if(currentLevel == 3) {
                difficulty = 0.7;
            }
            else if(currentLevel == 4) {
                difficulty = 0.7;
            }
            else if(currentLevel == 5) {
                difficulty = 0.75;
            }
            else if(currentLevel == 6) {
                difficulty = 0.8;
            }
            else if(currentLevel == 7) {
                difficulty = 1;
            }
            if(spawnBoss) {
                var boss = new Boss(0, 0, player, difficulty);
                boss.setStartPosition();
                add(boss);
            }
            return;
        }
        wave.activate();
        for (enemy in wave.enemies) {
            enemy.setStartPosition();
            add(enemy);
        }
        waveTimer.start(wave.timeTillNext, sendNextWave, 1);
    }
}
