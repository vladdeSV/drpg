module drpg.ui.side;

import std.stdio, std.conv, consoled;
import drpg.entities.entitymanager;
import drpg.reference;

class Side
{

	EntityManager em;

	static immutable int barBits = 15;
	immutable static int SideUiStartX = CHUNK_WIDTH + 1, SideUiEndX = 80, SideUiHeight = CHUNK_HEIGHT + 1;

	this(EntityManager emptr)
	{
		em = emptr;

		foreach(w; SideUiStartX .. SideUiEndX){
			foreach(h; 0 .. SideUiHeight){
				setCursorPos(w, h);
				if(w == SideUiStartX || w == 79 || h == CHUNK_HEIGHT)
					write('*');
				else
					write(' ');
			}
		}

		setCursorPos(to!int((6 + em.player.name.length) / 2 + (SideUiStartX + 1)), 1);
		write("Name: ", em.player.name);

		update();
	}

	void update(){
		//TODO make something happen when the player dies

		//em.player.health--; /* TEMP to check if health/mana and shit works */


		//HP
		setCursorPos(SideUiStartX + 2, 3);
		write("Health: [", healthbar, "]");
	}

	string healthbar(){
		string s;

		if(em.player.health > 0){
			foreach(i; 0 .. barBits){
				if(i <= (cast(float)em.player.health/cast(float)em.player.maxHealth)*barBits){ //This amazing function takes the health and converts/rounds it to barBits amount of slots
					s ~= '*';
				}else{
					s ~= ' ';
				}
			}
		}else{
			s = "   DEAD   ";
		}

		return s;
	}
}
