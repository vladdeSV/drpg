module drpg.entities.entity;

import std.stdio;
import std.random;
import std.conv;
import consoled;

import drpg.entities.entitymanager;
import drpg.misc;
import drpg.item;
import drpg.references.size, drpg.references.sprites;

class Inventory{
	int maximumAmountOfItems;

	this(int maxItems = 100){
		maximumAmountOfItems = maxItems;
	}

	Item[] items;
	ItemLetter[] letters;
	
	void addItem(Item item){
		if(to!int(items.length) < maximumAmountOfItems){
			items ~= item;
		}
	}

	void addLetter(ItemLetter item){
		if(to!int(letters.length) < 100){
			letters ~= item;
		}
	}
}

abstract class Entity{
	int health, maxHealth, level;
	double updateInterval = 100.0; //Default value
	double entityTick = 0.0;
	string id;

	EntityManager em;

	Location position;
//	Stats stats;
	Inventory inventory = new Inventory();
	
	this(EntityManager emptr, Location loc, int hp, uint lvl, string id = ""){
		em = emptr;
		position = loc;

		health = maxHealth = hp;
		level = lvl;
		this.id = id;
	}
	
	protected void move(){

		Location oldPosition = position;

		Location movement = Location(uniform(-1, +2), uniform(-1, +2));
		Location dest = add(oldPosition, movement);
		
		bool inbounds = (dest.x >= 0 && dest.x < WORLD_WIDTH && 
		                 dest.y >= 0 && dest.y < WORLD_HEIGHT);

		/* Check so the enteties won't leave the world border and that the moving-to tile is not occupied*/
		if(inbounds && !em.isEntityAt(dest) && !em.game.map.isTileSolidAt(dest)){
			position = dest;
		}

		if(chunkAtPos(oldPosition) == em.player.chunk){ //Restore the tile where the entity was
			setCursorPos(oldPosition.x % CHUNK_WIDTH, oldPosition.y % CHUNK_HEIGHT);
			em.game.map.printTile(oldPosition);
		}
		
		if(chunk == em.player.chunk){ //If the enemy is in the visible chunk (the chunk the player is in), then render the entity
			print();
		}
	}
	
	void update(double dt){
		entityTick += dt;
		int runs = to!int(entityTick / updateInterval);
		entityTick = entityTick - runs * updateInterval;
		
		foreach (i; 0 .. runs){
			move();
		}
	}
	
	Location chunk(){
		return chunkAtPos(position);
	}
	
	void print(){
		setCursorPos(position.x % CHUNK_WIDTH, position.y % CHUNK_HEIGHT);
		write(getSprite());
		stdout.flush(); //Thanks to Destructionator from #d (freenode) for this amazing one-liner which makes sure the enemies get properly written out!
	}

//	void kill(){
//		destroy(this); // ;)
//	}

	char getSprite(){
		return '?';
	}
}