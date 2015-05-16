module drpg.room;

import consoled;
import std.stdio;
import std.random : uniform;
import drpg.misc;
import drpg.map;
import drpg.tile;
import drpg.entities.enemy;
import drpg.references.variables;

class Room{

	Map map;

	int left, top;
	int width, height;
	bool ordinary = true, force = false;
	private Tile[][] tiles;
	
	int right(){
		return left + width;
	}
	
	int bottom(){
		return top + height;
	}
	
	this(Map mapptr, int worldX, int worldY, int width, int height, bool forcePlacement = false, bool ordinary = true){
		map = mapptr;
		this.left = worldX;
		this.top = worldY;
		this.width  = width;
		this.height = height;
		this.ordinary = ordinary;
		this.force = forcePlacement;

		if(initTiles){
			setBase();
			if(ordinary){
				setDoor();
				spawnEnemy();
			}
			setRoomInWorld();
		}		
	}

	int roomXToWorldX(int roomX){
		return left + roomX;
	}
	
	int roomYToWorldY(int roomY){
		return top + roomY;
	}

	int worldXToRoomX(int worldX){
		return worldX - this.left;
	}
	
	int worldYToRoomY(int worldY){
		return worldY - this.top;
	}

	/**
	* Should be something like this:
	* setTile(x, y, new TileType());
	*/
	void setTile(int x, int y, Tile tile, Tile overlay = null){
		try{
			tiles[x][y] = tile;
			if(overlay !is null){
				tiles[x][y].setOverlay(overlay);
			}
		}catch(Throwable e){
			write(e.msg);
		}
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	bool initTiles(){
		tiles.length = width;
		for(int y = 0; y < width; y++)
			tiles[y].length = height;

		if(!force){
			//TODO: There is a possibillity in the future that room-check will throw and out of bounds exception, but meh...
			foreach(x; left - 1.. roomXToWorldX(width) + 1){
				foreach(y; top - 1 .. roomYToWorldY(height) + 1){
					if(cast(TileWall)map.getTile(Location(x, y)) !is null || cast(TileFloor)map.getTile(Location(x, y)) !is null) /* "Downcasting is usually a sign of bad design" -jA_C0p from #d TODO: ?*/{
						roomsFailedToPlace++;
						return false;
					}
				}
			}
		}

		return true;
	}

	void setBase(){
		/* Function that adds a room */
		//Loop that loops through all the soon-to-be room.
		foreach(x; 0 .. width){
			foreach(y; 0 .. height){
				//If the loop is on the edge (border) of the room, place a wall tile.
				if (y == 0 || y == height - 1 || x == 0 || x == width - 1){
					setTile(x, y, new TileWall());
				}
				else{
					setTile(x, y, new TileFloor()); //Adds empty tiles inside the room.
				}
			}
		}
	}

	void spawnEnemy(){
		map.game.em.addEntity(new Enemy(map.game.em, Location(uniform(left + 1, right - 1), uniform(top + 1, bottom - 1)), uniform(5,10), uniform(1,4)));
	}

	void setDoor(){
		switch(uniform(0,4)){
			case 0:
				setTile(0, uniform(1, height - 1), new TileDoor());
				break;
			case 1:
				setTile(uniform(1, width - 1), 0, new TileDoor());
				break;
			case 2:
				setTile(width - 1, uniform(1, height - 1), new TileDoor());
				break;
			case 3:
				setTile(uniform(1, width - 1), height - 1, new TileDoor());
				break;
			default:
				break;
		}
	}

	void setRoomInWorld(){
		foreach(x; 0 .. width){
			foreach(y; 0 .. height){
				map.setTile(Location(x + left, y + top), tiles[x][y].returnTile);
			}
		}
	}
}
