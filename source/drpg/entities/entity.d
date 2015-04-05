module drpg.entities.entity;

import drpg.reference;

class Entity{

	void move(){};

	void update(){
		chunk[0] = x/CHUNK_WIDTH;
		chunk[1] = y/CHUNK_HEIGHT;
	}

	void kill(){
		destroy(this); // ;)
	}

	int x, y;
	int[2] chunk;
	int health, mana;
	int maxHealth, maxMana;
	//http://en.wikipedia.org/wiki/Attribute_%28role-playing_games%29
	int strength, stamina, defense, dexterity, intelligence, charisma, wisdom, willpower, perception, luck;

}
