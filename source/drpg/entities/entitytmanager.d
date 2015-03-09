module drpg.entities.entitymanager;

import std.stdio;
import drpg.entities.player, drpg.reference;

/+
/*
 * Working singleton!
 * But not safe for multi-thread
 */

class EntityManager{

	//Singleton
	private static EntityManager INSTANCE_ENTITY_MANAGER;
	public EntityManager instance(){
		if(!INSTANCE_ENTITY_MANAGER) INSTANCE_ENTITY_MANAGER = new EntityManager();
		return INSTANCE_ENTITY_MANAGER;
	}
	
}
+/

class EM {

	private static const MAX_AMOUNT_PLAYERS = 16;
	private Player*[MAX_AMOUNT_PLAYERS] players; //Maximum of 16 players
	private byte amountPlayer = 0;

	public void addPlayer(Player* p){
		
		if(amountPlayer >= MAX_AMOUNT_PLAYERS - 1){ //Note to self: "- 1" is because it's an array
			players[amountPlayer] = p;	
			amountPlayer++;
		}else{
			
		}
	}

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
private:
	this() {}
	static bool instantiated_;  // Thread local
	__gshared EM instance_;
}