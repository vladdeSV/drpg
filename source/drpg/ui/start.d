module drpg.ui.start;

import consoled;
import std.stdio;
import std.conv;
import drpg.entities.entitymanager;
import drpg.references.text;
import drpg.references.size;

class Start
{
	this()
	{
		char[] ns = ("** " ~ GAME_NAME ~ " - Mystique Adventures **").dup, l;
		string[] info = [
			"In a mystique world, you need to save your friends",
			"by defeating \"Boss B\", and ensuring the alphabet's",
			"rights to live as they please!",
			"",
			"",
			"Move with W, A, S and D",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"<PRESS 'S' TO START>",
		];

		foreach(a; 0 .. ns.length) l ~= '*';

		writeAt(ConsolePoint(to!int(SCREEN_WIDTH/2 - l.length/2), 2), l);
		writeAt(ConsolePoint(to!int(SCREEN_WIDTH/2 - l.length/2), 3), ns);
		writeAt(ConsolePoint(to!int(SCREEN_WIDTH/2 - l.length/2), 4), l);

		foreach(int x; 0 .. info.length)
			writeAt(ConsolePoint(to!int(SCREEN_WIDTH/2 - info[x].length/2), 6 + x), info[x]);

		string madeby = "LBS Gameawards 2015\nVladde Nordholm & Fredrik Fernlund - Motala, SU14";
		writeAt(ConsolePoint(0, SCREEN_HEIGHT - 1), madeby);
		setCursorPos(0,0);

		bool kp = false;
		while(!kp){
			if(kbhit()){
				int key = getch();

				if(key == 'S' || key == 's')
					kp = true;
			}
		}


//		do{
//			clearScreen();
//			writeAt(ConsolePoint(1,1), "Please enter your name: ");
//			if(PLAYER_NAME.length > 21) writeAt(ConsolePoint(1,3), "Your name cannot be longer than 21 characters.");
//			PLAYER_NAME = readln();
//		}while(PLAYER_NAME.length > 21);

	}
}
