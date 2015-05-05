module drpg.game;

import std.stdio, std.random, consoled;
import drpg.reference, drpg.map, drpg.entities.entitymanager, drpg.entities.player, drpg.ui.uimanager;
import drpg.room, drpg.tile;

class Game{

	EntityManager em;
	Map map;
	UIManager uim;

	this(){
		cursorVisible(false);
		clearScreen();

		map = new Map(&this);
		em = new EntityManager(&this);
		uim = new UIManager(&this);

		//Always last
		map.printChunk();


//		setCursorPos(0,0);
//		write(roomsFailedToPlace," rooms failed to be placed");

		while(running){
			em.tick();
		}
	}
}
