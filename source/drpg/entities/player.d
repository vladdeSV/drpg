module drpg.entities.player;

import std.stdio, consoled;
import drpg.map, drpg.entities.entitymanager, drpg.reference;
import drpg.entities.entity;

class Player : Entity{

	char[] name = "Hermando".dup; //Dummy name

	override void move() {

		int xc = x / CHUNK_WIDTH;
		int yc = y / CHUNK_HEIGHT;

		if(xChunk != xc || yChunk != yc) {
			xChunk = xc;
			yChunk = yc;
			Map.map.printChunk;
		}

		setCursorPos(0,24);
		write("u sux m", x, " & ", y);

		/+
		//setCursorPos(0,24);
		//writeln(key);
		+/

		int lx = x, ly = y; //Saves the player's x and y.
		int key = getch();

		//FIXME: Keycodes are different in Debian.
		if (key == 87 && y - 1 >= 0 && !Map.map.getTile(x, y - 1).isSolid){ //W
			y--;
		}
		else if (key == 65 && x - 1 >= 0 && !Map.map.getTile(x - 1, y).isSolid){ //A
			x--;
		}
		else if (key == 83 && y + 1 <= Map.map.getHeight - 1 && !Map.map.getTile(x, y + 1).isSolid){ //S
			y++;
		}
		else if (key == 68 && x + 1 <= Map.map.getWidth - 1 && !Map.map.getTile(x + 1, y).isSolid()){ //D
			x++;
		}

		setCursorPos(lx % CHUNK_WIDTH, ly % CHUNK_HEIGHT);
		write(Map.map.getTile(lx % CHUNK_WIDTH, ly % CHUNK_HEIGHT).getTile); //... prints out the correct tile.

		EM.em.printPlayer;

		/+
		if (map_p.getTile(x, y).coin){ //If the player is on a tile that has a coin on it...
			map_p.getTile(x, y).coin(false); //... set the overlay to nothing and...
			coins++; //... give the player a coin :)
		}
		
		setCursorPos(lx, ly); //Puts the cursor on the old tile and...
		+/

		super.move;
	}
	
	this(int xStart, int yStart){
		x = xStart;
		y = yStart;
	}
}