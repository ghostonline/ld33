package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;

class Building extends Entity
{
    static inline var FloorPopulation = 10;
    static inline var FloorHealth = 6;
    public static inline var CollisionType = "building";

    var stages:Array<Image>;
    var health:Int;
    var healthBar:Image;
    var stage:Int;
    var population:Population;
    var hud:HUD;
    var healthBarScale:Float;

    public function new(x:Float=0, y:Float=0, population:Population, hud:HUD)
    {
        super(x, y);
        stages = [
            ImageFactory.createRect(25, 30, 0xA52A2A),
            ImageFactory.createRect(25, 25, 0xA52A2A),
            ImageFactory.createRect(25, 20, 0xA52A2A),
            ImageFactory.createRect(25, 15, 0x808080),
        ];
        for (img in stages) { addGraphic(img); img.visible = false; }
        var base = stages.pop();
        for (img in stages)
        {
            img.originY = img.height - base.originY;
        }
        stages.push(base);

        health = FloorHealth;
        healthBar = ImageFactory.createRect(20, 2, 0x00FF00);
        healthBarScale = healthBar.scaleX;
        addGraphic(healthBar);

        stage = 0;
        setStage(stage);
        type = CollisionType;
        this.population = population;
        this.hud = hud;
    }

    function setStage(idx:Int)
    {
        var img = stages[idx];
        if (stage < stages.length - 1)
        {
            ImageFactory.setEntityHitboxTo(this, img);
            healthBar.visible = true;
        }
        else
        {
            setHitbox();
            healthBar.visible = false;
        }

        for (stageIdx in 0...stages.length) { stages[stageIdx].visible = stageIdx == idx; }
    }

    override public function update():Void
    {
        super.update();

        if (Input.mousePressed && collidePoint(x, y, Input.mouseX, Input.mouseY))
        {
            --health;
            if (health <= 0)
            {
                stage = (stage + 1) % stages.length;
                setStage(stage);
                population.spawnCiviliansFromBuilding(x, y + 35, FloorPopulation);
                hud.smashFloor();
                health = FloorHealth;
            }
            healthBar.scaleX = healthBarScale * health / FloorHealth;
            hud.shake();
        }

        layer = ZOrder.layerByY(y);
    }
}
