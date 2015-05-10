﻿module drpg.ui.fight;

import std.stdio, std.algorithm, std.conv, core.thread, std.random : uniform;
import drpg.game, consoled;
import drpg.reference, drpg.misc;
import drpg.ui.uimanager;
import drpg.entities.entity;

class FightScreen
{

	UIManager uim;
	bool fighting = true;
	int level;

	this(UIManager uiman){
		uim = uiman;
	}

	void startFight(Entity e){

		string line;
		foreach(int nr; 0 .. CHUNK_WIDTH){ line ~= '*'; }

		level = e.level;

		clearChunk();

		writeRectangle(Location(1,1), Location(CHUNK_WIDTH-2, 5));

		writeAt(ConsolePoint(5, 3), uim.game.em.player.getSprite());
		writeAt(ConsolePoint(23, 3), "vs.");
		writeAt(ConsolePoint(CHUNK_WIDTH - 6, 3), e.getSprite());

		stdout.flush();

		FallingLetter[] falling;

		foreach(int i; 0 .. to!int(level)){
			falling ~= new FallingLetter(this, Location(3 + 4*i, 9), e, i);
		}

		while(fighting){
			int press;

			if(kbhit()){
				press = getch();
			}

			//if myclockclass
				foreach(int i; 0 .. to!int(falling.length)){
					falling[i].update(press);
				}
		}

		fighting = true;

		if(uim.game.em.player.health)
			uim.game.map.printChunk();
	}
}

class FallingLetter{

	char[26] alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".dup;

	int fallStart, goalHeight, speed;
	int tick;

	FightScreen screen;

	Location location;
	Entity opponent;
	Letter[] letters;

	this(FightScreen f, Location location, Entity e, int spd){
		screen = f;
		this.location = location;
		opponent = e;
		speed = spd * 10000;

		fallStart = location.y;
		goalHeight = CHUNK_HEIGHT - 3;

		writeAt(ConsolePoint(location.x, goalHeight), "[ ]");

		updateStats();
	}

	struct Letter{
		char letter;
		int fallHeight;
	}

	void update(int key){
		++tick;

		if(opponent.health <= 0){
			screen.fighting = false;
			screen.uim.game.em.kill(opponent);
			Thread.sleep( dur!("seconds")(5) ); // FIXME Better way of pausing?
			return;
		}
		else if(screen.uim.game.em.player.health <= 0){
			Thread.sleep( dur!("seconds")(3) ); // FIXME ditto.

			screen.fighting = false;

			centerStringOnEmptyScreen("You died.");
			Thread.sleep( dur!("seconds")(5) ); // FIXME from pokémon.
			return;
		}

		bool hit =
			letters.length &&
			letters[0].fallHeight == goalHeight &&
			key == letters[0].letter;

		if(hit){
			opponent.health -= 1;
			letters = remove(letters, 0);
			writeAt(ConsolePoint(location.x + 1, goalHeight), ' ');
			updateStats();
		}

		if(tick < 40000 - speed){ //FIXME: BAD WAY OF DEALING WITH HOW OFTEN THE LETTERS SHOULD FALL
			return;
		}

		//Removes missed letters
		writeAt(ConsolePoint(location.x + 1, goalHeight + 1), ' ');

		if(uniform(0, 2) == 0){
			letters ~= Letter(alphabet[uniform(0, alphabet.length)], fallStart);
		}

		if(!letters.length){
			return;
		}

		foreach(int a; 0 .. to!int(letters.length)){
			letters[a].fallHeight += 1;
			writeAt(ConsolePoint(location.x + 1, letters[a].fallHeight), letters[a].letter);
			writeAt(ConsolePoint(location.x + 1, letters[a].fallHeight - 1), ' ');
		}

		if(letters[0].fallHeight > goalHeight){
			letters = remove(letters, 0);
			screen.uim.game.em.player.health -= 1;
		}

		screen.uim.sideUI.update();
		stdout.flush();

		tick = 0;
	}

	void updateStats(){
		string hp;
		
		static immutable barBits = CHUNK_WIDTH - 14;
		
		if(opponent.health > 0){
			foreach(i; 0 .. barBits){
				if(i <= (to!float(opponent.health)/to!float(opponent.maxHealth))*barBits){ //This amazing function takes the health and converts/rounds it to barBits amount of slots
					hp ~= '*';
				}else{
					hp ~= ' ';
				}
			}
		}else{
			foreach(int nr; 0 .. barBits/2 - 2){ hp ~= ' '; }
			hp ~= "DEAD";
			foreach(int nr; 0 .. barBits/2 - 2){ hp ~= ' '; }
		}

		setCursorPos(1, 7);
		write("Enemy HP: [", hp, "]");
		stdout.flush();

	}
}