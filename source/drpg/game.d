module drpg.game;

import std.stdio, std.random, consoled;
import drpg.reference, drpg.map, drpg.entities.entitymanager, drpg.entities.player, drpg.ui.uimanager;
import drpg.room, drpg.tile;

class Game{

	void start(){
		clearScreen;
		cursorVisible(false);

		_em.em;
		_map.init;
		_uim.init;

		//Always last
		_map.printChunk;
		setCursorPos(0,0);
		write(roomsFailedToPlace," rooms failed to be placed");

		while(running){
			++tick;

			if(tick > 250){
				tick = 0;
				gameTick;
			}
		}
	}

	void gameTick(){
		_em.player.move;
		tick = 0;
	}

}
