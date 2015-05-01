module drpg.entities.enemy;

import drpg.entities.entity;
import std.random;

class Enemy : Entity{
	this(int xStart, int yStart){
		x = xStart;
		y = yStart;
	}
}
