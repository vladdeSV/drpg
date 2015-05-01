module drpg.ui.start;

import std.stdio, consoled;
import drpg.reference, drpg.entities.entitymanager;

class Start
{
	this()
	{
		char[] ns = ("** " ~ GAME_NAME ~ " - Mystique Adventures **").dup, l;
		string[10] info = [
			"In a mystique world, you wanted the worlds",
			"grandest adventure. You packed your bag and left",
			"the safe home, and now you're on your own.",
			"",
			"",
			"Move with W, A, S and D",
			"Open your inventory with I",
			"",
			"",
			"",
		];
		char[13] tr = "<PRESS ENTER>".dup;

		foreach(a; 0 .. ns.length)
			l ~= '*';

		setCursorPos(CHUNK_WIDTH/2 - l.length/2, 1); write(l);
		setCursorPos(CHUNK_WIDTH/2 - l.length/2, 2); write(ns);
		setCursorPos(CHUNK_WIDTH/2 - l.length/2, 3); write(l);

		foreach(x; 0 .. info.length){
			setCursorPos(CHUNK_WIDTH/2 - info[x].length/2, 5 + x);
			write(info[x]);
		}

		setCursorPos(CHUNK_WIDTH/2 - tr.length/2, CHUNK_HEIGHT - 4); write(tr);
		readln();

	}
}