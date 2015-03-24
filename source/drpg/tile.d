module drpg.tile;

static abstract class Tile{

	protected char type = '?';
	protected bool solid = false;
	protected Tile overlay = null;

	char getTile(){
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
			return overlay.getTile();
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

class TileFloor : Tile{
	this(){
		type = ' ';
	}
}

class TileWall : Tile{
	this(){
		type = '#';
		solid = true;
	}
}

class TilePlank : Tile{
	this(){
		type = '=';
		solid = true;
	}
}

class TileRock : Tile{
	this(){
		type = '*';
		solid = true;
	}
}


class TileDoor : Tile{
	
	//bool locked = false;
	
	this(){
		type = 'D';
	}
}