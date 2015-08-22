package ;
import com.haxepunk.HXP;

class Population
{

    var scene:MainScene;
    var civilians:Array<Civilian>;

    public function new(scene:MainScene)
    {
        this.scene = scene;
        civilians = new Array<Civilian>();
    }

    public function spawnCiviliansFromBuilding(x:Float, y:Float, count:Int)
    {
        for (ii in 0...count)
        {
            var angle = Math.PI * (ii / count) * 2;
            angle += (HXP.random - 0.5) * 0.1;
            var civ = new Civilian(x, y, angle);
            scene.add(civ);
            civilians.push(civ);
        }
    }

}
