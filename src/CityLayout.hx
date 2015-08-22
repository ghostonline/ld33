package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Tilemap;
import com.haxepunk.masks.Grid;

class CityLayout extends Entity
{

    public function new()
    {
        super(0, 0);
        var data = [
            [22,22,22,22,22,22,21,22,22,22,22,22,],
            [22,9,10,11,22,22,21,9,10,11,22,22,],
            [22,29,30,31,22,22,21,29,30,31,22,22,],
            [22,49,50,51,22,22,21,49,50,51,22,22,],
            [22,69,70,71,22,22,21,69,70,71,22,22,],
            [2,2,2,3,2,2,83,2,3,2,2,2,],
            [22,22,22,21,22,9,10,11,21,22,22,22,],
            [2,2,2,83,5,29,30,31,21,22,22,22,],
            [22,9,10,11,21,49,50,51,21,22,22,22,],
            [22,29,30,31,21,69,70,71,21,22,22,22,],
            [22,49,50,51,41,2,2,2,83,2,2,2,],
            [22,69,70,71,21,9,10,11,9,10,11,22,],
            [2,2,2,2,45,29,30,31,29,30,31,22,],
            [22,22,22,22,21,49,50,51,49,50,51,22,],
            [22,22,22,22,21,69,70,71,69,70,71,22,],
            [22,22,22,22,81,2,3,2,2,2,2,2,],
            [22,22,22,22,22,22,21,22,22,22,22,22],
        ];
        for (row in 0...data.length)
        {
            for (col in 0...data[row].length)
            {
                data[row][col] = data[row][col] - 1;
            }
        }

        var layout = new Tilemap("graphics/tiles.png", 160 + 16 + 16, 240 + 16 + 16, 16, 16);
        layout.loadFrom2DArray(data);
        layout.scale = 2;
        layout.smooth = false;
        layout.x = -16 * layout.scale;
        layout.y = -16 * layout.scale;
        graphic = layout;

        var collisionData = [
            [0,0,0,0,0,0,0,0,0,0,0,0,],
            [0,0,0,0,0,0,0,0,0,0,0,0,],
            [0,0,0,0,0,0,0,0,0,0,0,0,],
            [0,1,1,1,0,0,0,1,1,1,0,0,],
            [0,1,1,1,0,0,0,1,1,1,0,0,],
            [0,0,0,0,0,0,0,0,0,0,0,0,],
            [0,0,0,0,0,0,0,0,0,0,0,0,],
            [0,0,0,0,0,0,0,0,0,0,0,0,],
            [0,0,0,0,0,1,1,1,0,0,0,0,],
            [0,0,0,0,0,1,1,1,0,0,0,0,],
            [0,1,1,1,0,0,0,0,0,0,0,0,],
            [0,1,1,1,0,0,0,0,0,0,0,0,],
            [0,0,0,0,0,0,0,0,0,0,0,0,],
            [0,0,0,0,0,1,1,1,1,1,1,0,],
            [0,0,0,0,0,1,1,1,1,1,1,0,],
            [0,0,0,0,0,0,0,0,0,0,0,0,],
            [0,0,0,0,0,0,0,0,0,0,0,0,],
        ];

        var collider = new Grid(
            Math.floor(layout.width * layout.scale),
            Math.floor(layout.height * layout.scale),
            Math.floor(layout.tileWidth * layout.scale),
            Math.floor(layout.tileHeight * layout.scale),
            Math.floor(layout.x),
            Math.floor(layout.y)
            );
        collider.loadFrom2DArray(collisionData);
        mask = collider;
        layer = ZOrder.Roads;
    }

}