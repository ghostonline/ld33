package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;

class HUD extends Entity
{
    static inline var BulletFlashTime = 0.25;
    static inline var StartingHealth = 15;
    static inline var ScoreDigits = 10;
    static inline var HumanScore = 100;
    static inline var FloorScore = 500;

    var flash:Image;
    var flashTimer:Float;
    var flashTotal:Float;
    var healthBar:Array<Image>;
    var scoreText:Text;
    var score:Int;

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
            bar.y = HXP.height - 20 - barSpacing * ii;
            addGraphic(bar);
            healthBar.push(bar);
        }

        score = 0;
        scoreText = new Text();
        scoreText.x = 20;
        scoreText.y = 20;
        addGraphic(scoreText);
        updateScore();
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

    public function smashFloor()
    {
        score += FloorScore;
        updateScore();
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
    }
}
