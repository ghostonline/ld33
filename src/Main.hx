import com.haxepunk.Engine;
import com.haxepunk.HXP;

class Main extends Engine
{
    var soundPlayer:SoundPlayer;

    override public function init()
    {
#if debug
        HXP.console.enable();
#end
        soundPlayer = new SoundPlayer();
        HXP.scene = new MainScene();
    }

    public static function main() { new Main(); }

}
