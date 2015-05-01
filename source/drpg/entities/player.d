module drpg.entities.player;

import std.stdio, std.concurrency, consoled, std.random;
import drpg.map, drpg.entities.entitymanager, drpg.reference, drpg.ui.uimanager, drpg.entities.entity;

class Player : Entity{

	public char[] name = "Hermando".dup; //Dummy name. NOTE: Maximum lenght of name must be 21 or less characters. This is because the player UI has room for maximum of 21 characters!

	int key; //The key being pressed
	int xc, yc; //X chunk and y chunk
	bool mv = true; //Check if need to move

	override void move() {

		xc = x / CHUNK_WIDTH;
		yc = y / CHUNK_HEIGHT;

		if(chunk[0] != xc || chunk[1] != yc) {
			chunk[0] = xc;
			chunk[1] = yc;
			_map.printChunk;
		}

		//Movement is still a bit clunky. If you press left and down at the same time you move down twice
		if(kbhit){
			//FIXME Due to getch() being a bit buggy, the player won't be printed out correctly if there is no setCursoPos(x, y) in the move function.
			//I'm pretty sure it can be anywhere in the code as long it will always get run. This is a bug in ConsoleD. Create an issue?
			//setCursorPos(0,0); //Enable when in doubt

			int lx = x, ly = y; //Saves the player's x and y.
			key = getch(); //TODO: Fix movement. In new versions of ConsoleD, getch() recognizes a key realease as an input too. Basically you move twice for one quick keypress.

			if(mv){
				/***/if ((key == 'W' || key == 'w') && y - 1 >= 0 && !_map.getTile(x, y - 1).isSolid){
					y--;
				}
				else if ((key == 'A' || key == 'a') && x - 1 >= 0 && !_map.getTile(x - 1, y).isSolid){
					x--;
				}
				else if ((key == 'S' || key == 's') && y + 1 <= _map.getHeight - 1 && !_map.getTile(x, y + 1).isSolid){
					y++;
				}
				else if ((key == 'D' || key == 'd') && x + 1 <= _map.getWidth - 1 && !_map.getTile(x + 1, y).isSolid()){
					x++;
				}
				else if(key == 27 /* Escape character on Windows */){
					running = false;
				}

				//Prints out the correc tile where the player once was, otherwise it would still be the player icon.
				setCursorPos(lx % CHUNK_WIDTH, ly % CHUNK_HEIGHT);
				write(_map.getTile(lx, ly).getTile);

				//Finally print out the player
				_em.printPlayer;
				//_uim.sideUI.update;

				//Write out players x and y + chunks
				setCursorPos(70-17, 20-3);
				write("x: ", _em.player.x, " [Chunk: ", _em.player.chunk[0], " / ", WORLD_WIDTH/CHUNK_WIDTH, "]");
				setCursorPos(70-17, 21-3);
				writeln("y: ", _em.player.y, " [Chunk: ", _em.player.chunk[1], " / ", WORLD_HEIGHT/CHUNK_HEIGHT, "]");

				mv = false;
			}else{
				mv = true;
			}
		}
	}
	
	this(int xStart, int yStart){
		x = xStart;
		y = yStart;
		maxHealth = health = 15;
		maxMana = mana = 10;
	}

	void startMove(){
	}
}
