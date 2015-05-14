module drpg.misc;

import core.time;
import std.stdio;
import std.conv;
import consoled;
import drpg.references.size;

struct Stats{
	//http://en.wikipedia.org/wiki/Attribute_%28role-playing_games%29
	int strength, stamina, defense, dexterity, intelligence, charisma, wisdom, willpower, perception, luck;
}

struct Location{
	int x;
	int y;
}

//bool isInChunk(Location pos, Location chunk){
//	return (pos.x / CHUNK_WIDTH == chunk.x && pos.y / CHUNK_HEIGHT == chunk.y);
//}

Location chunkAtPos(Location pos){
	Location chunk;
	chunk.x = pos.x / CHUNK_WIDTH;
	chunk.y = pos.y / CHUNK_HEIGHT;
	return chunk;
}

Location add(Location loc1, Location loc2){
	return Location(loc1.x+loc2.x, loc1.y+loc2.y);
}

class Clock
{
	private MonoTime lasttime;

	this(){
		lasttime = MonoTime.zero();
	}

	static wait(long sec){
		auto totime = MonoTime.currTime() + dur!"seconds"(sec);

		while(MonoTime.currTime() < totime){  }
	}

	double reset()
	{
		MonoTime newtime = MonoTime.currTime();
		Duration duration = newtime - lasttime;
		double durationmsec = duration.total!"nsecs" / (10.0 ^^ 6);
		lasttime = newtime;

		return durationmsec;
	}
}

/**
 * Clears the chunk by putting whitespaces in the chunk.
 */
void clearChunk(){

	string clearLine;

	foreach(int a; 0 .. CHUNK_WIDTH)
		clearLine ~= ' ';

	foreach(int y; 0 .. CHUNK_HEIGHT){
		setCursorPos(0, y);
		write(clearLine);
	}
}

/**
 * Clears the screen and writes a string in the center
 */
void centerStringOnEmptyScreen(string s){
	clearScreen;
	setCursorPos((width / 2) - to!int(s.length / 2), height/2);
	write(s);
	setCursorPos(0, 0);
	stdout.flush();
}

void centerStringInEmptyChunk(string s){
	clearChunk();
	setCursorPos((CHUNK_WIDTH / 2) - to!int(s.length / 2), CHUNK_HEIGHT/2);
	write(s);
	setCursorPos(0, 0);
	stdout.flush();
}

/**
 * Writes a frame with whitespace inside
 */
void writeRectangle(Location start, Location end){
	foreach(int x; start.x .. end.x + 1){
		foreach(int y; start.y .. end.y + 1){
			bool inRange = x == start.x || x == end.x || y == start.y || y == end.y;
			if(inRange){
				writeAt(ConsolePoint(x, y), '*');
			}else{
				writeAt(ConsolePoint(x, y), ' ');
			}
		}
	}
}

void talkBox(string message, char talker){

	string talk = "-"~talker;
	Location topleft = Location(1, CHUNK_HEIGHT - 6);
	Location bottomright = Location(CHUNK_WIDTH - 2, CHUNK_HEIGHT - 1);
	ConsolePoint textstart = ConsolePoint(topleft.x + 2, topleft.y + 2);
	ConsolePoint talkerpos = ConsolePoint(bottomright.x - 3, bottomright.y - 2);

	writeRectangle(topleft, bottomright);

	//TODO make message linewrap in textbox
	writeAt(textstart, message);
	writeAt(talkerpos, talk);
	Clock.wait(5);
}

void pause(){
	centerStringInEmptyChunk("Paused - Press Q");
	
	bool paused = true;
	int pausekey;
	while(paused){
		pausekey = getch();
		if(pausekey == 'Q' || pausekey == 'q')
			paused = false;
	}
}

string[] hswsag = [
	"               **********                  ",
	"             **          **                ",
	"            **   '    '   **               ",
	"      *     **             **              ",
	"     ***    **  .      .  **               ",
	"      **      ** ......  **                ",
	"       **       *********                  ",
	"        **   **    **                  *** ",
	"          ***      **      *************** ",
	"        **  **   ************              ",
	"             ***** **    **                ",
	"               **  **    **                ",
	"                *  **                      ",
	"                   **                      ",
	"                 ******                    ",
	"                **     **                  ",
	"              ***       **                 ",
	"            ***          **                ",
	"           **            **                ",
	"",
	"Happy Stickman with Sword and Gun"];
