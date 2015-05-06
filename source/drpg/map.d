module drpg.map;

import std.stdio, std.math, std.random, std.conv, consoled;
import drpg.game;
import drpg.misc;
import drpg.reference;
import drpg.entities.player, drpg.entities.entitymanager;
import drpg.tile, drpg.room;

/*
 * Working singleton!
 */

class Map{

	Game* game;

	private int width, height;
	private Tile[][] tiles;
	private Room[] rooms;

	@property{
		int getWidth(){ return width; }
		int getHeight(){ return height; }
	}

	this(Game* gameptr)
	{
		game = gameptr;
		width = WORLD_WIDTH;
		height = WORLD_HEIGHT;

		centerStringOnEmptyScreen("Generating map");

		//Sets the width and height of the map
		tiles.length = width;
		for(int y = 0; y < width; y++)
			tiles[y].length = height;
		
		//Thanks to jA_cOp from #d (freenode) :)
		//This is 1.5~ times faster than "foreach(x; 0 .. width) foreach(y; 0 .. height) tiles[x][y] = new TileFloor();"
		foreach(ref column; tiles) //"ref column" becomes a reference to "Tile[][] tiles"
			foreach(ref tile; column) //"ref tile" then becomes a reference to "column"
				tile = new TileGround(); //Sets all tiles on the map to be TileFloor();

		addStructures();
	}

	void addStructures(){

		addFlowersToWorld();
//		addTreesToWorld();
//		addRocksToWorld();
		addRoomsToWorld();
		
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	void update(){
		
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	/**
	 * Prints the chunk the player currently is in
	*/
	void printChunk(){

		int xChunkStartPos = CHUNK_WIDTH * (game.em.player.position.x / CHUNK_WIDTH);
		int yChunkStartPos = CHUNK_HEIGHT* (game.em.player.position.y / CHUNK_HEIGHT);

		//FIXME This function will crash if the map width/height is not a multiple of CHUNK_WIDTH/CHUNK_HEIGHT
		foreach(int y; 0 .. CHUNK_HEIGHT){
			foreach(int x; 0 .. CHUNK_WIDTH){
				setCursorPos(x, y);
				printTile(Location(xChunkStartPos + x, yChunkStartPos + y)); //TODO: Change to writeln(), faster?
			}
			write('+');
		}
		setCursorPos(0, CHUNK_HEIGHT);
		foreach(a; 0 .. CHUNK_WIDTH + 1)
			write('+');
			
		game.em.printAllEntities();
		//game.em.update();
	}

	//A function to place tiles in a rectangle. I really wanted to name this function getREKT, but sadly I didn't :(
	void addRect(int x, int y, int w, int h, Tile tiletype, Tile overlay = null){

		try
			foreach(xPos;0 .. w)
				foreach(yPos;0 .. h)
					setTile(Location(xPos + x, yPos + y), tiletype, overlay);
		
		catch(Throwable e)
			write(e.msg);
		
	}

	/**
	* Return the tile at specified x and y
	*/
	Tile getTile(Location loc){
		return tiles[loc.x][loc.y]; //FIXME Range violation. Map may not be inited
	}

	void printTile(Location location){
		setCursorPos(location.x % CHUNK_WIDTH, location.y % CHUNK_HEIGHT);
		write(getTile(location).getSprite);
		stdout.flush();
	}

	/**
	* Returns true if the tile at x and y is sold
	*/
	bool isTileSolidAt(Location loc){
		return tiles[loc.x][loc.y].isSolid;
	}
	
	/**
	* Should be something like this:
	* setTile(x, y, new TileType());
	*/
	void setTile(Location loc, Tile tile, Tile overlay = null){
		try{
			tiles[loc.x][loc.y] = tile;
			if(overlay !is null){
				tiles[loc.x][loc.y].setOverlay(overlay);
			}
		}catch(Throwable e){
			write(e.msg);
		}
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	void addFlowersToWorld(){
		int CHANCE_OF_FLOWER_BEING_PLACED = 18;
		foreach(x; 0 .. WORLD_WIDTH)
			foreach(y; 0 .. WORLD_HEIGHT)
				if(uniform(0, CHANCE_OF_FLOWER_BEING_PLACED) == 0)
					setTile(Location(x, y), new TileFlower);
	}

	void addTreesToWorld(){
		int CHANCE_OF_TREE_BEING_PLACED = 40;
		foreach(x; 0 .. WORLD_WIDTH)
			foreach(y; 0 .. WORLD_HEIGHT)
				if(uniform(0, CHANCE_OF_TREE_BEING_PLACED) == 0)
					setTile(Location(x, y), new TileTree);
	}

	void addRocksToWorld(){
		int CHANCE_OF_ROCK_BEING_PLACED = 90;
		foreach(x; 0 .. WORLD_WIDTH)
			foreach(y; 0 .. WORLD_HEIGHT)
				if(uniform(0, CHANCE_OF_ROCK_BEING_PLACED) == 0)
					setTile(Location(x, y), new TileRock);
	}

	void addRoomsToWorld(){

		int w, h, wx, wy;

		foreach(i; 0 .. MAX_NUMBER_OF_ROOMS){
			w = uniform(5, MAX_ROOM_WIDTH);
			h = uniform(5, MAX_ROOM_HEIGHT);
			
			wx = uniform(3, width - w); //"- w" is to make sure the room never goes out if bound
			wy = uniform(3, height- h); //Ditto from Pokémon

			rooms ~= new Room(&this, wx, wy, w, h);
		}
	}
}
