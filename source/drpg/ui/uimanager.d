module drpg.ui.uimanager;

import std.stdio, drpg.reference, consoled;
import drpg.game;
import drpg.ui.side, drpg.ui.start, drpg.ui.inventory;
import drpg.entities.player;

class UIManager {

	Game* game;
	Start startUI; 
	Side sideUI;
	Inventory invUI;

	this(Game* gameptr)
	{
		game = gameptr;

		startUI = new Start(); 
	}

	void startSideUi(){
		sideUI = new Side(&game.em); //Must be created after the player, otherwise ERRORS!
	}
}
