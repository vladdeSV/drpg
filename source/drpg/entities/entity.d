module drpg.entities.entity;

import drpg.reference;

class Entity{

	void move(){};

	void update(){
		xChunk = x/CHUNK_WIDTH;
		yChunk = y/CHUNK_HEIGHT;
	}

	//These should NOT be public
	int x, y;
	int xChunk, yChunk;

protected:
	int health, mana;
	//http://en.wikipedia.org/wiki/Attribute_%28role-playing_games%29
	int strength, stamina, defense, dexterity, intelligence, charisma, wisdom, willpower, perception, luck;

}
