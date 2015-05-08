module drpg.entities.enemy;

import drpg.misc;
import drpg.refs.sprites;
import drpg.entities.entitymanager, drpg.entities.entity;
import std.random;

class Enemy : Entity{

	this (EntityManager* emptr, Location location, int hp = 10, uint lvl = 1){
		super(emptr, location, hp, lvl);
	}

	override void move(){
		updateInterval = uniform(30, 70);
		super.move;
	}

	override char getSprite(){
		return SPRITE_ENEMY;
	}
}
