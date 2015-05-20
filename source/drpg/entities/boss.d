module drpg.entities.boss;

import drpg.misc;
import drpg.references.sprites;
import drpg.entities.entitymanager;
import drpg.entities.entity;

class Boss : Entity{

	this(EntityManager emptr, Location location){
		super(emptr, location, 25, 4, false, "boss");
	}
	
	override char getSprite(){
		return SPRITE_BOSS;
	}
}
