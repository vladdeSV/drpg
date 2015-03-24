module drpg.room;

import std.stdio, drpg.reference, consoled;
import drpg.tile;

class Room{
	int left, top;
	int width, height;
	private Tile[][] tiles;
	
	int right(){
		return left + width;
	}
	
	int bottom(){
		return top + height;
	}
	
	this(int worldX, int worldY, int width, int height){
		this.left = worldX;
		this.top = worldY;
		this.width  = width;
		this.height = height;

		initTiles;

		setWalls;

		setRoomInWorld;
		
	}

	/**
	 * First int in array is x position, second is y position.
	 * Ex.
	 * int worldPosX = roomToWorldPosition(3, 6)[0];
	 * int worldPosY = roomToWorldPosition(3, 6)[1];
	*/
	int[2] roomToWorldPosition(int roomX, int roomY){
		int[2] worldPos = [left + roomX, top + roomY];
		return worldPos;
	}
	
	int[2] worldToRoomPosition(int worldX, int worldY){
		int[2] roomPos = [worldX - this.left, worldY - this.top];
		return roomPos;
	}
	
	/**
	* Should be something like this:
	* setTile(x, y, new TileType());
	*/
	void setTile(int x, int y, Tile tile, Tile overlay = null){
		try{
			tiles[x][y] = tile;
			if(overlay !is null){
				tiles[x][y].setOverlay(new TileDoor());
			}
		}catch(Throwable e){
			throwError(e, ErrorList.OUT_OF_BOUNDS);
		}
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	void setWalls(){
		//If a room is places outside the world border, then shit goes down.
		try{
			/* Function that adds a room */
			//Loop that loops through all the soon-to-be room.
			foreach(xPos;0 .. width){
				foreach(yPos;0 .. height){
					//If the loop is on the edge (border) of the room, place a wall tile.
					if (yPos == 0 || yPos == height - 1 || xPos == 0 || xPos == width - 1){
						setTile(xPos, yPos, new TileWall());
					}
					else{
						setTile(xPos, yPos, new TileFloor()); //Adds empty tiles inside the room.
					}
				}
			}
			
			//TODO: Put in new funciton!
			/*
			int side = uniform(0,4);
			if(side == 0)
				_map.setTile(worldX, worldY+height/2, new TileDoor());
			if(side == 1)
				_map.setTile(worldX+width/2, worldY, new TileDoor());
			if(side == 2)
				_map.setTile(worldX+width-1, worldY+height/2, new TileDoor());
			if(side == 3)
				_map.setTile(worldX+width/2, worldY+height-1, new TileDoor());
			*/
			
		}catch(Throwable e){
			throwError(e, ErrorList.OUT_OF_BOUNDS);
		}
	}

	void initTiles(){
		tiles.length = width;
		for(int y = 0; y < width; y++)
			tiles[y].length = height;

	}

	void setRoomInWorld(){
		foreach(x; 0 .. width){
			foreach(y; 0 .. height){
				if(x == 0 || x == width - 1 || y == 0 || y == height - 1)
					_map.setTile(roomToWorldPosition(x,y)[0], roomToWorldPosition(x,y)[1], new TileWall());
				else
					_map.setTile(roomToWorldPosition(x,y)[0], roomToWorldPosition(x,y)[1], new TileFloor());
			}
		}
	}
	
}