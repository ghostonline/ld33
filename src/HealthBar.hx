package ;

import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Tilemap;
import com.haxepunk.HXP;

class HealthBar
{
    static inline var TopID = 0;
    static inline var EmptyTopID = 1;
    static inline var EmptyMiddleID = 2;
    static inline var GreenID = 3;
    static inline var YellowID = 4;
    static inline var RedID = 5;
    static inline var EmptyBottomID = 6;
    static inline var BottomID = 7;

    public var bar(default, null):Tilemap;
    var health:Int;
    var emptyIDs:Array<Int>;
    var startingHealth:Int;

    public function new(owner:Graphiclist, startingHealth)
    {
        this.startingHealth = startingHealth;
        bar = new Tilemap("graphics/healthbar.png", 14, startingHealth * 2 + 2 + 2, 14, 2);
        bar.scale = 2;
        bar.smooth = false;
        owner.add(bar);
        bar.x = HXP.width - 5 - bar.width * bar.scale;
        bar.y = 5;
        emptyIDs = new Array<Int>();
        emptyIDs.push(EmptyTopID);
        for (ii in 0...startingHealth - 2)
        {
            emptyIDs.push(EmptyMiddleID);
        }
        emptyIDs.push(EmptyBottomID);
        health = startingHealth;
        updateHealth();
    }

    public function removeHealth(points:Int)
    {
        health -= points;
        updateHealth();
    }

    public function reset()
    {
        health = startingHealth;
        updateHealth();
    }

    function updateHealth()
    {
        bar.setTile(0, 0, TopID);
        bar.setTile(0, bar.rows - 1, BottomID);
        var blipId = GreenID;
        if (health < startingHealth * 0.20)
        {
            blipId = RedID;
        }
        else if (health < startingHealth * 0.50)
        {
            blipId = YellowID;
        }

        for (ii in 0...startingHealth)
        {
            var healthIdx = startingHealth - ii - 1;
            var part = blipId;
            if (health <= healthIdx)
            {
                part = emptyIDs[ii];
            }
            bar.setTile(0, 1 + ii, part);
        }
    }
}