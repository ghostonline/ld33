package ;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Spritemap;
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
    var image:Spritemap;

    public function new(hud:HUD, x:Float, y:Float, angle:Float=-1)
    {
        super(x, y);
        image = ImageFactory.createSpriteSheet("graphics/civilians.png", 6);
        image.add("walk", [0, 1], 4, true);
        image.play("walk");
        image.originY = image.height - image.width / 2;
        graphic = image;
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

        ImageFactory.setEntityHitboxTo(this, image);
        this.hud = hud;
    }

    function updateGraphics()
    {
    }

    override public function update():Void
    {
        super.update();

        if (Input.mousePressed && collideRect(x, y, Input.mouseX - StompRange / 2, Input.mouseY - StompRange / 2, StompRange, StompRange))
        {
            scene.remove(this);
            hud.smashHuman();
        }

        moveBy(direction.x, direction.y, CityLayout.CollisionType);
        if (x < 0 || HXP.width < x) { direction.x *= -1; }
        if (y < 0 || HXP.height < y) { direction.y *= -1; }
        image.flipped = direction.x < 0;

        layer = ZOrder.layerByY(y);
    }

    override public function moveCollideX(e:Entity):Bool
    {
        direction.x *= -1;
        image.flipped = direction.x < 0;
        return super.moveCollideX(e);
    }

    override public function moveCollideY(e:Entity):Bool
    {
        direction.y *= -1;
        return super.moveCollideY(e);
    }
}
