module drpg.entities.entitymanager;

import std.stdio, std.array, consoled;
import drpg.entities.entity, drpg.entities.player, drpg.entities.enemy;
import drpg.reference;

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
	private static bool instantiated_;  // Thread local
	private __gshared EM instance_;

	private Entity[] ents;
	private Player p = new Player(1, 1);

	void setPlayer(Player player){
		p = player;
	}

	void printPlayer(){
		setCursorPos(player.x % CHUNK_WIDTH, player.y % CHUNK_HEIGHT);
		write('p');
	}

	public Player player(){
		return p;
	}

	void addEntity(Entity ent){
		ents ~= ent;
	}

	void update(){
		setCursorPos(player.x % CHUNK_WIDTH, player.y % CHUNK_HEIGHT);
		write('p');

		foreach(l; 0 .. ents.length){
			if(ents[l].chunk[0] == player.chunk[0] && ents[l].chunk[1] == player.chunk[1]){
				setCursorPos(ents[l].x % CHUNK_WIDTH, ents[l].y % CHUNK_HEIGHT);
				write('e');
			}
		}
	}
}