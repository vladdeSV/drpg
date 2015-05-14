module drpg.game;

import std.stdio, std.random, consoled;
import drpg.misc;
import drpg.references.variables, drpg.map, drpg.entities.entitymanager, drpg.entities.player, drpg.ui.uimanager;
import drpg.room, drpg.tile;

class Game{

	UIManager uim;
	Map map;
	EntityManager em;

	this(){
		cursorVisible(false);
		clearScreen();

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
	}
}
