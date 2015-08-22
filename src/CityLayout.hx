package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Tilemap;
import com.haxepunk.masks.Grid;

typedef BuildingTile = { x:Int, y:Int };

class CityLayout extends Entity
{
    public static inline var CollisionType = "building";
    static inline var BuildingTileID = 49;

    var layout:Tilemap;
    var buildings:Array<BuildingTile>;

    public function new()
    {
        super(0, 0);
        buildings = new Array<BuildingTile>();
        var data = [
            [22,22,22,22,22,22,21,22,22,22,22,22,],
            [22,22,22,22,22,22,21,22,22,22,22,22,],
            [22,22,22,22,22,22,21,22,22,22,22,22,],
            [22,49,50,51,22,22,21,49,50,51,22,22,],
            [22,69,70,71,22,22,21,69,70,71,22,22,],
            [2,2,2,3,2,2,83,2,3,2,2,2,],
            [22,22,22,21,22,22,22,22,21,22,22,22,],
            [2,2,2,83,5,22,22,22,21,22,22,22,],
            [22,22,22,22,21,49,50,51,21,22,22,22,],
            [22,22,22,22,21,69,70,71,21,22,22,22,],
            [22,49,50,51,41,2,2,2,83,2,2,2,],
            [22,69,70,71,21,22,22,22,22,22,22,22,],
            [2,2,2,2,45,22,22,22,22,22,22,22,],
            [22,22,22,22,21,49,50,51,49,50,51,22,],
            [22,22,22,22,21,69,70,71,69,70,71,22,],
            [22,22,22,22,81,2,3,2,2,2,2,2,],
            [22,22,22,22,22,22,21,22,22,22,22,22,],
        ];
        for (row in 0...data.length)
        {
            for (col in 0...data[row].length)
            {
                if (data[row][col] == BuildingTileID)
                {
                    buildings.push( { x:col, y:row } );
                }
                data[row][col] = data[row][col] - 1;
            }
        }

        layout = new Tilemap("graphics/tiles.png", 160 + 16 + 16, 240 + 16 + 16, 16, 16);
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
        type = CollisionType;
    }

    public function setBuildingType(tileX:Int, tileY:Int, fundamentType:Int)
    {
        var data = [
            [49, 50, 51],
            [69, 70, 71],
        ];
        var typeOffset = 3 * fundamentType;

        for (row in 0...data.length)
        {
            for (col in 0...data[row].length)
            {
                var x = tileX + col;
                var y = tileY + row;
                var tileId = data[row][col] + typeOffset - 1;
                layout.setTile(x, y, tileId);
            }
        }
    }

    public function generateBuildings(scene:MainScene, population:Population, hud:HUD)
    {
        for (pos in buildings)
        {
            var x = (pos.x + 1.5) * layout.tileWidth * layout.scale + layout.x;
            var y = (pos.y + 1) * layout.tileHeight * layout.scale + layout.y;
            var building = new Building(x, y, population, hud, this, pos.x, pos.y);
            scene.add(building);
        }
    }
}