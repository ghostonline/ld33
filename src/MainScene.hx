import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;

class MainScene extends Scene
{
    static inline var PoliceSpawnInterval = 5;
    static inline var PoliceMinInterval = 1;
    static inline var PoliceIntervalDecrease = 0.333;

    var tutorial:Tutorial;
    var population:Population;
    var hud:HUD;
    var policeSpawnTimer:Float;
    var policeSpawnLanes:Array<Int>;

    public override function begin()
    {
        tutorial = new Tutorial();
        add(tutorial);

        hud = new HUD();
        add(hud);

        population = new Population(this, hud);

        policeSpawnTimer = PoliceSpawnInterval;
        policeSpawnLanes = [
            160,
            165,
            170,
            455,
            366,
            467,
        ];

        var layout = new CityLayout();
        layout.generateBuildings(this, population, hud);
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

        if (tutorial != null)
        {
            if (Input.mousePressed)
            {
                remove(tutorial);
                tutorial = null;
            }

            return;
        }

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
