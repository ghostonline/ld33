package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;

class Building extends Entity
{
    static inline var FloorPopulation = 10;
    public static inline var CollisionType = "building";

    var stages:Array<Image>;
    var stage:Int;
    var population:Population;

    public function new(x:Float=0, y:Float=0, population:Population)
    {
        super(x, y);
        stages = [
            ImageFactory.createRect(25, 60, 0xA52A2A),
            ImageFactory.createRect(25, 45, 0xA52A2A),
            ImageFactory.createRect(25, 30, 0xA52A2A),
            ImageFactory.createRect(25, 15, 0x808080),
        ];
        var base = stages.pop();
        for (img in stages)
        {
            img.originY = img.height - base.originY;
        }
        stages.push(base);
        stage = 0;
        setStage(stage);
        type = CollisionType;
        this.population = population;
    }

    function setStage(idx:Int)
    {
        var img = stages[idx];
        graphic = img;
        if (stage < stages.length - 1)
        {
            ImageFactory.setEntityHitboxTo(this, img);
        }
        else
        {
            setHitbox();
        }
    }

    override public function update():Void
    {
        super.update();

        if (Input.mousePressed && collidePoint(x, y, Input.mouseX, Input.mouseY))
        {
            stage = (stage + 1) % stages.length;
            setStage(stage);
            population.spawnCiviliansFromBuilding(x, y + 35, FloorPopulation);
        }

        layer = ZOrder.layerByY(y);
    }
}
