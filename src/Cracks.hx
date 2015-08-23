package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;

typedef Point = { x:Int, y:Int };

class Cracks extends Entity
{
    static inline var MaxCrackCount = 50;

    var centers:Array<Point>;
    var pool:Array<Spritemap>;
    var idx:Int;

    public function new()
    {
        super();
        layer = ZOrder.Cracks;
        centers = [
            {x:7, y:4},
            {x:8, y:5},
            {x:3, y:4},
            {x:4, y:2},
        ];
        pool = new Array<Spritemap>();
        for (ii in 0...MaxCrackCount)
        {
            var img = ImageFactory.createSpriteSheet("graphics/cracks.png", 0, 8);
            img.originX = 0;
            img.originY = 0;
            pool.push(img);
            img.visible = false;
            addGraphic(img);
        }
        idx = 0;
    }

    public function spawn(x:Int, y:Int)
    {
        var variant = HXP.rand(centers.length);
        idx = (idx + 1) % pool.length;
        var img = pool[idx];
        img.x = x - centers[variant].x * img.scale;
        img.y = y - centers[variant].y * img.scale;
        img.frame = variant;
        img.alpha = HXP.random * 0.5 + 0.25;
        img.visible = true;
    }

}