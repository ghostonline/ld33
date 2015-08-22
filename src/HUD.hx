package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;

class HUD extends Entity
{
    static inline var BulletFlashTime = 0.25;
    static inline var StartingHealth = 15;

    var flash:Image;
    var flashTimer:Float;
    var flashTotal:Float;
    var healthBar:Array<Image>;

    public function new()
    {
        super(0, 0);
        layer = ZOrder.HUD;

        flash = Image.createRect(HXP.width, HXP.height, 0xFF3333);
        flash.alpha = 0;
        flashTimer = flashTotal = 0;
        addGraphic(flash);

        healthBar = new Array<Image>();
        for (ii in 0...StartingHealth)
        {
            var bar = ImageFactory.createRect(10, 2, 0x33FF33);
            var barSpacing = bar.scaledHeight + 2;

            bar.x = HXP.width - 20;
            bar.y = 20 + barSpacing * (StartingHealth - ii - 1);
            addGraphic(bar);
            healthBar.push(bar);
        }
    }

    public function hitWithBullet()
    {
        flash.alpha = 1;
        flashTotal = flashTimer = BulletFlashTime;
        flash.alpha = flashTimer / flashTotal;

        if (healthBar.length > 0)
        {
            var bar = healthBar.pop();
            bar.visible = false;
        }
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
