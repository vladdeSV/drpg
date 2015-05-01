module drpg.entities.enemy;

import drpg.refs.sprites;
import drpg.entities.entity;
import std.random;

class Enemy : Entity{
	this(int xStart, int yStart){
		x = xStart;
		y = yStart;
	}

	override char getSprite(){
		return SPRITE_ENEMY;
	}
}
