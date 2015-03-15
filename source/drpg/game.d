module drpg.game;

import std.stdio, consoled;
import drpg.reference, drpg.map, drpg.entities.entitymanager, drpg.entities.player, drpg.ui.uimanager;
import drpg.tiles.tile, drpg.tiles.tilefloor, drpg.tiles.tileplank, drpg.tiles.tiledoor, drpg.tiles.tilewall;
class Game{

	void start(){

		clearScreen;
		cursorVisible(false);

		_map.setTile(4, 1, new TilePlank());
		_map.setTile(94, 4, new TilePlank());
		_map.addRoom(40, 5, 15, 7);
		_map.addRoom(CHUNK_WIDTH + 13, 9, 14, 6);

		_uim.uim;

		//Always last
		_map.printChunk;

		while(1) update;
	}

	void update(){
		_em.player.move;
	}
}