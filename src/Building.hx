package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Ease;
import com.haxepunk.HXP;

class Building extends Entity
{
    public static inline var CollisionType = "building";

    static inline var FloorPopulation = 5;
    static inline var FloorHealth = 6;
    static inline var PunchParticleCount = 4;
    static inline var CollapseParticleCount = 20;
    static inline var ShiverOffset = 2;
    static inline var ShiverDuration = 0.25;
    static inline var HealthBarOffset = -73;
    static inline var StageCountOffset = -85;

    var sprite:Spritemap;
    var health:Int;
    var healthBar:Spritemap;
    var stageCount:Spritemap;
    var stage:Int;
    var population:Population;
    var hud:HUD;
    var city:CityLayout;
    var cityTileX:Int;
    var cityTileY:Int;
    var smoke:Emitter;
    var emitterX:Float;
    var emitterY:Float;
    var shiverTimer:Float;

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

        health = FloorHealth;
        healthBar = ImageFactory.createSpriteSheet("graphics/buildingbar.png", 27);
        healthBar.y = HealthBarOffset;
        addGraphic(healthBar);

        stageCount = ImageFactory.createSpriteSheet("graphics/counter.png", 4);
        stageCount.y = StageCountOffset;
        addGraphic(stageCount);

        smoke = new Emitter("graphics/smoke.png", 30);
        addGraphic(smoke);
        var particle = smoke.newType("smoke", [0,1,2,3]);
        particle.setAlpha(1, 0);
        particle.setMotion(0, 20, 1, 360, 10, 0.5, Ease.cubeOut);
        particle.setGravity();

        stage = 0;
        setStage(stage);
        type = CollisionType;
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
            stageCount.visible = false;
            sprite.visible = false;
        }
        city.setBuildingType(cityTileX, cityTileY, idx);
    }

    override public function update():Void
    {
        super.update();

        if (MonsterAttack.smashBuilding && collidePoint(x, y, MonsterAttack.x, MonsterAttack.y))
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
                hud.shake();
                SoundPlayer.collapse();
            }
            else
            {
                shiverTimer = ShiverDuration;
                SoundPlayer.shake();
            }
            healthBar.frame = healthBar.frameCount - health - 1;
            stageCount.frame = stage;
            stageCount.visible = stage < 2;
            burstSmoke(PunchParticleCount);
        }

        layer = ZOrder.layerByY(y);

        if (shiverTimer > 0)
        {
            shiverTimer -= HXP.elapsed;
            var dx = (HXP.random - 0.5) * ShiverOffset;
            var dy = (HXP.random - 0.5) * ShiverOffset;
            if (shiverTimer <= 0)
            {
                dx = 0;
                dy = 0;
            }
            sprite.x = dx;
            sprite.y = dy;
            healthBar.x = dx;
            healthBar.y = HealthBarOffset + dy;
            stageCount.x = dx;
            stageCount.y = StageCountOffset + dy;
        }
    }

    function burstSmoke(count:Int)
    {
        for (ii in 0...count)
        {
            smoke.emitInRectangle("smoke", emitterX, emitterY, sprite.scaledWidth, sprite.scaledHeight);
        }
    }
}
