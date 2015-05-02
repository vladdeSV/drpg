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

		setCursorPos(width/2 - l.length/2, 2); write(l);
		setCursorPos(width/2 - l.length/2, 3); write(ns);
		setCursorPos(width/2 - l.length/2, 4); write(l);

		foreach(x; 0 .. info.length){
			setCursorPos(width/2 - info[x].length/2, 6 + x);
			write(info[x]);
		}

		setCursorPos(width/2 - tr.length/2, height - 2); write(tr);
		readln();

	}
}