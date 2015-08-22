package ;

class Population
{

    var scene:MainScene;
    var civilians:Array<Civilian>;

    public function new(scene:MainScene)
    {
        this.scene = scene;
        civilians = new Array<Civilian>();
    }

    public function spawnCivilian(x:Float, y:Float)
    {
        var civ = new Civilian(x, y);
        scene.add(civ);
        civilians.push(civ);
    }

}
