module drpg.entities.enemy;

import std.random;
import drpg.misc;
import drpg.references.sprites;
import drpg.entities.entitymanager;
import drpg.entities.entity;

class Enemy : Entity{

	string id;

	this (EntityManager emptr, Location location, int hp = 10, uint lvl = 1, string id = ""){
		this.id = id;
		hp = hp + ((lvl - 1) * 2);
		super(emptr, location, hp, lvl, id);
	}

	override void move(){
		updateInterval = uniform(1*1000, 5*1000);
		super.move();
	}

	override char getSprite(){
		return SPRITE_ENEMY;
	}
}
