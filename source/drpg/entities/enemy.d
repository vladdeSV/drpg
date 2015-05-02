module drpg.entities.enemy;

import drpg.refs.sprites;
import drpg.entities.entity;
import std.random;

class Enemy : Entity{

	this (int w, int g){
		super(w, g);
	}

	override void move(){
		updateInterval = uniform(30, 70);
		super.move;
	}

	override char getSprite(){
		return SPRITE_ENEMY;
	}
}
