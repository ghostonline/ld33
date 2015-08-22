import com.haxepunk.Scene;

class MainScene extends Scene
{
    var civilians:Array<Civilian>;

    public override function begin()
    {
        civilians = new Array<Civilian>();
        for (ii in 0...25)
        {
            var civ = new Civilian(100, 100);
            civilians.push(civ);
            add(civ);
        }
    }
}
