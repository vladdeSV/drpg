module drpg.game;

import std.stdio, std.random, consoled;
import drpg.reference, drpg.map, drpg.entities.entitymanager, drpg.entities.player, drpg.ui.uimanager;
import drpg.room, drpg.tile;

class Game{

	UIManager uim;
	Map map;
	EntityManager em;



	this(){
		cursorVisible(false);
		clearScreen();

		uim = new UIManager(this);
		map = new Map(this);
		em = new EntityManager(this);

		uim.startSideUi();

		//Always last
		map.printChunk();


//		setCursorPos(0,0);
//		write(roomsFailedToPlace," rooms failed to be placed");

		while(running){
			em.tick();
		}
	}
}
