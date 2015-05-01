module drpg.entities.entity;

import std.stdio, std.random;
import consoled;
import drpg.reference, drpg.refs.sprites;

class Entity{
	int[2] chunk;
	int x, y,	health, mana,	maxHealth, maxMana;

	Stats stats;

	void move(){
		int lx = x;
		int ly = y;
		
		x += 1;
		y += 1;

		if(chunk[0] == _em.player.chunk[0] && chunk[1] == _em.player.chunk[1]){ //If the enemy is in the visible chunk (the chunk the player is in), then render the player
			setCursorPos(lx % CHUNK_WIDTH, ly % CHUNK_HEIGHT);
			write(_map.getTile(lx, ly).getTile);

			setCursorPos(x % CHUNK_WIDTH, y % CHUNK_HEIGHT);
			write(SPRITE_ENEMY); //TODO: The rendering of an entity does not work properly. 
		}
	}

	void update(){
		chunk[0] = x/CHUNK_WIDTH;
		chunk[1] = y/CHUNK_HEIGHT;
	}

	void kill(){
		destroy(this); // ;)
	}
}

struct Stats{
	//http://en.wikipedia.org/wiki/Attribute_%28role-playing_games%29
	int strength, stamina, defense, dexterity, intelligence, charisma, wisdom, willpower, perception, luck;
}