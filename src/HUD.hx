package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Graphiclist;

class HUD extends Entity
{
    static inline var StartingHealth = 20;
    static inline var BulletFlashTime = 0.25;
    static inline var ScoreDigits = 10;
    static inline var HumanScore = 100;
    static inline var FloorScore = 500;
    static inline var ShotShakeTime = 0.25;
    static inline var MaxShakeOffset = 5.0;

    var flash:Image;
    var flashTimer:Float;
    var flashTotal:Float;
    var shakeTimer:Float;
    var healthBar:HealthBar;
    var scoreText:Text;
    var score:Int;
    public var floorSmashed(default, null):Int;

    public function new()
    {
        super(0, 0);
        layer = ZOrder.HUD;

        var graphics = new Graphiclist();

        flash = Image.createRect(HXP.width, HXP.height, 0xFF3333);
        flash.alpha = 0;
        flashTimer = flashTotal = 0;
        graphics.add(flash);

        healthBar = new HealthBar(graphics, StartingHealth);

        score = 0;
        scoreText = new Text();
        scoreText.x = 20;
        scoreText.y = 20;
        graphics.add(scoreText);
        updateScore();
        shakeTimer = 0;
        floorSmashed = 0;
        graphic = graphics;
    }

    public function shake()
    {
        shakeTimer = ShotShakeTime;
    }

    public function hitWithBullet()
    {
        flash.alpha = 1;
        flashTotal = flashTimer = BulletFlashTime;
        flash.alpha = flashTimer / flashTotal;

        healthBar.removeHealth(1);
        shakeTimer = ShotShakeTime;
    }

    public function smashFloor()
    {
        score += FloorScore;
        updateScore();
        floorSmashed += 1;
    }

    public function smashHuman()
    {
        score += HumanScore;
        updateScore();
    }

    function updateScore()
    {
        var i:Float = score;
        var count = 0;
        do
        {
            count++;
            i /= 10;
        } while (i >= 1);

        var buf = new StringBuf();
        count = ScoreDigits - count;
        for (ii in 0...count)
        {
            buf.add("0");
        }
        buf.add(score);
        scoreText.text = buf.toString();
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

        if (shakeTimer > 0)
        {
            shakeTimer -= HXP.elapsed;
            var dx = (HXP.random - 0.5) * MaxShakeOffset;
            var dy = (HXP.random - 0.5) * MaxShakeOffset;
            if (shakeTimer <= 0)
            {
                dx = 0;
                dy = 0;
            }
            x = dx;
            y = dy;
            HXP.camera.setTo(dx, dy);
        }
    }
}
