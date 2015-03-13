module drpg.map;

import std.stdio, std.math, consoled;
import drpg.reference;
import drpg.entities.player, drpg.entities.entitymanager;
import drpg.tiles.tile, drpg.tiles.tilefloor, drpg.tiles.tileplank, drpg.tiles.tiledoor, drpg.tiles.tilewall;

/*
 * Working singleton!
 */

class Map{

	private static bool instantiated_;  // Thread local
	private __gshared Map instance_;
	private int width, height;
	private Tile[][] tiles;

	int getWidth(){
		return width;
	}

	int getHeight(){
		return height;
	}

	static Map map() {
		if (!instantiated_) {
			synchronized {
				if (instance_ is null) {
					instance_ = new Map;
				}
				instantiated_ = true;
			}
		}
		return instance_;
	}
	
	private this() {
		width = CHUNK_WIDTH*4;
		height = CHUNK_HEIGHT*4;
		
		//Sets the width and height of the map
		tiles.length = width;
		for(int y = 0; y < width; y++)
			tiles[y].length = height;
		
		//Thanks to jA_cOp from #d on freenode :)
		//This is 1.5~ times faster than "foreach(x; 0 .. width) foreach(y; 0 .. height) tiles[x][y] = new TileFloor();"
		foreach(ref column; tiles) //"ref column" becomes a reference to "Tile[][] tiles"
			foreach(ref tile; column) //ref tile" then also becomes a to "column"
				tile = new TileFloor(); //Sets all tiles on the map to be TileFloor();
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	void update(){
		
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	/**
	 * Prints the chunk the player currently is in
	*/
	void printChunk(){

		int xChunkStartPos = CHUNK_WIDTH * (EM.em.player.x / CHUNK_WIDTH);
		int yChunkStartPos = CHUNK_HEIGHT* (EM.em.player.y / CHUNK_HEIGHT);

		foreach(int y; 0 .. CHUNK_HEIGHT){
			foreach(int x; 0 .. CHUNK_WIDTH){
				setCursorPos(x, y);
				write(tiles[xChunkStartPos + x][yChunkStartPos + y].getTile());
			}
		}

		EM.em.printPlayer();
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

	/**
	* Should be:
	* getTile(x, y);
	*/
	Tile getTile(int x, int y){
		return tiles[x][y];
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	void addRoom(int x, int y, int w, int h){

		//If a room is places outside the world border, then shit goes down.
		try{
			/* Funktion that adds a room */
			//Loop that loops through all the soon-to-be room.
			for (int xPos = 0; xPos < w; xPos++){
				for (int yPos = 0; yPos < h; yPos++){

					//If the loop is on the edge (border) of the room, place a wall tile.
					if (yPos == 0 || yPos == h - 1 || xPos == 0 || xPos == w - 1){
						setTile(xPos + x, yPos + y, new TileWall());
					}
					else{
						setTile(xPos + x, yPos + y, new TileFloor()); //Adds empty tiles inside the room.
					}
				}
			}
		}catch(Throwable e){
			throwError(e, ErrorList.OUT_OF_BOUNDS);
		}
	}

	//A function to place tiles in a rectangle. I really wanted to name this function getREKT, but sadly I didn't :(
	void addREKT(int x, int y, int w, int h, Tile tiletype, Tile overlay){

		try
			for (int xPos = 0; xPos < w; xPos++)
				for (int yPos = 0; yPos < h; yPos++)		
					setTile(xPos + x, yPos + y, tiletype, overlay);

		catch(Throwable e)
			throwError(e, ErrorList.OUT_OF_BOUNDS);	
		
	}
}