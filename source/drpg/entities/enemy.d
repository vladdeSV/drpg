module drpg.entities.enemy;

import std.random;
import drpg.misc;
import drpg.references.sprites;
import drpg.entities.entitymanager;
import drpg.entities.entity;

class Enemy : Entity{

	this (EntityManager emptr, Location location, bool shouldMove, int hp = 10, uint lvl = 1, string id = ""){
		hp = hp + ((lvl - 1) * 2);
		super(emptr, location, hp, lvl, shouldMove, id);
	}

	override void move(){
		updateInterval = uniform(0.5*1000, 3*1000);
		super.move();
	}

	override char getSprite(){
		return SPRITE_ENEMY;
	}
}
