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
	
	void init(){
		addEntity(new Enemy(4,4));
	}

	private Player p = new Player(1, 2);
	private Entity[] ents;

	void setPlayer(Player player){
		p = player;
	}

	void printPlayer(){
		setCursorPos(player.x % CHUNK_WIDTH, player.y % CHUNK_HEIGHT);
		write(SPRITE_PLAYER);
	}

	public Player player(){
		return p;
	}

	void addEntity(Entity ent){
		ents ~= ent;
	}

	int entityTick;
	void tick(){
		++entityTick;
		if(entityTick > 100000){
			update;
			entityTick = 0;
		}
	}

	void update(){
		foreach(l; 0 .. ents.length){
			ents[l].move();
		}
	}
}