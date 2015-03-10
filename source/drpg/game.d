module drpg.game;

import std.stdio, consoled;
import drpg.reference, drpg.map, drpg.entities.entitymanager, drpg.entities.player;
import drpg.tiles.tile, drpg.tiles.tilefloor, drpg.tiles.tileplank, drpg.tiles.tiledoor, drpg.tiles.tilewall;
class Game{

	void start(){

		clearScreen;

		Map.map.setTile(4, 1, new TilePlank());
		Map.map.setTile(94, 4, new TilePlank());

		//Always last
		Map.map.printChunk;


		//while(0) update;
	}

	void update(){

	}
}