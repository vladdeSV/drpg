module drpg.entities.player;

import std.stdio, consoled;
import drpg.map, drpg.entities.entitymanager, drpg.reference;
import drpg.entities.entity;

class Player : Entity{

	public char[] name = "Hermando".dup; //Dummy name. NOTE: Maximum lenght of name must be 21 or less characters. This is because the player UI has room for maximum of 21 characters!

	override void move() {
	
		//FIXME Due to getch() being a bit buggy, the player won't be printed out correctly if there is no setCursoPos(x, y) in the move function.
		//I'm pretty sure it can be anywhere in the code as long it will always get run. This is a bug in ConsoleD. Create an issue?
		setCursorPos(0,0);

		int xc = x / CHUNK_WIDTH;
		int yc = y / CHUNK_HEIGHT;

		if(xChunk != xc || yChunk != yc) {
			xChunk = xc;
			yChunk = yc;
			_map.printChunk;
			setCursorPos(0,0); //FIXME Same bug as above, with out this the player won't get printed out
		}

		int lx = x, ly = y; //Saves the player's x and y.
		int key = getch();

		//FIXME: Keycodes are different in Debian.
		if (key == 87 && y - 1 >= 0 && !_map.getTile(x, y - 1).isSolid){ //W
			y--;
		}
		else if (key == 65 && x - 1 >= 0 && !_map.getTile(x - 1, y).isSolid){ //A
			x--;
		}
		else if (key == 83 && y + 1 <= _map.getHeight - 1 && !_map.getTile(x, y + 1).isSolid){ //S
			y++;
		}
		else if (key == 68 && x + 1 <= _map.getWidth - 1 && !_map.getTile(x + 1, y).isSolid()){ //D
			x++;
		}

		//Prints out the correc tile where the player once was, otherwise it would still be the player icon.
		setCursorPos(lx % CHUNK_WIDTH, ly % CHUNK_HEIGHT);
		write(_map.getTile(lx, ly).getTile);

		//Finally print out the player
		EM.em.printPlayer;

		super.move;
	}
	
	this(int xStart, int yStart){
		x = xStart;
		y = yStart;
	}
}