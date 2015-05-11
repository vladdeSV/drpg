module drpg.ui.fight;

import consoled, std.stdio, std.range, std.algorithm, std.conv, core.thread, std.random;
import drpg.game;
import drpg.misc;
import drpg.item;
import drpg.ui.uimanager;
import drpg.entities.entity;
import drpg.references.size;
import drpg.references.text;
import drpg.references.sprites;

class FightScreen
{

	UIManager uim;
	bool fighting = false;
	int level;

	this(UIManager uiman){
		uim = uiman;
	}

	void startFight(Entity e){

		fighting = true;
		
		string line;
		foreach(int nr; 0 .. CHUNK_WIDTH){ line ~= '*'; }

		level = e.level;

		clearScreen();

		writeRectangle(Location(1,1), Location(width-2, 5));
		writeAt(ConsolePoint(5, 3), uim.game.em.player.getSprite());
		writeAt(ConsolePoint(width/2-1, 3), "vs.");
		writeAt(ConsolePoint(width - 6, 3), e.getSprite());
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
			if(kbhit()){
				press = getch();
//				if(press == 'P' || press == 'p'){
//					pause();
//				}
			}
			foreach(int i; 0 .. to!int(falling.length)){
				falling[i].update(press, dt);
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

		writeAt(ConsolePoint(location.x, goalHeight), "[ ]");

		updateStats();
	}

	struct Letter{
		char letter;
		int fallHeight;
	}

	void update(int key, double dt){
		tick += dt;
		
		if(opponent.health <= 0 && screen.fighting /* fixme: fighting bool is there to prevent the function to run wice. Look in to it*/){

			//FIXME improve the letter gets in fight.d

			screen.fighting = false;
			
			Clock.wait(3);
			int amountOfLettersDropped = uniform(1, 4);
			string lettersGot = "You found: ";
			char[] tlt;
			foreach(int a; 0 .. amountOfLettersDropped){
				tlt ~= alphabetLC[uniform(0, to!int(alphabetLC.length))];
				screen.uim.game.em.player.addItem(new ItemLetter("A letter", tlt[a]));
				lettersGot ~= tlt[a] ~ " ";
			}

			screen.uim.game.em.kill(opponent);

			centerStringOnEmptyScreen(lettersGot);

			Clock.wait(5);
			screen.uim.game.map.printChunk();

			return;
		}
		else if(screen.uim.game.em.player.health <= 0){
			Clock.wait(3);
			screen.fighting = false;
			centerStringOnEmptyScreen(GAME_PLAYER_DEAD);
			Clock.wait(5);
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

		double speed = 1000; //One second
		int runs = to!int(tick / speed);
		tick = tick - runs * speed;
		
		foreach (i; 0 .. runs){
			//Removes missed letters
			writeAt(ConsolePoint(location.x + 1, goalHeight + 1), ' ');
	
			if(uniform(0, 3) == 0){
				letters ~= Letter(alphabetUC[uniform(0, alphabetUC.length)], fallStart);
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

			updateStats();
			stdout.flush();
	
			tick = 0;
		}
	}

	void updateStats(){
		string playerhp;
		string opponenthp;
		
		static immutable barBits = SCREEN_WIDTH/2 - 5;

		if(screen.uim.game.em.player.health > 0){
			foreach(i; 0 .. barBits){
				if(i <= (to!float(screen.uim.game.em.player.health)/to!float(screen.uim.game.em.player.maxHealth))*barBits){ //This amazing function takes the health and converts/rounds it to barBits amount of slots
					playerhp ~= '=';
				}else{
					playerhp ~= ' ';
				}
			}

			playerhp = to!string(playerhp.retro()); //fixme dubble slize

		}else{
			foreach(int nr; 0 .. barBits/2 - 2){ playerhp ~= ' '; }
			playerhp ~= "DEAD";
			foreach(int nr; 0 .. barBits/2 - 2){ playerhp ~= ' '; }
		}
		
		if(opponent.health > 0){
			foreach(i; 0 .. barBits){
				if(i <= (to!float(opponent.health)/to!float(opponent.maxHealth))*barBits){ //This amazing function takes the health and converts/rounds it to barBits amount of slots
					opponenthp ~= '=';
				}else{
					opponenthp ~= ' ';
				}
			}
		}else{
			foreach(int nr; 0 .. barBits/2 - 2){ opponenthp ~= ' '; }
			opponenthp ~= "DEAD";
			foreach(int nr; 0 .. barBits/2 - 2){ opponenthp ~= ' '; }
		}


		setCursorPos(2, 7);
		write(SPRITE_PLAYER, " [", playerhp, "|", opponenthp, "] ", opponent.getSprite());

		stdout.flush();

	}
}
