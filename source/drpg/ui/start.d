module drpg.ui.start;

import std.stdio, std.conv, consoled;
import drpg.entities.entitymanager;
import drpg.references.text;
import drpg.references.size;

class Start
{
	this()
	{
		char[] ns = ("** " ~ GAME_NAME ~ " - Mystique Adventures **").dup, l;
		string[10] info = [
			"In a mystique world, you need to save your friends",
			"by defeating \"Boss B\", and ensuring the alphabet's",
			"rights to live as they please!",
			"",
			"",
			"Move with W, A, S and D",
			"Pause with P",
			"",
			"",
			"",
		];
		string pressenter = "<PRESS ENTER>";

		foreach(a; 0 .. ns.length) l ~= '*';

		writeAt(ConsolePoint(to!int(SCREEN_WIDTH/2 - l.length/2), 2), l);
		writeAt(ConsolePoint(to!int(SCREEN_WIDTH/2 - l.length/2), 3), ns);
		writeAt(ConsolePoint(to!int(SCREEN_WIDTH/2 - l.length/2), 4), l);

		foreach(int x; 0 .. info.length)
			writeAt(ConsolePoint(to!int(SCREEN_WIDTH/2 - info[x].length/2), 6 + x), info[x]);
	
		writeAt(ConsolePoint(to!int(SCREEN_WIDTH/2 - pressenter.length/2), SCREEN_HEIGHT - 4), pressenter);

		string madeby = "Vladde Nordholm & Fredrik Fernlund - Motala, SU14";
		string about = "LBS Gameawards 2014";
		writeAt(ConsolePoint(0, SCREEN_HEIGHT - 1), about);
		writeAt(ConsolePoint(0, SCREEN_HEIGHT), madeby);
//		writeAt(ConsolePoint(SCREEN_WIDTH - to!int(about.length) + 1, SCREEN_HEIGHT), about);
		setCursorPos(0,0);

		readln();
		clearScreen();

	}
}