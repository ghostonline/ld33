package ;
import com.haxepunk.utils.Input;

class MonsterAttack
{
    public static var x(default, null):Int;
    public static var y(default, null):Int;
    public static var stompFloor(default, null):Bool;
    public static var smashBuilding(default, null):Bool;

    public static function update(hud:HUD, scene:MainScene)
    {
        x = Input.mouseX;
        y = Input.mouseY;
        var pressed = Input.mousePressed && hud.isAlive() && !hud.killCops();

        if (pressed && scene.collidePoint(Building.CollisionType, x, y) == null)
        {
            stompFloor = pressed;
        }
        else
        {
            smashBuilding = pressed;
        }
    }

    public static function reset()
    {
        x = 0;
        y = 0;
        smashBuilding = false;
        stompFloor = false;
    }

}