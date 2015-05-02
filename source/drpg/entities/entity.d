module drpg.entities.entity;

import std.stdio, std.random;
import consoled;

import drpg.misc;
import drpg.item;
import drpg.reference, drpg.refs.sprites;

abstract class Entity{
	int[2] chunk;
	int x, y,	health, mana,	maxHealth, maxMana,		entityTick;
	int updateInterval = 50; //Default value

	Stats stats;
	Inventory inv;

	this(int x, int y){
		this.x = x;
		this.y = y;
		updateChunk(x, y);
	}

	protected void move(){
		int lx = x;
		int ly = y;
		
		int mx = uniform(0, 3) - 1;
		int my = uniform(0, 3) - 1;

		if(x + mx >= 0 && x + mx < WORLD_WIDTH && y + my >= 0 && y + my < WORLD_HEIGHT) /* Check so the enteties won't leave the world border */ {
			if(!_em.isEntityAt(x+mx, y+my) && !_map.isTileSolidAt(x+mx, y+my)) /* Check that the moving-to tile is not occupied */{
				x += mx;
				y += my;
			}
		}

		//FIXME: When an entity leaves the current chunk the enemy sprite does not get removed.
		if(cast(int)(lx / CHUNK_WIDTH) == _em.player.chunk[0] && cast(int)(ly / CHUNK_HEIGHT) == _em.player.chunk[1]){ //If the enemy is in the visible chunk (the chunk the player is in), then render the entity
			setCursorPos(lx % CHUNK_WIDTH, ly % CHUNK_HEIGHT);
			write(_map.getTile(lx, ly).getTile);
			stdout.flush;

			updateChunk(x, y);

			if(chunk[0] == _em.player.chunk[0] && chunk[1] == _em.player.chunk[1]){
				setCursorPos(x % CHUNK_WIDTH, y % CHUNK_HEIGHT);
				write(SPRITE_ENEMY);
				stdout.flush(); //Thanks to Destructionator from #d (freenode) for this amazing one-liner which makes sure the enemies get properly written out!
			}
		}
	}

	void update(){
		++entityTick;
		if(entityTick > updateInterval){
			move;

			entityTick = 0;
		}
	}

	void updateChunk(int xCurrentX, int yCurrent){
		chunk[0] = x / CHUNK_WIDTH;
		chunk[1] = y / CHUNK_HEIGHT;
	}

	void kill(){
		destroy(this); // ;)
	}

	char getSprite(){
		return '?';
	}
}