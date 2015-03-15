module drpg.entities.entity;

import drpg.reference;

class Entity{

	void move(){};

	void update(){
		xChunk = x/CHUNK_WIDTH;
		yChunk = y/CHUNK_HEIGHT;
	}

	int x, y, xChunk, yChunk;
	int health, mana;
	int maxHealth, maxMana;
	//http://en.wikipedia.org/wiki/Attribute_%28role-playing_games%29
	int strength, stamina, defense, dexterity, intelligence, charisma, wisdom, willpower, perception, luck;

}
