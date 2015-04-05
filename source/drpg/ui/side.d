module drpg.ui.side;

import std.stdio, consoled;
import drpg.reference, drpg.entities.entitymanager;

class Side
{
	static immutable barBits = 15;
	immutable static int SideUiStartX = CHUNK_WIDTH + 1, SideUiEndX = 80, SideUiHeight = CHUNK_HEIGHT + 1;

	this()
	{
		foreach(w; SideUiStartX .. SideUiEndX){
			foreach(h; 0 .. SideUiHeight){
				setCursorPos(w, h);
				if(w == SideUiStartX || w == 79 || h == CHUNK_HEIGHT)
					write('*');
				else
					write(' ');
			}
		}

		setCursorPos((6 + _em.player.name.length) / 2 + (SideUiStartX + 1), 1);
		write("Name: ", _em.player.name);

		update();
	}

	void update(){
		//TODO make something happen when the player dies

		//_em.player.health--; /* TEMP to check if health/mana and shit works */


		//HP
		setCursorPos(SideUiStartX + 2, 3);
		write("Health: [", healthbar, "]");
		//MANA
		setCursorPos(SideUiStartX + 2, 4);
		write("Mana:   [", manabar, "]");
	}

	string healthbar(){
		string s;

		if(_em.player.health > 0){
			foreach(i; 0 .. barBits){
				if(i <= (cast(float)_em.player.health/cast(float)_em.player.maxHealth)*barBits){ //This amazing function takes the health and converts/rounds it to barBits amount of slots
					s ~= '*';
				}else{
					s ~= ' ';
				}
			}
		}else{
			s = "   DEAD   ";
			_em.player.kill(); //Neat function that crashed the program :)
		}

		return s;
	}
	string manabar(){
		string s;

		foreach(i; 0 .. barBits){
			if(i <= (cast(float)_em.player.mana/cast(float)_em.player.maxMana)*barBits){ //This amazing function takes the mana and converts/rounds it to barBits amount of slots
				s ~= '=';
			}else{
				s ~= ' ';
			}
		}
		
		return s;
	}
}
