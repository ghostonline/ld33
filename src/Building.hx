package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Ease;
import com.haxepunk.utils.Input;

class Building extends Entity
{
    static inline var FloorPopulation = 5;
    static inline var FloorHealth = 6;
    static inline var PunchParticleCount = 4;
    static inline var CollapseParticleCount = 20;

    var sprite:Spritemap;
    var health:Int;
    var healthBar:Image;
    var stage:Int;
    var population:Population;
    var hud:HUD;
    var healthBarScale:Float;
    var city:CityLayout;
    var cityTileX:Int;
    var cityTileY:Int;
    var smoke:Emitter;
    var emitterX:Float;
    var emitterY:Float;

    public function new(x:Float=0, y:Float=0, population:Population, hud:HUD, city:CityLayout, cityTileX:Int, cityTileY:Int)
    {
        super(x, y);
        this.population = population;
        this.hud = hud;
        this.city = city;
        this.cityTileX = cityTileX;
        this.cityTileY = cityTileY;

        sprite = ImageFactory.createSpriteSheet("graphics/buildings.png", 48);
        addGraphic(sprite);
        sprite.originY = sprite.height - sprite.height / 4;
        emitterX = -sprite.originX * sprite.scale;
        emitterY = -sprite.originY * sprite.scale;

        smoke = new Emitter("graphics/smoke.png", 30);
        addGraphic(smoke);
        var particle = smoke.newType("smoke", [0,1,2,3]);
        particle.setAlpha(1, 0);
        particle.setMotion(0, 20, 1, 360, 10, 0.5, Ease.cubeOut);
        particle.setGravity();

        health = FloorHealth;
        healthBar = ImageFactory.createRect(20, 2, 0x00FF00);
        healthBarScale = healthBar.scaleX;
        addGraphic(healthBar);

        stage = 0;
        setStage(stage);
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
        city.setBuildingType(cityTileX, cityTileY, idx);
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
                population.spawnCiviliansFromBuilding(x, y + 48, FloorPopulation);
                hud.smashFloor();
                health = FloorHealth;
                burstSmoke(CollapseParticleCount);
            }
            healthBar.scaleX = healthBarScale * health / FloorHealth;
            hud.shake();
            burstSmoke(PunchParticleCount);
        }

        layer = ZOrder.layerByY(y);
    }

    function burstSmoke(count:Int)
    {
        for (ii in 0...count)
        {
            smoke.emitInRectangle("smoke", emitterX, emitterY, sprite.scaledWidth, sprite.scaledHeight);
        }
    }
}
