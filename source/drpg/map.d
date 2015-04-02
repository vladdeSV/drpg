module drpg.map;

import std.stdio, std.math, std.random, consoled;
import drpg.reference;
import drpg.entities.player, drpg.entities.entitymanager;
import drpg.tile, drpg.room;

/*
 * Working singleton!
 */

class Map{
	private static bool instantiated_;  // Thread local
	private __gshared Map instance_;
	private int width, height;
	private Tile[][] tiles;
	private Room[] rooms;

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
	
	private this() {}

	void init(){

		width = WORLD_WIDTH;
		height = WORLD_HEIGHT;
		
		//Sets the width and height of the map
		tiles.length = width;
		for(int y = 0; y < width; y++)
			tiles[y].length = height;
		
		//Thanks to jA_cOp from #d on freenode :)
		//This is 1.5~ times faster than "foreach(x; 0 .. width) foreach(y; 0 .. height) tiles[x][y] = new TileFloor();"
		foreach(ref column; tiles) //"ref column" becomes a reference to "Tile[][] tiles"
			foreach(ref tile; column) //ref tile" then also becomes a to "column"
				tile = new TileFloor(); //Sets all tiles on the map to be TileFloor();

		addFlowersToWorld;
		addRoomsToWorld;
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	void update(){
		
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	/**
	 * Prints the chunk the player currently is in
	*/
	void printChunk(){

		int xChunkStartPos = CHUNK_WIDTH * (_em.player.x / CHUNK_WIDTH);
		int yChunkStartPos = CHUNK_HEIGHT* (_em.player.y / CHUNK_HEIGHT);

		//FIXME This function will crash if the map width/height is not a multiple of CHUNK_WIDTH/CHUNK_HEIGHT
		foreach(int y; 0 .. CHUNK_HEIGHT){
			foreach(int x; 0 .. CHUNK_WIDTH){
				setCursorPos(x, y);
				write(tiles[xChunkStartPos + x][yChunkStartPos + y].getTile());
			}
			write('+');
		}
		setCursorPos(0, CHUNK_HEIGHT);
		foreach(a; 0 .. CHUNK_WIDTH + 1)
			write('+');


		_em.printPlayer();
	}

	void addFlowersToWorld(){
		foreach(x; 0 .. WORLD_WIDTH)
			foreach(y; 0 .. WORLD_HEIGHT)
				if(uniform(0, 5) == 0)
					setTile(x, y, new TileFlower);
	}

	void addRoomsToWorld(){

		int w,h,wx,wy;

		foreach(i; 0 .. maxNumberOfRooms){
			w = uniform(5, maxRoomWidth);
			h = uniform(5, maxRoomHeight);
			
			wx = uniform(3, width - w); //"- w" is to make sure the room never goes out if bound
			wy = uniform(3, height- h);

			rooms ~= new Room(wx, wy, w, h);
		}
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	/**
	* Should be:
	* getTile(x, y);
	*/
	Tile getTile(int x, int y){
		return tiles[x][y];
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
			throwError(e, ErrorList.OUT_OF_BOUNDS);
		}
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	//A function to place tiles in a rectangle. I really wanted to name this function getREKT, but sadly I didn't :(
	void addRect(int x, int y, int w, int h, Tile tiletype, Tile overlay = null){

		try
			foreach(xPos;0 .. w)
				foreach(yPos;0 .. h)
					setTile(xPos + x, yPos + y, tiletype, overlay);

		catch(Throwable e)
			throwError(e, ErrorList.OUT_OF_BOUNDS);	
		
	}
}