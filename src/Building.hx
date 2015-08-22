package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;

class Building extends Entity
{
    static inline var FloorPopulation = 5;
    static inline var FloorHealth = 6;

    var sprite:Spritemap;
    var health:Int;
    var healthBar:Image;
    var stage:Int;
    var population:Population;
    var hud:HUD;
    var healthBarScale:Float;

    public function new(x:Float=0, y:Float=0, population:Population, hud:HUD)
    {
        super(x, y);
        sprite = ImageFactory.createSpriteSheet("graphics/buildings.png", 48);
        addGraphic(sprite);
        sprite.originY = sprite.height - sprite.height / 4;

        health = FloorHealth;
        healthBar = ImageFactory.createRect(20, 2, 0x00FF00);
        healthBarScale = healthBar.scaleX;
        addGraphic(healthBar);

        stage = 0;
        setStage(stage);
        this.population = population;
        this.hud = hud;
    }

    function setStage(idx:Int)
    {
        sprite.frame = idx;
        if (stage < sprite.frameCount)
        {
            ImageFactory.setEntityHitboxTo(this, sprite);
            healthBar.visible = true;
        }
        else
        {
            setHitbox();
            healthBar.visible = false;
            sprite.visible = false;
        }
    }

    override public function update():Void
    {
        super.update();

        if (Input.mousePressed && collidePoint(x, y, Input.mouseX, Input.mouseY))
        {
            --health;
            if (health <= 0)
            {
                ++stage;
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
