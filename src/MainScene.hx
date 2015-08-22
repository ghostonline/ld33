import com.haxepunk.HXP;
import com.haxepunk.Scene;

class MainScene extends Scene
{
    static inline var PoliceSpawnInterval = 5;
    static inline var PoliceMinInterval = 1;
    static inline var PoliceIntervalDecrease = 0.333;

    var population:Population;
    var hud:HUD;
    var policeSpawnTimer:Float;
    var policeSpawnLanes:Array<Int>;

    public override function begin()
    {
        hud = new HUD();
        add(hud);

        population = new Population(this, hud);
        /*
        var building = new Building(100, 100, population, hud);
        add(building);
        var building = new Building(200, 100, population, hud);
        add(building);
        var building = new Building(100, 200, population, hud);
        add(building);
        var building = new Building(200, 200, population, hud);
        add(building);
        var building = new Building(100, 300, population, hud);
        add(building);
        var building = new Building(200, 300, population, hud);
        add(building);
        */

        policeSpawnTimer = PoliceSpawnInterval;
        policeSpawnLanes = [
            100,
            200,
            300,
            400,
        ];

        var layout = new CityLayout();
        add(layout);
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
                policeSpawnTimer = Math.max(PoliceSpawnInterval - hud.floorSmashed * PoliceIntervalDecrease, PoliceMinInterval);
            }
        }
    }
}
