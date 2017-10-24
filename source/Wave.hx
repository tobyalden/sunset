package;

import flixel.math.*;

class Wave
{
    public var enemies:Array<Enemy>;
    public var enemyNames:Array<String>;
    public var timeTillNext:Int;

    private var player:Player;

    // dont forget rocks..!
    public function new(
        enemyNames:Array<String>, timeTillNext:Int, player:Player
    ) {
        this.timeTillNext = timeTillNext;
        this.enemyNames = enemyNames;
        this.player = player;
        enemies = new Array<Enemy>();
    }

    public function activate() {
        for (enemyName in enemyNames) {
            if(enemyName == 'archer') {
                enemies.push(new Archer(0, 0, player));             
            }
            else if(enemyName == 'boss') {
                enemies.push(new Boss(0, 0, player));             
            }
            else if(enemyName == 'crasher') {
                enemies.push(new Crasher(0, 0, player));             
            }
            else if(enemyName == 'creeper') {
                enemies.push(new Creeper(0, 0, player));             
            }
            else if(enemyName == 'demon') {
                enemies.push(new Demon(0, 0, player));             
            }
            else if(enemyName == 'eye') {
                enemies.push(new Eye(0, 0, player));             
            }
            else if(enemyName == 'fighter') {
                enemies.push(new Fighter(0, 0, player));             
            }
            else if(enemyName == 'fossil') {
                enemies.push(new Fossil(0, 0, player));             
            }
            else if(enemyName == 'hydra') {
                enemies.push(new Hydra(0, 0, player));             
            }
            if(enemyName == 'rock') {
                if(new FlxRandom().bool(25)) {
                    enemies.push(new BigRock(0, 0, player));
                }
                else {
                    enemies.push(new Rock(0, 0, player));
                }
            }
            else if(enemyName == 'slither') {
                enemies.push(new Slither(0, 0, player));             
            }
            else if(enemyName == 'star') {
                enemies.push(new Star(0, 0, player));             
            }
            else if(enemyName == 'turret') {
                enemies.push(new Turret(0, 0, player));             
            }
        }
    }

}
