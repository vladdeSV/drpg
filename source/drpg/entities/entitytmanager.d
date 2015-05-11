module drpg.entities.entitymanager;

import std.stdio, std.random, std.algorithm, std.conv, consoled;
import drpg.game;
import drpg.misc;
import drpg.entities.entity, drpg.entities.player, drpg.entities.enemy;
import drpg.references.sprites;

class EntityManager {

	Game game;

	Player player;
	Entity[] entities;

	double entityTick;
	
	this(Game gameptr) {

		game = gameptr;
		player = new Player(this, Location(1,4));

		addEntities();
	}

	void tick(double dt){
		update(dt);
		player.update();
	}

	void update(double dt){
		foreach(l; 0 .. entities.length){
			entities[l].update(dt);
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

//	Entity* getEntityPointerAt(Location loc){
//		foreach(l; 0 .. entities.length){
//			if(entities[l].position == loc)
//				return &entities[l];
//		}
//		
//		return null;
//	}

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

	void kill(Entity e){
		foreach(int a; 0 .. to!int(entities.length)){
			if(e == entities[a]){
				entities = remove(entities, a);
				break;
			}
		}
	}

	void addEntities(){
		//addEntity(new Enemy(this, Location(4,4), 100, 19));
		addEntity(new Enemy(this, Location(4,4), 0, 2));
		addEntity(new Enemy(this, Location(2,7)));
		addEntity(new Enemy(this, Location(5,30)));
	}
}
