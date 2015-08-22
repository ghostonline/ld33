package ;

import com.haxepunk.Entity;
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

    public static function setEntityHitboxTo(entity:Entity, image:Image)
    {
        entity.setHitbox(
            Math.floor(image.scaledWidth),
            Math.floor(image.scaledHeight),
            Math.floor(image.originX * image.scale),
            Math.floor(image.originY * image.scale)
            );
    }
}
