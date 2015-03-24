module drpg.reference;

import std.stdio, consoled;
import drpg.map, drpg.entities.entitymanager, drpg.ui.uimanager;

alias _map = Map.map;
alias _uim = UIManager.uim; //UIManager
alias _em = EM.em; //EntityManager

enum EntityType {PLAYER, NPC, MONSTER} //to be added moar
enum MonsterType {SLIME, ZOMBIE};

immutable static byte CHUNK_WIDTH = 50, CHUNK_HEIGHT = 20; //Windows standard console size. I'm on windows.
immutable static char[] GAME_NAME = "DRPG".dup;

immutable static byte maxNumberOfRooms = 15;
immutable static byte maxRoomWidth = 20, maxRoomHeight = 20;

immutable static int SideUiStartX = CHUNK_WIDTH + 1, SideUiEndX = 80, SideUiHeight = CHUNK_HEIGHT + 1;

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
		default:
			writeln("Unknown error.");
			throw new Exception("unknown");
	}
}