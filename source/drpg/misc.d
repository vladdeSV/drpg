module drpg.misc;

import drpg.item;

struct Stats{
	//http://en.wikipedia.org/wiki/Attribute_%28role-playing_games%29
	int strength, stamina, defense, dexterity, intelligence, charisma, wisdom, willpower, perception, luck;
}

class Inventory{
	int maximumAmountOfItems;

	this(int maxItems = 10){
		maximumAmountOfItems = maxItems;
	}

	Item[] items;
	
	void addItem(Item item){
		if(items.length < maximumAmountOfItems){
			items ~= item;
		}
	}
}