import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;

class MainScene extends Scene
{
    static inline var PoliceSpawnInterval = 5;
    static inline var PoliceMinInterval = 1;
    static inline var PoliceIntervalDecrease = 0.333;

    var tutorial:Tutorial;
    var endgame:EndGame;
    var population:Population;
    var hud:HUD;
    var policeSpawnTimer:Float;
    var policeSpawnLanes:Array<Int>;
    var startTutorial:Bool;

    public function new(tutorial:Bool = true)
    {
        super();
        startTutorial = tutorial;
        endgame = null;
    }

    public override function begin()
    {
        if (startTutorial)
        {
            tutorial = new Tutorial();
            add(tutorial);
        }

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
        var buildingCount = layout.generateBuildings(this, population, hud);
        add(layout);
        hud.setTotalFloorCount(buildingCount * 3);
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

        MonsterAttack.reset();

        if (tutorial != null)
        {
            if (Input.mousePressed)
            {
                remove(tutorial);
                tutorial = null;
            }
            return;
        }

        if (endgame != null)
        {
            return;
        }

        if (hud.killCops())
        {
            endgame = new EndGame(true);
            add(endgame);
            return;
        }
        else if (!hud.isAlive())
        {
            endgame = new EndGame(false);
            add(endgame);
            return;
        }

        MonsterAttack.update(hud, this);

        if (policeSpawnTimer > 0 && !hud.killCops())
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
