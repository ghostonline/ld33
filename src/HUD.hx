package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;

class HUD extends Entity
{
    static inline var BulletFlashTime = 0.25;

    var flash:Image;
    var flashTimer:Float;
    var flashTotal:Float;

    public function new()
    {
        super(0, 0);
        flash = Image.createRect(HXP.width, HXP.height, 0xFF3333);
        flash.alpha = 0;
        flashTimer = flashTotal = 0;
        addGraphic(flash);
        layer = ZOrder.HUD;
    }

    public function hitWithBullet()
    {
        flash.alpha = 1;
        flashTotal = flashTimer = BulletFlashTime;
        flash.alpha = flashTimer / flashTotal;
    }

    override public function update():Void
    {
        super.update();
        if (flashTimer > 0)
        {
            flashTimer -= HXP.elapsed;
            if (flashTimer <= 0) { flashTimer = 0; }
            flash.alpha = flashTimer / flashTotal;
        }
    }
}
