module drpg.entities.player;

import std.stdio, std.concurrency, consoled, std.random;
import drpg.map;
import drpg.entities.entity, drpg.entities.entitymanager;
import drpg.reference, drpg.refs.sprites;
import drpg.ui.uimanager;

class Player : Entity{

	public char[] name = "Hermando".dup; //Dummy name. NOTE: Maximum lenght of name must be 21 or less characters. This is because the player UI has room for maximum of 21 characters!

	int key; //The key being pressed
	int xc, yc; //X chunk and y chunk
	bool mv = true; //Check if need to move

	override void update(){
		move;
	}

	private void move() {

		xc = x / CHUNK_WIDTH;
		yc = y / CHUNK_HEIGHT;

		if(chunk[0] != xc || chunk[1] != yc) {
			chunk[0] = xc;
			chunk[1] = yc;
			_map.printChunk;
		}

		//Movement is still a bit clunky. If you press left and down at the same time you move down twice
		if(kbhit){

			int lx = x, ly = y; //Saves the player's x and y.
			int mx, my; //Move x and move y.

			key = getch(); //TODO: Fix movement. In new versions of ConsoleD, getch() recognizes a key realease as an input too. Basically you move twice for one quick keypress.

			if(mv){
				/***/if (key == 'W' || key == 'w'){
					my--;
				}
				else if (key == 'A' || key == 'a'){
					mx--;
				}
				else if (key == 'S' || key == 's'){
					my++;
				}
				else if (key == 'D' || key == 'd'){
					mx++;
				}
				else if (key == 'I' || key == 'i'){
					//_uim.openInventory;
				}
				else if(key == 27 /* Escape key on Windows */){
					running = false;
				}

				if
				(
					x + mx >= 0								&&
					x + mx < _map.getWidth					&&
					y + my >= 0								&&
					y + my < _map.getHeight					&&

					!_map.isTileSolidAt (x + mx, y + my) 	&&
					!_em.isEntityAt		(x + mx, y + my)
				)
				{
					x += mx;
					y += my;

					mx = my = 0;
				}

				//Prints out the correc tile where the player once was, otherwise it would still be the player icon.
				setCursorPos(lx % CHUNK_WIDTH, ly % CHUNK_HEIGHT);
				if(_em.isEntityAt(lx, ly)){
					try{
						write(_em.getEntityAt(lx,ly).getSprite);
					}catch{
						write(_map.getTile(lx, ly).getTile);
					}
				}else{
					write(_map.getTile(lx, ly).getTile);
				}

				//Finally print out the player
				_em.printPlayer;
				_uim.sideUI.update;

				//Write out players x and y + chunks
				setCursorPos(70-17, 20-3);
				write("x: ", _em.player.x, " [Chunk: ", _em.player.chunk[0] + 1, " / ", WORLD_WIDTH/CHUNK_WIDTH, "]");
				setCursorPos(70-17, 21-3);
				writeln("y: ", _em.player.y, " [Chunk: ", _em.player.chunk[1] + 1, " / ", WORLD_HEIGHT/CHUNK_HEIGHT, "]");

				mv = false;
			}else{
				mv = true;
			}
		}
	}
	
	this(int xStart, int yStart){
		maxHealth = health = 15;
		maxMana = mana = 10;
		super(xStart, yStart);
	}

	override char getSprite(){
		return SPRITE_PLAYER;
	}
}
