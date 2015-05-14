﻿module drpg.ui.side;

import std.stdio, std.conv, consoled;
import drpg.ui.uimanager;
import drpg.references.size;

class Side
{

	UIManager uim;

	immutable static int barBits = 15;
	immutable static int sideUiStartX = CHUNK_WIDTH + 1, SideUiEndX = 80, SideUiHeight = CHUNK_HEIGHT + 1;

	this(UIManager uiman)
	{
		uim = uiman;

		printAll();
	}

	void printAll(){
		foreach(w; sideUiStartX .. SideUiEndX){
			foreach(h; 0 .. SideUiHeight){
				setCursorPos(w, h);
				if(w == sideUiStartX || w == 79 || h == CHUNK_HEIGHT)
					write('*');
				else
					write(' ');
			}
		}
		
		setCursorPos(to!int((6 + uim.game.em.player.name.length) / 2 + (sideUiStartX + 1)), 1);
		write("Name: ", uim.game.em.player.name);

		update();

		setCursorPos(0, 0);
	}

	void update(){
		printHealth();
		printInventory();
	}

	void printHealth(){
		string s;
		
		if(uim.game.em.player.health > 0){
			foreach(i; 0 .. barBits){
				if(i <= (to!float(uim.game.em.player.health)/to!float(uim.game.em.player.maxHealth))*barBits){ //This amazing function takes the health and converts/rounds it to barBits amount of slots
					s ~= '*';
				}else{ s ~= ' '; }
			}
		}else{ s = "     DEAD      "; }

		writeAt(ConsolePoint(sideUiStartX + 2, 3), "Health: [" ~ s ~ "]");

	}

	void printInventory(){
		if(to!int(uim.game.em.player.inventory.letters.length)){
			writeAt(ConsolePoint(sideUiStartX + 2, 5), "Letters");
			foreach(l; 0 .. to!int(uim.game.em.player.inventory.letters.length)){
				int loop = SideUiEndX - sideUiStartX - 4;
				int rowdown = to!int(cast(double)l / (cast(double)loop / 2));

				writeAt(ConsolePoint(sideUiStartX + 2 + (2*l)%loop, 6 + rowdown), uim.game.em.player.inventory.letters[l].letter);
			}
		}
	}
}
