module drpg.ui.start;

import std.stdio, std.conv, consoled;
import drpg.entities.entitymanager;
import drpg.references.text;

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
			"Pause with P",
			"",
			"",
			"",
		];
		char[13] tr = "<PRESS ENTER>".dup;

		foreach(a; 0 .. ns.length)
			l ~= '*';

		setCursorPos(to!int(width/2 - l.length/2), 2); write(l);
		setCursorPos(to!int(width/2 - l.length/2), 3); write(ns);
		setCursorPos(to!int(width/2 - l.length/2), 4); write(l);

		foreach(int x; 0 .. info.length){
			setCursorPos(to!int(width/2 - info[x].length/2), 6 + x);
			write(info[x]);
		}

		setCursorPos(to!int(width/2 - tr.length/2), to!int(height - 2)); write(tr);
		readln();
		clearScreen();

	}
}