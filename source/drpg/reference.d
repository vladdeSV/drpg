module drpg.reference;

import std.stdio, consoled;
import drpg.map, drpg.entities.entitymanager;

alias _map = Map.map;
alias _em = EM.em;

enum EntityType {PLAYER, NPC, MONSTER} //to be added moar
enum MonsterType {SLIME, ZOMBIE};

enum ErrorList {lolnoerror, MAXIMUM_PLAYERS_EXCEEDED, OUT_OF_BOUNDS};

immutable byte CHUNK_WIDTH = 60, CHUNK_HEIGHT = 20; //Windows standard console size. I'm on windows.

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
		default:
			writeln("Unknown error.");
			throw new Exception("unknown");
	}
}