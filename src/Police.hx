package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import openfl.geom.Point;
import com.haxepunk.utils.Input;

enum AIState
{
    EnteringScreen;
    Running;
    Shooting;
    Dead;
}

class Police extends Entity
{
    static inline var StompRange = 20;
    static inline var WalkSpeed = 2;
    static inline var ShootDelay = 1.0;
    static inline var MaxRunTime = 1.5;
    static inline var MinRunTime = 0.5;

    var direction:Point;
    var state:AIState;
    var decisionTimer:Float;
    var startDistance:Float;
    var hud:HUD;
    var sprite:Spritemap;
    var spriteDead:Spritemap;

    public function new(x:Float, y:Float, hud:HUD)
    {
        super(x, y);
        this.hud = hud;
        sprite = ImageFactory.createSpriteSheet("graphics/police.png", 7);
        sprite.add("walk", [0, 1], 8, true);
        sprite.add("aim", [2]);
        sprite.add("fire", [3]);
        sprite.originY = sprite.height - sprite.width / 2;
        graphic = sprite;
        spriteDead = ImageFactory.createSpriteSheet("graphics/police_dead.png", 14);
        spriteDead.add("dead_down", [0]);
        spriteDead.add("dead_up", [1]);
        direction = new Point();
        ImageFactory.setEntityHitboxTo(this, sprite);
        decisionTimer = 0;
        enterScreen();
    }

    function enterScreen()
    {
        direction.x = x < 0 ? 1 : -1;
        direction.y = 0;
        direction.normalize(WalkSpeed);
        state = AIState.EnteringScreen;
        startDistance = HXP.random * HXP.halfWidth + HXP.halfWidth / 2;
        sprite.play("walk");
    }

    function dashRandom()
    {
        direction.x = Math.random() - 0.5;
        direction.y = Math.random() - 0.5;
        direction.normalize(WalkSpeed);
        state = AIState.Running;
        decisionTimer = HXP.random * (MaxRunTime - MinRunTime) + MinRunTime;
        sprite.play("walk");
    }

    function tryShoot()
    {
        if (collide(Building.CollisionType, x, y) == null)
        {
            state = AIState.Shooting;
            decisionTimer = ShootDelay;
            sprite.play("aim");
        }
        else
        {
            dashRandom();
        }
    }

    override public function update():Void
    {
        super.update();

        if (state == AIState.Dead) { direction.x *= 0.95; direction.y *= 0.95; }

        if (state != AIState.Dead && Input.mousePressed && collideRect(x, y, Input.mouseX - StompRange / 2, Input.mouseY - StompRange / 2, StompRange, StompRange))
        {
            direction.x = x - Input.mouseX;
            direction.y = y - Input.mouseY;
            direction.normalize(WalkSpeed);
            graphic = spriteDead;
            spriteDead.flipped = direction.x < 0;

            if (direction.y > 0) { spriteDead.play("dead_down"); }
            else { spriteDead.play("dead_up"); }
            state = AIState.Dead;
            setHitbox();
        }

        decisionTimer -= HXP.elapsed;
        if (state == AIState.Running || state == AIState.Dead)
        {
            moveBy(direction.x, direction.y, CityLayout.CollisionType);
            if (x < 0 || HXP.width < x) { direction.x *= -1; x = HXP.clamp(x, 0, HXP.width); }
            if (y < 0 || HXP.height < y) { direction.y *= -1; y = HXP.clamp(y, 0, HXP.height); }
            if (decisionTimer <= 0 && state == AIState.Running) { tryShoot(); }
        }
        else if (state == AIState.Shooting)
        {
            if (decisionTimer <= 0) {
                hud.hitWithBullet();
                dashRandom();
            }
        }
        else if (state == AIState.EnteringScreen)
        {
            moveBy(direction.x, direction.y, CityLayout.CollisionType);
            startDistance -= direction.length;
            if (startDistance < 0) { tryShoot(); }
        }

        layer = ZOrder.layerByY(y);

        sprite.flipped = direction.x < 0;
    }
}
