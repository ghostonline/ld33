package ;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import com.haxepunk.Mask;
import com.haxepunk.graphics.Image;
import openfl.geom.Point;

class Civilian extends Entity
{
    static inline var WalkSpeed = 1.5;
    static inline var StompRange = 20;

    var direction:Point;
    var hud:HUD;
    var image:Spritemap;
    var dead:Bool;

    public function new(hud:HUD, x:Float, y:Float, angle:Float=-1)
    {
        super(x, y);
        image = ImageFactory.createSpriteSheet("graphics/civilians.png", 12, 8);
        var variantOffset = HXP.rand(4) * 4;
        var walkFrameA = variantOffset;
        var walkFrameB = variantOffset + 1;
        var deadFrameA = variantOffset + 2;
        var deadFrameB = variantOffset + 3;
        image.add("walk", [walkFrameA, walkFrameB], 4, true);
        image.add("dead_up", [deadFrameA]);
        image.add("dead_down", [deadFrameB]);
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
        this.dead = false;
    }

    override public function update():Void
    {
        super.update();

        if (dead) { direction.x *= 0.95; direction.y *= 0.95; }

        if (!dead && MonsterAttack.stompFloor && collideRect(x, y, MonsterAttack.x - StompRange / 2, MonsterAttack.y - StompRange / 2, StompRange, StompRange))
        {
            hud.smashHuman();
            direction.x = x - MonsterAttack.x;
            direction.y = y - MonsterAttack.y;
            direction.normalize(WalkSpeed);

            if (direction.y > 0) { image.play("dead_down"); }
            else { image.play("dead_up"); }
            dead = true;
            setHitbox();
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
