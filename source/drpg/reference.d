module drpg.reference;

import std.stdio;
import consoled;

enum EntityType {PLAYER, NPC, MONSTER} //to be added moar
enum MonsterType {SLIME, ZOMBIE};

//enum TileType {DIRT, PLANK, WATER, WOOD, STONE}

immutable byte CHUNK_WIDTH = 79, CHUNK_HEIGHT = 25; //Windows standard console size. I'm on windows.

enum ErrorList {lolnoerror, MAXIMUM_PLAYERS_EXCEEDED, OUT_OF_BOUNDS};

void throwError(Throwable e, int error, string msg = __PRETTY_FUNCTION__){
	setCursorPos(0, 0);
	writeln("Error: ", e.msg, " in\n", msg, "\n");
	switch(error){
		/*
		case ErrorList.MAXIMUM_PLAYERS_EXCEEDED:
			writeln("Players limit has been exceeded.");
			throw new Exception("max player");
			break;
		*/
		case ErrorList.OUT_OF_BOUNDS:
			writeln("Something most likely went out of bounds");
			throw new Exception("out of bounds");
			break;
		default:
			writeln("Unknown error.");
			throw new Exception("unknown");
			break;
	}
}