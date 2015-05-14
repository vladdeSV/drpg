module drpg.map;

import std.stdio, std.math, std.random, std.conv, consoled;
import drpg.game;
import drpg.misc;
import drpg.references.size;
import drpg.entities.player, drpg.entities.entitymanager;
import drpg.tile, drpg.room;

/*
 * Working singleton!
 */

class Map{

	Game game;

	private int width, height;
	private Tile[][] tiles;
	private Room[] rooms;

	@property{
		int getWidth(){ return width; }
		int getHeight(){ return height; }
	}

	this(Game gameptr)
	{
		game = gameptr;
		width = WORLD_WIDTH;
		height = WORLD_HEIGHT;

		centerStringOnEmptyScreen("Generating map...");

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

		centerStringOnEmptyScreen("Done!");
	}

	void addStructures(){

		tutorial();
		spawnBossRoom();

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

//		//FIXME This function will crash if the map width/height is not a multiple of CHUNK_WIDTH/CHUNK_HEIGHT
		string print;

		foreach(int y; 0 .. CHUNK_HEIGHT){
			foreach(int x; 0 .. CHUNK_WIDTH){
				print ~= tiles[x + xChunkStartPos][y + yChunkStartPos].getSprite();
			}

			setCursorPos(0, y);
			write(print, '+');

			print = null;
		}

		setCursorPos(0, CHUNK_HEIGHT);
		foreach(a; 0 .. CHUNK_WIDTH + 1)
			write('+');
			
		game.em.printAllEntities();
	}

	//A function to place tiles in a rectangle. I really wanted to name this function getREKT, but sadly I didn't :(
	void addRect(Location topleft, Location bottomright, Tile tiletype, Tile overlay = null){
		foreach(xPos; 0 .. bottomright.x)
			foreach(yPos; 0 .. bottomright.y)
				setTile(Location(xPos + topleft.x, yPos + topleft.y), tiletype, overlay);
		
	}

	/**
	* Return the tile at specified x and y
	*/
	Tile getTile(Location loc){
		return tiles[loc.x][loc.y];
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

	void tutorial(){

//		setTile(Location(18, 3), new TileDoor()); //TODO make this a locked door

		rooms ~= new Room(this, CHUNK_WIDTH - 20, 1, 18, 6, true, false);
		rooms ~= new Room(this, CHUNK_WIDTH - 3,  3, 10, 3, true, false);
		rooms ~= new Room(this, CHUNK_WIDTH + 6,  1, 14, 7, true, false);
		setTile(Location(CHUNK_WIDTH - 3, 4), new TileDoor());
		setTile(Location(CHUNK_WIDTH + 6, 4), new TileDoor());
		setTile(Location(CHUNK_WIDTH + 13, 7), new TileDoor(true));
		setTile(Location(CHUNK_WIDTH + 13, 8), new TileFloor());
		setTile(Location(CHUNK_WIDTH + 13, 9), new TileFloor());

	}

	void spawnBossRoom(){
		int w, h, wx, wy;

		w = CHUNK_WIDTH -2;
		h = CHUNK_HEIGHT-2;

		wx = CHUNK_WIDTH * uniform(1, CHUNK_AMOUNT_WIDTH-1) + 1;
		wy = CHUNK_HEIGHT * uniform(2, CHUNK_AMOUNT_HEIGHT-1) + 1;

//		wx = uniform(3, width - w); //"- w" is to make sure the room never goes out if bound
//		wy = uniform(3, height- h); //Ditto from Pokémon

		rooms ~= new Room(this, wx, wy, w, h, true, false);
	}

	void addFlowersToWorld(){
		int CHANCE_OF_FLOWER_BEING_PLACED = 18;
		foreach(x; 0 .. WORLD_WIDTH)
			foreach(y; 0 .. WORLD_HEIGHT)
				if(uniform(0, CHANCE_OF_FLOWER_BEING_PLACED) == 0)
					if(!getTile(Location(x, y)).isSolid && cast(TileDoor) getTile(Location(x, y)) is null && cast(TileFloor) getTile(Location(x, y)) is null)
						setTile(Location(x, y), new TileFlower);
	}

	void addTreesToWorld(){
		int CHANCE_OF_TREE_BEING_PLACED = 40;
		foreach(x; 0 .. WORLD_WIDTH)
			foreach(y; 0 .. WORLD_HEIGHT)
				if(uniform(0, CHANCE_OF_TREE_BEING_PLACED) == 0)
					if(!getTile(Location(x, y)).isSolid())
						setTile(Location(x, y), new TileTree);
	}

	void addRocksToWorld(){
		int CHANCE_OF_ROCK_BEING_PLACED = 90;
		foreach(x; 0 .. WORLD_WIDTH)
			foreach(y; 0 .. WORLD_HEIGHT)
				if(uniform(0, CHANCE_OF_ROCK_BEING_PLACED) == 0)
					if(!getTile(Location(x, y)).isSolid())
						setTile(Location(x, y), new TileRock);
	}

	void addRoomsToWorld(){

		int w, h, wx, wy;

		foreach(i; 0 .. MAX_NUMBER_OF_ROOMS){
			w = uniform(5, MAX_ROOM_WIDTH);
			h = uniform(5, MAX_ROOM_HEIGHT);
			
			wx = uniform(3, width - w); //"- w" is to make sure the room never goes out if bound
			wy = uniform(3, height- h); //Ditto from Pokémon

			rooms ~= new Room(this, wx, wy, w, h);
		}
	}
}
