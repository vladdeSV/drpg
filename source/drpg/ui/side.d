module drpg.ui.side;

import std.stdio, consoled;
import drpg.reference, drpg.entities.entitymanager;

class Side
{
	this()
	{
		update();
	}

	void update(){
		foreach(w; SideUiStartX .. SideUiEndX){
			foreach(h; 0 .. SideUiHeight){
				setCursorPos(w, h);
				if(w == SideUiStartX || w == 79 || h == CHUNK_HEIGHT)
					write('*');
				else
					write(' ');
				

			}
		}
		setCursorPos(SideUiStartX, CHUNK_HEIGHT);

		setCursorPos((6 + _em.player.name.length) / 2 + (SideUiStartX + 1), 1);
		write("Name: ", _em.player.name);

	}
}

