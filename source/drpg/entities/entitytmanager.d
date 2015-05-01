module drpg.entities.entitymanager;

import std.stdio, std.random, consoled;
import drpg.entities.entity, drpg.entities.player, drpg.entities.enemy;
import drpg.reference, drpg.refs.sprites;

class EM {

	/+
	TODO: Like, there is no need to do this yet. No plans for local/online multiplayer. So yeah.
	private static const MAX_AMOUNT_PLAYERS = 8;
	private Player*[MAX_AMOUNT_PLAYERS] players; //Maximum of 16 players
	private byte amountPlayer = 0;
	public void addPlayer(Player* p){
		if(amountPlayer < MAX_AMOUNT_PLAYERS - 1){ //Note to self: "- 1" is because it's an array
			players[amountPlayer] = p;	
			amountPlayer++;
		}else{
			setCursorPos(0, 0);
			write("MAXIMUM PLAYER COUNT EXCEEDED!");
		}
	}
	+/
	//////////////////////////////////////
	static EM em() {
		if (!instantiated_) {
			synchronized {
				if (instance_ is null) {
					instance_ = new EM;
				}
				instantiated_ = true;
			}
		}
		return instance_;
	}
	private this() {}
	private static bool instantiated_;
	private __gshared EM instance_;
	//////////////////////////////////////

	int entityTick;

	void tick(){
		++entityTick;
		if(entityTick > 100000){
			update;
			entityTick = 0;
		}
	}
	
	void init(){
		addEntities;
	}

	void update(){
		foreach(l; 0 .. ents.length){
			ents[l].update();
		}
	}

	private Player p = new Player(1, 2);
	private Entity[] ents;

	void setPlayer(Player player){
		p = player;
	}

	void printPlayer(){
		setCursorPos(player.x % CHUNK_WIDTH, player.y % CHUNK_HEIGHT);
		write(SPRITE_PLAYER);
		stdout.flush(); //Thanks to Destructionator from #d (freenode) for this amazing one-liner which makes sure the enemies get properly written out!
	}

	public Player player(){
		return p;
	}

	void printEntity(Entity ent){
		setCursorPos(ent.x % CHUNK_WIDTH, ent.y % CHUNK_HEIGHT);
		write(ent.getSprite);
		stdout.flush(); //Thanks to Destructionator from #d (freenode) for this amazing one-liner which makes sure the enemies get properly written out!
	}

	void addEntity(Entity ent){
		ents ~= ent;
	}

	Entity getEntityAt(int a, int b){
		foreach(l; 0 .. ents.length){
			if(ents[l].x == a && ents[l].y == b)
				return ents[l];
		}

		return null;
	}

	/**
	 * Check if there is an entity at give location
	 */
	bool isEntityAt(int xpos, int ypos){

		if(player.x == xpos && player.y == ypos)
			return true;

		foreach(l; 0 .. ents.length){
			if(ents[l].x == xpos && ents[l].y == ypos)
				return true;
		}

		return false;
	}

	void addEntities(){
		addEntity(new Enemy(4,4));
		addEntity(new Enemy(2,7));
		addEntity(new Enemy(5,30));
	}
}
