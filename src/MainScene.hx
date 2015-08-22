import com.haxepunk.HXP;
import com.haxepunk.Scene;

class MainScene extends Scene
{
    var population:Population;
    var hud:HUD;

    public override function begin()
    {
        hud = new HUD();
        add(hud);

        population = new Population(this);
        var building = new Building(100, 100, population);
        add(building);

        var police = new Police(-10, 200, hud);
        add(police);
        var police = new Police(HXP.width + 10, 300, hud);
        add(police);
    }
}
