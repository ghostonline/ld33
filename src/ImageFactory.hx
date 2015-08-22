package ;

import com.haxepunk.graphics.Image;

class ImageFactory
{

    public static function createRect(width:Int, height:Int, color:Int)
    {
        var img = Image.createRect(width, height, color);
        img.scale = 2;
        img.centerOrigin();
        return img;
    }

}
