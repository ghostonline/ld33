package ;

class ZOrder
{
    static inline var Entities = 480;
    public static inline var Roads = 481;
    public static inline var HUD = 0;
    public static inline var Tutorial = -1;
    public static inline var EndGame = -1;

    public static function layerByY(y:Float)
    {
        return Entities - Math.floor(y);
    }
}
