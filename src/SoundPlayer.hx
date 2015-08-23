package ;
import com.haxepunk.Sfx;

enum ID
{
    Collapse;
    CollapseB;
    Shake;
    ShakeB;
    Shoot;
    ShootB;
    Stomp;
}

class SoundPlayer
{
    var effects:Array<Sfx>;
    static var player:SoundPlayer;

    public function new()
    {
        effects = [
            new Sfx("audio/collapse.wav"),
            new Sfx("audio/collapse_b.wav"),
            new Sfx("audio/shake.wav"),
            new Sfx("audio/shake_b.wav"),
            new Sfx("audio/shoot.wav"),
            new Sfx("audio/shoot_b.wav"),
            new Sfx("audio/stomp.wav"),
        ];

        player = this;
    }

    function play(id:ID)
    {
        effects[id.getIndex()].play();
    }

    static public function stomp()
    {
        player.play(ID.Stomp);
    }

    static public function shoot()
    {
        player.play(ID.Shoot);
    }

    static public function shake()
    {
        player.play(ID.Shake);
    }

    static public function collapse()
    {
        player.play(ID.Collapse);
    }

}