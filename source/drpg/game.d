module drpg.game;

import std.stdio;
import drpg.reference, drpg.map, drpg.entities.entitymanager, drpg.entities.player;
import drpg.tiles.tile, drpg.tiles.tilefloor, drpg.tiles.tileplank, drpg.tiles.tiledoor, drpg.tiles.tilewall;
class Game{

	Map m = new Map();

	void start(){
		m.i.setTile(4, 1, new TilePlank());
		m.i.printMap();
		
		Player hermando = new Player();
		Player* g = &hermando;
		//EM.em.addPlayer(g);

		m.i.setTile(1000,41,new TileFloor());
	}
}