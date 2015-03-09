module drpg.map;

import std.stdio, consoled;
import drpg.reference, drpg.entities.entitymanager;
import drpg.tiles.tile, drpg.tiles.tilefloor, drpg.tiles.tileplank, drpg.tiles.tiledoor, drpg.tiles.tilewall;

/*
 * Working singleton!
 */

class Map{

	//Singleton
	private static Map INSTANCE_MAP;
	/**
	* Returns the static instance of the map
	*/
	@property public Map i(){
		if(!INSTANCE_MAP) INSTANCE_MAP = new Map();
		return INSTANCE_MAP;
	}

	//private EntityManager em = new EntityManager();

	private int width, height;
	private Tile[][] tiles;

	this(){
		
		width = 50;
		height = 20;
		
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

		try{
			for (int xPos = 0; xPos < w; xPos++){
				for (int yPos = 0; yPos < h; yPos++){		
					setTile(xPos + x, yPos + y, tiletype, overlay);
				}
			}
		}catch(Throwable e){
			throwError(e, ErrorList.OUT_OF_BOUNDS);
		}
	}

	void printMap(){
		try{
			for(int y = 0; y < height; y++) { //The y is looped through before the x
				for(int x = 0; x < width; x++) { //If not the the world would be printed out the wrong way
					setCursorPos(x,y);
					write(tiles[x][y].getTile());
				}
			}
		}catch(Throwable e){
			throwError(e, ErrorList.OUT_OF_BOUNDS);
		}
	}
}