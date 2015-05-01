module drpg.entities.entity;

import std.stdio, std.random;
import consoled;
import drpg.reference, drpg.refs.sprites;

class Entity{
	int[2] chunk;
	int x, y,	health, mana,	maxHealth, maxMana;

	Stats stats;

	private void move(){
		int lx = x;
		int ly = y;
		
		int mx = uniform(0, 3) - 1;
		int my = uniform(0, 3) - 1;

		if(x + mx >= 0 && x + mx < WORLD_WIDTH && y + my >= 0 && y + my < WORLD_HEIGHT) /* Check so the enteties won't leave the world border */{
			if(!_em.isEntityAt(x+mx, y+my) && !_map.getTile(x+mx, y+my).isSolid ){
				x += mx;
				y += my;
			}
		}

		if(chunk[0] == _em.player.chunk[0] && chunk[1] == _em.player.chunk[1]){ //If the enemy is in the visible chunk (the chunk the player is in), then render the player
			setCursorPos(lx % CHUNK_WIDTH, ly % CHUNK_HEIGHT);
			write(_map.getTile(lx, ly).getTile);

			setCursorPos(x % CHUNK_WIDTH, y % CHUNK_HEIGHT);
			write(SPRITE_ENEMY);
			stdout.flush(); //Thanks to Destructionator from #d (freenode) for this amazing one-liner which makes sure the enemies get properly written out!
		}
	}

	void update(){
		chunk[0] = x / CHUNK_WIDTH;
		chunk[1] = y / CHUNK_HEIGHT;
		move;
	}

	void kill(){
		destroy(this); // ;)
	}

	char getSprite(){
		return '?';
	}
}

struct Stats{
	//http://en.wikipedia.org/wiki/Attribute_%28role-playing_games%29
	int strength, stamina, defense, dexterity, intelligence, charisma, wisdom, willpower, perception, luck;
}
