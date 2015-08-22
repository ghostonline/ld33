import com.haxepunk.Scene;

class MainScene extends Scene
{
    var population:Population;

    public override function begin()
    {
        population = new Population(this);
        var building = new Building(100, 100, population);
        add(building);

        var police = new Police(-10, 200);
        add(police);
    }
}
