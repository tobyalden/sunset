package;

import flixel.*;
import flixel.math.*;
import flixel.util.*;

class Boss extends Enemy
{
    public static inline var SPEED = 60;
    public static inline var SHOT_COOLDOWN = 1;
    public static inline var SHOT_SPEED = 80;
    public static inline var SHOT_SPREAD = 10;
    public static inline var TIME_BETWEEN_SHOTS = 0.2;
    public static inline var SHOTS_IN_BURST = 5;
    public static inline var TIME_BETWEEN_PHASES = 10;
    public static inline var MAX_NUMBER_OF_PHASES = 3;
    public static inline var SPIN_SPEED = 15;

    private var shootTimer:FlxTimer;
    private var numberOfPhases:Int;
    private var phase:Int;
    private var spinOffset:Float;
    private var difficulty:Float; // 1 = full difficulty, 0.5 = half difficulty

    // TODO: add difficulty parameter that unlocks phases, gives more health, and makes slightly faster
    public function new(x:Int, y:Int, player:Player, difficulty:Float=1)
    {
        super(x, y, player);
        this.difficulty = difficulty;
        loadGraphic('assets/images/boss.png', true, 64, 64);
        animation.add('idle', [0]);
        animation.add('freak', [1, 2, 3], 10);
        animation.add('idle2', [4]);
        animation.add('freak2', [5, 6, 7], 10);
        animation.play('idle');
        health = 50 * difficulty;
        spinOffset = 1;
        shootTimer = new FlxTimer();
        var shotCooldown:Float = SHOT_COOLDOWN;
        if(difficulty == 1) {
            numberOfPhases = MAX_NUMBER_OF_PHASES;
        }
        else if(difficulty <= 0.75) {
            numberOfPhases = MAX_NUMBER_OF_PHASES - 1;
            shotCooldown = SHOT_COOLDOWN * (1/difficulty * 2);
        }
        else if(difficulty <= 0.5) {
            numberOfPhases = MAX_NUMBER_OF_PHASES - 2;
            shotCooldown = SHOT_COOLDOWN * (1/difficulty * 2);
        }
        shootTimer.start(shotCooldown, shoot, 0);
        var rand = new FlxRandom();
        velocity.set(rand.sign() * SPEED * difficulty, SPEED * difficulty);
        phase = new FlxRandom().int(1, numberOfPhases);
        //phase = 1;
        new FlxTimer().start(TIME_BETWEEN_PHASES * difficulty, function(_:FlxTimer) {
            phase += 1;
            if(phase > numberOfPhases) {
                phase = 1;
            }
        }, 0);
    }

    private function shoot(_:FlxTimer)
    {
        if(!alive) {
            return;
        }
        if(phase == 1) {
            phaseOneShot();
        }
        else if(phase == 2 || phase == 3) {
            phaseTwoShot();
        }
    }

    private function phaseTwoShot() {
        if(!alive) {
            return;
        }
        var shots = SHOTS_IN_BURST;
        if(difficulty <= 0.75) {
            shots -= 1;
        }
        else if(difficulty <= 0.5) {
            shots -= 2;
        }
        for(i in 0...shots) {
            new FlxTimer().start(
                i * TIME_BETWEEN_SHOTS * (1/difficulty),
                function(_:FlxTimer) {
                    if(!alive) {
                        return;
                    }
                    var sign = 1;
                    if(phase == 3) {
                        sign = -1;
                    }
                    spinOffset += SPIN_SPEED * difficulty;
                    var angle = FlxAngle.angleBetweenPoint(
                        this, new FlxPoint(0, 0), true
                    );
                    angle += spinOffset;
                    angle *= sign;
                    var bulletVelocity = FlxVelocity.velocityFromAngle(
                        angle, SHOT_SPEED * difficulty
                    );
                    var bullet1 = new Bullet(
                        Std.int(x + width/2), Std.int(y + height/2),
                        bulletVelocity
                    );

                    var angle2 = FlxAngle.angleBetweenPoint(
                        this, new FlxPoint(FlxG.width, 0), true
                    );
                    angle2 += spinOffset;
                    angle2 *= sign;
                    var bulletVelocity2 = FlxVelocity.velocityFromAngle(
                        angle2, SHOT_SPEED * difficulty
                    );
                    var bullet2 = new Bullet(
                        Std.int(x + width/2), Std.int(y + height/2),
                        bulletVelocity2
                    );

                    var angle3 = FlxAngle.angleBetweenPoint(
                        this, new FlxPoint(FlxG.width, FlxG.height), true
                    );
                    angle3 += spinOffset;
                    angle3 *= sign;
                    var bulletVelocity3 = FlxVelocity.velocityFromAngle(
                        angle3, SHOT_SPEED * difficulty
                    );
                    var bullet3 = new Bullet(
                        Std.int(x + width/2), Std.int(y + height/2),
                        bulletVelocity3
                    );

                    var angle4 = FlxAngle.angleBetweenPoint(
                        this, new FlxPoint(0, FlxG.height), true
                    );
                    angle4 += spinOffset;
                    angle4 *= sign;
                    var bulletVelocity4 = FlxVelocity.velocityFromAngle(
                        angle4, SHOT_SPEED * difficulty
                    );
                    var bullet4 = new Bullet(
                        Std.int(x + width/2), Std.int(y + height/2),
                        bulletVelocity4
                    );

                    FlxG.state.add(bullet1);
                    FlxG.state.add(bullet2);
                    FlxG.state.add(bullet3);
                    FlxG.state.add(bullet4);
                }
            );
        }
    }

    private function phaseOneShot() {
        for(i in 0...SHOTS_IN_BURST) {
            new FlxTimer().start(
                i * TIME_BETWEEN_SHOTS,
                function(_:FlxTimer) {
                    if(!alive) {
                        return;
                    }
                    for(count in 0...2) {
                        var angle = FlxAngle.angleBetween(this, player, true);
                        angle += new FlxRandom().float(-SHOT_SPREAD, SHOT_SPREAD);
                        var bulletVelocity = FlxVelocity.velocityFromAngle(
                            angle, SHOT_SPEED
                        );
                        var bullet = new Bullet(
                            Std.int(x + width/2), Std.int(y + height/2),
                            bulletVelocity
                        );
                        FlxG.state.add(bullet);
                    }
                }
            );
        }
    }

    override public function movement()
    {
        if(phase == 1) {
            if(health < 15) {
                animation.play('freak');
            }
            else {
                animation.play('idle');
            }
        }
        else {
            if(health < 15) {
                animation.play('freak2');
            }
            else {
                animation.play('idle2');
            }
        }
        if(phase == 1 || phase == 3) {
            if(x < 0) {
                x = 0;
                velocity.x = SPEED * difficulty;
            }
            else if(x > FlxG.width - width) {
                x = FlxG.width - width;
                velocity.x = -SPEED * difficulty;
            }
            if(y < 0 && velocity.y < 0) {
                y = 0;
                velocity.y = SPEED * difficulty;
            }
            else if(y > FlxG.height - height) {
                y = FlxG.height - height;
                velocity.y = -SPEED * difficulty;
            }
        }
        else if(phase == 2) {
            FlxVelocity.moveTowardsPoint(
                this, new FlxPoint(FlxG.width/2, FlxG.height/2)
            );
        }
    }

    override public function kill()
    {
        for(bullet in Bullet.enemyAll) {
            bullet.destroy();
        }
        shootTimer.cancel();
        super.kill();
    }
}






