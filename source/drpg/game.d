module drpg.game;

import consoled;
import std.stdio;
import std.random;
import std.conv;
import drpg.misc;
import drpg.tile;
import drpg.map;
import drpg.room;
import drpg.ui.uimanager;
import drpg.entities.entitymanager;
import drpg.entities.player;
import drpg.references.size;
import drpg.references.variables;
import drpg.references.text;

class Game{

	UIManager uim;
	Map map;
	EntityManager em;

	this(){
		running = true;

		cursorVisible(false);
		title("DRPG");
		clearScreen();

		//LOGO
		foreach(l; 0 .. to!int(hswsag.length - 1)){
			writeAt(ConsolePoint(SCREEN_WIDTH / 2 - to!int(hswsag[l].length/2), l), hswsag[l]);
			Clock.wait(100);
		}
		Clock.wait(2000);
		writeAt(ConsolePoint(SCREEN_WIDTH / 2 - to!int(hswsag[SCREEN_HEIGHT].length/2), SCREEN_HEIGHT), hswsag[SCREEN_HEIGHT]);
		Clock.wait(5000);
		clearScreen();
		Clock.wait(1000);

		uim = new UIManager(this);
		em = new EntityManager(this);
		map = new Map(this);

		uim.startSideUi();
		map.printChunk();

		//Move help
		Clock.wait(1000);
		talkBox("FACT: I can move with WASD", em.player.getSprite());

		map.printChunk();

		Clock clock = new Clock();
		clock.reset();

		while(running){
			double dt = clock.reset();
			em.tick(dt);
		}

		centerStringOnEmptyScreen(GAME_END);
		Clock.wait(5000);
	}
}
