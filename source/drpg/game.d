module drpg.game;

import std.stdio, std.random, consoled;
import drpg.reference, drpg.map, drpg.entities.entitymanager, drpg.entities.player, drpg.ui.uimanager;
import drpg.room, drpg.tile;

class Game{

	void start(){

		clearScreen;
		cursorVisible(false);

		_em.em;
		_map.init;
		_uim.init;

		_map.setTile(4, 1, new TileRock());
		_map.setTile(94, 4, new TileRock());
		_map.addRect(CHUNK_WIDTH + 5, CHUNK_HEIGHT + 2, 4 ,5, new TilePlank());


		//Always last
		_map.printChunk;
		setCursorPos(0,0);
		write(roomsFailedToPlace," rooms failed to be placed");

		while(1) update;
	}

	void update(){
		_em.player.move;
	}
}