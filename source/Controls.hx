package;

import flixel.*;
import flixel.input.gamepad.*;
import flixel.input.keyboard.*;

class Controls {

    public static inline var DEAD_ZONE = 0.5;
    public static var KEYBOARD_CONTROLS = [
        'up'=>FlxKey.UP,
        'down'=>FlxKey.DOWN,
        'left'=>FlxKey.LEFT,
        'right'=>FlxKey.RIGHT,
        'jump'=>FlxKey.Z,
        'shoot'=>FlxKey.X
    ];

    public static var controller:FlxGamepad;
    public static var controls:Map<String, Int> = KEYBOARD_CONTROLS;

    public static function checkPressed(name:String) {
        if(controller == null) {
            if(name == 'shoot' || name == 'jump') {
                return (
                    FlxG.keys.firstPressed() != -1
                    && FlxG.keys.firstPressed() != FlxKey.UP
                    && FlxG.keys.firstPressed() != FlxKey.DOWN
                    && FlxG.keys.firstPressed() != FlxKey.LEFT
                    && FlxG.keys.firstPressed() != FlxKey.RIGHT
                );
            }
            return FlxG.keys.anyPressed([controls[name]]);
        }
        else {
            if(name == 'shoot') {
                return controller.pressed.X;
            } 
            if(name == 'jump') {
                return controller.pressed.A;
            } 
            if(name == 'left') {
                return (
                    controller.analog.value.LEFT_STICK_X < -DEAD_ZONE
                    || controller.pressed.DPAD_LEFT
                );
            }
            if(name == 'right') {
                return (
                    controller.analog.value.LEFT_STICK_X > DEAD_ZONE
                    || controller.pressed.DPAD_RIGHT
                );
            }
            if(name == 'up') {
                return (
                    controller.analog.value.LEFT_STICK_Y < -DEAD_ZONE
                    || controller.pressed.DPAD_UP
                );
            }
            if(name == 'down') {
                return (
                    controller.analog.value.LEFT_STICK_Y > DEAD_ZONE
                    || controller.pressed.DPAD_DOWN
                );
            }
        }
        return false;
    }

    public static function checkJustPressed(name:String) {
        if(controller == null) {
            if(name == 'shoot' || name == 'jump') {
                return (
                    FlxG.keys.firstJustPressed() != -1
                    && FlxG.keys.firstJustPressed() != FlxKey.UP
                    && FlxG.keys.firstJustPressed() != FlxKey.DOWN
                    && FlxG.keys.firstJustPressed() != FlxKey.LEFT
                    && FlxG.keys.firstJustPressed() != FlxKey.RIGHT
                );
            }
            return FlxG.keys.anyJustPressed([controls[name]]);
        }
        else {
            if(name == 'shoot') {
                return controller.justPressed.X;
            } 
            if(name == 'jump') {
                return controller.justPressed.A;
            } 
        }
        return false;
    }

    public static function checkJustReleased(name:String) {
        if(controller == null) {
            if(name == 'shoot' || name == 'jump') {
                return (
                    FlxG.keys.firstJustReleased() != -1
                    && FlxG.keys.firstJustReleased() != FlxKey.UP
                    && FlxG.keys.firstJustReleased() != FlxKey.DOWN
                    && FlxG.keys.firstJustReleased() != FlxKey.LEFT
                    && FlxG.keys.firstJustReleased() != FlxKey.RIGHT
                );
            }
            return FlxG.keys.anyJustReleased([controls[name]]);
        }
        else {
            if(name == 'shoot') {
                return controller.justReleased.X;
            } 
            if(name == 'jump') {
                return controller.justReleased.A;
            } 
        }
        return false;
    }

}
