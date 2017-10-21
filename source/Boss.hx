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
    public static inline var NUMBER_OF_PHASES = 2;
    public static inline var SPIN_SPEED = 15;

    private var shootTimer:FlxTimer;
    private var phase:Int;
    private var spinOffset:Float;

    public function new(x:Int, y:Int, player:Player)
    {
        super(x, y, player);
        loadGraphic('assets/images/boss.png', true, 64, 64);
        animation.add('idle', [0]);
        animation.add('freak', [1, 2, 3], 10);
        animation.play('idle');
        health = 50;
        spinOffset = 1;
        shootTimer = new FlxTimer();
        shootTimer.start(SHOT_COOLDOWN, shoot, 0);
        var rand = new FlxRandom();
        velocity.set(rand.sign() * SPEED, SPEED);
        phase = new FlxRandom().int(1, NUMBER_OF_PHASES);
        new FlxTimer().start(TIME_BETWEEN_PHASES, function(_:FlxTimer) {
            phase += 1;
            if(phase > NUMBER_OF_PHASES) {
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
        else if(phase == 2) {
            phaseTwoShot();
        }
    }

    private function phaseTwoShot() {
        if(!alive) {
            return;
        }
        for(i in 0...SHOTS_IN_BURST) {
            new FlxTimer().start(
                i * TIME_BETWEEN_SHOTS,
                function(_:FlxTimer) {
                    if(!alive) {
                        return;
                    }
                    spinOffset += SPIN_SPEED;
                    var angle = FlxAngle.angleBetweenPoint(
                        this, new FlxPoint(0, 0), true
                    );
                    angle += spinOffset;
                    var bulletVelocity = FlxVelocity.velocityFromAngle(
                        angle, SHOT_SPEED
                    );
                    var bullet1 = new Bullet(
                        Std.int(x + width/2), Std.int(y + height/2),
                        bulletVelocity
                    );

                    var angle2 = FlxAngle.angleBetweenPoint(
                        this, new FlxPoint(FlxG.width, 0), true
                    );
                    angle2 += spinOffset;
                    var bulletVelocity2 = FlxVelocity.velocityFromAngle(
                        angle2, SHOT_SPEED
                    );
                    var bullet2 = new Bullet(
                        Std.int(x + width/2), Std.int(y + height/2),
                        bulletVelocity2
                    );

                    var angle3 = FlxAngle.angleBetweenPoint(
                        this, new FlxPoint(FlxG.width, FlxG.height), true
                    );
                    angle3 += spinOffset;
                    var bulletVelocity3 = FlxVelocity.velocityFromAngle(
                        angle3, SHOT_SPEED
                    );
                    var bullet3 = new Bullet(
                        Std.int(x + width/2), Std.int(y + height/2),
                        bulletVelocity3
                    );

                    var angle4 = FlxAngle.angleBetweenPoint(
                        this, new FlxPoint(0, FlxG.height), true
                    );
                    angle4 += spinOffset;
                    var bulletVelocity4 = FlxVelocity.velocityFromAngle(
                        angle4, SHOT_SPEED
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
            if(x < 0) {
                x = 0;
                velocity.x = SPEED;
            }
            else if(x > FlxG.width - width) {
                x = FlxG.width - width;
                velocity.x = -SPEED;
            }
            if(y < 0 && velocity.y < 0) {
                y = 0;
                velocity.y = SPEED;
            }
            else if(y > FlxG.height - height) {
                y = FlxG.height - height;
                velocity.y = -SPEED;
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
        shootTimer.cancel();
        super.kill();
    }
}






