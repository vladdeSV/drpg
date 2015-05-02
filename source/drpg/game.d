module drpg.game;

import std.stdio, std.random, consoled;
import drpg.reference, drpg.map, drpg.entities.entitymanager, drpg.entities.player, drpg.ui.uimanager;
import drpg.room, drpg.tile;

class Game{

	void start(){
		clearScreen;
		cursorVisible(false);

		_em.init;
		_map.init;
		_uim.init;

		//Always last
		_map.printChunk;
		
//		setCursorPos(0,0);
//		write(roomsFailedToPlace," rooms failed to be placed");

		while(running) gameTick;
	}

	void gameTick(){
		_em.tick;
		_em.player.update; //Other enteties and the player should update separately. Player movement should be instant, while enemies move not so often (maybe).
	}

}
