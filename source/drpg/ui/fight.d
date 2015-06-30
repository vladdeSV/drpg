module drpg.ui.fight;

import consoled;
import std.stdio;
import std.string;
import std.range;
import std.algorithm;
import std.conv;
import std.random;
import drpg.game;
import drpg.misc;
import drpg.item;
import drpg.tile;
import drpg.ui.uimanager;
import drpg.entities.entity;
import drpg.references.size;
import drpg.references.text;
import drpg.references.sprites;
import drpg.references.variables;

class FightScreen
{
	bool fighting = false;
	int level;

	UIManager uim;

	this(UIManager uiman){
		uim = uiman;
	}

	void startFight(Entity e){
		string line; foreach(int nr; 0 .. CHUNK_WIDTH) line ~= '*';
		fighting = true;
		level = e.level;

		clearScreen();
		if(e.id == "tut") talkBox("Press the letters as they fall into the [ ]");
		clearScreen();
		writeRectangle(Location(1,1), Location(SCREEN_WIDTH-2, 5));
		writeAt(ConsolePoint(5, 3), uim.game.em.player.getSprite());
		writeAt(ConsolePoint(SCREEN_WIDTH / 2 - 1, 3), "vs.");
		writeAt(ConsolePoint(SCREEN_WIDTH - 6, 3), e.getSprite());
		stdout.flush();

		FallingLetter[] falling;
		foreach(int i; 0 .. to!int(level)){
			falling ~= new FallingLetter(this, Location(3 + 4*i, 9), e);
		}
		Clock clock = new Clock();
		clock.reset();
		while(fighting){
			double dt = clock.reset();
			int press;
			if(kbhit())
				press = getch();
			foreach(int i; 0 .. to!int(falling.length)){
				if(fighting)
					falling[i].update(press, dt);
				else
					break;
			}
		}
		if(uim.game.em.player.health){
			uim.game.map.printChunk();
			uim.sideUI.printAll();
		}
	}
}

class FallingLetter{
	int fallStart, goalHeight;
	double tick = 0;
	int failed;

	FightScreen screen;
	Location location;
	Entity opponent;
	Letter[] letters;

	this(FightScreen f, Location location, Entity e){
		screen = f;
		this.location = location;
		opponent = e;
		fallStart = location.y;
		goalHeight = CHUNK_HEIGHT - 2;
		writeAt(ConsolePoint(location.x + 1, fallStart), "_");
		writeAt(ConsolePoint(location.x, fallStart + 1), "| |");
		writeAt(ConsolePoint(location.x, goalHeight), "[ ]");
		updateStats();
	}

	struct Letter{
		char letter;
		int fallHeight;
	}

	void update(int key, double dt){
		tick += dt;
		if(opponent.health <= 0){
			killOpponent();
			return;
		}
		else if(screen.uim.game.em.player.health <= 0){
			Clock.wait(3000);
			screen.fighting = false;
			centerStringOnEmptyScreen(GAME_PLAYER_DEAD);
			Clock.wait(5000);
			return;
		}
		bool hit =
			letters.length &&
			letters[0].fallHeight == goalHeight &&
			toLower(key) == toLower(letters[0].letter); // FIXME Key input may not work on Unix, keyinput can be lowercase
		if(hit){
			opponent.health -= 1;
			letters = remove(letters, 0);
			writeAt(ConsolePoint(location.x + 1, goalHeight), ' ');
			updateStats();
		}
		double speed = 1000; //One second
		//Some sort of faster speed pacer thing idk

		speed -= (1 + screen.uim.game.em.player.enemiesMurdered - opponent.level * 2) * 75;

		if(speed < 700) speed = 700;

		int runs = to!int(tick / speed);
		tick = tick - runs * speed;
		foreach (i; 0 .. runs){
			//Removes missed letters
			writeAt(ConsolePoint(location.x + 1, goalHeight + 1), ' ');
			if(uniform(0, 3) == 0 || failed >= 3){
				letters ~= Letter(alphabetUC[uniform(0, alphabetUC.length)], fallStart);
				failed = 0;
			}else{
				failed += 1;
			}
			if(!letters.length){
				return;
			}
			foreach(int a; 0 .. to!int(letters.length)){
				letters[a].fallHeight += 1;
				writeAt(ConsolePoint(location.x + 1, letters[a].fallHeight), letters[a].letter);
				if(letters[a].fallHeight > fallStart + 1) writeAt(ConsolePoint(location.x + 1, letters[a].fallHeight - 1), ' ');
			}
			if(letters[0].fallHeight > goalHeight){
				letters = remove(letters, 0);
				screen.uim.game.em.player.health -= 1;
			}
			updateStats();
			stdout.flush();
			
			tick = 0;
		}
	}

	void killOpponent(){
		screen.uim.game.em.player.enemiesMurdered += 1;
		screen.fighting = false;

		string lettersGot = "The opponent dropped: ";
		int amountOfLettersDropped = uniform(opponent.level, opponent.level*2 + screen.uim.game.em.player.enemiesMurdered*2);
		char[] tlt;

		talkBox("The opponent was murdered.");
		Clock.wait(1000);
		
		foreach(int a; 0 .. amountOfLettersDropped){
			tlt ~= alphabetLC[uniform(0, to!int(alphabetLC.length))];
			lettersGot ~= tlt[a] ~ " ";
			screen.uim.game.em.player.addLetter(tlt[a]);
		}
		
		if(opponent.id == "tut"){
			screen.uim.game.map.setTile(Location(CHUNK_WIDTH + 13, 7), new TileFloor());
		}else if(opponent.id == "bossminion"){
			screen.uim.game.em.player.boss_toFour++;
			if(screen.uim.game.em.player.boss_toFour == 4){
				screen.uim.game.map.openBoss();
				centerStringOnEmptyScreen("The boss room is now open");
			}
		}
		
		centerStringOnEmptyScreen(lettersGot);
		Clock.wait(5000);
		
		if(screen.uim.game.em.player.health < screen.uim.game.em.player.maxHealth){
			if(screen.uim.game.em.player.health + opponent.level * 2 >= screen.uim.game.em.player.maxHealth){
				screen.uim.game.em.player.health = screen.uim.game.em.player.maxHealth;
				centerStringOnEmptyScreen("You gained full health!");
			}else{
				screen.uim.game.em.player.health += opponent.level * 2;
				centerStringOnEmptyScreen("You gained " ~ text(opponent.level * 2) ~ " health points!");
			}
			Clock.wait(3000);
		}

		int twentyseven;
		foreach(int a; 0 .. to!int(screen.uim.game.em.player.inventory.letters.length)){
			if(screen.uim.game.em.player.inventory.letters[a].amount > 0){
				twentyseven += 1;
			}else{
				break;
			}
		}
		if(twentyseven >= 26){
			screen.uim.game.map.openCastle();
		}

		if(opponent.id == "boss"){
			gamegamegame = false;
			running = false;
			centerStringOnEmptyScreen("You killed the boss! You have now set the letters free once and for all!!!");
			Clock.wait(5000);
		}

		screen.uim.game.em.kill(opponent);
		screen.uim.game.map.printChunk();
	}

	void updateStats(){
		string playerhp;
		string opponenthp;
		
		int barBits = SCREEN_WIDTH/2 - 5;

		if(screen.uim.game.em.player.health > 0){
			//This amazing function takes the health and converts/rounds it to barBits amount of slots
			foreach(i; 0 .. barBits)
				if(i <= (to!float(screen.uim.game.em.player.health)/to!float(screen.uim.game.em.player.maxHealth))*barBits) playerhp ~= '=';
				else playerhp ~= ' ';
			playerhp = to!string(playerhp.retro());
		}else{
			string babydonthurtme = "";
			foreach(int nr; 0 .. barBits/2 - 2) babydonthurtme ~= ' ';
			playerhp = babydonthurtme ~ "DEAD" ~ babydonthurtme;
		}
		
		if(opponent.health > 0){
			//Basically the same as above
			foreach(i; 0 .. barBits)
				if(i <= (to!float(opponent.health)/to!float(opponent.maxHealth))*barBits) opponenthp ~= '=';
				else opponenthp ~= ' ';
		}else{
			string imontheedgeofglory = "";
			foreach(int nr; 0 .. barBits/2 - 2) imontheedgeofglory ~= ' ';
			opponenthp = imontheedgeofglory ~ "DEAD" ~ imontheedgeofglory;
		}
		writeAt(ConsolePoint(2, 7), SPRITE_PLAYER ~ " [" ~ playerhp ~ "|" ~ opponenthp ~ "] " ~ opponent.getSprite());
		stdout.flush();
	}
}
