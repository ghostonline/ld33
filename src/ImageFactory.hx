package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;

class ImageFactory
{

    public static function createRect(width:Int, height:Int, color:Int)
    {
        var img = Image.createRect(width, height, color);
        img.scale = 2;
        img.centerOrigin();
        return img;
    }

    public static function createSpriteSheet(file:String, frameWidth:Int=0, frameHeight:Int=0)
    {
        var img = new Spritemap(file, frameWidth, frameHeight);
        img.scale = 2;
        img.smooth = false;
        img.centerOrigin();
        return img;
    }

    public static function createImage(file:String)
    {
        var img = new Image(file);
        img.scale = 2;
        img.smooth = false;
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
