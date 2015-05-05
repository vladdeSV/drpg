module drpg.entities.entitymanager;

import std.stdio, std.random, consoled;
import drpg.game;
import drpg.misc;
import drpg.entities.entity, drpg.entities.player, drpg.entities.enemy;
import drpg.reference, drpg.refs.sprites;

class EntityManager {

	Game* game;

	Player player;
	Entity[] entities;

	int entityTick;
	
	this(Game* gameptr) {

		game = gameptr;
		player = new Player(&game.em, Location(1,4));
		
		entityTick = 0; //For you Gab
		addEntities();
	}

	void tick(){
		++entityTick;
		if(entityTick > 1000){
			update();
			entityTick = 0;
		}
		player.update();
	}

	void update(){
		foreach(l; 0 .. entities.length){
			entities[l].update();
		}
	}

	/*
	void printPlayer(){
		player.print();
	}

	public Player player(){
		return player;
	}
	
	*/

	void printAllEntities(){
		player.print();

		foreach(l; 0 .. entities.length){
			printEntity(entities[l]);
		}
	}

	void printEntity(Entity ent){
		if(ent.chunk == player.chunk){
			ent.print();
		}
	}

	void addEntity(Entity ent){
		entities ~= ent;
	}

	Entity getEntityAt(Location loc){
		foreach(l; 0 .. entities.length){
			if(entities[l].position == loc)
				return entities[l];
		}

		return null;
	}

	/**
	 * Check if there is an entity at give location
	 */
	bool isEntityAt(Location loc){
		
		if(player.position == loc)
			return true;

		foreach(l; 0 .. entities.length){
			if(entities[l].position == loc)
				return true;
		}

		return false;
	}

	void addEntities(){
		addEntity(new Enemy(&game.em, Location(4,4)));
		addEntity(new Enemy(&game.em, Location(2,7)));
		addEntity(new Enemy(&game.em, Location(5,30)));
	}
}
