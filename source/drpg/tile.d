module drpg.tile;

import std.random : uniform;
import drpg.references.sprites;

abstract class Tile{

	protected char type = '?';
	protected bool solid = false;
	protected Tile overlay = null;

	Tile returnTile(){
		return this;
	}

	char getSprite(){
		if(overlay !is null){
			return getOverlay();
		}else{
			return getType();
		}
	}

	private char getType(){
		return type;
	}

	private char getOverlay(){
		try{
			return overlay.getSprite();
		}catch(Exception e){
			throw new Exception(e.msg); //If for some reason overlay is null or something.
		}
	}

	void setOverlay(Tile t){
		overlay = t;
	}

	@property bool isSolid(){
		return solid;
	}
	
}

//TODO: Change all "sprites" to the ones in reference.

class TileGround : Tile{
	this(){
		type = SPRITE_NONE;
	}
}

class TileFloor : Tile{
	this(){
		type = SPRITE_NONE;
	}
}

class TileWall : Tile{
	this(){
		type = SPRITE_WALL;
		solid = true;
	}
}

class TilePlank : Tile{
	this(){
		type = SPRITE_PLANK;
		solid = true;
	}
}

class TileRock : Tile{
	this(){
		type = SPRITE_ROCK;
		solid = true;
	}
}

class TileDoor : Tile{
	
	//bool locked = false;
	
	this(bool locked = false){
		if(!locked)
			type = SPRITE_DOOR;
		else{
			type = 'L'; //LOCKED DOOR
			solid = true;
		}
	}
}

class TileTree : Tile{
	this(){
		type = SPRITE_TREE;
		solid = true;
	}
}

class TileFlower: Tile{
	this(){
		if(uniform(0,2)) //Randomly chooses between the different flower types
			type = SPRITE_FLOWER_1;
		else
			type = SPRITE_FLOWER_2;
	}
}