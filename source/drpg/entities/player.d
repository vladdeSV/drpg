module drpg.entities.player;

import consoled;
import std.stdio;
import std.conv;
import std.random;
import drpg.map;
import drpg.misc;
import drpg.item;
import drpg.ui.uimanager;
import drpg.entities.entity;
import drpg.entities.entitymanager;
import drpg.references.text;
import drpg.references.variables;
import drpg.references.size;
import drpg.references.sprites;

class Player : Entity{

	public string name;

	int enemiesMurdered = 0;
	int boss_toFour = 0;

	this(EntityManager emptr, Location loc){
		name = PLAYER_NAME; //Dummy name. NOTE: Maximum lenght of name must be 21 or less characters. This is because the player UI has room for maximum of 21 characters!
		health = maxHealth = 15;
		super(emptr, loc, health, 1, true, "player");
		inventory.letters[locationInAlphabet('p')].amount += 1;
	}

	void update(){
		if(health <= 0){
			running = false;
			return;
		}
		move();
	}

	void addLetter(char letter){
		inventory.addLetter(letter);
	}

	private void move() {
		static bool shouldMove = true; //Since getch() sees both key press and release as inputs, we simply just check every other input. FIXME key input can bug out by holding down a key.

		//Movement is still a bit clunky. If you press left and down at the same time you move down twice
		if(kbhit()){
			int key = getch();

			Location oldLocation = location; //Saves the player's x and y.
			Location movement = Location(0,0);

			if (!shouldMove){ //Get ever second key press, due to how getch() gets both keypress and keyrelease as input.
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
//			else if (key == 'P' || key == 'p'){
//				pause();
//				em.game.map.printChunk();
//				return;
//			}
			else if(key == SpecialKey.escape){
				running = false;
				return;
			}else{
				return;
			}

			Location dest = Location(oldLocation.x + movement.x, oldLocation.y + movement.y);

			bool inbounds = (dest.x >= 0 && dest.x < WORLD_WIDTH && 
			                 dest.y >= 0 && dest.y < WORLD_HEIGHT);


			if(em.isEntityAt(dest)){
				em.game.uim.fightUI.startFight(em.getEntityAt(dest));
				return;
			}

			if(inbounds && !em.game.map.isTileSolidAt(dest)){
				location = dest;
			}

			if(chunkAtPos(oldLocation) != chunkAtPos(location)){
				em.game.map.printChunk();
			}else{
				//Prints out the correc tile where the player once was, otherwise it would still be the player icon.
				setCursorPos(location.x % CHUNK_WIDTH, location.y % CHUNK_HEIGHT);
				em.game.map.printTile(oldLocation);
			}

			print();
		}
	}
	
	override char getSprite(){
		return SPRITE_PLAYER;
	}
}
