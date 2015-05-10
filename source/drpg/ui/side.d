module drpg.ui.side;

import std.stdio, std.conv, consoled;
import drpg.ui.uimanager;
import drpg.references.size;

class Side
{

	UIManager uim;

	static immutable int barBits = 15;
	immutable static int SideUiStartX = CHUNK_WIDTH + 1, SideUiEndX = 80, SideUiHeight = CHUNK_HEIGHT + 1;

	this(UIManager uiman)
	{
		uim = uiman;

		printAll();
	}

	void printAll(){
		foreach(w; SideUiStartX .. SideUiEndX){
			foreach(h; 0 .. SideUiHeight){
				setCursorPos(w, h);
				if(w == SideUiStartX || w == 79 || h == CHUNK_HEIGHT)
					write('*');
				else
					write(' ');
			}
		}
		
		setCursorPos(to!int((6 + uim.game.em.player.name.length) / 2 + (SideUiStartX + 1)), 1);
		write("Name: ", uim.game.em.player.name);

		update();

		setCursorPos(0, 0);
	}

	void update(){
		//HP
		setCursorPos(SideUiStartX + 2, 3);
		write("Health: [", healthbar, "]");
	}

	string healthbar(){
		string s;

		if(uim.game.em.player.health > 0){
			foreach(i; 0 .. barBits){
				if(i <= (to!float(uim.game.em.player.health)/to!float(uim.game.em.player.maxHealth))*barBits){ //This amazing function takes the health and converts/rounds it to barBits amount of slots
					s ~= '*';
				}else{
					s ~= ' ';
				}
			}
		}else{
			s = "     DEAD      ";
		}

		return s;
	}
}
