module drpg.ui.side;

import consoled;
import std.stdio;
import std.range;
import std.conv;
import drpg.misc;
import drpg.ui.uimanager;
import drpg.references.size;

class Side
{
	immutable static int barBits = 15;
	immutable static int sideUiStartX = CHUNK_WIDTH + 1, sideUiEndX = SCREEN_WIDTH, sideUiHeight = CHUNK_HEIGHT + 1;

	UIManager uim;

	this(UIManager uiman)
	{
		uim = uiman;
		printAll();
	}

	void printAll(){
		foreach(w; sideUiStartX .. sideUiEndX){
			foreach(h; 0 .. sideUiHeight){
				if(w == sideUiStartX || h == CHUNK_HEIGHT)
					writeAt(ConsolePoint(w, h), '*');
				else
					writeAt(ConsolePoint(w, h), ' ');
			}
		}
		setCursorPos(to!int((6 + uim.game.em.player.name.length) / 2 + (sideUiStartX + 1)), 1);
		write("Name: ", uim.game.em.player.name);
		update();
		focus();
	}

	void update(){
		printHealth();
		printInventory();
		printMiniMap();
	}

	void printHealth(){
		string s;
		if(uim.game.em.player.health > 0){
			foreach(i; 0 .. barBits){
				if(i <= (to!float(uim.game.em.player.health)/to!float(uim.game.em.player.maxHealth))*barBits){ //This amazing function takes the health and converts/rounds it to barBits amount of slots
					s ~= '*';
				}else{ s ~= ' '; }
			}
			s = to!string(retro(s));
		}else{ s = "     DEAD      "; }
		writeAt(ConsolePoint(sideUiStartX + 2, 3), "Health: [" ~ s ~ "]");

	}

	void printInventory(){
		if(to!int(uim.game.em.player.inventory.letters.length)){
			writeAt(ConsolePoint(sideUiStartX + 2, 5), "Letters:");
			foreach(l; 0 .. to!int(uim.game.em.player.inventory.letters.length)){
				int loop = 8;
				int mv = to!int(l / loop);
				writeAt(ConsolePoint(sideUiStartX + 2 + (mv * 6), 6 + l%loop), uim.game.em.player.inventory.letters[l].letter ~ " x" ~ text(uim.game.em.player.inventory.letters[l].amount));
			}
		}
	}

	void printMiniMap(){
		writeAt(ConsolePoint(sideUiStartX + 2, 15), "Minimap");
		foreach(x; 0 .. CHUNK_AMOUNT_WIDTH + 2){
			foreach(y; 0 .. CHUNK_AMOUNT_HEIGHT + 2){
				if(x == 0 || x == CHUNK_AMOUNT_WIDTH + 1 || y == 0 || y == CHUNK_AMOUNT_HEIGHT + 1)
					writeAt(ConsolePoint(sideUiStartX + 2 + x, 16 + y), '+');
				writeAt(ConsolePoint(sideUiStartX + 3 + x, 17 + y), ' ');
			}
		}
		writeAt(ConsolePoint(sideUiStartX + 3 + to!int(uim.game.map.bossroom.x / CHUNK_WIDTH), 17 + to!int(uim.game.map.bossroom.y / CHUNK_HEIGHT)), 'B');
		writeAt(ConsolePoint(sideUiStartX + 3 + to!int(uim.game.em.player.location.x / CHUNK_WIDTH), 17 + to!int(uim.game.em.player.location.y / CHUNK_HEIGHT)), uim.game.em.player.getSprite());
	}
}
