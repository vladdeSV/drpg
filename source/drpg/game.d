module drpg.game;

import std.stdio, consoled;
import drpg.reference, drpg.map, drpg.entities.entitymanager, drpg.entities.player, drpg.ui.start;
import drpg.tiles.tile, drpg.tiles.tilefloor, drpg.tiles.tileplank, drpg.tiles.tiledoor, drpg.tiles.tilewall;
class Game{

	void start(){

		clearScreen;
		cursorVisible(false);

		//Prints out the border of the chunk
		foreach(y; 0 .. CHUNK_HEIGHT){
			setCursorPos(CHUNK_WIDTH, y);
			write("+");
		}
		foreach(q; 0 .. CHUNK_WIDTH + 1){
			setCursorPos(q, CHUNK_HEIGHT);
			write("+");
		}

		Start c = new Start(); 

		clearScreen;
		_em.setPlayer(new Player(5, 9));

		_map.setTile(4, 1, new TilePlank());
		_map.setTile(94, 4, new TilePlank());
		_map.addRoom(40, 5, 15, 11);
		_map.addRoom(CHUNK_WIDTH+13, 9, 14, 6);

		//Always last
		_map.printChunk;

		while(1) update;
	}

	void update(){
		_em.player.move;
	}
}