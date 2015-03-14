module drpg.ui.start;

import std.stdio, std.string, consoled;
import drpg.reference, drpg.entities.entitymanager;

class Start
{
	this()
	{

		char[] ns = ("** " ~ GAME_NAME ~ " - Mystique Adventures **").dup, l;
		foreach(a; 0 .. ns.length)
			l ~= '*';

		setCursorPos(CHUNK_WIDTH/2 - 1 - l.length/2, 1); write(l);
		setCursorPos(CHUNK_WIDTH/2 - 1 - l.length/2, 2); write(ns);
		setCursorPos(CHUNK_WIDTH/2 - 1 - l.length/2, 3); write(l);

		char[] info = "press enter, move with WASD, go to the right".dup;
		setCursorPos(CHUNK_WIDTH/2 - 1 - info.length/2, 5); write(info);


		//setCursorPos(CHUNK_WIDTH / 2 - GAME_NAME.length / 2, 2);
		//write(GAME_NAME);

		setCursorPos(0, CHUNK_HEIGHT - 3);
		writeln("[*] Start, lolol no other options, press enter"); //Teehee, you cannot choose anything yet :P
		writeln("[ ] Options");
		writeln("[ ] Quit");
		setCursorPos(0, CHUNK_HEIGHT + 1);

		readln();


	}
}