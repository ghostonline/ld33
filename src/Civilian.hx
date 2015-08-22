package ;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import com.haxepunk.Mask;
import com.haxepunk.graphics.Image;
import openfl.geom.Point;
import com.haxepunk.utils.Input;

class Civilian extends Entity
{
    static inline var WalkSpeed = 2.5;
    static inline var StompRange = 20;

    var direction:Point;
    var hud:HUD;

    public function new(hud:HUD, x:Float, y:Float, angle:Float=-1)
    {
        super(x, y);
        var img = ImageFactory.createRect(5, 10, 0xFF3300);
        img.originY = img.height - img.width / 2;
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

        ImageFactory.setEntityHitboxTo(this, img);
        this.hud = hud;
    }

    override public function update():Void
    {
        super.update();

        if (Input.mousePressed && collideRect(x, y, Input.mouseX - StompRange / 2, Input.mouseY - StompRange / 2, StompRange, StompRange))
        {
            scene.remove(this);
            hud.smashHuman();
        }

        moveBy(direction.x, direction.y, Building.CollisionType);
        if (x < 0 || HXP.width < x) { direction.x *= -1; }
        if (y < 0 || HXP.height < y) { direction.y *= -1; }

        layer = ZOrder.layerByY(y);
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
