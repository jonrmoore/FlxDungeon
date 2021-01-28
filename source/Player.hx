package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

class Player extends FlxSprite
{
    static inline var SPEED:Float = 200;
    
    public function new():Void
    {
        // super(x, y);
        super();
        loadGraphic(AssetPaths.player__png, true, 16, 16);
        setFacingFlip(FlxObject.LEFT, false, false);
        setFacingFlip(FlxObject.RIGHT, true, false);
        animation.add("lr", [3, 4, 3, 5], 6, false);
        animation.add("u", [6, 7, 6, 8], 6, false);
        animation.add("d", [0, 1, 0, 2], 6, false);
        drag.x = drag.y = 1600;
        setSize(8, 8);
        offset.set(4, 4);
    }

    override function update(elapsed:Float):Void
    {
        updateMovement();
        super.update(elapsed);
    }

    private function updateMovement():Void
    {
        var up:Bool = false;
        var down:Bool = false;
        var left:Bool = false;
        var right:Bool = false;

        up = FlxG.keys.anyPressed([UP, W]);
        down = FlxG.keys.anyPressed([DOWN, S]);
        left = FlxG.keys.anyPressed([LEFT, A]);
        right = FlxG.keys.anyPressed([RIGHT, D]);

        if (up && down)
            up = down = false;
        if (left && right)
            left = right = false;

        if (up || down || left || right)
        {
            var newAngle:Float = 0;
            if (up)
            {
                newAngle = -90;
                if (left)
                    newAngle -= 45;
                else if (right)
                    newAngle += 45;

                facing = FlxObject.UP;
            }
            else if (down)
            {
                newAngle = 90;
                if (left)
                    newAngle += 45;
                else if (right)
                    newAngle -= 45;

                facing = FlxObject.DOWN;
            }
            else if (left)
            {
                newAngle = 180;
                facing = FlxObject.LEFT;
            }
            else if (right)
            {
                newAngle = 0;
                facing = FlxObject.RIGHT;
            }
            
            // Determine velocity based on angle and speed
            velocity.set(SPEED, 0);
            velocity.rotate(FlxPoint.weak(0, 0), newAngle);

            // if the player is moving, change the animation the direction they're facing
            if ((velocity.x != 0 && velocity.y != 0) && touching == FlxObject.NONE)
            {
                switch (facing)
                {
                    case FlxObject.LEFT, FlxObject.RIGHT:
                        animation.play("lr");
                    case FlxObject.UP:
                        animation.play("u");
                    case FlxObject.DOWN:
                        animation.play("d");
                }
            }
        }
    }
}