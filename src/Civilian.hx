package ;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import com.haxepunk.Mask;
import com.haxepunk.graphics.Image;
import openfl.geom.Point;

class Civilian extends Entity
{
    static inline var WalkSpeed = 5;

    var direction:Point;

    public function new(x:Float=0, y:Float=0, angle:Float=-1)
    {
        super(x, y);
        var img = ImageFactory.createRect(5, 10, 0xFF3300);
        img.originY = 0;
        graphic = img;
        direction = new Point();
        if (angle < 0)
        {
            direction.x = Math.random() - 0.5;
            direction.y = Math.random() - 0.5;
            direction.normalize(WalkSpeed);
        }
        else
        {
            direction.x = Math.cos(angle) * WalkSpeed;
            direction.y = Math.sin(angle) * WalkSpeed;
        }
    }

    override public function update():Void
    {
        super.update();
        moveBy(direction.x, direction.y, Building.CollisionType);
        if (x < 0 || HXP.width < x) { direction.x *= -1; }
        if (y < 0 || HXP.height < y) { direction.y *= -1; }
    }

    override public function moveCollideX(e:Entity):Bool
    {
        direction.x *= -1;
        return super.moveCollideX(e);
    }

    override public function moveCollideY(e:Entity):Bool
    {
        direction.y *= -1;
        return super.moveCollideY(e);
    }
}
