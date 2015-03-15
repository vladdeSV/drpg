module drpg.ui.side;

import std.stdio, consoled;
import drpg.reference, drpg.entities.entitymanager;

class Side
{
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
		update();
	}

	void update(){
		//TODO make something happen when the player dies

		//_em.player.health--; /* TEMP to check if health and shit works */

		setCursorPos((6 + _em.player.name.length) / 2 + (SideUiStartX + 1), 1);
		write("Name: ", _em.player.name);

		setCursorPos(SideUiStartX + 2, 3);
		write("Health: [");

		if(_em.player.health > 0){
			foreach(i; 0 .. 10){
				if(i <= (cast(float)_em.player.health/cast(float)_em.player.maxHealth)*10){ //This amazing function takes the health and converts/rounds it to 10 slots
					//setCursorPos(SideUiStartX + 11 + i, 3);
					write('*');
				}else{
					//setCursorPos(SideUiStartX + 11 + i, 3);
					write(' ');
				}
			}
		}else{
			write("   DEAD   ");
		}

		write("]");
	}
}

