module drpg.entities.player;

import std.stdio, std.concurrency, consoled, std.random;
import drpg.map;
import drpg.misc;
import drpg.entities.entity, drpg.entities.entitymanager;
import drpg.reference, drpg.refs.sprites;
import drpg.ui.uimanager;

class Player : Entity{
	
	public string name = "Hermando"; //Dummy name. NOTE: Maximum lenght of name must be 21 or less characters. This is because the player UI has room for maximum of 21 characters!

	this(EntityManager* emptr, Location loc){
		health = maxHealth = 15;

		super(emptr, loc);
	}

	override void update(){
		if(health <= 0){
			running = false;
			return;
		}
		move();
	}

	private void move() {

		static bool shouldMove = true; //Since getch() sees both key press and release as inputs, we simply just check every other input. Can bug out by holding down a key.

		//Movement is still a bit clunky. If you press left and down at the same time you move down twice
		if(kbhit()){
			int key = getch();

			Location oldPosition = position; //Saves the player's x and y.
			Location movement = Location(0,0);

			if (!shouldMove){
				shouldMove = true;
				return;
			} else {
				shouldMove = false;
			}

			if (key == 'W' || key == 'w'){
				movement.y = -1;
			}
			else if (key == 'S' || key == 's'){
				movement.y = +1;
			}
			else if (key == 'A' || key == 'a'){
				movement.x = -1;
			}
			else if (key == 'D' || key == 'd'){
				movement.x = +1;
			}
			else if (key == 'I' || key == 'i'){
				//em.game.uim.openInventory;
			}
			else if(key == 27){ // Escape key on Windows
				running = false;
				return;
			}else{
				return;
			}

			Location dest = Location(oldPosition.x + movement.x, oldPosition.y + movement.y);

			bool inbounds = (dest.x >= 0 && dest.x < WORLD_WIDTH && 
			                 dest.y >= 0 && dest.y < WORLD_HEIGHT);

			if(em.isEntityAt(dest)){
				
				em.game.fight.startFight(em.getEntityPointerAt(dest));
			}

			if(inbounds && !em.game.map.isTileSolidAt(dest)){
				position = dest;
			}

			if(chunkAtPos(oldPosition) != chunkAtPos(position)){
				em.game.map.printChunk();
			}

			//Prints out the correc tile where the player once was, otherwise it would still be the player icon.
			setCursorPos(position.x % CHUNK_WIDTH, position.y % CHUNK_HEIGHT);

			em.game.map.printTile(oldPosition);

			print();

			//Write out players x and y + chunks
			setCursorPos(70-17, 21); write("x: ", position.x, " [Chunk: ", chunkAtPos(position).x + 1, " / ", CHUNK_AMOUNT_WIDTH, "]");
			setCursorPos(70-17, 22); write("y: ", position.y, " [Chunk: ", chunkAtPos(position).y + 1, " / ", CHUNK_AMOUNT_HEIGHT, "]");
		}
	}
	
	override char getSprite(){
		return SPRITE_PLAYER;
	}
}
