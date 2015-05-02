module drpg.reference;

import std.stdio, std.conv, consoled;
import drpg.map, drpg.entities.entitymanager, drpg.ui.uimanager;

alias _map = Map.map;
alias _uim = UIManager.uim; //UIManager
alias _em = EM.em; //EntityManager

static bool running = true;

enum EntityType {PLAYER, NPC, MONSTER} //to be added moar
enum MonsterType {SLIME, ZOMBIE};

//World variables
immutable static char[] GAME_NAME = "DRPG";
immutable static int CHUNK_WIDTH = 50, CHUNK_HEIGHT = 24; //Windows OS standard console size. I'm on windows.
immutable static int WORLD_WIDTH = CHUNK_WIDTH * 3, WORLD_HEIGHT = CHUNK_HEIGHT * 2;

//Room variables
immutable static int MAX_ROOM_WIDTH = 20, MAX_ROOM_HEIGHT = 20, MAX_NUMBER_OF_ROOMS = 50;
static int roomsFailedToPlace = 0;

void centerStringOnEmptyScreen(string s){
	clearScreen;
	setCursorPos((79 / 2) - to!int(s.length / 2), 12);
	write(s);
	setCursorPos(0,25);
}

/+
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
+/
