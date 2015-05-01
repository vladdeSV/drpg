module drpg.ui.start;

import std.stdio, consoled;
import drpg.reference, drpg.entities.entitymanager;

class Start
{
	this()
	{
		char[] ns = ("** " ~ GAME_NAME ~ " - Mystique Adventures **").dup, l;
		char[] info = "press enter, move with WASD, go to the right".dup;
		char[] tr = "<PRESS ENTER>".dup;

		foreach(a; 0 .. ns.length)
			l ~= '*';

		setCursorPos(CHUNK_WIDTH/2 - 1 - l.length/2, 1); write(l);
		setCursorPos(CHUNK_WIDTH/2 - 1 - l.length/2, 2); write(ns);
		setCursorPos(CHUNK_WIDTH/2 - 1 - l.length/2, 3); write(l);

		setCursorPos(CHUNK_WIDTH/2 - 1 - info.length/2, 5); write(info);

		setCursorPos(CHUNK_WIDTH/2 - tr.length/2, CHUNK_HEIGHT - 4);
		write(tr);
		readln();

	}
}