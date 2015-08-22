package ;

class ZOrder
{
    public static inline var HUD = 1;

    public static function layerByY(y:Float)
    {
        return Math.floor(y);
    }
}
