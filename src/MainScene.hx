import com.haxepunk.HXP;
import com.haxepunk.Scene;

class MainScene extends Scene
{
    static inline var PoliceStartInterval = 5;

    var population:Population;
    var hud:HUD;
    var policeSpawnTimer:Float;
    var policeSpawnInterval:Float;
    var policeSpawnLanes:Array<Int>;

    public override function begin()
    {
        hud = new HUD();
        add(hud);

        population = new Population(this, hud);
        var building = new Building(100, 100, population, hud);
        add(building);

        policeSpawnTimer = policeSpawnInterval = PoliceStartInterval;
        policeSpawnLanes = [
            100,
            200,
            300,
            400,
        ];
    }

    function spawnCop()
    {
        var x = HXP.rand(2) == 0 ? -10 : HXP.width + 10;
        var y = HXP.choose(policeSpawnLanes);
        var police = new Police(x, y, hud);
        add(police);
    }

    override public function update()
    {
        super.update();
        if (policeSpawnTimer > 0)
        {
            policeSpawnTimer -= HXP.elapsed;
            if (policeSpawnTimer <= 0)
            {
                spawnCop();
                policeSpawnTimer = policeSpawnInterval;
            }
        }
    }
}
