module drpg.game;

import std.stdio;
import std.random;
import consoled;
import drpg.misc;
import drpg.tile;
import drpg.map;
import drpg.room;
import drpg.ui.uimanager;
import drpg.entities.entitymanager;
import drpg.entities.player;
import drpg.references.variables;
import drpg.references.text;

class Game{

	UIManager uim;
	Map map;
	EntityManager em;

	this(){
		cursorVisible(false);
		clearScreen();
		title("DRPG");

		uim = new UIManager(this);
		em = new EntityManager(this);
		map = new Map(this);

		uim.startSideUi();
		map.printChunk();

		//Always last
		Clock.wait(1);
		talkBox("FACT: I can move with WASD", em.player.getSprite());
		map.printChunk();

		Clock clock = new Clock();
		clock.reset();

		while(running){
			double dt = clock.reset();
			em.tick(dt);
		}

		centerStringOnEmptyScreen(GAME_END);
		Clock.wait(5);
	}
}
