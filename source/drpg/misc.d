module drpg.misc;

import core.time;
import drpg.reference;

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
	MonoTime lasttime;
	
	this()
	{
		
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