package ;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import openfl.geom.Point;
import com.haxepunk.utils.Input;

enum AIState
{
    EnteringScreen;
    Running;
    Shooting;
}

class Police extends Entity
{
    static inline var StompRange = 20;
    static inline var WalkSpeed = 3;
    static inline var ShootDelay = 1.0;
    static inline var MaxRunTime = 1.5;
    static inline var MinRunTime = 0.5;

    var direction:Point;
    var state:AIState;
    var decisionTimer:Float;
    var startDistance:Float;
    var hud:HUD;

    public function new(x:Float, y:Float, hud:HUD)
    {
        super(x, y);
        this.hud = hud;
        var img = ImageFactory.createRect(5, 10, 0x0033FF);
        img.originY = img.height - img.width / 2;
        graphic = img;
        direction = new Point();
        ImageFactory.setEntityHitboxTo(this, img);
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
    }

    function dashRandom()
    {
        direction.x = Math.random() - 0.5;
        direction.y = Math.random() - 0.5;
        direction.normalize(WalkSpeed);
        state = AIState.Running;
        decisionTimer = HXP.random * (MaxRunTime - MinRunTime) + MinRunTime;
    }

    function shoot()
    {
        state = AIState.Shooting;
        decisionTimer = ShootDelay;
    }

    override public function update():Void
    {
        super.update();

        if (Input.mousePressed && collideRect(x, y, Input.mouseX - StompRange / 2, Input.mouseY - StompRange / 2, StompRange, StompRange))
        {
            scene.remove(this);
            hud.smashHuman();
        }

        decisionTimer -= HXP.elapsed;
        if (state == AIState.Running)
        {
            moveBy(direction.x, direction.y, Building.CollisionType);
            if (x < 0 || HXP.width < x) { direction.x *= -1; }
            if (y < 0 || HXP.height < y) { direction.y *= -1; }
            if (decisionTimer <= 0) { shoot(); }
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
            moveBy(direction.x, direction.y, Building.CollisionType);
            startDistance -= direction.length;
            if (startDistance < 0) { shoot(); }
        }

        layer = ZOrder.layerByY(y);
    }
}
