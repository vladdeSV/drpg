module drpg.map;

import consoled;
import std.stdio;
import std.random;
import std.conv;
import std.math;
import drpg.game;
import drpg.misc;
import drpg.tile;
import drpg.room;
import drpg.references.size;
import drpg.entities.player;
import drpg.entities.enemy;
import drpg.entities.boss;
import drpg.entities.entitymanager;

/*
 * Working singleton!
 */

class Map{

	Game game;

	private int width, height;
	private Tile[][] tiles;
	private Room[] rooms;
	bool castleOpen = false;

	Location bossroom;

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
		centerStringOnEmptyScreen("Adding structures...");
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

	/**
	 * Prints the chunk the player currently is in
	*/
	void printChunk(){
		int xChunkStartPos = CHUNK_WIDTH * (game.em.player.location.x / CHUNK_WIDTH);
		int yChunkStartPos = CHUNK_HEIGHT* (game.em.player.location.y / CHUNK_HEIGHT);
		string print;
		//FIXME This function will crash if the map width/height is not a multiple of CHUNK_WIDTH/CHUNK_HEIGHT
		foreach(int y; 0 .. CHUNK_HEIGHT){
			foreach(int x; 0 .. CHUNK_WIDTH)
				print ~= tiles[x + xChunkStartPos][y + yChunkStartPos].getSprite();
			writeAt(ConsolePoint(0, y), print ~ '+');
			print = null;
		}
		foreach(x; 0 .. CHUNK_WIDTH + 1)
			writeAt(ConsolePoint(x, CHUNK_HEIGHT), '+');
		game.em.printAllEntities();
		game.uim.sideUI.update();
	}

	//A function to place tiles in a rectangle. I really wanted to name this function getREKT, but sadly I didn't :(
	void addRect(Location topleft, Location bottomright, Tile tiletype, Tile overlay = null){
		//TODO Tell dev somehow if the locations are misplaced
		if(topleft.x < bottomright.x && topleft.y < bottomright.y){
			foreach(int x; 0 .. bottomright.x - topleft.x)
			foreach(int y; 0 .. bottomright.y - topleft.y)
				setTile(Location(x + topleft.x, y + topleft.y), tiletype, overlay);
		}
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

	/**
	 * Creates a room in the world.
	 * 
	 * Params:
	 *  worldx = X posision of the room in the world
	 *  worldy = Y posision of the room in the world
	 *  width = The width of the room
	 *  height = The height of the room (downwards)
	 *  force = Should the room be placed on top other rooms etc
	 *  normal = Should a door and enemy spawn
	 */
	void addRoom(int worldx, int worldy, int width, int height, bool force = false, bool normal = true){
		rooms ~= new Room(this, worldx, worldy, width, height, force, normal);
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	void tutorial(){
		addRoom(CHUNK_WIDTH - 20, 1, 18, 6, true, false);
		addRoom(CHUNK_WIDTH - 3,  3, 10, 3, true, false);
		addRoom(CHUNK_WIDTH + 6,  1, 14, 7, true, false);
		setTile(Location(CHUNK_WIDTH - 3, 4), new TileDoor());
		setTile(Location(CHUNK_WIDTH + 6, 4), new TileDoor());
		setTile(Location(CHUNK_WIDTH + 13, 7), new TileDoor(true));
		setTile(Location(CHUNK_WIDTH + 13, 8), new TileFloor());
		setTile(Location(CHUNK_WIDTH + 13, 9), new TileFloor());
	}

	void spawnBossRoom(){
		int w, h, wx, wy;
		w = CHUNK_WIDTH - 6;
		h = CHUNK_HEIGHT- 6;
		wx = CHUNK_WIDTH  * uniform(1, CHUNK_AMOUNT_WIDTH  - 1);
		wy = CHUNK_HEIGHT * uniform(2, CHUNK_AMOUNT_HEIGHT - 1);
		bossroom = Location(wx, wy);

		//Main room
		addRoom(wx + 3, wy + 3, w, h, true, false);
		//Small towers
		addRoom(wx + 1, wy + 2, 6, 5, true, false);
		addRoom(wx + 1, wy + CHUNK_HEIGHT - 7, 6, 5, true, false);
		addRoom(wx + CHUNK_WIDTH - 7, wy + 2, 6, 5, true, false);
		addRoom(wx + CHUNK_WIDTH - 7, wy + CHUNK_HEIGHT - 7, 6, 5, true, false);
		addRect(Location(wx + 5, wy + 5), Location(wx + CHUNK_WIDTH - 5, wy + CHUNK_HEIGHT - 5), new TileFloor());

		closeCastle();

		game.em.addEntity(new Enemy(game.em, Location(wx + 4, wy + 4), false, 15, 3, "bossminion"));
		game.em.addEntity(new Enemy(game.em, Location(wx + CHUNK_WIDTH - 5, wy + 4), false, 15, 3, "bossminion"));
		game.em.addEntity(new Enemy(game.em, Location(wx + 4, wy + CHUNK_HEIGHT - 5), false, 15, 3, "bossminion"));
		game.em.addEntity(new Enemy(game.em, Location(wx + CHUNK_WIDTH - 5, wy + CHUNK_HEIGHT - 5), false, 15, 3, "bossminion"));

		//Add bossroom and shit
		addRoom(wx + CHUNK_WIDTH/2 - 3, wy + 2, 7, 6, true, false);
		game.em.addEntity(new Boss(game.em, Location(wx + CHUNK_WIDTH / 2, wy + 5)));

//		game.em.player.location = Location(wx, wy); //FIXME REMOVE THIS IN THE FUTURE
	}

	void openCastle(){
		addRect(Location(bossroom.x + CHUNK_WIDTH / 2 - 2, bossroom.y + CHUNK_HEIGHT - 4), Location(bossroom.x + CHUNK_WIDTH / 2 + 3, bossroom.y + CHUNK_HEIGHT - 3), new TileFloor());
		castleOpen = true;
	}

	void closeCastle(){
		addRect(Location(bossroom.x + CHUNK_WIDTH / 2 - 2, bossroom.y + CHUNK_HEIGHT - 4), Location(bossroom.x + CHUNK_WIDTH / 2 + 2, bossroom.y + CHUNK_HEIGHT - 3), new TileDoor(true));
		castleOpen = false;
	}

	void openBoss(){
		centerStringOnEmptyScreen("The boss has deemed you worthy. Fight, for your friends.");
		addRect(Location(bossroom.x + 5, bossroom.y + 5), Location(bossroom.x + CHUNK_WIDTH - 5, bossroom.y + CHUNK_HEIGHT - 5), new TileFloor());
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
			h = w + uniform(-2, 2);
			wx = uniform(3, width - w); //"- w" is to make sure the room never goes out if bound
			wy = uniform(3, height- h); //Ditto from Pokémon
			addRoom(wx, wy, w, h);
		}
	}
}
