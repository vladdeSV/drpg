module drpg.ui.uimanager;

import std.stdio, consoled;
import drpg.game;
import drpg.ui.side, drpg.ui.start, drpg.ui.fight;
import drpg.entities.player;

class UIManager {

	Game game;

	Start startUI; 
	Side sideUI;
	FightScreen fightUI;

	this(Game gameptr)
	{
		game = gameptr;

		startUI = new Start(); 
		fightUI = new FightScreen(this);
	}

	void startSideUi(){
		sideUI = new Side(this); //Must be created after the player, otherwise ERRORS!
	}
}
