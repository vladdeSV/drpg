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

/**
 * WIP
 */ 
class Clock
{
	MonoTime lasttime;
	
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
 * Writes a frame with whitespace inside
 */
void writeRectangle(Location start, Location end){
	foreach(int x; start.x .. end.x + 1){
		foreach(int y; start.y .. end.y + 1){
			bool inRange = x == start.x || x == end.x || y == start.y || y == end.y;
			if(inRange){
				setCursorPos(x, y);
				write('*');
			}
		}
	}
}

/**
 * Clears the screen and writes a string in the center
 */ 
void centerStringOnEmptyScreen(string s){
	clearScreen;
	setCursorPos((79 / 2) - to!int(s.length / 2), 12);
	write(s);
	setCursorPos(0,25);
	stdout.flush();
}
