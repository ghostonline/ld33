package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;

class Tutorial extends Entity
{
    static inline var HealthTickTimout = 0.5;

    var background:Image;
    var continueText:Text;
    var story:Text;
    var health:Int;
    var maxHealth:Int;
    var healthBar:HealthBar;
    var healthTickTimer:Float;

    public function new()
    {
        super(0, 0);
        background = Image.createRect(HXP.width - 50, HXP.height - 50, 0x333333, 0.75);
        background.x = 25;
        background.y = 25;
        addGraphic(background);

        story = new Text("It was a quiet day in Neo Tokyo Metropolis. Lets change that by going on a good old fashioned stomp through town!", 0, 0, background.width - 50, 0, { wordWrap:true } );
        story.x = background.x + background.width / 2 - story.textWidth / 2;
        story.y = background.y + 10;
        addGraphic(story);

        continueText = new Text("Click here to start your rampage", 0,0, background.width - 100, 0, {wordWrap:true, align:flash.text.TextFormatAlign.CENTER});
        continueText.x = background.x + background.width / 2 - continueText.textWidth / 2;
        continueText.y = background.y + background.height - 40;
        addGraphic(continueText);

        var lineY = background.y + 150;
        var iconX = background.x + 50;
        var labelX = background.x + 100;
        var padding = 60;
        {
            var icon = ImageFactory.createSpriteSheet("graphics/buildingbar.png", 27);
            icon.add("loop", [0, 1, 2, 3, 4, 5, 6], 2, true);
            icon.play("loop");
            icon.x = iconX;
            icon.y = lineY;
            addGraphic(icon);
            var legend = new Text("Destroy buildings for points", 0, 0, background.width - 100, 0, { wordWrap:true } );
            legend.x = labelX;
            legend.y = lineY - Math.floor(legend.textHeight / 2);
            addGraphic(legend);
        }
        lineY += padding;
        {
            var icon = ImageFactory.createSpriteSheet("graphics/civilians.png", 12, 8);
            icon.add("loop", [0, 1, 0, 1, 0, 1, 4, 5, 4, 5, 4, 5, 8, 9, 8, 9, 8, 9, 12, 13, 12, 13, 12, 13], 6, true);
            icon.play("loop");
            icon.x = iconX;
            icon.y = lineY;
            addGraphic(icon);
            var legend = new Text("Smash civilians for extra points", 0, 0, background.width - 100, 0, { wordWrap:true } );
            legend.x = labelX;
            legend.y = lineY - Math.floor(legend.textHeight / 2);
            addGraphic(legend);
        }
        lineY += padding;
        {
            var icon = ImageFactory.createSpriteSheet("graphics/police.png", 7);
            icon.add("loop", [0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 2, 2, 2, 2, 2, 2, 2, 3, 2, 3, 2], 6, true);
            icon.play("loop");
            icon.x = iconX;
            icon.y = lineY;
            addGraphic(icon);
            var legend = new Text("Disable cops before they can hurt you", 0, 0, background.width - 100, 0, { wordWrap:true } );
            legend.x = labelX;
            legend.y = lineY - Math.floor(legend.textHeight / 2);
            addGraphic(legend);
        }
        lineY += padding;
        {
            health = maxHealth = 10;
            healthTickTimer = HealthTickTimout;
            healthBar = new HealthBar(cast(graphic, Graphiclist), maxHealth);
            healthBar.bar.x = iconX - healthBar.bar.width * healthBar.bar.scale / 2;
            healthBar.bar.y = lineY - healthBar.bar.height * healthBar.bar.scale / 2;
            var legend = new Text("The game ends when you run out of health", 0, 0, background.width - 100, 0, { wordWrap:true } );
            legend.x = labelX;
            legend.y = lineY - Math.floor(legend.textHeight / 2);
            addGraphic(legend);
        }


        layer = ZOrder.Tutorial;
    }

    override public function update():Void
    {
        super.update();
        healthTickTimer -= HXP.elapsed;
        if (healthTickTimer < 0)
        {
            healthTickTimer += HealthTickTimout;
            --health;
            if (health < 0)
            {
                healthBar.reset();
                health = maxHealth;
            }
            else
            {
                healthBar.removeHealth(1);
            }
        }
    }
}